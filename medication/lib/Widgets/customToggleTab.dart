import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class MyToggleTab extends StatefulWidget {
  final bool editMode;

  MyToggleTab({Key? key, required this.editMode}) : super(key: key);

  @override
  _MyToggleTabState createState() => _MyToggleTabState();
}

class _MyToggleTabState extends State<MyToggleTab> {
  int _tabIconIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return FlutterToggleTab(
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
    );
  }
}
