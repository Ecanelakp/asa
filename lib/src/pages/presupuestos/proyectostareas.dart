import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Tareasproyectos extends StatelessWidget {
  const Tareasproyectos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas"),
        backgroundColor: Color.fromRGBO(35, 56, 120, 1.0),
      ),
      body: Center(
        child: Text("Tareas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecondRoute()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  TextEditingController fechaincioctl = new TextEditingController();
  //String _fechainicio;
  String dropdownValue = 'First';
  @override
  Widget build(BuildContext context) {
    final format = DateFormat("dd-MM-yyyy");
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear Tarea"),
        ),
        body: Center(
            child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Column(children: <Widget>[
                    new ListTile(
                      leading: const Icon(Icons.account_circle_rounded),
                      title: Text("Resumen"),
                      subtitle: const Text('Resumen de la tarea'),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.note_add),
                      title: new TextField(
                          keyboardType: TextInputType.multiline,
                          decoration: new InputDecoration(
                            hintText: "notas",
                          )),
                      subtitle: const Text('Descripcion de la tarea'),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.label),
                      title: Text("Responsable"),
                      subtitle: const Text('Responsable'),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.label),
                      title: Container(
                          child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['First', 'Second', 'Third', 'Fourth']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                      subtitle: const Text('Prioridad de la Tarea'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.today),
                      title: new DateTimeField(
                        controller: fechaincioctl,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: new InputDecoration(
                          hintText: "Fecha Inicio",
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.today),
                      title: new DateTimeField(
                        controller: fechaincioctl,
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: new InputDecoration(
                          hintText: "Fecha de Vigencia",
                        ),
                      ),
                    ),
                    Container(
                        child: ElevatedButton(
                      child: Text("Crear Tarea"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
                  ]),
                ))));
  }

  void setState(Null Function() param0) {}
}
