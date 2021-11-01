import 'package:asa_mexico/src/pages/clientes/clientesfacturas.dart';
import 'package:asa_mexico/src/pages/clientes/lastlogscliente.dart';
import 'package:asa_mexico/src/pages/clientes/listaclientes.dart';
import 'package:flutter/material.dart';

class Clienteview extends StatelessWidget {
  final String usuario;
  final String acceso;
  const Clienteview(this.usuario, this.acceso, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.account_circle_rounded),
              ),
              Tab(
                icon: Icon(Icons.chat_bubble),
              ),
              Tab(icon: Icon(Icons.payment_sharp)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //JsonSpinner(widget.usuario),
            Listaclientes(usuario),

            Loglastclientes(),
            acceso == 'full'
                ? Homefacturas(usuario)
                : Container(
                    child: Center(
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.announcement_rounded,
                        color: Colors.orange,
                        size: 50.0,
                      ),
                      Text("Acceso restringido"),
                    ],
                  ))),
            //child: Datainsert(widget.usuario),
          ],
        ),
      ),
    );
  }
}
