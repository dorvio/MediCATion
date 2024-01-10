import 'package:flutter/material.dart';
import 'package:medication/Widgets/customDropdownFormField.dart';
import '../Widgets/menuDrawer.dart';
import '../Widgets/customTextFormField.dart';
import '../Widgets/customButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';

///class to add new medication
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
      endDrawer: MenuDrawer(),
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
                CustomTextFormField(
                  onChanged: (text) {
                    setState(() => medicationName = text);
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Pole nie może być puste!';
                    }
                    return null;
                  },
                  prefixIcon: Icon(MdiIcons.pill),
                  labelText: 'Nazwa leku',
                ),
                const SizedBox(height: 40),
                CustomDropdownButtonFormField(
                    items: types,
                    onChanged: (String? value) {
                      dropdownValue = value!;
                    },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Należy wybrać typ!';
                    }
                    return null;
                  },
                  labelText: "Wybierz typ",
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  onChanged: (text) {
                    setState(() => description = text);
                  },
                  maxLines: 8,
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Opis',
                ),
                const SizedBox(height: 40),
                CustomButton(
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
                  text: "Dodaj",
                ),
              ],
            ),
        ),
      ),
    );
  }
}
