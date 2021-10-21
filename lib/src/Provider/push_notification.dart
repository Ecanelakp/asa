// import 'package:asa_mexico/src/pages/login.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class PushNotificationsManager {
//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();

//   //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<void> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure(
//         onMessage: (Map<dynamic, dynamic> message) => _redirectToPageTwo(),
//         onResume: (Map<dynamic, dynamic> message) => _redirectToPageTwo(),
//         onLaunch: (Map<dynamic, dynamic> message) => _redirectToPageTwo(),
//       );

//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");

//       _initialized = true;
//     }
//   }
// }

// _redirectToPageTwo() {
//   return PageTwo();
// }

// class PageTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: <Widget>[
//           Center(
//             child: Text('Page2'),
//           ),
//           RaisedButton(
//             child: Text('Go back to page 1'),
//             onPressed: () => Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => LoginPage())),
//           )
//         ],
//       ),
//     );
//   }
// }
