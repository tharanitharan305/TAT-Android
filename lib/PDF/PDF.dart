import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

import '../OrderScreen/model/Orders.dart';

class PDF {
  PDF(
      {required this.items,
      required this.Shopname,
      required this.useremail,
      required this.timestamp,
      required this.total,
      required this.Date});
  List<Order> items;
  String Date;
  String Shopname;
  String useremail;
  cloud.Timestamp timestamp;
  String total;
  List<Order> fromBase = [];
}
