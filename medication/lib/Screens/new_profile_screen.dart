import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database_classes/Profile.dart';
import '../Blocs/profile_bloc.dart';
import 'package:medication/Services/authorization.dart';

class NewProfileView extends StatefulWidget {
  final String userId;

  const NewProfileView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<NewProfileView> createState() => _NewProfileViewState();

}

class _NewProfileViewState extends State<NewProfileView> {

  final AuthorizationService _authorizationService = AuthorizationService();

  bool isAnimalController = false;
  Color? button1Color = Color.fromARGB(255, 174, 199, 255);
  Color? button2Color = Colors.grey[200];
  final _formKey = GlobalKey<FormState>();
  String name = '';

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
        child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    "Dodaj nowy profil",
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
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLength: 15,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nazwa profilu',
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
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Pole nie może być puste!';
                      }
                      return null;
                    },
                    onChanged: (text) => setState(() => name = text),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    color: Colors.grey[800],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          tooltip: 'Profil człowieka',
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
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          tooltip: 'Profil zwierzęcia',
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        if (_formKey.currentState!.validate()) {
                          final profile = Profile(
                            profileId: DateTime.now().toString(),
                            name: name,
                            isAnimal: isAnimalController,
                            userId: widget.userId,
                          );
                          BlocProvider.of<ProfileBloc>(context).add(AddProfile(profile));
                          Navigator.pop(context);
                        } else {}
                      },
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}