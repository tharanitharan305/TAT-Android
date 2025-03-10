import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tat/Firebase/NewOrder.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  File? image = null;
  bool isWorking = false;
  void _getImage() async {
    XFile? tempImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (tempImage != null) {
      setState(() {
        image = File(tempImage.path);
      });
    } else {
      Get.dialog(AlertDialog(
        title: Text('Look on to the camera'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // if (isWorking) Center(child: CircularProgressIndicator()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _getImage,
                  child: Card(
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: image == null
                          ? Icon(Icons.camera_alt_rounded)
                          : Image.file(
                              image!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              if (image != null)
                TextButton.icon(
                  label: Text('Upload'),
                  icon: Icon(Icons.fingerprint_rounded),
                  onPressed: () async {
                    setState(() {
                      isWorking = true;
                    });
                    await NewOrder().addAttendance(
                        image!, FirebaseAuth.instance.currentUser!.email!);
                    setState(() {
                      isWorking = false;
                    });
                    Get.snackbar("Sucess", "Your attendance sent Sucessfully",
                        icon: Icon(
                          Icons.done_outline_rounded,
                          color: Colors.greenAccent,
                        ));
                    Navigator.pop(context);
                  },
                )
            ],
          ),
          if (isWorking) Center(child: Lottie.asset("animations/setting.json")),
        ],
      ),
    );
  }
}
