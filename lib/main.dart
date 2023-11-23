//import 'package:asa_mexico/src/Provider/push_notification.dart';

//import 'package:asa_mexico/src/pages/presupuestos/presupuestolist_home.dart';

import 'package:Asamexico/app/login/login_app.dart';
import 'package:Asamexico/app/notificaciones/notificaciones_services.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifficacions();
  //WidgetsFlutterBinding.ensureInitialized();
  //PushNotificationsManager().init();
  runApp(MyApp());
}
//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //PushNotificationsManager();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //navigatorKey: navigatorkey,
        title: 'Asamexico',
        initialRoute: 'login',
        routes: {
          //'home': (BuildContext context) => Homepage(fullname),
          //'presupesto': (BuildContext context) => Presupuestos(),
          'login': (BuildContext context) => login_app(),
        },
        theme: ThemeData());
  }
}
