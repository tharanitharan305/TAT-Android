import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/AttendanceCard.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  QuerySnapshot<Map<String, dynamic>>? attendanceList = null;
  void setup() async {
    final list =
        await FirebaseFirestore.instance.collection('Attendance').get();
    setState(() {
      attendanceList = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: //if(attendanceList==null)
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (attendanceList != null)
                Column(
                  children: [
                    ...attendanceList!.docs
                        .map((e) => AttendanceCard(
                              image: e.data()['image url'],
                              name: e.data()['name'],
                              time: e.data()['time'].toString(),
                              date: e.data()['date'],
                              status: e.data()['status'],
                              email: e.data()['User'],
                            ))
                        .toList()
                  ],
                ),
              if (attendanceList == null) Text("No Attendance Today")
            ],
          ),
        ),
      ),
    );
  }
}
