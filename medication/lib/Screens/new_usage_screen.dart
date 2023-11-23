import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocs/usage_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController _typeAheadMedController = TextEditingController();
  final TextEditingController _typeAheadConController = TextEditingController();
  final TextEditingController _typeAheadProController = TextEditingController();
  String medication = '';
  String conflictMed = '';
  String probioticName = '';
  int _administrationChoice = 0;
  int _timeMedChoice = 0;
  int _timeNotChoice = 0;
  int _probioticChoice = 0;
  int _conflictChoice = 0;
  bool isTypedIn = false;
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay timeCon = TimeOfDay(hour: 1, minute: 0);
  List <dynamic> administration = [];
  List <dynamic> hour = [];
  String restrictions = '';
  List <dynamic> conflict = [];
  String probiotic = '';
  bool administrationError = false;
  bool hourError = false;
  bool restrictionError = false;

  final List<MultiSelectCard> daysCards = <MultiSelectCard>[
    MultiSelectCard(value: 'Pon', label: 'Pon'),
    MultiSelectCard(value: 'Wt', label: 'Wt'),
    MultiSelectCard(value: 'Śr', label: 'Śr'),
    MultiSelectCard(value: 'Czw', label: 'Czw'),
    MultiSelectCard(value: 'Pt', label: 'Pt'),
    MultiSelectCard(value: 'Sb', label: 'Sb'),
    MultiSelectCard(value: 'Ndz', label: 'Ndz'),
  ];
  final List<MultiSelectCard> timeOfDayCards = <MultiSelectCard>[
    MultiSelectCard(value: 'Rano', label: 'Rano'),
    MultiSelectCard(value: 'Wieczorem', label: 'Wieczorem'),
    MultiSelectCard(value: 'W południe', label: 'W południe'),
    MultiSelectCard(value: 'Na noc', label: 'Na noc'),
  ];
  final List<MultiSelectCard> restrictionsCards = <MultiSelectCard>[
    MultiSelectCard(value: 'Brak', label: 'Brak'),
    MultiSelectCard(value: 'Na czczo', label: 'Na czczo'),
    MultiSelectCard(value: 'Przy posiłku', label: 'Przy posiłku'),
    MultiSelectCard(value: 'Po posiłku', label: 'Po posiłku'),
  ];

  @override
  void initState() {
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(widget.animal));
    BlocProvider.of<UsageBloc>(context).add(LoadUsages(widget.profileId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final hourCon = timeCon.hour.toString().padLeft(2, '0');
    final minuteCon = timeCon.minute.toString().padLeft(2, '0');
    return Scaffold(
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
        child: BlocBuilder<MedicationBloc, MedicationState>(
          builder: (context, state) {
            if (state is MedicationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MedicationLoaded) {
              final List<Medication> medications = state.medications;
              final List<Medication> probiotics = medications.where((med) => med.type == 'Probiotyk').toList();
              return BlocBuilder<UsageBloc, UsageState>(
                builder: (context, state) {
                  if (state is UsageLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UsageLoaded) {
                    final List<Usage> usages = state.usages;
                    return Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                controller: _typeAheadMedController,
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
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: (){
                                      setState(() {
                                        _typeAheadMedController.clear();
                                        medication = '';
                                      });
                                    },
                                  ),
                                  suffixIconColor: Colors.white,
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
                                _typeAheadMedController.text = suggestion;
                                setState(() {
                                  medication = suggestion;
                                });
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
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return 'Pole nie może być puste';
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'PODAWANIE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
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
                                    items: daysCards,
                                    onChange: (allSelectedItems, selectedItem){
                                      setState(() {
                                        administration = allSelectedItems;
                                      });
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
                                    suffix: MultiSelectSuffix(
                                      selectedSuffix: const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: administrationError,
                                      child: const Text(
                                        'Zaznacz co najmniej jeden element',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                        )
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
                                fontWeight: FontWeight.bold,
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
                                  Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                          backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? newTime = await _showTimePicker(context);
                                          if(newTime == null) return;
                                          setState(() {
                                            time = newTime;
                                          });
                                        },
                                        child: Text(
                                          '$hours:$minutes',
                                          style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
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
                                      items: timeOfDayCards,
                                      onChange: (allSelectedItems, selectedItem){
                                        setState(() {
                                          hour = allSelectedItems;
                                        });
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
                                      suffix: MultiSelectSuffix(
                                        selectedSuffix: const Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: hourError,
                                      child: const Text(
                                          'Zaznacz co najmniej jeden element',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                          )
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
                                fontWeight: FontWeight.bold,
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
                                  Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                          backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? newTime = await _showTimePicker(context);
                                          if(newTime == null) return;
                                          setState(() {
                                            time = newTime;
                                          });
                                        },
                                        child: Text(
                                          '$hours:$minutes',
                                          style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MultiSelectContainer(
                              items: restrictionsCards,
                              onChange: (allSelectedItems, selectedItem){
                                setState(() {
                                  restrictions = selectedItem.toString();
                                });
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
                              suffix: MultiSelectSuffix(
                                selectedSuffix: const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: restrictionError,
                              child: const Text(
                                  'Należy zaznaczyć element',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  )
                              ),
                            ),
                            Visibility(
                              visible: _isAntibiotic(medications),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'PROBIOTYK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
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
                                        _probioticChoice = index;
                                      });
                                    },
                                    icons: [MdiIcons.pill, MdiIcons.pillOff],
                                    selectedIndex: _probioticChoice,
                                    iconSize: 25,
                                  ),
                                  Visibility(
                                    visible: _probioticChoice == 0,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        TypeAheadFormField(
                                          textFieldConfiguration: TextFieldConfiguration(
                                            controller: _typeAheadProController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              labelText: 'Probiotyk',
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
                                              suffixIcon: IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: (){
                                                  setState(() {
                                                    _typeAheadProController.clear();
                                                    probioticName = '';
                                                  });
                                                },
                                              ),
                                              suffixIconColor: Colors.white,
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return probiotics
                                                .where((pro) => pro.medication.toLowerCase().contains(pattern.toLowerCase()))
                                                .map((pro) => pro.medication)
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
                                            _typeAheadProController.text = suggestion;
                                            setState(() {
                                              probioticName = suggestion;
                                            });
                                          },
                                          noItemsFoundBuilder: (context) =>
                                              Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    'Nie znaleziono probiotyku',
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontSize: 20,
                                                    )
                                                ),
                                              ),
                                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                            color: Colors.grey[800],
                                          ),
                                          validator: (text) {
                                            if(text == null || text.isEmpty){
                                              return 'Pole nie może być puste';
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'KONFLIKT Z INNYM LEKIEM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
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
                                  _conflictChoice = index;
                                });
                              },
                              selectedIndex: _conflictChoice,
                            ),
                            Visibility(
                              visible: _conflictChoice == 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  TypeAheadFormField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: _typeAheadConController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Lek konfliktowy',
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
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: (){
                                            setState(() {
                                              _typeAheadConController.clear();
                                              conflictMed = '';
                                            });
                                          },
                                        ),
                                        suffixIconColor: Colors.white,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) {
                                      return usages
                                          .where((us) => us.medicationName.toLowerCase().contains(pattern.toLowerCase()))
                                          .map((us) => us.medicationName)
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
                                      _typeAheadConController.text = suggestion;
                                      setState(() {
                                        conflictMed = suggestion;
                                      });
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
                                    validator: (text) {
                                      if(text == null || text.isEmpty){
                                        return 'Pole nie może być puste';
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'CZAS POMIĘDZY LEKAMI',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                          backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? newTime = await showTimePicker(
                                            context: context,
                                            initialTime: timeCon,
                                            initialEntryMode: TimePickerEntryMode.inputOnly,
                                            cancelText: 'Anuluj',
                                            helpText: 'Wybierz odstęp czasowy',
                                            hourLabelText: 'Godzin',
                                            minuteLabelText: 'Minut',
                                            builder: (BuildContext context, Widget? child) {
                                              return Theme(
                                                data: ThemeData.dark().copyWith(
                                                  primaryColor: const Color.fromARGB(255, 174, 199, 255),
                                                  colorScheme: ColorScheme.dark(
                                                    primary: const Color.fromARGB(255, 174, 199, 255),
                                                    onPrimary: Colors.white,
                                                    surface: Colors.grey[800]!,
                                                    onSurface: Colors.white,
                                                  ),
                                                  dialogBackgroundColor: Colors.grey[900],
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if(newTime == null) return;
                                          setState(() {
                                            time = newTime;
                                          });
                                        },
                                        child: Text(
                                          '$hourCon:$minuteCon',
                                          style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                  ),
                                  child: const Text(
                                      'Anuluj',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      )
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(width: 25),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                                  ),
                                  child: const Text(
                                      'Zapisz',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      )
                                  ),
                                  onPressed: () {
                                    if(_formKey.currentState!.validate() && _isAdministrationValid() && _isHourValid() && _isRestrictionValid()){
                                      saveUsage(medications);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );;
                  }else if (state is UsageError) {
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
                    return Container();
                  }
                },
              );
                }else if (state is MedicationError) {
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
              return Container();
            }
          },
        ),
      ),
    );
  }
  Future<TimeOfDay?> _showTimePicker (BuildContext context) async {
    Completer<TimeOfDay?> completer = Completer<TimeOfDay?>();
    TimeOfDay selectedTime = TimeOfDay.now();
    Time _time = Time.fromTimeOfDay(TimeOfDay.now(), 0);
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        sunrise: TimeOfDay(hour: 6, minute: 0),
        sunset: TimeOfDay(hour: 18, minute: 0),
        duskSpanInMinutes: 120,
        is24HrFormat: true,
        cancelText: 'Anuluj',
        minuteInterval: TimePickerInterval.FIVE,
        okStyle: TextStyle(color: Colors.black),
        cancelStyle: TextStyle(color: Colors.black),
        onChange: (Time newTime){
          setState(() {
            selectedTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
          });
          completer.complete(selectedTime);
        },
      ),
    );
    return completer.future;
  }

  bool _isAntibiotic (List<Medication> medications){
    if(medication == '') {return false;}
    Medication selectedMed = medications.firstWhere((element) => element.medication == medication);
    if(selectedMed.type == 'Antybiotyk') {
      return true;
    } else {
      return false;
    }
  }

  bool _isAdministrationValid(){
    if(_administrationChoice == 1 && administration.isEmpty){
      setState(() {
        administrationError = true;
      });
        return false;
      } else {
      setState(() {
        administrationError = false;
      });
      return true;
    }
  }

  bool _isHourValid(){
    if(_timeMedChoice == 1 && hour.isEmpty){
      setState(() {
        hourError = true;
      });
      return false;
    } else {
      setState(() {
        hourError = false;
      });
      return true;
    }
  }
  bool _isRestrictionValid(){
    if(restrictions.isEmpty){
      setState(() {
        restrictionError = true;
      });
      return false;
    } else {
      setState(() {
        restrictionError = false;
      });
      return true;
    }
  }

  void saveUsage(List<Medication> medications) {
    if(_administrationChoice == 0){
      administration = ['Codziennie'];
    }
    if(_timeMedChoice == 0){
      hour = [time.toString()];
    } else if(_timeMedChoice == 2){
      hour = ['Brak'];
    }
    if(_conflictChoice == 0){
      conflict = [conflictMed, timeCon.toString()];
    } else if(_conflictChoice == 1){
      conflict = ['Brak'];
    }
    if(_isAntibiotic(medications)){
      if(_probioticChoice == 0){
        probiotic = probioticName;
      } else if(_probioticChoice == 1){
        probiotic = 'Brak';
      }
    } else {
      probiotic = '';
    }
    String userId = '';
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
    } else {
      userId = user.uid.toString();
    }
    final usage = Usage(
      usageId: DateTime.now().toString(),
      medicationName: medication,
      profileId: widget.profileId,
      administration: administration,
      hour: hour,
      restrictions: restrictions,
      conflict: conflict,
      probiotic: probiotic,
      userId: userId,
    );
    BlocProvider.of<UsageBloc>(context).add(AddUsage(usage));
    Navigator.pop(context);
  }

}