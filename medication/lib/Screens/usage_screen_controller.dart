import 'package:flutter/material.dart';
import '../Widgets/menuDrawer.dart';
import 'package:medication/Screens/usage_history_screen.dart';
import 'package:medication/Screens/usage_review_screen.dart';
import 'package:medication/Services/authorization.dart';
import 'package:medication/Database_classes/Usage.dart';

///class to manage displaying usage review and usage history screens
///allows to navigate between screen with swipes or BottomNavigationsBar
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
      endDrawer: MenuDrawer(),
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
