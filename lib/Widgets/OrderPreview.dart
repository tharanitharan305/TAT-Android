import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tat/Widgets/Orders.dart';

import '../Firebase/NewOrder.dart';

class OrderPreview extends StatefulWidget {
  OrderPreview(
      {super.key,
      required this.Order,
      required this.Shopname,
      required this.Location});
  Set<Orders> Order;
  String Shopname;
  String Location;
  @override
  State<OrderPreview> createState() => _OrderPreview();
}

class _OrderPreview extends State<OrderPreview> {
  void Upload() {
    NewOrder().putOrder(widget.Order, widget.Shopname, widget.Location);
    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    return AlertDialog(
        actions: [TextButton(onPressed: Upload, child: const Text("upload"))],
        title: const Text('Checking..'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Shopname',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.Shopname),
              const Text(
                'ORDER BY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(FirebaseAuth.instance.currentUser!.email!),
              const Text(
                'LOCATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.Location),
              const Text(
                'ORDERS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...widget.Order.map((e) => Row(
                    children: [Text(e.Products), Text('-${e.Quantity}')],
                  )).toList()
            ],
          ),
        ));
  }
}
