import 'package:flutter/material.dart';

///custom text form field class
///reusable text form field with customized look
class CustomTextFormField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final String labelText;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;

  const CustomTextFormField({
    Key? key,
    this.onChanged,
    this.validator,
    this.prefixIcon = null,
    this.labelText = 'Wpisz tutaj',
    this.maxLines = null,
    this.maxLength = null,
    this.initialValue = null,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String medicationName = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      maxLines: widget.maxLines,
      maxLength : widget.maxLength,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.labelText,
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
        prefixIcon: widget.prefixIcon,
        prefixIconColor: Colors.white,
      ),
      validator: widget.validator ?? (text) {
        return null;
      },
      onChanged: (text) {
        setState(() {
          medicationName = text;
        });
        widget.onChanged?.call(text);
      },
    );
  }
}