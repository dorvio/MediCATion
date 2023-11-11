import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Screens/new_medication_screen.dart';
import 'package:medication/Screens/new_usage_screen.dart';
import 'package:medication/CustomIcons/app_icons_icons.dart';
import '../Blocs/usage_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medication/Services/authorization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Database_classes/Profile.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MedicationView extends StatefulWidget {
  final Profile profile;

  const MedicationView({
    Key? key,
    required this.profile
  }) : super(key: key);

  @override
  State<MedicationView> createState() => _MedicationViewState();
  }

class _MedicationViewState extends State<MedicationView> {

  final AuthorizationService _authorizationService = AuthorizationService();

  @override
  void initState() {
    BlocProvider.of<UsageBloc>(context).add(LoadUsages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<UsageBloc, UsageState>(
        builder: (context, state) {
          if (state is UsageInitial) {
            return CircularProgressIndicator();
          } else if (state is UsageLoading) {
            return CircularProgressIndicator();
          } else if (state is UsageLoaded) {
            final usages = state.usages;
            return Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.profile.isAnimal == false ? Icons.person : Icons.pets,
                      color: const Color.fromARGB(255, 174, 199, 255),
                      size: 35,
                    ),
                    Text(
                      widget.profile.name.toUpperCase(),
                      style: GoogleFonts.tiltNeon(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 174, 199, 255),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: usages.length,
                    itemBuilder: (context, index) {
                      final usage = usages[index];
                      return Column(
                        children: [
                          const SizedBox(height: 3),
                          Container(
                            width: double.infinity,
                            height: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.grey[800],
                              ),
                              onPressed: () {
                                //_goToMedicationScreen(context, profile.profileId, profile.name, profile.isAnimal);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      MdiIcons.pill,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      usage.medicationName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        //_showEditDialog(context, profile);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(context, usage);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is UsageOperationSuccess) {
            BlocProvider.of<UsageBloc>(context).add(LoadUsages()); // Reload usages
            return Container();
          } else if (state is UsageError) {
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        //animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 20,
        backgroundColor: Color.fromARGB(255, 174, 199, 255),
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
            child: const Icon(
                AppIcons.person_pill,
                color: Colors.white,
            ),
            label: "Dodaj lek",
            backgroundColor: Color.fromARGB(255, 175, 77, 152),
            onTap: () => goToNewUsageScreen(context, widget.profile.isAnimal, widget.profile.profileId),
          ),
          SpeedDialChild(
            child: Icon(
                MdiIcons.pill,
                color:Colors.white),
            label: "Utwórz nowy lek",
            backgroundColor: Color.fromARGB(255, 175, 77, 152),
            onTap: () => goToNewMedicationScreen(context, widget.profile.isAnimal),
          ),
        ],
      ),
    );
  }
}

void goToNewMedicationScreen(BuildContext context, bool animal) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewMedicationView(animal: animal)),
  );
}

void goToNewUsageScreen(BuildContext context, bool animal, String profileId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewUsageView(animal: animal, profileId: profileId)),
  );
}

void _showDeleteDialog(BuildContext context, Usage usage) {
  final _formKey = GlobalKey<FormState>();
  String name = '';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Czy na pewno chcesz usunąć lek ${usage.medicationName}?',
              style: const TextStyle(color: Colors.white),
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 15,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Podaj nazwę',
                  labelStyle: TextStyle(color: Colors.white),
                  counterStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Wpisz nazwę';
                  } else if (text != usage.medicationName){
                    return 'Nieprawidłowa nazwa';
                  }
                  return null;
                },
                onChanged: (text) => setState(() => name = text),
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('NIE'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('TAK'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<UsageBloc>(context).add(
                        DeleteUsage(usage.usageId));
                    Navigator.pop(context);
                  } else {}
                },
              ),
            ],
          );
        },
      );
    },
  );
}
