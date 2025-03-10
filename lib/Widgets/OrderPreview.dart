import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:tat/Screens/Editor.dart';
import 'package:tat/Screens/splashScreen.dart';
import 'package:tat/OrderScreen/model/Orders.dart';

import '../Firebase/NewOrder.dart';
import '../OrderScreen/bloc/order_bloc.dart';
import '../OrderScreen/model/Orders.dart';
import '../Shop/Shops.dart';

class OrderPreview extends StatefulWidget {
  OrderPreview(
      {required this.context,
      required this.orders,
      required this.shop,
      required this.location,
      required this.upload});
  List<Order> orders;
  BuildContext context;
  Shop shop;
  String location;
  final Function(List<Order>, BuildContext, Shop, String) upload;
  @override
  State<OrderPreview> createState() => _OrderPreview();
}

class _OrderPreview extends State<OrderPreview> {
  final spkey = GlobalKey<FormState>();
  bool changeQuan = true;
  Future<void> Upload() async {
    log("in OrderPriview ${widget.location}");
    Get.snackbar("Processing", "${widget.shop.name} Placing Order ",
        duration: Duration(seconds: 5),
        icon: const Icon(
          Icons.cloud_upload_rounded,
          color: Colors.yellowAccent,
        ));

    widget.upload(widget.orders, widget.context, widget.shop, widget.location);
  }

  @override
  Widget build(context) {
    double total = 0;
    for (Order o in widget.orders) {
      total += o.product.sPrice * o.qty;
    }
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderEditor(
                        productList: widget.orders.toSet(),
                        area: widget.location,
                        shop: widget.shop,
                        context: widget.context,
                        upload: widget.upload,
                      ),
                    ));
              },
              child: const Text("Edit")),
          TextButton(onPressed: Upload, child: const Text("upload"))
        ],
        title: Text("Checking..."),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text("Shopname : ${widget.shop.name}"),
              Text(
                  "Order by : ${FirebaseAuth.instance.currentUser!.displayName == null ? FirebaseAuth.instance.currentUser!.email : FirebaseAuth.instance.currentUser!.displayName}"),
              SizedBox(
                height: 15,
              ),
              DataTable(columns: [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("S.P")),
                DataColumn(label: Text("Quantity")),
                DataColumn(label: Text("FREE"))
              ], rows: [
                ...widget.orders.map((e) => DataRow(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      actions: [
                                        IconButton(
                                            onPressed: () {
                                              if (spkey.currentState!
                                                  .validate()) {
                                                spkey.currentState!.save();
                                                Navigator.pop(context);
                                              }
                                            },
                                            icon: Icon(Icons
                                                .currency_exchange_rounded))
                                      ],
                                      title: Text("Changing..."),
                                      content: Form(
                                        key: spkey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  label: Text("Selling Price")),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (double.tryParse(value!) ==
                                                    null) {
                                                  return "Enter a valid Selling price";
                                                }

                                                return null;
                                              },
                                              onSaved: (values) {
                                                if (double.parse(values!) !=
                                                    0) {
                                                  setState(() {
                                                    e.product.sPrice =
                                                        double.parse(values);
                                                  });
                                                }
                                              },
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  label: Text("Quantity")),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                return null;
                                              },
                                              onSaved: (values) {
                                                if (values != null &&
                                                    !values.isEmpty) {
                                                  setState(() {
                                                    e.qty =
                                                        double.parse(values);
                                                  });
                                                }
                                              },
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  label: Text("FREE")),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                return null;
                                              },
                                              onSaved: (values) {
                                                if (values != null &&
                                                    !values.isEmpty) {
                                                  setState(() {
                                                    e.free =
                                                        double.parse(values);
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )));
                        },
                        cells: [
                          DataCell(Text(
                            e.product.productName,
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total :",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(total.toString())
                ],
              )
            ],
          ),
        ));
  }
}
