import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database_classes/Profile.dart';
import '../Blocks/profile_bloc.dart';
import '../Blocks/type_bloc.dart';
import 'medication_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const ProfileView(),
    );
  }
}

class _ProfileViewState extends State<ProfileView> {

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(LoadProfiles());
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
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
                      Icons.arrow_left,
                      color: Color.fromARGB(255, 174, 199, 255),
                      size: 50,
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
                    const Icon(
                      Icons.arrow_right,
                      color: Color.fromARGB(255, 174, 199, 255),
                      size: 50,
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
                                _goToMedicationScreen(context, profile.profileId, profile.name);
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
                                      icon: Icon(Icons.edit),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(context, profile);
                                      },
                                      icon: Icon(Icons.delete),
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
            _profileBloc.add(LoadProfiles()); // Reload profiles
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
          _showAddProfileDialog(context);
        },
        tooltip: 'Dodaj nowy profil',
        child: const Icon(Icons.person_add_alt),
      ),
    );
  }
}
void _showAddProfileDialog(BuildContext context) {
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
                    isAnimal: profile.isAnimal
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

void _goToMedicationScreen(BuildContext context, String profileId, String profileName) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MedicationView(profileId: profileId, profileName: profileName)),
  );
}