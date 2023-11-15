import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database_classes/Profile.dart';
import '../Blocs/profile_bloc.dart';
import 'medication_screen.dart';
import 'package:medication/Services/authorization.dart';

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

  final AuthorizationService _authorizationService = AuthorizationService();

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(LoadProfiles(widget.userId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
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
                                _goToMedicationScreen(context, profile);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      profile.isAnimal == false ? Icons.person : Icons.pets,
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      profile.name,
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
                                        _showEditDialog(context, profile);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(context, profile);
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
          } else if (state is ProfileOperationSuccess) {
            _profileBloc.add(LoadProfiles(widget.userId)); // Reload profiles
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
          _showAddProfileDialog(context, widget.userId);
        },
        tooltip: 'Dodaj nowy profil',
        child: const Icon(Icons.person_add_alt),
      ),
    );
  }
}
void _showAddProfileDialog(BuildContext context, String userId) {
  bool isAnimalController = false;
  Color? button1Color = Theme.of(context).colorScheme.inversePrimary;
  Color? button2Color = Colors.grey[200];
  bool showError = false;
  final _formKey = GlobalKey<FormState>();
  String name = '';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Dodaj profil',
              style: const TextStyle(color: Colors.white),
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                maxLength: 15,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Podaj nazwę',
                  labelStyle: const TextStyle(color: Colors.white),
                  counterStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorText: showError ? 'Pole nie może być puste!' : null,
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    setState(() {
                      showError = true;
                    });
                    return 'Pole nie może być puste!';
                  }
                  setState(() {
                    showError = false;
                  });
                  return null;
                },
                onChanged: (text) => setState(() => name = text),
              ),
            ),
            actions: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isAnimalController = false;
                        button1Color = Theme.of(context).colorScheme.inversePrimary;
                        button2Color = Colors.grey[200];
                      });
                    },
                    icon: const Icon(Icons.person),
                    color: button1Color,
                    iconSize: 40,
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isAnimalController = true;
                        button1Color = Colors.grey[200];
                        button2Color = Theme.of(context).colorScheme.inversePrimary;
                      });
                    },
                    icon: const Icon(Icons.pets),
                    color: button2Color,
                    iconSize: 40,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Anuluj'),
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
                    child: const Text('Zapisz'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final profile = Profile(
                          profileId: DateTime.now().toString(),
                          name: name,
                          isAnimal: isAnimalController,
                          userId: userId,
                        );
                        BlocProvider.of<ProfileBloc>(context).add(AddProfile(profile));
                        Navigator.pop(context);
                      } else {}
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}


void _showDeleteDialog(BuildContext context, Profile profile){
  showDialog(
      context: context,
      builder: (context)
  {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        'Czy na pewno chcesz usunąć profil ${profile.name}?',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
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
            foregroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text('TAK'),
          onPressed: () {
            BlocProvider.of<ProfileBloc>(context).add(
                DeleteProfile(profile.profileId));
            Navigator.pop(context);
          },
        ),
      ],
    );
  },
  );
}

void _showEditDialog(BuildContext context, Profile profile) {
  bool showError = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController(text: profile.name);
  String name = profile.name;

  showDialog(
    context: context,
    builder: (context) {
    return StatefulBuilder(
      builder: (context, setState) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Zmień nazwę',
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            maxLength: 15,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Podaj nazwę',
              labelStyle: const TextStyle(color: Colors.white),
              counterStyle: const TextStyle(color: Colors.white),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorText: showError ? 'Pole nie może być puste!' : null,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                setState(() {
                  showError = true;
                });
                return 'Pole nie może być puste!';
              }
              setState(() {
                showError = false;
              });
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
            child: const Text('Anuluj'),
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
            child: const Text('Zapisz'),
            onPressed: () {
              if (name == profile.name){
                Navigator.pop(context);
              }
              else if (_formKey.currentState!.validate()) {
                final updatedProfile = Profile(
                    profileId: profile.profileId,
                    name: name,
                    isAnimal: profile.isAnimal,
                    userId: profile.userId,
                );
                BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(updatedProfile));
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