// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime_type/mime_type.dart';

// class Photo {
//   Future<String> subirImagen(File imagen) async {
//     final apiurl = Uri.parse(
//       'https://api.cloudinary.com/v1_1/ecanelakp/image/upload?upload_preset=yad3zask',
//     );
//     final mimeType = mime(imagen.path).split('/');

//     final imageUploadRequest = http.MultipartRequest('POST', apiurl);

//     final file = await http.MultipartFile.fromPath('file', imagen.path,
//         contentType: MediaType(mimeType[0], mimeType[1]));

//     imageUploadRequest.files.add(file);

//     final streamRespose = await imageUploadRequest.send();
//     final resp = await http.Response.fromStream(streamRespose);

//     if (resp.statusCode != 200 && resp.statusCode != 201) {
//       print('algo salio mal');
//       print(resp.body);
//       return null;
//     }

//     final respData = json.decode(resp.body);
//     print(respData);
//     return respData['secure_url'];
//   }
// }
