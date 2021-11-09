import 'package:flutter/material.dart';

class Meses with ChangeNotifier {
  int? _mes = 10;

  int get mes => _mes!;

  set mes(int? numero) {
    _mes = numero;

    notifyListeners();
  }
}
