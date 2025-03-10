import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tat/Screens/Attedance.dart';
import 'package:tat/Screens/AttendanceView.dart';
import 'package:tat/Screens/Employees.dart';
import 'package:tat/Widgets/Info.dart';
import 'package:tat/companies/comapnies.dart';

import '../Beat/Areas.dart';
import 'DateTime.dart';

class UserDrawer extends StatefulWidget {
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  Widget build(context) {
    Companies().GetCompany();
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        "images/tatlogo.png",
                      ),
                      radius: 40),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(FirebaseAuth.instance.currentUser!.displayName == null
                  ? FirebaseAuth.instance.currentUser!.email!
                  : FirebaseAuth.instance.currentUser!.displayName!),
            ],
          )),
          TextButton.icon(
              icon: Icon(Icons.fingerprint_rounded),
              onPressed: () {
                Get.to(() => Attendance());
              },
              label: Text('Attendance')),
          TextButton.icon(
              icon: Icon(Icons.admin_panel_settings_rounded),
              onPressed: () {
                Get.to(() => AttendanceView());
              },
              label: Text('Admin')),
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text("LOGING OUT...",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text("Confirm Logout"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        child: Text("Confirm"),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"))
                    ]),
              );
            },
            icon: Icon(Icons.logout_rounded),
            label: Text("logout"),
          ),
          TextButton.icon(
            onPressed: () {
              Get.to(() => Employees());
            },
            label: Text("Employees"),
            icon: Icon(Icons.people_alt_rounded),
          )
        ],
      ),
    );
  }
}
