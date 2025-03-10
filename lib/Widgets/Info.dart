import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tat/Widgets/DateTime.dart';

import '../Beat/Areas.dart';

class Info extends StatefulWidget {
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String dayTotal = "0";
  String Location = "Karur_Local";
  List<String> Time = [
    DateTimeTat().GetpreDate(0),
    DateTimeTat().GetpreDate(1),
    DateTimeTat().GetpreDate(2),
    DateTimeTat().GetpreDate(3),
    DateTimeTat().GetpreDate(4),
    DateTimeTat().GetpreDate(5),
    DateTimeTat().GetpreDate(6),
    DateTimeTat().GetpreDate(7),
    DateTimeTat().GetpreDate(8),
  ];
  String date = DateTimeTat().GetDate();
  Set<String> locations = {};
  void setup() async {
    final dummy = await Areas().GetLocations();
    setState(() {
      locations = dummy;
    });
  }

  void Total() async {
    final list = await FirebaseFirestore.instance
        .collection(Location)
        .where('Date', isEqualTo: date)
        .get();
    final Orderlist =
        list.docs.map((e) => e.data()['Total'].toString()).toList();
    var dummytotal = 0.0;
    for (String x in Orderlist) {
      dummytotal += double.parse(x);
    }
    setState(() {
      dayTotal = dummytotal.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  Widget build(context) {
    Total();
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          DropdownButton(
              elevation: 50,
              autofocus: true,
              dropdownColor: Theme.of(context).colorScheme.primaryContainer,
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
          SizedBox(
            height: 20,
          ),
          DropdownButton(
              elevation: 50,
              autofocus: true,
              dropdownColor: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              value: date,
              items: Time.map((e) => DropdownMenuItem(
                    value: e,
                    key: UniqueKey(),
                    child: Text(e),
                  )).toList(),
              onChanged: (values) {
                setState(() {
                  date = values!;
                });
              }),
          SizedBox(
            height: 40,
          ),
          Text(
            "TOTAL",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 40,
          ),
          Text("₹" + dayTotal,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
        ],
      ),
    );
  }
}
