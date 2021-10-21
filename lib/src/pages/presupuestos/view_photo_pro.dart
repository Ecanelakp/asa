import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Photoproview extends StatelessWidget {
  final String urlimagen;
  Photoproview(this.urlimagen);

  @override
  Widget build(BuildContext context) {
    print(urlimagen);
    return Scaffold(
      appBar: AppBar(
        title: Text('Revisar foto'),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(
          urlimagen,
        ),
        // Contained = the smallest possible size to fit one dimension of the screen
        minScale: PhotoViewComputedScale.contained * 0.8,
        // Covered = the smallest possible size to fit the whole screen
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
        // Set the background color to the "classic white"
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
