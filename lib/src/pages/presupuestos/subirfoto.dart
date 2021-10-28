import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

File? _image;
//File foto;
String? secure_url;
String? idtarea;
String estado = "";
bool? error, sending, success;
String? msg;

class Subirfoto extends StatefulWidget {
  final String idfoto;

  const Subirfoto(this.idfoto);
  @override
  _SubirfotoState createState() => _SubirfotoState(idfoto);
}

class _SubirfotoState extends State<Subirfoto> {
  final String idfoto;

  _SubirfotoState(this.idfoto);

  /// Variables

  /// Widg  et
  @override
  Widget build(BuildContext context) {
    idtarea = idfoto;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: Container(
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _image!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 200,
                    child: new Image.asset(
                      'assets/images/no-image.png',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(35, 56, 120, 0.8),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextButton.icon(
              onPressed: () {
                subirImagen(_image!, idfoto);
              },
              icon: Icon(Icons.photo_camera, size: 25.0, color: Colors.white),
              label: Text("Guardar imagen",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Desde la galeria'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Desde la camara'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _imgFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> subirImagen(File _image, String idfoto) async {
    final apiurl = Uri.parse(
      'https://api.cloudinary.com/v1_1/ecanelakp/image/upload?upload_preset=yad3zask',
    );
    final mimeType = mime(_image.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', apiurl);

    final file = await http.MultipartFile.fromPath('file', _image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamRespose = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamRespose);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    //print(respData);

    secure_url = respData['secure_url'];
    //print('========$secure_url=========');
    return upurlphoto();
  }

// ignore: missing_return
  Future<String?> upurlphoto() async {
    print(idtarea);
    print(secure_url);

    var resi = await http.post(
        Uri.parse(
            "https://asamexico.com.mx/php/controller/updatephototarea.php"),
        body: {
          "idtarea": idtarea,
          "url": secure_url
        }); //sending post request with header data

    if (resi.statusCode == 200) {
      print(resi.body); //print raw response on console
      var data = json.decode(resi.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          estado = "Error al guardar";
        });
      } else {
        estado = "Se ha actualizado";
        print("$estado");
        _image = null;
        showAlertDialog(context);
        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sendign data.";
        sending = false;
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          setState(() {
            Navigator.of(context).pop();
          });
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Estado"),
      content: Text("Se ha cargado correctamente la informacion."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
