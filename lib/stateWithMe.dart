import 'package:flutter/material.dart';

class StateWithMe extends StatefulWidget {
  const StateWithMe({super.key});

  @override
  State<StateWithMe> createState() => _StateWithMeState();
}

class _StateWithMeState extends State<StateWithMe> {
  String _name = "";
  int? _age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              label: Text("Enter your")
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Enter your age",
            ),
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value);
              });
            },
          ),
          Text("$_name is $_age years old."),
        ],
      ),
    );
  }
}

