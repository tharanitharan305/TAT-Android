import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/DateTime.dart';



class Areas {
  var Locations = {
    "--select--",
    "Karur_Local",
    "China tharapuram",
    "velayuthapalayam",
    "Tharagampatti",
    "Pallapatti",
    "Thennilai",
    "lalapetai",
    "Panjapatti",
    "Aravakurichi"
  };
  bool check(String str, var file) {
    for (int i = 0; i < file.length; i++) {
      if (file[i]["locations"] == str) {
        // Get.closeAllSnackbars();
        // Get.snackbar(
        //   "Location Exists",
        //   "$str is alread there",
        //   duration: Duration(seconds: 5),
        // );
        return false;
      }
    }
    return true;
  }

  Uuid uuid = Uuid();
  Future<void> AddLocation(String location) async {
    String uid = uuid.v4();

    try {
      final file =
          await FirebaseFirestore.instance.collection("locations").get();
      if (location.length <= 0) throw "Enter a valid shop name";
      if (!check(location, file.docs))
        throw Error.safeToString("$location already exist");
      await FirebaseFirestore.instance.collection("locations").doc(uid).set(
          {"locations": location, "uid": uid, "date": DateTimeTat().GetDate()});
      Get.snackbar("Sucess", "$location added SucessFully",
          duration: Duration(seconds: 5));
    } catch (e) {
      //Get.closeAllSnackbars();
      if (Get.isSnackbarOpen) {
        print(Get.isSnackbarOpen);
        // Get.closeAllSnackbars();
      }
      Get.dialog(AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.redAccent,
        ),
        title: Text("Error "),
        content:
            Text("Error in adding Company $location Error=${e.toString()}"),
      ));
    }
    // Get.back();
  }

  Future<Set<String>> GetLocations() async {
    Set<String> locations = {"--select--"};

    final firebase =
        await FirebaseFirestore.instance.collection("locations").get();
    final list = firebase.docs;
    try {
      for (int i = 0; i < list.length; i++) {
        locations.add(list[i]["locations"]);
      }
    } on Error catch (e) {
      print(e.toString());
      Get.dialog(Icon(Icons.warning_rounded));
    }
    if (locations.length <= 1) {
      return Locations;
    }

    return locations;
  }
}
