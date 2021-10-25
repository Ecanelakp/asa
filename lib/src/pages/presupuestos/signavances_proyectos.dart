import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import 'dart:ui';

class SignAvance extends StatefulWidget {
  @override
  State<SignAvance> createState() => _SignAvanceState();
}

final SignatureController _controller = SignatureController(
  penStrokeWidth: 1,
  penColor: Colors.black,
  exportBackgroundColor: Colors.white,
);

class _SignAvanceState extends State<SignAvance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar acuse de Avance'),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.assignment_outlined,
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Text('El avance del dia:'),
                    Text('Es por la cantidad de:'),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                )),
                child: Signature(
                  controller: _controller,
                  height: 300,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(35, 56, 120, 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //SHOW EXPORTED IMAGE IN NEW ROUTE
                    IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          final data = await _controller.toPngBytes();
                          if (data != null) {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(),
                                    body: Center(
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: Image.memory(data),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
