import 'package:flutter/material.dart';

class Prompt extends StatelessWidget {
  Prompt(
      {@required
          this.targetValue}); //method Prompt is a constructor function for a Prompt object
  final int targetValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("PUT THE BULLSEYE AS CLOSE AS YOU CAN TO"),
        Text("$targetValue"),
      ],
    );
  }
}
