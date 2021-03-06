//import 'package:asa_mexico/src/Provider/push_notification.dart';
import 'package:asa_mexico/src/pages/login.dart';
//import 'package:asa_mexico/src/pages/presupuestos/presupuestolist_home.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
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
          'login': (BuildContext context) => LoginPage(),
        },
        theme: ThemeData(
            primaryColor: Color.fromRGBO(35, 56, 120, 1.0),
            accentColor: Colors.red));
  }
}
