import 'package:flutter/material.dart';

class Meses with ChangeNotifier {
  int _mes = 6;

  get mes {
    return _mes;
  }

  set mes(int numero) {
    _mes = numero;

    notifyListeners();
  }
}
