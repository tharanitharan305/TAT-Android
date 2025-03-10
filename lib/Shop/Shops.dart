import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  Shop(this.name, this.balance, this.total, this.time, this.phno, this.lat,
      this.long, this.street, this.area, this.district, this.pin);
  String name = "";
  String time = "";
  double balance = 0;
  double total = 0;
  String phno = "";
  String lat = "";
  String long = "";
  String street = "";
  String area = "";
  String district = "";
  String pin = "";
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'balance': balance,
      'total': total,
      'phno': phno,
      'lat': lat,
      'long': long,
      'street': street,
      'area': area,
      'district': district,
      'pin': pin,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      map["name"] ?? "Unknown",
      (map["balance"] ?? 0).toDouble(),
      (map["total"] ?? 0).toDouble(),
      map["time"] ?? "",
      map["phno"] ?? "Not Available",
      map["lat"] ?? "Location Not Added",
      map["long"] ?? "Location Not Added",
      map["street"] ?? "Location Not Added",
      map["area"] ?? "Location Not Added",
      map["district"] ?? "Location Not Added",
      map["pin"] ?? "Location Not Added",
    );
  }
}

Future<Set<String>> getShops(String Locations) async {
  Set<String> Shops = {"--select--"};
  final list = await FirebaseFirestore.instance
      .collection(Locations + "Shops")
      .orderBy("Time")
      .get();
  Shops.addAll(list.docs
      .map((e) => e.data()["Shop Name"].toString().toUpperCase())
      .toSet());
  return Shops;
}

Future<Set<Shop>> getShop(String location) async {
  Set<Shop> shop;
  final list = await FirebaseFirestore.instance
      .collection(location + "Shops")
      .orderBy("Time")
      .get();
  shop = list.docs
      .map((e) => Shop(
          e.data()["Shop Name"],
          e.data()["Total Balance"],
          e.data()["Total Purchase"],
          e.data()["Time"],
          e.data()['Phone Number'],
          e.data()["Lat"] ?? "location NOt added",
          e.data()["Long"] ?? "location NOt added",
          e.data()["Street"] ?? "location NOt added",
          e.data()['Area'] ?? "location NOt added",
          e.data()['District'] ?? "location NOt added",
          e.data()['Pin'] ?? "location NOt added"))
      .toSet();
  shop.add(Shop("--select--", 0.0, 0.0, "", "", "", "", "", "", "", ""));
  return shop;
}
