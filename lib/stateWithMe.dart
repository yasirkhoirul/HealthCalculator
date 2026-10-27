// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider untuk mengelola state name dan age
class StateWithMeProvider extends ChangeNotifier {
  String _name = "";
  int? _age = 0;

  String get name => _name;
  int? get age => _age;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setAge(String value) {
    _age = int.tryParse(value);
    notifyListeners();
  }
}

/// Widget StateWithMe tanpa setState, menggunakan Provider & ChangeNotifier
class StateWithMe extends StatelessWidget {
  const StateWithMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StateWithMeProvider(),
      child: const _StateWithMeContent(),
    );
  }
}

class _StateWithMeContent extends StatelessWidget {
  const _StateWithMeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter your name",
              ),
              onChanged: (value) {
                context.read<StateWithMeProvider>().setName(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter your age",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context.read<StateWithMeProvider>().setAge(value);
              },
            ),
            const SizedBox(height: 24),
            Consumer<StateWithMeProvider>(
              builder: (context, provider, child) {
                return Text(
                  "${provider.name} is ${provider.age ?? 0} years old.",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
