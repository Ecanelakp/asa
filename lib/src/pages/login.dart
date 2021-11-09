import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asa_mexico/src/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import http package manually

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  String? errormsg;
  bool error = false, showprogress = false;
  String? username, password;
  bool? isChecked;
  var _username = TextEditingController();
  var _password = TextEditingController();

  startLogin() async {
    String apiurl =
        "https://asamexico.com.mx/php/controller/login.php"; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    print('====$username');
    print(_username.text);

    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username, //get the username text
      'password': password //get password text
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            error = false;
            showprogress = false;
          });
          //save the data returned from server
          //and navigate to home page
          //String uid = jsondata["uid"];
          String fullname = jsondata["nombrecorto"];
          String acceso = jsondata["acceso"];
          String nombre = jsondata["fullname"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('nuser', fullname);
          prefs.setString('nombre', nombre);

          prefs.setString('user', _username.text);
          prefs.setString('password', _password.text);
          prefs.setString('recover', isChecked.toString());
          prefs.setString('acceso', acceso);
          //String address = jsondata["address"];
          print(nombre);
          print(acceso);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(fullname, acceso)));
          //user shared preference to save data
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    recordarcredenciales();
    isChecked = true;
    super.initState();
  }

  Future<void> recordarcredenciales() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('recover'));
    isChecked = true;
    if (prefs.getString('recover') == 'true') {
      print(prefs.getString('password'));
      setState(() {
        isChecked = true;
      });

      username = prefs.getString('user');
      password = prefs.getString('password');
      _username.text = username!;
      _password.text = password!;
    } else {
      setState(() {
        isChecked = false;
      });
      _username.text = '';
      _password.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height
                //set minimum height equal to 100% of VH
                ),
        width: MediaQuery.of(context).size.width,
        //make width of outer wrapper to 100%
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.6),
              end: FractionalOffset(0.0, 1.0),
              colors: [
                Color.fromRGBO(35, 56, 120, 1.0),
                Color.fromRGBO(35, 37, 57, 1.0)
              ]),
        ), //show linear gradient background of page

        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Image(
                image: AssetImage('assets/images/asaazul.jpg'),
                fit: BoxFit.cover),
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Text(
              "Gestión de proyectos",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ), //subtitle text
          ),
          Container(
            //show error message here
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            child: error ? errmsg(errormsg!) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _username, //set username controller
              style: TextStyle(
                  color: Color.fromRGBO(35, 56, 120, 1.0), fontSize: 20),
              decoration: myInputDecoration(
                label: "Usuario",
                icon: Icons.person,
              ),
              onChanged: (value) {
                //set username  text on change
                username = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _password, //set password controller
              style: TextStyle(
                  color: Color.fromRGBO(35, 56, 120, 1.0), fontSize: 20),
              obscureText: true,
              decoration: myInputDecoration(
                label: "Contraseña",
                icon: Icons.lock,
              ),
              onChanged: (value) {
                // change password text
                password = value;
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    //show progress indicator on click
                    showprogress = true;
                  });
                  startLogin();
                },
                child: showprogress
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red[100],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      )
                    : Text(
                        "Entrar",
                        style: TextStyle(fontSize: 20),
                      ),
                // if showprogress == true then show progress indicator
                // else show "LOGIN NOW" text
                colorBrightness: Brightness.dark,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                    //button corner radius
                    ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Text("Recordar credenciales",
                      style: (TextStyle(color: Colors.white)))),
              Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  activeColor: Color.fromRGBO(35, 56, 120, 1.0),
                  onChanged: (bool? newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  }),
            ],
          ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   margin: EdgeInsets.only(top: 20),
          //   child: InkResponse(
          //       onTap: () {
          //         //action on tap
          //       },
          //       child: Text(
          //         "Ovidaste tu contraseña?",
          //         style: TextStyle(color: Colors.white, fontSize: 18),
          //       )),
          // ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Asamexico  v1.5.4 ©",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ), //title text Image(
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 80),
            child: Text(
              "Design by Enrique Canela ",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ), //title text Image(
          )
        ]),
      )),
    );
  }

  InputDecoration myInputDecoration({String? label, IconData? icon}) {
    return InputDecoration(
      hintText: label, //show label as placeholder
      hintStyle: TextStyle(
          color: Color.fromRGBO(35, 56, 120, 1.0),
          fontSize: 20), //hint text style
      prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
            color: Color.fromRGBO(35, 56, 120, 1.0),
          )
          //padding and icon for prefix
          ),

      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: Colors.red[300]!, width: 1)), //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              BorderSide(color: Colors.orange[200]!, width: 1)), //focus border

      fillColor: Color.fromRGBO(255, 255, 255, 0.9),
      filled: true, //set true if you want to show input background
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color: Colors.red[300]!, width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        //show error message text
      ]),
    );
  }
}
