import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:tat/Beat/Areas.dart';
import 'package:uuid/uuid.dart';

import '../Screens/splashScreen.dart';
import 'DateTime.dart';
import 'Location.dart';
import '../companies/comapnies.dart';

class ShopGetter extends StatefulWidget {
  State<ShopGetter> createState() => _ShopGetterState();
}

final user = FirebaseAuth.instance.currentUser!;

class _ShopGetterState extends State<ShopGetter> {
  var geolocator;
  String street = "";
  String area = "";
  String district = "";
  String state = "";
  String pin = "";
  String country = "";
  String latitude = "";
  String longitude = "";
  String Address =
      "Where is the King...[Streetname, post or taluk, district, state]";
  String Location = "--select--";
  final key = GlobalKey<FormState>();
  String Shopname = '';
  bool uploadStatus = false;
  Set<String> locations = {};
  Uuid uuid = Uuid();
  String phoneNumber = "";
  SetLocation() async {
    final temploc = await Areas().GetLocations();
    setState(() {
      locations = temploc;
    });
  }

  Future<void> locationSetup() async {
    var add = await getcurrentLocation();
    setState(() {
      geolocator = add.split(",");
      street = geolocator[0] + "," + geolocator[1];
      area = geolocator[2];
      district = geolocator[3];
      pin = geolocator[5];
      state = geolocator[4];
      country = geolocator[6];
      latitude = geolocator[7];
      longitude = geolocator[8];
    });
  }

  Future<void> AddShop() async {
    await locationSetup();
    String uid = uuid.v4();
    if (key.currentState!.validate()) {
      key.currentState!.save();
      try {
        Get.snackbar("Adding shop..", "${Shopname} is been Adding ",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.cloud_upload_rounded,
              color: Colors.yellowAccent,
            ));
        setState(() {
          uploadStatus = true;
        });
        await FirebaseFirestore.instance
            .collection(Location + "Shops")
            .doc(Shopname)
            .set({
          'Shop Name': Shopname,
          'Phone Number': phoneNumber,
          'Total Purchase': 0.0,
          'Total Balance': 0.0,
          'Time': DateTimeTat().GetDate(),
          'Created by': user.email,
          'Lat': latitude,
          "Long": longitude,
          "Street": street,
          "Area": area,
          "District": district,
          "Pin": pin
        });
        setState(() {
          uploadStatus = false;
        });
        Get.snackbar("Sucess", "$Shopname Added to TAT Sucessfully",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.done_outline_rounded,
              color: Colors.greenAccent,
            ));
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar("Fail", "$Shopname not Added ",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.warning,
              color: Colors.redAccent,
            ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Get.dialog(Center(child: Lottie.asset("animations/back2.json")));
    SetLocation();
    //Get.back();
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Shop"),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Container(
          width: double.infinity,
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (widget.Status == "p")
                DropdownButton(
                    elevation: 50,
                    autofocus: true,
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    value: Location,
                    items: locations
                        .map((e) => DropdownMenuItem(
                              value: e,
                              key: UniqueKey(),
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (values) {
                      setState(() {
                        Location = values!;
                      });
                    }),
                if (Location != "--select--")
                  TextFormField(
                    decoration: InputDecoration(labelText: "Shop Name"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3)
                        return "Enter a valid shopname";
                    },
                    onChanged: (values) {
                      setState(() {
                        Shopname = values!;
                      });
                    },
                    onSaved: (values) {
                      setState(() {
                        Shopname = values!;
                      });
                    },
                  ),
                if (Location != "--select--")
                  TextFormField(
                    decoration: InputDecoration(labelText: "Phone Number"),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10)
                        return "Enter a valid shopname";
                    },
                    onChanged: (values) {
                      setState(() {
                        phoneNumber = values!;
                      });
                    },
                    onSaved: (values) {
                      setState(() {
                        phoneNumber = values!;
                      });
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (Shopname != null &&
                    !Shopname.isEmpty &&
                    Shopname.length >= 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (uploadStatus) SplashScreen(),
                      if (!uploadStatus)
                        ElevatedButton(
                          onPressed: AddShop,
                          child: Text('Upload'),
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
