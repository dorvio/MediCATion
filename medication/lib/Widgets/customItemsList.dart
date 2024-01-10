import 'package:flutter/material.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Database_classes/Profile.dart';

///custom list class
///reusable list with customized look
class CustomItemList<T> extends StatelessWidget {
  final T item;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onPressed;
  final IconData icon;

  const CustomItemList({
    Key? key,
    required this.item,
    required this.onDeletePressed,
    required this.onEditPressed,
    required this.onPressed,
    this.icon = Icons.ads_click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 3),
        Container(
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.grey[800],
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    icon,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 7,
                  child: Text(
                    item is Usage ? (item as Usage).medicationName : (item as Profile).name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: onEditPressed,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: onDeletePressed,
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
