import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/DateTime.dart';

class Companies {
  // Companies({required this.uid,required this.name,required this.date});
  // String name;
  // String uid;
  // String date;
  var companies = {"--select--", "GRB", "Elite", "Tata", "Unibic", "Beros"};
  bool check(String str, var file) {
    for (int i = 0; i < file.length; i++) {
      if (file[i]['Company name'] == str) {
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
  Future<void> AddCompany(String location) async {
    String uid = uuid.v4();

    try {
      final file =
          await FirebaseFirestore.instance.collection("companies").get();
      if (location.length <= 0) throw Error();
      if (!check(location, file.docs)) throw Error();
      FirebaseFirestore.instance.collection("companies").doc(uid).set({
        "Company name": location,
        "uid": uid,
        "date": DateTimeTat().GetDate()
      });
      Get.snackbar("Sucess", "$location added SucessFully",
          duration: Duration(seconds: 5));
    } on Error catch (e) {
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
        content: Text("Error in adding Company $location Error=${e}"),
      ));
    }
    // Get.back();
  }

  Future<Set<String>> GetCompany() async {
    Set<String> locations = {"--select--"};

    final firebase =
        await FirebaseFirestore.instance.collection("companies").get();
    final list = firebase.docs;
    try {
      for (int i = 0; i < list.length; i++) {
        locations.add(list[i]["Company name"]);
      }
    } on Error catch (e) {
      print(e.toString());
      Get.dialog(Icon(Icons.warning_rounded));
    }
    if (locations.length <= 1) {
      return companies;
    }
    return locations;
  }
}
