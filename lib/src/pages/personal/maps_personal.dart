import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapersonal extends StatefulWidget {
  final String? _fullname;
  final String? _tipo;
  final double? _latitude;
  final double? _longitude;
  final DateTime? _fechareg;

  const Mapersonal(this._fullname, this._tipo, this._latitude, this._longitude,
      this._fechareg);
  @override
  _MapersonalState createState() =>
      _MapersonalState(_fullname, _tipo, _latitude, _longitude, _fechareg);
}

class _MapersonalState extends State<Mapersonal> {
  final String? _fullname;
  final String? _tipo;
  final double? _latitude;
  final double? _longitude;
  final DateTime? _fechareg;
  double lat = 0.0;

  _MapersonalState(this._fullname, this._tipo, this._latitude, this._longitude,
      this._fechareg);
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _currentPosition = CameraPosition(
    target: LatLng(19.3910038, -99.2836991),
    zoom: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicacion"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          markers: {
            Marker(
                markerId: MarkerId(_fullname!),
                position: LatLng(_latitude!, _longitude!),
                infoWindow: InfoWindow(
                    title: _fullname,
                    snippet: _tipo! + '  ' + _fechareg.toString())),
          },
          initialCameraPosition: _currentPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete();
          },
        ),
      ),
    );
  }
}
