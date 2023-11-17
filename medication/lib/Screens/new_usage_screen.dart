import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class NewUsageView extends StatefulWidget {
  final bool animal;
  final String profileId;

  const NewUsageView({
    required this.animal,
    required this.profileId,
    Key? key,
  }) : super(key: key);

  @override
  State<NewUsageView> createState() => _NewUsageViewState();
}

class _NewUsageViewState extends State<NewUsageView> {
  final AuthorizationService _authorizationService = AuthorizationService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String medication = '';
  int _administrationChoice = 0;
  int _timeMedChoice = 0;
  int _timeNotChoice = 0;
  TimeOfDay time = TimeOfDay.now();
  final List<MultiSelectCard> days = <MultiSelectCard>[
    MultiSelectCard(value: 0, label: 'Poniedziałek'),
    MultiSelectCard(value: 1, label: 'Wtorek'),
    MultiSelectCard(value: 2, label: 'Środa'),
    MultiSelectCard(value: 3, label: 'Czwartek'),
    MultiSelectCard(value: 4, label: 'Piątek'),
    MultiSelectCard(value: 5, label: 'Sobota'),
    MultiSelectCard(value: 6, label: 'Niedziela'),
  ];
  final List<MultiSelectCard> timeOfDay = <MultiSelectCard>[
    MultiSelectCard(value: 0, label: 'Rano'),
    MultiSelectCard(value: 1, label: 'Wieczorem'),
    MultiSelectCard(value: 2, label: 'W południe'),
    MultiSelectCard(value: 3, label: 'Na noc'),
  ];
  final List<MultiSelectCard> restrictiions = <MultiSelectCard>[
    MultiSelectCard(value: 0, label: 'Brak'),
    MultiSelectCard(value: 1, label: 'Na czczo'),
    MultiSelectCard(value: 2, label: 'Przy posiłku'),
    MultiSelectCard(value: 3, label: 'Po posiłku'),
  ];

  @override
  void initState() {
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(widget.animal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MediCATion'),
        centerTitle: true,
      ),
      endDrawer: Drawer(
          backgroundColor: Colors.grey[900],
          clipBehavior: Clip.none,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 93, // To change the height of DrawerHeader
                width: double.infinity, // To Change the width of DrawerHeader
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 174, 199, 255),
                  ),
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                ),
                onPressed: (){
                  _authorizationService.signOut();
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Wyloguj się",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: BlocBuilder<MedicationBloc, MedicationState>(
            builder: (context, state) {
              if (state is MedicationLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MedicationLoaded) {
                final List<Medication> medications = state.medications;
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Dodaj podawany lek",
                          style: GoogleFonts.tiltNeon(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 174, 199, 255),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _typeAheadController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Lek',
                            labelStyle: const TextStyle(color: Colors.white),
                            counterStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(255, 174, 199, 255)),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            prefixIcon: Icon(MdiIcons.pill),
                            prefixIconColor: Colors.white,
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return medications
                              .where((med) => med.medication.toLowerCase().contains(pattern.toLowerCase()))
                              .map((med) => med.medication)
                              .toList();
                        },
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            title: Text(
                              suggestion,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                        transitionBuilder: (context, suggestionsBox, controller) =>
                        suggestionsBox,
                        onSuggestionSelected: (String suggestion) {
                          _typeAheadController.text = suggestion;
                          medication = suggestion;
                        },
                        noItemsFoundBuilder: (context) =>
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                  'Nie znaleziono leku',
                                  style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 20,
                                  )
                              ),
                            ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'PODAWANIE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FlutterToggleTab(
                        width: 75,
                        height: 60,
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        unSelectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        selectedBackgroundColors: const [Color.fromARGB(255, 174, 199, 255)],
                        unSelectedBackgroundColors: [Colors.grey[800]!],
                        labels: ['Codziennie', 'Harmonogram'],
                        selectedLabelIndex: (index) {
                          setState(() {
                            _administrationChoice = index;
                          });
                        },
                        selectedIndex: _administrationChoice,
                        iconSize: 25,
                      ),
                      Visibility(
                        visible: _administrationChoice == 1,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            MultiSelectContainer(
                              items: days,
                              onChange: (allSelectedItems, selectedItem){
                                print('Value: ${selectedItem}');
                                //TODO add saving values
                              },
                              textStyles: const MultiSelectTextStyles(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              itemsDecoration: MultiSelectDecorations(
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(color: const Color.fromARGB(255, 174, 199, 255)),
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 174, 199, 255),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'GODZINA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FlutterToggleTab(
                        width: 75,
                        height: 60,
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        unSelectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        selectedBackgroundColors: const [Color.fromARGB(255, 174, 199, 255)],
                        unSelectedBackgroundColors: [Colors.grey[800]!],
                        labels: ['Konkretna', 'Ogólna', 'Brak'],
                        selectedLabelIndex: (index) {
                          setState(() {
                            _timeMedChoice = index;
                          });
                        },
                        selectedIndex: _timeMedChoice,
                        iconSize: 25,
                      ),
                      Visibility(
                        visible: _timeMedChoice == 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                ),
                                onPressed: () async {
                                  TimeOfDay? newTime = await showRoundedTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      negativeBtn: 'Anuluj',
                                      theme: ThemeData.dark()
                                  );
                                  if(newTime == null) return;
                                  setState(() {
                                    time = newTime;
                                  });
                                },
                                child: Text(
                                  '$hours:$minutes',
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: _timeMedChoice == 1,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              MultiSelectContainer(
                                items: timeOfDay,
                                onChange: (allSelectedItems, selectedItem){
                                  print('Value: ${selectedItem}');
                                  //TODO add saving values
                                },
                                textStyles: const MultiSelectTextStyles(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                itemsDecoration: MultiSelectDecorations(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(color: const Color.fromARGB(255, 174, 199, 255)),
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 174, 199, 255),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'POWIADOMIENIE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FlutterToggleTab(
                        width: 75,
                        height: 60,
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        unSelectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        selectedBackgroundColors: const [Color.fromARGB(255, 174, 199, 255)],
                        unSelectedBackgroundColors: [Colors.grey[800]!],
                        labels: ['TAK', 'NIE'],
                        selectedLabelIndex: (index) {
                          setState(() {
                            _timeNotChoice = index;
                          });
                        },
                        icons: [Icons.notifications, Icons.notifications_off],
                        selectedIndex: _timeNotChoice,
                        iconSize: 25,
                      ),
                      Visibility(
                        visible: _timeNotChoice == 0 && _timeMedChoice != 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                ),
                                onPressed: () async {
                                  TimeOfDay? newTime = await showRoundedTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      negativeBtn: 'Anuluj',
                                      theme: ThemeData.dark()
                                  );
                                  if(newTime == null) return;
                                  setState(() {
                                    time = newTime;
                                  });
                                },
                                child: Text(
                                  '$hours:$minutes',
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'OGRANICZNIA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MultiSelectContainer(
                        items: restrictiions,
                        onChange: (allSelectedItems, selectedItem){
                          print('Value: ${selectedItem}');
                          //TODO add saving values
                        },
                        maxSelectableCount: 1,
                        textStyles: const MultiSelectTextStyles(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        itemsDecoration: MultiSelectDecorations(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: const Color.fromARGB(255, 174, 199, 255)),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: const Color.fromARGB(255, 174, 199, 255),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is MedicationError) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                );
              } else {
                return Container( );
              }
            },
          ),
        ),
      ),
    );
  }
}
