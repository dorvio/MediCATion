import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocks/type_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';

class NewMedicationView extends StatefulWidget {

  const NewMedicationView({
    Key? key,
  }) : super(key: key);

  @override
  State<NewMedicationView> createState() => _NewMedicationViewState();
}

class _NewMedicationViewState extends State<NewMedicationView> {

  final AuthorizationService _authorizationService = AuthorizationService();

  @override
  void initState() {
    BlocProvider.of<TypeBloc>(context).add(LoadTypes());
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
      body: Column(
        children: [
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}