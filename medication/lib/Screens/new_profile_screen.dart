import 'package:flutter/material.dart';
import 'package:medication/Widgets/customButton.dart';
import 'package:medication/Widgets/customTextFormField.dart';
import '../Widgets/menuDrawer.dart';
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
      endDrawer: MenuDrawer(),
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
                  child: CustomTextFormField(
                    initialValue: widget.editMode ? widget.profile?.name ?? '' : null,
                    onChanged: (text) {
                      setState(() => name = text);
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Pole nie może być puste!';
                      }
                      return null;
                    },
                    labelText: 'Nazwa profilu',
                    maxLength : 15,
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
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Anuluj",
                    ),
                    const SizedBox(width: 25),
                    CustomButton(
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
                      text: "Zapisz",
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}