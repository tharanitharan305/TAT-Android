import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Maps extends StatefulWidget {
  Maps({super.key, required this.lat, required this.log});
  double lat;
  double log;
  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  void launchMap(String lat, String long) async {
    //   NewOrder().sendSms("Your Current Balance is ", ["+919787874607"]);
    final Uri _url = Uri.parse(
        "https://www.google.com/search?q=$lat%2C$long&oq=$lat%2C$long&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQLhhA0gEINTY5M2owajSoAgCwAgA&sourceid=chrome&ie=UTF-8");
    launchUrl(_url);
    print(lat);
    print(long);
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  @override
  Widget build(BuildContext context) {
    print("hai maps");
    return FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(widget.lat, widget.log), initialZoom: 12.2),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
                point: LatLng(widget.lat, widget.log),
                child: IconButton(
                    onPressed: () {
                      launchMap(widget.lat.toString(), widget.log.toString());
                    },
                    icon: Icon(Icons.location_on)))
          ])
        ]);
  }
}
