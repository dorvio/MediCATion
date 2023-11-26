import 'package:flutter/material.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UsageView extends StatefulWidget {
  final Usage usage;

  const UsageView({
    Key? key,
    required this.usage,
  }) : super(key: key);

  @override
  State<UsageView> createState() => _UsageViewState();
}

class _UsageViewState extends State<UsageView> {
  final AuthorizationService _authorizationService = AuthorizationService();

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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.pill,
                  color: const Color.fromARGB(255, 174, 199, 255),
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.usage.medicationName,
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
            const Text(
              'PODAWANIE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.usage.administration.join(', '),
              style: const TextStyle(
                color: Color.fromARGB(255, 174, 199, 255),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'GODZINA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.usage.hour.join(', '),
              style: const TextStyle(
                color: Color.fromARGB(255, 174, 199, 255),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'OGRANICZNIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.usage.restrictions,
              style: const TextStyle(
                color: Color.fromARGB(255, 174, 199, 255),
                fontSize: 20,
              ),
            ),
            Visibility(
              visible: widget.usage.probiotic != '',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'PROBIOTYK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.usage.probiotic,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 174, 199, 255),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'KONFLIKT Z INNYM LEKIEM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.usage.conflict[0],
              style: const TextStyle(
                color: Color.fromARGB(255, 174, 199, 255),
                fontSize: 20,
              ),
            ),
            Visibility(
              visible: widget.usage.conflict.length > 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'CZAS POMIĘDZY LEKAMI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.conflict.length > 1 ? widget.usage.conflict[1] : '',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
            ),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                ),
                child: const Text(
                    'Wyjdź',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
