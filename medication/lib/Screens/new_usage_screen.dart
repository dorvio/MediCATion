import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medication/Widgets/customButton.dart';
import 'package:medication/Widgets/customDropdownFormField.dart';
import 'package:medication/Widgets/customToggleTab.dart';
import 'package:medication/Widgets/customTypeAhead.dart';
import '../Widgets/headerText.dart';
import '../Widgets/menuDrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Blocs/notification_bloc.dart';
import 'package:medication/Blocs/usage_bloc.dart';
import 'package:medication/Database_classes/NotificationData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medication/Services/notification_service.dart';

///class to add new usage
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadMedController = TextEditingController();
  final TextEditingController _typeAheadProController = TextEditingController();
  final TextEditingController _doseNumerController = TextEditingController();
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
  String doseNumber = '';
  String doseType = '';
  List<int> notificationIds = [];
  bool administrationError = false;
  bool hourError = false;
  bool restrictionError = false;
  bool conflictError = false;
  List<bool> daysCardsSelected = [false, false, false, false, false, false, false];
  List<bool> timeOfDayCardsSelected = [false, false, false, false];
  List<bool> restrictionsCardsSelected = [false, false, false, false];
  Map<String, bool> checkedConMeds = {};

  final List<String> types = <String>[
    'tabletka',
    'kapsułka',
    'ampułka',
    'spray',
    'plaster',
    'czopek',
    'zastrzyk',
    'gram'
  ];

  @override
  void initState() {
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(widget.animal));
    BlocProvider.of<UsageBloc>(context).add(LoadUsages(widget.profileId));
    super.initState();

    if (widget.usage != null) {
      medication = widget.usage!.medicationName;
      _typeAheadMedController.text = widget.usage!.medicationName;
      doseNumber = widget.usage!.doseData[0];
      _doseNumerController.text = doseNumber;
      doseType = widget.usage!.doseData[1];
      List<dynamic> tmp = widget.usage!.administration;
      administration = widget.usage!.administration;
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
        conflictMed = tmp[1].toString();
        timeCon = stringToTimeOfDay(tmp[0].toString());
        conflictMedId = tmp[2];
        for(int i = 1; i < tmp.length; i+=2){
          checkedConMeds[tmp[i]] = true;
        }
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
      endDrawer: MenuDrawer(),
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
                    final List<String> otherMeds = usages.map((us) => us.medicationName).toList();
                    if(widget.usage != null){
                      otherMeds.removeWhere((element) => element == widget.usage!.medicationName);
                    }
                    return Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                widget.usage == null ? "Dodaj podawany lek" : "Edytuj podawany lek",
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
                            CustomTypeAheadFormField(
                                controller: _typeAheadMedController,
                                onSuggestionSelected: (String suggestion) {
                                  _typeAheadMedController.text = suggestion;
                                  setState(() {
                                    medication = suggestion;
                                  });
                                },
                                onClear: (){
                                  setState(() {
                                    _typeAheadMedController.clear();
                                    medication = '';
                                  });
                                },
                                enabled: widget.usage == null,
                                suggestionsCallback: (pattern) {
                                  return medications
                                      .where((med) => med.medication.toLowerCase().contains(pattern.toLowerCase()))
                                      .map((med) => med.medication)
                                      .toList();
                                },
                              label: 'Lek',
                              icon: MdiIcons.pill,
                            ),
                            const SizedBox(height: 30),
                            const HeaderText(text: "DAWKA"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: TextFormField(
                                      controller: _doseNumerController,
                                      style: const TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: '',
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
                                        prefixIcon: Icon(MdiIcons.numeric),
                                        prefixIconColor: Colors.white,
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Pole nie może być puste!';
                                        }
                                        return null;
                                      },
                                      onChanged: (text) => setState(() => doseNumber = text),
                                    ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CustomDropdownButtonFormField(
                                    items: types,
                                    onChanged: (String? value) {
                                      doseType = value!;
                                    },
                                    labelText: "Jednostka",
                                    prefixIcon: Icon(Icons.search),
                                    value: widget.usage != null ? doseType : null,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Należy wybrać!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const HeaderText(text: "PODAWANIE"),
                            const SizedBox(height: 10),
                            CustomToggleTab(
                                labels: ['Codziennie', 'Harmonogram'],
                                selectedIndex: _administrationChoice,
                                selectedLabelIndex: (index) {
                                  setState(() {
                                    _administrationChoice = index;
                                  });
                                },
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
                            const HeaderText(text: "GODZINA"),
                            const SizedBox(height: 10),
                            CustomToggleTab(
                              labels: ['Konkretna', 'Ogólna', 'Brak'],
                              selectedIndex: _timeMedChoice,
                              selectedLabelIndex: (index) {
                                setState(() {
                                  _timeMedChoice = index;
                                });
                              },
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
                            const HeaderText(text: "POWIADOMIENIE"),
                            const SizedBox(height: 10),
                            CustomToggleTab(
                              labels: ['TAK', 'NIE'],
                              selectedIndex: _timeNotChoice,
                              selectedLabelIndex: (index) {
                                setState(() {
                                  _timeNotChoice = index;
                                });
                              },
                              icons: [Icons.notifications, Icons.notifications_off],
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
                            const HeaderText(text: "OGRANICZNIA"),
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
                                  const HeaderText(text: "PROBIOTYK"),
                                  const SizedBox(height: 10),
                                  CustomToggleTab(
                                    labels: ['TAK', 'NIE'],
                                    selectedIndex: _probioticChoice,
                                    selectedLabelIndex: (index) {
                                      setState(() {
                                        _probioticChoice = index;
                                      });
                                    },
                                    icons: [MdiIcons.pill, MdiIcons.pillOff],
                                  ),
                                  Visibility(
                                    visible: _probioticChoice == 0,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        CustomTypeAheadFormField(
                                          controller: _typeAheadProController,
                                          onSuggestionSelected: (String suggestion) {
                                            _typeAheadProController.text = suggestion;
                                            setState(() {
                                              probioticName = suggestion;
                                            });
                                          },
                                          onClear: (){
                                            setState(() {
                                              _typeAheadProController.clear();
                                              probioticName = '';
                                            });
                                          },
                                          suggestionsCallback: (pattern) {
                                            return probiotics
                                                .where((pro) => pro.medication.toLowerCase().contains(pattern.toLowerCase()))
                                                .map((pro) => pro.medication)
                                                .toList();
                                          },
                                          label: 'Probiotyk',
                                          icon: MdiIcons.pill,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: otherMeds.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    CustomToggleTab(
                                      labels: ['TAK', 'NIE'],
                                      selectedIndex: _conflictChoice,
                                      selectedLabelIndex: (index) {
                                        setState(() {
                                          _conflictChoice = index;
                                        });
                                      },
                                    ),
                                    Visibility(
                                        visible: _conflictChoice == 0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 30),
                                            for (final itemName in otherMeds)
                                              CheckboxListTile(
                                                title: Text(itemName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                activeColor: Color.fromARGB(255, 174, 199, 255),
                                                value: checkedConMeds[itemName] ?? false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkedConMeds[itemName] = value ?? false;
                                                  });
                                                },
                                              ),
                                            Visibility(
                                              visible: conflictError,
                                              child: const Text(
                                                  'Należy wybrać przynajmniej 1 element',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                  )
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            const HeaderText(text: "CZAS POMIĘDZY LEKAMI"),
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
                                )
                            ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                            Row(
                              children: [
                                CustomButton(
                                  text: "Anuluj",
                                    onPressed: () {
                                      NotificationService().showScheduledNotifications();
                                      Navigator.pop(context);
                                    },
                                ),
                                const SizedBox(width: 25),
                                CustomButton(
                                  text: "Zapisz",
                                    onPressed: () {
                                      if(_formKey.currentState!.validate() && _isAdministrationValid() && _isHourValid() && _isRestrictionValid() && _isConflictValid()){
                                        _handleSave(medications, usages);
                                      }
                                    },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
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

  ///function showing time picker
  ///returns chosen time
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

  ///function checking if medication is type antibiotic
  bool _isAntibiotic (List<Medication> medications){
    if(medication == '') {return false;}
    Medication selectedMed = medications.firstWhere((element) => element.medication == medication);
    if(selectedMed.type == 'Antybiotyk') {
      return true;
    } else {
      return false;
    }
  }

  ///function checking if data in category administration is filled correctly
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

  ///function checking if data in category hour is filled correctly
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

  ///function checking if data in category restrictions is filled correctly
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

  ///function checking if data in category conflict is filled correctly
  bool _isConflictValid(){
    if(_conflictChoice == 0 && checkedConMeds.values.any((value) => value == true)){
      setState(() {
        conflictError = false;
      });
      return true;
    } else {
      setState(() {
        conflictError = true;
      });
      return false;
    }
  }

  ///function adding new usage to Firebase
  void saveUsage(List<Medication> medications, List<Usage> usages) {
    List<dynamic> doseData = [doseNumber, doseType];
    if(_administrationChoice == 0){
      administration = ['Codziennie'];
    }
    if(_timeMedChoice == 0){
      hour = [formatTimeOfDay(timeMed)];
    } else if(_timeMedChoice == 2){
      hour = ['Brak'];
    }
    if(_conflictChoice == 0){
      conflict = [formatTimeOfDay(timeCon)];
      List<String> conflictMeds = checkedConMeds.keys.where((key) => checkedConMeds[key] == true).toList();
      for(String el in conflictMeds){
        conflict.add(el);
        conflict.add(usages.firstWhere((element) => element.medicationName == el).usageId);
      }
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
      doseData: doseData,
    );
    if(widget.usage == null){
      BlocProvider.of<UsageBloc>(context).add(AddUsage(newUsage));
    } else {
      BlocProvider.of<UsageBloc>(context).add(UpdateUsage(newUsage));
    }
    Navigator.pop(context);
  }

  ///function formating time to string
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  ///function converting string to timeOfDay
  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  ///function checking which days where selected
  void checkSelectedDays(){
    daysCardsSelected[0] = administration.contains('Poniedziałek');
    daysCardsSelected[1] = administration.contains('Wtorek');
    daysCardsSelected[2] = administration.contains('Środa');
    daysCardsSelected[3] = administration.contains('Czwartek');
    daysCardsSelected[4] = administration.contains('Piątek');
    daysCardsSelected[5] = administration.contains('Sobota');
    daysCardsSelected[6] = administration.contains('Niedziela');
  }

  ///function finding the smallest missing number
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

  ///function creating ids for notifications
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

  ///functions schedulting new notifications
  void _scheduleNotifications() async {
    String userId = '';
    User? user = FirebaseAuth.instance.currentUser;
    userId = user!.uid.toString();
    if(_administrationChoice == 0){
      final notificationData = NotificationData(
        notificationId : DateTime.now().toString(),
        locNotId: notificationIds[0],
        userId: userId,
        body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
        hour: timeMed.hour,
        minute: timeMed.minute,
        weekday: null,
      );
      BlocProvider.of<NotificationBloc>(context).add(AddNotification(notificationData));
      DateTime now = DateTime.now();
      DateTime time = DateTime(now.year, now.month, now.day, timeMed.hour, timeMed.minute);
      await NotificationService().scheduleDailyNotification(
          title: 'Czas na lek!',
          body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
          id: notificationIds[0],
          scheduledNotificationDateTime: time,
      );
    } else {
      int id = 0;
      for(int i = 0; i < 7; i++){
        if(daysCardsSelected[i]){
          final notificationData = NotificationData(
            notificationId : DateTime.now().toString(),
            locNotId: notificationIds[id],
            userId: userId,
            body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
            hour: timeMed.hour,
            minute: timeMed.minute,
            weekday: i + 1,
          );
          BlocProvider.of<NotificationBloc>(context).add(AddNotification(notificationData));
          DateTime time = NotificationService().findNextDayOfWeek(i+1);
          await NotificationService().scheduleWeeklyNotification(
              title: 'Czas na lek',
              body: 'To już czas dla ${widget.profileName}, aby przyjąć $medication',
              id: notificationIds[id],
            scheduledNotificationDateTime: time,
          );
        }
        id++;
      }
    }
  }

  /// Function checking data and adding new usage to Firebase or updating an existing one
  void _handleSave (List<Medication> medications, List<Usage> usages) async {
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
    saveUsage(medications, usages);
  }
}