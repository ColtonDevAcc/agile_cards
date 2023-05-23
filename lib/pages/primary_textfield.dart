import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PrimaryTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? title;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final Iterable<String>? autofillHints;
  final bool? obscureText;
  final double? width;
  final IconData? suffixIcon;
  final bool? canEdit;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSaved;
  final GlobalKey<FormBuilderState>? formKey;
  const PrimaryTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.title,
    this.autofillHints,
    this.keyboardType,
    this.obscureText,
    this.width,
    this.suffixIcon,
    this.canEdit,
    this.validator,
    this.onEditingComplete,
    this.onSaved,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.9,
      child: canEdit != false
          ? FormBuilderTextField(
              key: formKey,
              onEditingComplete: onEditingComplete,
              onSaved: onSaved,
              name: hintText ?? '',
              validator: validator,
              enabled: canEdit ?? true,
              onChanged: onChanged,
              keyboardType: keyboardType,
              autofillHints: autofillHints,
              obscureText: obscureText ?? false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              scrollPadding: const EdgeInsets.only(bottom: 50),
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                labelText: title == null || title == '' ? hintText : title,
                suffixIcon: Icon(suffixIcon),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : Center(
              child: Text(
                title ?? '',
              ),
            ),
    );
  }
}
