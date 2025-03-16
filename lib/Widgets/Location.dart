import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
Future<bool> getPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return false;
  }
  return true;
}

Future<String> getcurrentLocation(LatLng? loc) async {
  if (!(await getPermission())) {
    return "Enter address manually";
  }

  List<Placemark> place;
  double latitude, longitude;

  if (loc != null) {
    latitude = loc.latitude;
    longitude = loc.longitude;
  } else {
    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
  }

  place = await placemarkFromCoordinates(latitude, longitude);

  return "${place[0].street ?? ''},${place[0].thoroughfare ?? ''},${place[0].subLocality ?? ''},"
      "${place[0].locality ?? ''},${place[0].administrativeArea ?? ''},${place[0].postalCode ?? ''},"
      "${place[0].country ?? ''},$latitude,$longitude";
}

class MapBox extends StatefulWidget {
  double lat;
  double lng;
  Function setup;
   MapBox({required this.lat,required this.lng,required this.setup});

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  final mapController=MapController();
  @override
  Widget build(BuildContext context) {

    return FlutterMap(
      mapController: mapController,
        options: MapOptions(
            initialCenter: LatLng(widget.lat, widget.lng),
            onTap: (tapPosition, point) =>{
              widget.setup(point.latitude,point.longitude)
            },
            initialZoom: 2),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
                rotate: true,
                point: LatLng(widget.lat, widget.lng),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        mapController.move(LatLng(widget.lat, widget.lng), 12);
                      });
                    },
                    icon: Icon(Icons.pin_drop_rounded)))
          ])
        ]);
  }
}
