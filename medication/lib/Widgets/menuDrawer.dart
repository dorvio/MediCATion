import 'package:flutter/material.dart';
import 'package:medication/Services/authorization.dart';

///custom menu drawer class
///reusable menu drawer with customized look
class MenuDrawer extends StatelessWidget {

  MenuDrawer({Key? key}) : super(key: key);
  final AuthorizationService _authorizationService = AuthorizationService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 93,
            width: double.infinity,
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
            child: Row(
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
      ),
    );
  }
}