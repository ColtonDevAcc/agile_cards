import 'package:flutter/material.dart';

class SessionAverageText extends StatelessWidget {
  const SessionAverageText({Key? key, required this.sessionMeasurementAverage}) : super(key: key);

  final String sessionMeasurementAverage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text('average score is $sessionMeasurementAverage'),
    );
  }
}
