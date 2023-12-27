import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderViewCard extends StatelessWidget {
  OrderViewCard(
      {super.key,
      required this.items,
      required this.Shopname,
      required this.useremail,
      required this.timestamp});
  var items;
  String Shopname;
  String useremail;
  Timestamp timestamp;
  @override
  Widget build(context) {
    var itemslist = items.toString().replaceAll("null", "");

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Text('Shopname : $Shopname')),
            Text('email: $useremail')
          ],
        ),
        ...itemslist.split(" ").map((e) {
          return Text(e.toUpperCase());
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              timestamp.toDate().toString(),
              style: const TextStyle(fontSize: 10),
            )
          ],
        )
      ]),
    );
  }
}
