import 'package:asa_mexico/src/pages/materiales/altamateriales.dart';

import 'package:asa_mexico/src/pages/materiales/pruebalista.dart';
import 'package:flutter/material.dart';

class Materialespage extends StatelessWidget {
  const Materialespage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Materiales"),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.list),
                ),
                Tab(
                    icon: Icon(
                  Icons.note_add,
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[UserFilterDemo(), altamateriales()],
          ),
        ));
  }
}
