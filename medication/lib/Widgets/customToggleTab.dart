import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class CustomToggleTab extends StatefulWidget {
  final List<String> labels;
  final List<IconData>? icons;
  final int selectedIndex;
  final void Function(int) selectedLabelIndex;

  CustomToggleTab({
    required this.labels,
    this.icons = null,
    required this.selectedIndex,
    required this.selectedLabelIndex,
  });

  @override
  _CustomToggleTabState createState() => _CustomToggleTabState();
}

class _CustomToggleTabState extends State<CustomToggleTab> {

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
      labels: widget.labels,
      selectedLabelIndex: widget.selectedLabelIndex,
      icons: widget.icons,
      selectedIndex: widget.selectedIndex,
      iconSize: 25,
    );
  }
}
