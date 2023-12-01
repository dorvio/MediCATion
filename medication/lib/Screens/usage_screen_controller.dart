import 'package:flutter/material.dart';
import 'package:medication/Screens/usage_history_screen.dart';
import 'package:medication/Screens/usage_review_screen.dart';
import 'package:medication/Services/authorization.dart';
import 'package:medication/Database_classes/Usage.dart';

class UsageController extends StatefulWidget {
  final Usage usage;

  const UsageController({
    Key? key,
    required this.usage,
  }) : super(key: key);

  @override
  _UsageControllerState createState() => _UsageControllerState();
}

class _UsageControllerState extends State<UsageController> {
  final AuthorizationService _authorizationService = AuthorizationService();
  int currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

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
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex){
          setState(() {
            currentIndex = newIndex;
          });
        },
        children: [
          UsageReviewView(usage: widget.usage),
          UsageHistoryView(usage: widget.usage),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey[700],
        backgroundColor: Color.fromARGB(255, 174, 199, 255),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Dane o leku'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Dane przyjmowania'),
        ],
        onTap: (index) {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }
}
