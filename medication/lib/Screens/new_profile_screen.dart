import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database_classes/Profile.dart';
import '../Blocs/profile_bloc.dart';
import 'package:medication/Services/authorization.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class NewProfileView extends StatefulWidget {
  final String? userId;
  final bool editMode;
  final Profile? profile;

  const NewProfileView({
    Key? key,
    required this.userId,
    required this.editMode,
    required this.profile,
  }) : super(key: key);

  @override
  State<NewProfileView> createState() => _NewProfileViewState();

}

class _NewProfileViewState extends State<NewProfileView> {

  final AuthorizationService _authorizationService = AuthorizationService();

  Color? button1Color = Color.fromARGB(255, 174, 199, 255);
  Color? button2Color = Colors.grey[200];
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int _tabIconIndexSelected = 0;

  @override
  void initState() {
    super.initState();
    name = widget.editMode ? widget.profile!.name : '';
    if(widget.editMode){
      _tabIconIndexSelected = widget.profile!.isAnimal ? 1 : 0;
    }
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
                      widget.editMode ? 'Edytuj profil' :'Dodaj nowy profil',
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
                    initialValue: widget.editMode ? widget.profile?.name ?? '' : null,
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
                const SizedBox(height: 40),
                FlutterToggleTab(
                  width: 75,
                  height: 60,
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  unSelectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  selectedBackgroundColors: const [Color.fromARGB(255, 174, 199, 255)],
                  unSelectedBackgroundColors: [Colors.grey[800]!],
                  labels: ['Człowiek', 'Zwierzę'],
                  selectedLabelIndex: (index) {
                    if (!widget.editMode) {
                      setState(() {
                        _tabIconIndexSelected = index;
                      });
                    } else {}
                  },
                  selectedIndex: _tabIconIndexSelected,
                  icons: [Icons.person, Icons.pets],
                  iconSize: 25,
                ),
                const SizedBox(height: 80),
                Row(
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
                          if(widget.editMode){
                            if (name == widget.profile?.name){
                              Navigator.pop(context);
                            } else {
                              final updatedProfile = Profile(
                              profileId: widget.profile!.profileId,
                              name: name,
                              isAnimal: widget.profile!.isAnimal,
                              userId: widget.profile!.userId,
                              );
                              BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(updatedProfile));
                              Navigator.pop(context);
                            }
                          } else {
                            final profile = Profile(
                            profileId: DateTime.now().toString(),
                            name: name,
                            isAnimal: _tabIconIndexSelected == 0 ? false : true,
                            userId: widget.userId!,
                            );
                            BlocProvider.of<ProfileBloc>(context).add(AddProfile(profile));
                            Navigator.pop(context);
                            }
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