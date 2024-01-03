import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTypeAheadFormField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSuggestionSelected;
  final void Function()? onClear;
  final bool enabled;
  final String label;
  final IconData icon;
  final FutureOr<List<String>> Function(String) suggestionsCallback;

  const CustomTypeAheadFormField({
    Key? key,
    required this.controller,
    required this.onSuggestionSelected,
    required this.onClear,
    this.enabled = true,
    this.label = "Wybierz",
    this.icon = Icons.ads_click,
    required this.suggestionsCallback,
  }) : super(key: key);

  @override
  _CustomTypeAheadFormFieldState createState() => _CustomTypeAheadFormFieldState();
}

class _CustomTypeAheadFormFieldState extends State<CustomTypeAheadFormField> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        enabled: widget.enabled,
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white),
          counterStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(30.0),
          ),
          disabledBorder: OutlineInputBorder(
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
          prefixIcon: Icon(widget.icon),
          prefixIconColor: Colors.white,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: widget.onClear,
          ),
          suffixIconColor: Colors.white,
        ),
      ),
      suggestionsCallback: widget.suggestionsCallback,
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(
            suggestion,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) =>
      suggestionsBox,
      onSuggestionSelected: widget.onSuggestionSelected,
      noItemsFoundBuilder: (context) =>
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
                'Nie znaleziono leku',
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 20,
                )
            ),
          ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.grey[800],
      ),
      validator: (text) {
        if(text == null || text.isEmpty){
          return 'Pole nie może być puste';
        }
        return null;
      },
    );
  }
}
