import 'package:flutter/material.dart';
import '../Widgets/customItemsList.dart';
import '../Widgets/menuDrawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medication/Screens/new_profile_screen.dart';
import '../Database_classes/Profile.dart';
import '../Blocs/profile_bloc.dart';
import 'medication_screen.dart';

class ProfileView extends StatefulWidget {
  final String userId;

  const ProfileView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();

}

class _ProfileViewState extends State<ProfileView> {

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(widget.userId));

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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profiles = state.profiles;
            return Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group,
                      color: Color.fromARGB(255, 174, 199, 255),
                      size: 40,
                    ),
                    Text(
                      "TWOJE PROFILE",
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
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profile = profiles[index];
                      return CustomItemList(
                        item: profile,
                        onDeletePressed: () {
                          _showDeleteDialog(context, profile);
                        },
                        onEditPressed: () {
                          _modifyProfile(context, profile);
                        },
                        onPressed: () {
                          _goToMedicationScreen(context, profile);
                        },
                        icon: profile.isAnimal == false ? Icons.person : Icons.pets,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProfileOperationSuccess) {
            BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(widget.userId)); // Reload profiles
            return Container();
          } else if (state is ProfileError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewProfile(context, widget.userId);
        },
        tooltip: 'Dodaj nowy profil',
        child: const Icon(Icons.person_add_alt),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, Profile profile) {
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
              'Czy na pewno chcesz usunąć profil ${profile.name}?',
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
                  } else if (text != profile.name) {
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
                  if(_formKey.currentState!.validate()){
                    BlocProvider.of<ProfileBloc>(context).add(
                        DeleteProfile(profile.profileId),
                    );
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

void _goToMedicationScreen(BuildContext context, Profile profile) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MedicationView(profile: profile)),
  );
}

void _createNewProfile(BuildContext context, String userId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewProfileView(userId: userId, editMode: false, profile: null)),
  );
}

void _modifyProfile(BuildContext context, Profile profile) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewProfileView(userId: null, editMode: true, profile: profile)),
  );
}