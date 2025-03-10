import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tat/Sms/sms.dart';
import 'package:tat/Widgets/OrderFormat.dart';

import '../Firebase/NewOrder.dart';
import '../OrderScreen/model/Orders.dart';

class OrderViewCard extends StatelessWidget {
  OrderViewCard(
      {super.key,
      required this.items,
      required this.Shopname,
      required this.useremail,
      required this.timestamp,
      required this.total,
      required this.uid,
      required this.location,
      required this.phno});
  List<Order> items;
  //var items;
  String Shopname;
  String useremail;
  String timestamp;
  String total;
  String uid;
  String location;
  List<Order> fromBase = [];
  String phno;
  void delete() {
    Get.dialog(AlertDialog(
      title: Text("Delete"),
      content: Text('Are You Sure to detlete $Shopname Order'),
      actions: [
        TextButton(
            onPressed: () async {
              Get.back();
              Get.dialog(Center(
                child: CircularProgressIndicator(),
              ));
              await NewOrder().deleteOrder(uid, location);
              Get.back();
            },
            child: Text('YES')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('NO'))
      ],
    ));
  }

  _sendMessage() {
    var messageText = "Products     qty     free    S.price    MRP";
    items.forEach((e) {
      String a = e.product.productName;
      String b = e.qty.toString();
      String c = e.free.toString();
      String d = e.product.sPrice.toString();
      String f = e.product.mrp.toString();
      String res = "\n$a    $b    $c    $d    $f";
      messageText += res;
    });
    Get.dialog(AlertDialog(
      icon: Icon(Icons.sms_rounded),
      actions: [
        TextButton(onPressed: () {}, child: Text("Send")),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No")),
      ],
    ));
  }

  @override
  Widget build(context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Shopname : ${Shopname}")),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Expanded(child: Text("Order by : ${useremail}")),
                IconButton(onPressed: delete, icon: Icon(Icons.delete_rounded))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            DataTable(columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("S.P")),
              DataColumn(label: Text("Quantity")),
              DataColumn(label: Text("FREE")),
            ], rows: [
              ...items.map((e) => DataRow(cells: [
                    DataCell(Text(
                      e.product.productName,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(e.product.sPrice.toString())),
                    DataCell(Text(e.qty.toString())),
                    DataCell(Text(e.free.toString())),
                  ]))
            ]),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                    onPressed: () {
                      _sendMessage();
                    },
                    label: Text("Send Sms"),
                    icon: Icon(Icons.message_rounded)),
                Spacer(),
                Text(
                  "Time:",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  timestamp,
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ],
        ));
  }
}
