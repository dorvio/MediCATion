import 'package:flutter/material.dart';

///custom dropdown button form field class
///reusable dropdown button form field  with customized look
class CustomDropdownButtonFormField extends StatelessWidget {
  final List<String> items;
  final FormFieldValidator<String>? validator;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final Widget prefixIcon;

  const CustomDropdownButtonFormField({
    Key? key,
    required this.items,
    this.validator,
    this.value,
    required this.onChanged,
    required this.labelText,
    this.prefixIcon = const Icon(Icons.search),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[800],
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30.0),
        ),
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
        filled: true,
        fillColor: Colors.grey[800],
        prefixIcon: prefixIcon,
        prefixIconColor: Colors.white,
      ),
      padding: const EdgeInsets.all(0),
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator ?? (text) {
        return null;
      },
      value: value,
    );
  }
}
