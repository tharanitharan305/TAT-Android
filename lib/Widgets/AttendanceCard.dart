import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Firebase/NewOrder.dart';

class AttendanceCard extends StatelessWidget {
  AttendanceCard(
      {super.key,
      required this.image,
      required this.name,
      required this.time,
      required this.date,
      required this.status,
      required this.email});
  String image;
  String name;
  String email;
  String date;
  bool status;
  String time;
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await NewOrder().updateAttendance(name, !status, email);
        Get.snackbar("Sucess", !status ? "$name Present" : "$name Absent",
            icon: Icon(
              Icons.done_outline_rounded,
              color: !status ? Colors.greenAccent : Colors.redAccent,
            ));
      },
      child: Card(
        elevation: 10,
        child: Container(
          // height: MediaQuery.of(context).size.height,
          //]] width: MediaQuery.of(context).size.width * 0.60,
          decoration: BoxDecoration(
              color: status ? Colors.greenAccent : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  foregroundImage: NetworkImage(image),
                ),
                SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: GoogleFonts.lexend(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      name,
                      style: GoogleFonts.lexend(fontSize: 17),
                    )
                  ],
                ),
                SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    Text(
                      'Email : ',
                      style: GoogleFonts.lexend(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        email,
                        style: GoogleFonts.lexend(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    Text(
                      'Date : ',
                      style: GoogleFonts.lexend(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.lexend(fontSize: 17),
                    )
                  ],
                ),
                SizedBox(
                  height: 17,
                ),
                Row(
                  children: [
                    Text(
                      'Time Stamp : ',
                      style: GoogleFonts.lexend(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        time,
                        style: GoogleFonts.lexend(fontSize: 17),
                      ),
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
