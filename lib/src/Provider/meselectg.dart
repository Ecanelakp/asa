import 'package:flutter/material.dart';

class Mesesg with ChangeNotifier {
  String _mesg = '11';

  String get mesg {
    return _mesg;
  }

  set mesg(String numero) {
    _mesg = numero;

    notifyListeners();
  }
}
