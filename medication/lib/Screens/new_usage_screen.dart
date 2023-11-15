import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/medication_bloc.dart';
import 'package:medication/Database_classes/Medication.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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

  @override
  void initState() {
    BlocProvider.of<MedicationBloc>(context).add(LoadMedications(widget.animal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String medication = '';
    final TextEditingController _typeAheadController = TextEditingController();

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
      body: Container(
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
    );
  }
}
