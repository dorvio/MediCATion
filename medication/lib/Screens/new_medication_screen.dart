import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';

class NewMedicationView extends StatefulWidget {
  final bool animal;

  const NewMedicationView({
    required this.animal,
    Key? key,
  }) : super(key: key);

  @override
  State<NewMedicationView> createState() => _NewMedicationViewState();
}

class _NewMedicationViewState extends State<NewMedicationView> {
  final AuthorizationService _authorizationService = AuthorizationService();
  final _formKey =GlobalKey<FormState>();
  bool showErrorName = false;
  bool showErrorType = false;
  String medicationName = '';
  String dropdownValue = '';
  String description = '';

  final List<String> types = <String>[
    'Antybiotyk',
    'Nasenne',
    'Przeciwbólowe',
    'Probiotyk',
    'Przeciwhistaminowe',
    'Witaminy',
    'Inne'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            bottomLeft: Radius.circular(20),
          ),
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
              onPressed: () {
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
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
              children: [
                Center(
                  child: Text(
                    "Utwórz nowy lek",
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
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nazwa leku',
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
                    errorText: showErrorName ? 'Pole nie może być puste!' : null,
                    prefixIcon: Icon(MdiIcons.pill),
                    prefixIconColor: Colors.white,
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      setState(() {
                        showErrorName = true;
                      });
                      return 'Pole nie może być puste!';
                    }
                    setState(() {
                      showErrorName = false;
                    });
                    return null;
                  },
                  onChanged: (text) => setState(() => medicationName = text),
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField(
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: "Wybierz typ",
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                      errorText: showErrorType ? 'Należy wybrać typ!' : null,
                      filled: true,
                      fillColor: Colors.grey[800],
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.white,

                    ),
                    padding: const EdgeInsets.all(0),
                    items: types.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                        dropdownValue = value!;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        setState(() {
                          showErrorType = true;
                        });
                        return 'Należy wybrać typ!';
                      }
                      setState(() {
                        showErrorType = false;
                      });
                      return null;
                    },
                ),
                const SizedBox(height: 40),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Opis',
                    labelStyle: const TextStyle(color: Colors.white),
                    counterStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromARGB(255, 174, 199, 255)),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    prefixIcon: Icon(Icons.description),
                    prefixIconColor: Colors.white,
                  ),
                  onChanged: (text) => setState(() => description = text),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        final medication = Medication(
                          medicationId: '',
                          medication: medicationName,
                          type: dropdownValue,
                          description: description,
                          forAnimal: widget.animal,
                        );
                        BlocProvider.of<MedicationBloc>(context).add(AddMedication(medication));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                        "Dodaj",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )
                    )
                ),
              ],
            ),
        ),
      ),
    );
  }
}
