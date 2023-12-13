import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocs/notification_bloc.dart';
import 'package:medication/Blocs/usage_bloc.dart';
import 'package:medication/Database_classes/NotificationData.dart';
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
import 'package:medication/Services/notification_service.dart';

class NewUsageView extends StatefulWidget {
  final bool animal;
  final String profileId;
  final String profileName;
  final Usage? usage;

  const NewUsageView({
    required this.animal,
    required this.profileId,
    required this.profileName,
    required this.usage,
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
  String conflictMedId = '';
  String probioticName = '';
  int _administrationChoice = 0;
  int _timeMedChoice = 0;
  int _timeNotChoice = 0;
  int _probioticChoice = 0;
  int _conflictChoice = 0;
  bool isTypedIn = false;
  TimeOfDay timeMed = TimeOfDay.now();
  TimeOfDay timeCon = TimeOfDay(hour: 1, minute: 0);
  List <dynamic> administration = [];
  List <dynamic> hour = [];
  String restrictions = '';
  List <dynamic> conflict = [];
  String probiotic = '';
  List <dynamic> notificationData = [];
  List<int> notificationIds = [];
  bool administrationError = false;
  bool hourError = false;
  bool restrictionError = false;
  List<bool> daysCardsSelected = [false, false, false, false, false, false, false];
  List<bool> timeOfDayCardsSelected = [false, false, false, false];
  List<bool> restrictionsCardsSelected = [false, false, false, false];

  @override
  void initState() {
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(widget.animal));
    BlocProvider.of<UsageBloc>(context).add(LoadUsages(widget.profileId));
    super.initState();

    if (widget.usage != null) {
      medication = widget.usage!.medicationName;
      _typeAheadMedController.text = widget.usage!.medicationName;
      List<dynamic> tmp = widget.usage!.administration;
      if (tmp[0] == 'Codziennie') {
        _administrationChoice = 0;
      } else {
        _administrationChoice = 1;
        daysCardsSelected[0] = tmp.contains('Poniedziałek');
        daysCardsSelected[1] = tmp.contains('Wtorek');
        daysCardsSelected[2] = tmp.contains('Środa');
        daysCardsSelected[3] = tmp.contains('Czwartek');
        daysCardsSelected[4] = tmp.contains('Piątek');
        daysCardsSelected[5] = tmp.contains('Sobota');
        daysCardsSelected[6] = tmp.contains('Niedziela');
      }
      RegExp regex = RegExp(r'^\d+:\d+$');
      tmp = widget.usage!.hour;
      if (tmp[0] == 'Brak') {
        _timeMedChoice = 2;
      } else if (regex.hasMatch(tmp[0].toString())) {
        _timeMedChoice = 0;
        timeMed = stringToTimeOfDay(tmp[0].toString());
      } else {
        _timeMedChoice = 1;
        hour = widget.usage!.hour;
        timeOfDayCardsSelected[0] = hour.contains('Rano');
        timeOfDayCardsSelected[1] = hour.contains('Wieczorem');
        timeOfDayCardsSelected[2] = hour.contains('Po południu');
        timeOfDayCardsSelected[3] = hour.contains('Na noc');
      }
      if(widget.usage!.probiotic == 'Brak'){
        _probioticChoice = 1;
      } else if (widget.usage!.probiotic == ''){

      } else {
        probioticName = widget.usage!.probiotic;
        _typeAheadProController.text = widget.usage!.probiotic;
      }
      tmp = widget.usage!.conflict;
      if(tmp[0] == 'Brak'){
        _conflictChoice = 1;
      } else {
        _conflictChoice = 0;
        conflictMed = tmp[0].toString();
        timeCon = stringToTimeOfDay(tmp[1].toString());
        conflictMedId = tmp[2];
        _typeAheadConController.text = tmp[0].toString();
      }
      restrictions = widget.usage!.restrictions;
      restrictionsCardsSelected[0] = restrictions == 'Brak' ? true : false;
      restrictionsCardsSelected[1] = restrictions == 'Na czczo' ? true : false;
      restrictionsCardsSelected[2] = restrictions == 'Przy posiłku' ? true : false;
      restrictionsCardsSelected[3] = restrictions == 'Po posiłku' ? true : false;
      if(widget.usage!.notificationData[0] != 'Brak'){
        notificationData = widget.usage!.notificationData;
        if(_timeMedChoice != 0){
          timeMed = TimeOfDay(hour: notificationData[0], minute: notificationData[1]);
        }
      }
      else {
        _timeNotChoice = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = timeMed.hour.toString().padLeft(2, '0');
    final minutes = timeMed.minute.toString().padLeft(2, '0');
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
                                enabled: widget.usage == null,
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
                                  disabledBorder: OutlineInputBorder(
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
                                  const SizedBox(height: 30),
                                  MultiSelectContainer(
                                    items: [
                                      MultiSelectCard(value: 'Poniedziałek', label: 'Poniedziałek', selected: daysCardsSelected[0]),
                                      MultiSelectCard(value: 'Wtorek', label: 'Wtorek', selected: daysCardsSelected[1]),
                                      MultiSelectCard(value: 'Środa', label: 'Środa', selected: daysCardsSelected[2]),
                                      MultiSelectCard(value: 'Czwartek', label: 'Czwartek', selected: daysCardsSelected[3]),
                                      MultiSelectCard(value: 'Piątek', label: 'Piątek', selected: daysCardsSelected[4]),
                                      MultiSelectCard(value: 'Sobota', label: 'Sobota', selected: daysCardsSelected[5]),
                                      MultiSelectCard(value: 'Niedziela', label: 'Niedziela', selected: daysCardsSelected[6]),
                                    ],
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
                                  const SizedBox(height: 30),
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
                                            timeMed = newTime;
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
                                    const SizedBox(height: 30),
                                    MultiSelectContainer(
                                      items: [
                                        MultiSelectCard(value: 'Rano', label: 'Rano', selected: timeOfDayCardsSelected[0]),
                                        MultiSelectCard(value: 'Wieczorem', label: 'Wieczorem', selected: timeOfDayCardsSelected[1]),
                                        MultiSelectCard(value: 'Po południu', label: 'Po południu', selected: timeOfDayCardsSelected[2]),
                                        MultiSelectCard(value: 'Na noc', label: 'Na noc', selected: timeOfDayCardsSelected[3]),
                                      ],
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
                                  const SizedBox(height: 30),
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
                                            timeMed = newTime;
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
                            const SizedBox(height: 30),
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
                              items: [
                                MultiSelectCard(value: 'Brak', label: 'Brak', selected: restrictionsCardsSelected[0]),
                                MultiSelectCard(value: 'Na czczo', label: 'Na czczo', selected: restrictionsCardsSelected[1]),
                                MultiSelectCard(value: 'Przy posiłku', label: 'Przy posiłku', selected: restrictionsCardsSelected[2]),
                                MultiSelectCard(value: 'Po posiłku', label: 'Po posiłku', selected: restrictionsCardsSelected[3]),
                              ],
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
                                  const SizedBox(height: 30),
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
                                        const SizedBox(height: 30),
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
                            const SizedBox(height: 30),
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
                                  const SizedBox(height: 30),
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
                                        conflictMedId = (usages
                                            .where((us) => us.medicationName == conflictMed)).first.usageId;
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
                                            timeCon = newTime;
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
                                    NotificationService().showScheduledNotifications();
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
                                      _handleSave(medications);
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
      hour = [formatTimeOfDay(timeMed)];
    } else if(_timeMedChoice == 2){
      hour = ['Brak'];
    }
    if(_conflictChoice == 0){
      conflict = [conflictMed, formatTimeOfDay(timeCon), conflictMedId];
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
    if(_timeNotChoice == 0){
      notificationData = [timeMed.hour, timeMed.minute];
      notificationData.addAll(notificationIds);
    } else {
      notificationData = ['Brak'];
    }
    String userId = '';
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
    } else {
      userId = user.uid.toString();
    }
    final newUsage = Usage(
      usageId: widget.usage == null ? DateTime.now().toString() : widget.usage!.usageId,
      medicationName: medication,
      profileId: widget.profileId,
      administration: administration,
      hour: hour,
      restrictions: restrictions,
      conflict: conflict,
      probiotic: probiotic,
      userId: userId,
      notificationData: notificationData,
    );
    if(widget.usage == null){
      BlocProvider.of<UsageBloc>(context).add(AddUsage(newUsage));
    } else {
      BlocProvider.of<UsageBloc>(context).add(UpdateUsage(newUsage));
    }
    Navigator.pop(context);
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void checkSelectedDays(){
    daysCardsSelected[0] = administration.contains('Poniedziałek');
    daysCardsSelected[1] = administration.contains('Wtorek');
    daysCardsSelected[2] = administration.contains('Środa');
    daysCardsSelected[3] = administration.contains('Czwartek');
    daysCardsSelected[4] = administration.contains('Piątek');
    daysCardsSelected[5] = administration.contains('Sobota');
    daysCardsSelected[6] = administration.contains('Niedziela');
  }

  int findMissingNumber(List<int> numbers) {
    if(numbers.isEmpty) return 1;
    numbers.sort();
    int missingNumber = 1;
    for (int number in numbers) {
      if (number == missingNumber) {
        missingNumber++;
      }
    }
    return missingNumber;
  }

  void _createNotificationIds(List<int> idsInUse) async  {
    int newId = 0;
    List<int> ids = [];
    if(_administrationChoice == 0){
      newId = findMissingNumber(idsInUse);
      ids = [newId];
    } else {
      checkSelectedDays();
      for(int i = 0; i < 7; i++){
        if(daysCardsSelected[i]){
          newId = findMissingNumber(idsInUse);
          ids.add(newId);
          idsInUse.add(newId);
        }
      }
    }
    setState(() {
      notificationIds = ids;
    });
    //return ids;
  }

  void _scheduleNotifications() async {
    String userId = '';
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid.toString();
    if(_administrationChoice == 0){
      final notificationData = NotificationData(
        notificationId : DateTime.now().toString(),
        awNotId: notificationIds[0],
        userId: userId,
        body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
        hour: timeMed.hour,
        minute: timeMed.minute,
        weekday: null,
      );
      BlocProvider.of<NotificationBloc>(context).add(AddNotification(notificationData));
      await NotificationService().scheduleDailyNotification(
          title: 'Czas na lek!',
          body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
          id: notificationIds[0],
          hour: timeMed.hour,
          minute: timeMed.minute,
      );
    } else {
      int id = 0;
      for(int i = 0; i < 7; i++){
        if(daysCardsSelected[i]){
          final notificationData = NotificationData(
            notificationId : DateTime.now().toString(),
            awNotId: notificationIds[id],
            userId: userId,
            body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
            hour: timeMed.hour,
            minute: timeMed.minute,
            weekday: i + 1,
          );
          BlocProvider.of<NotificationBloc>(context).add(AddNotification(notificationData));
          await NotificationService().scheduleNotificationWeekday(
              title: 'Czas na lek',
              body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
              id: notificationIds[id],
              hour: timeMed.hour,
              minute: timeMed.minute,
              weekday: i +1
          );
        }
        id++;
      }
    }
  }

  void _handleSave (List<Medication> medications) async {
    List<int> idsInUse = await NotificationService().getScheduledNotificationIds();
    if(widget.usage != null){
      //edit mode
      if(_timeNotChoice == 0){
        //chcemy powiadomienia
        if(widget.usage!.notificationData.isNotEmpty){
          //już było powiadomienie
          for(int i = 2; i < notificationData.length; i++){
            //usuwamy poprzednie powiadomienia
            NotificationService().clearNotifications(notificationData[i]);
            BlocProvider.of<NotificationBloc>(context).add(DeleteNotification(notificationData[i]));
          }
        }
        //nie było powidomień + tworzenie po usunięciu
        _createNotificationIds(idsInUse);
        _scheduleNotifications();
      } else {
        //nie chcemy powiadomień
        if(widget.usage!.notificationData.isNotEmpty){
          //są powiadomienia
          for(int i = 2; i < notificationData.length; i++){
            //usuwamy poprzednie powidomienia
            NotificationService().clearNotifications(notificationData[i]);
            BlocProvider.of<NotificationBloc>(context).add(DeleteNotification(notificationData[i]));
          }
        }
      }
    } else {
      //add mode
      //wybrana opcja powiadomienia - dodajemy powiadomienie
      if(_timeNotChoice == 0){
        _createNotificationIds(idsInUse);
        _scheduleNotifications();
      }
    }
    saveUsage(medications);
  }
}