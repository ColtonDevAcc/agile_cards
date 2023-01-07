import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Color? color;
  final bool? outlined;
  const PrimaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            backgroundColor: outlined != true ? Theme.of(context).colorScheme.primary : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: color ?? Theme.of(context).colorScheme.primary),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
