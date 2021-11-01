import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Gps extends StatefulWidget {
  @override
  _GpsState createState() => _GpsState();
}

class _GpsState extends State<Gps> {
  Geolocator geolocator = Geolocator();

  Position? userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          userLocation == null
              ? CircularProgressIndicator()
              : Text("Location:" +
                  userLocation!.latitude.toString() +
                  " " +
                  userLocation!.longitude.toString()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _getLocation().then((value) {
                  setState(() {
                    userLocation = value;
                  });
                });
              },
              color: Colors.blue,
              child: Text(
                "Get Location",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position?> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
