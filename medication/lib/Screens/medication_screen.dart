import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Screens/new_medication_screen.dart';
import 'package:medication/Screens/new_usage_screen.dart';
import 'package:medication/CustomIcons/app_icons_icons.dart';
import 'package:medication/Screens/usage_screen_controller.dart';
import '../Blocs/usage_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/customItemsList.dart';
import '../Widgets/menuDrawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Database_classes/Profile.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

///class displaying medication screen with all activities
///allows to display, add, edit and delete usages
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

  @override
  void initState() {
    BlocProvider.of<UsageBloc>(context).add(LoadUsages(widget.profile.profileId));
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
      endDrawer: MenuDrawer(),
      backgroundColor: Colors.grey[900],
      body: BlocBuilder<UsageBloc, UsageState>(
        builder: (context, state) {
          if (state is UsageLoading) {
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
                      return CustomItemList(
                        item: usage,
                        onDeletePressed: () {
                          _showDeleteDialog(context, usage);
                        },
                        onEditPressed: () {
                          goToEditUsageScreen(context, widget.profile.isAnimal, widget.profile.profileId, usage, widget.profile.name);
                        },
                        onPressed: () {
                          _goToUsageScreen(context, usage);
                        },
                        icon: MdiIcons.pill,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is UsageOperationSuccess) {
            BlocProvider.of<UsageBloc>(context).add(LoadUsages(widget.profile.profileId));
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
            onTap: () => goToNewUsageScreen(context, widget.profile.isAnimal, widget.profile.profileId, widget.profile.name),
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

///function navigating to new medication screen
void goToNewMedicationScreen(BuildContext context, bool animal) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewMedicationView(animal: animal)),
  );
}

///function navigating to new usage screen
void goToNewUsageScreen(BuildContext context, bool animal, String profileId, String profileName) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewUsageView(animal: animal, profileId: profileId, profileName: profileName, usage: null)),
  );
}

///function navigating to edit usage screen
void goToEditUsageScreen(BuildContext context, bool animal, String profileId, Usage usage, String profileName) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewUsageView(animal: animal, profileId: profileId, profileName: profileName, usage: usage)),
  );
}

///function navigating screen displaying data about usage
void _goToUsageScreen(BuildContext context, Usage usage) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UsageController(usage: usage)),
  );
}

/// Function displaying a dialog to confirm delete
/// The user is required to enter the name of the profile being deleted
/// as an additional security measure.
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