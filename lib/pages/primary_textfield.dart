import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? title;
  final TextInputType? keyboardType;
  final Function(String)? onPressed;
  final Iterable<String>? autofillHints;
  final bool? obscureText;
  const PrimaryTextField({
    super.key,
    required this.onPressed,
    this.hintText,
    this.labelText,
    this.title,
    this.autofillHints,
    this.keyboardType,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        onChanged: onPressed,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        obscureText: obscureText ?? false,
        scrollPadding: const EdgeInsets.only(bottom: 50),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
