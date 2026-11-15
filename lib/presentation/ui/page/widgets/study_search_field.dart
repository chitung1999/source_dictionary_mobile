import 'package:flutter/material.dart';

class StudySearchField extends StatelessWidget {
  const StudySearchField({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFE5E5E9),
        border: outline,
        enabledBorder: outline,
        focusedBorder: outline,
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }
}
