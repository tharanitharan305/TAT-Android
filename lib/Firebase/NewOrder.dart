import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tat/Validator/UserInterface.dart';
import 'package:tat/Widgets/DateTime.dart';
import 'package:tat/Widgets/Grb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../Products/model/Product.dart';
import '../Screens/Employees.dart';
import '../Widgets/Location.dart';
import '../OrderScreen/model/Orders.dart';
import '../Widgets/getAttendaceSheet.dart';

final user = FirebaseAuth.instance.currentUser!;

class NewOrder {
  Future<void> putOrder(
      Set<Order> order, String ShopName, String Locations, String phno) async {
    double total = 0;
    for (Order o in order) {
      total += o.product.sPrice * o.qty;
    }
    Uuid uuid = Uuid();
    String uid = uuid.v4();
    await cloud.FirebaseFirestore.instance.collection(Locations).doc(uid).set({
      'Date': DateTimeTat().GetDate(),
      'Ordered time': cloud.Timestamp.now(),
      'Shopname': ShopName,
      'Ordered by': user.displayName == null ? user.email : user.displayName,
      'Orders': order.map(
        (e) {
          String quantity = e.qty.toString();
          if (quantity.endsWith("0")) return null;
          return e.toString();
        },
      ),
      'Total': total.toString(),
      "uid": uid,
      "Shop PhoneNumer": phno
    });
    Get.snackbar("Sucess", "${ShopName} Placed Order ",
        duration: Duration(seconds: 5),
        icon: Icon(
          Icons.done_outline_rounded,
          color: Colors.greenAccent,
        ));

    final useDet = await cloud.FirebaseFirestore.instance
        .collection('Employees')
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .get();

    await cloud.FirebaseFirestore.instance
        .collection('Employees')
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .update({'Sales': useDet.data()?['Sales'] + total});
    final userMondet = await cloud.FirebaseFirestore.instance
        .collection('Employees')
        .doc(FirebaseAuth.instance.currentUser!.displayName)
        .collection(DateTime.now().year.toString())
        .doc(DateTime.now().month.toString())
        .get();
    // final user=FirebaseAuth.instance.currentUser!.displayName;
    if (userMondet.exists) {
      Get.snackbar("Updating...", "${user.displayName} Updating your Profile ",
          duration: Duration(seconds: 5),
          icon: Icon(
            Icons.cloud_upload_rounded,
            color: Colors.yellowAccent,
          ));
      await cloud.FirebaseFirestore.instance
          .collection('Employees')
          .doc(FirebaseAuth.instance.currentUser!.displayName)
          .collection(DateTime.now().year.toString())
          .doc(DateTime.now().month.toString())
          .update({'Mothly sales': userMondet.data()?['Mothly sales'] + total});
      final max = userMondet.data()?['Mothly sales'];
      if (max < total) {
        await cloud.FirebaseFirestore.instance
            .collection('Employees')
            .doc(FirebaseAuth.instance.currentUser!.displayName)
            .collection(DateTime.now().year.toString())
            .doc(DateTime.now().month.toString())
            .update({'Max Sale Shop': ShopName, 'Max Sale': total});
        Get.snackbar(
            "Achivement", "${total} is your Highest sale of this month ",
            duration: Duration(seconds: 5),
            icon: Icon(
              Icons.badge_rounded,
              color: Colors.orangeAccent,
            ));
      }
    }
    final shopref = await cloud.FirebaseFirestore.instance
        .collection(Locations + "Shops")
        .doc(ShopName);
    final shopdet = await shopref.get();
    final shoptot = shopdet.data()?["Total Purchase"];
    shopref.update({"Total Purchase": shoptot ?? 0 + total});
    Get.back();
    await Future.delayed(Duration(seconds: 3));
    Get.dialog(
        Center(child: Lottie.asset("animations/cartDone.json", repeat: false)));
    await Future.delayed(Duration(seconds: 3));
    Get.offAll(() => UserInterface());
  }

  List<Product> products1 = [];
  Future<List<Product>> getProductByCompany(String Company) async {
    final v = await cloud.FirebaseFirestore.instance.collection(Company).get();

    try {
      var products = v.docs
          .map((e) => Product(
                sno: e["sno"] ?? 0,
                partNo: e["partNo"] ?? "",
                barcode: e["barcode"] ?? "",
                productName: e["productName"] ?? "",
                rack: e["rack"] ?? "",
                groupName: e["groupName"] ?? "",
                company: e["company"] ?? "",
                commodity: e["commodity"] ?? "",
                salesVat: e["salesVat"] ?? "",
                section: e["section"] ?? "",
                cPrice: e["cPrice"] ?? 0.0,
                pPrice: e["pPrice"] ?? 0.0,
                margin: e["margin"] ?? 0.0,
                mrp: e["mrp"] ?? 0.0,
                sPrice: e["sPrice"] ?? 0.0,
                splPrice: e["splPrice"] ?? 0.0,
                unit: e["unit"] ?? "",
                weight: e["weight"] ?? 0.0,
                expiryDays: e["expiryDays"] ?? 0,
                godownTax: e["godownTax"] ?? "",
                supplier: e["supplier"] ?? "",
                discound: e["discound"] ?? 0.0,
              ))
          .toList();
      log("sucessFul fetch from FireBase with ${products.length}");
      return products;
    } catch (e) {
      log(e.toString() + "ferr");
    }
    return products1;
  }

  Future<List<Product>> GetList(String Company) async {
    await getProductByCompany(Company);
    print(products1);
    return products1;
  }

  Future<void> addAttendance(File image, String userName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref('Attendance').child(userName);
      await storageRef.putFile(image);
      print(await storageRef.getDownloadURL());
      final url = await storageRef.getDownloadURL();
      await cloud.FirebaseFirestore.instance
          .collection('Attendance')
          .doc(userName)
          .set({
        'image url': url,
        'time': cloud.Timestamp.now(),
        'date': DateTimeTat().GetDate(),
        'User': userName,
        "status": false,
        "name": FirebaseAuth.instance.currentUser!.displayName
      });
    } on FirebaseException catch (e) {
      Get.snackbar('Error', 'Attendance not added try again',
          duration: Duration(seconds: 5),
          icon: Icon(Icons.warning_amber_rounded),
          shouldIconPulse: true);
    }
  }

  Future<void> updateAttendance(
      String userName, bool status, String email) async {
    await cloud.FirebaseFirestore.instance
        .collection('Attendance')
        .doc(email)
        .update({'status': status});
    if (status) {
      final list = await cloud.FirebaseFirestore.instance
          .collection("Employees")
          .doc(userName)
          .collection(DateTime.now().year.toString())
          .doc(DateTime.now().month.toString())
          .get();
      if (list.exists) {
        Map map = list.data()?['Attendance Days'];
        // print(map);
        print("hai");
        map.update(DateTime.now().day.toString(), (value) => status);
        await cloud.FirebaseFirestore.instance
            .collection("Employees")
            .doc(userName)
            .collection(DateTime.now().year.toString())
            .doc(DateTime.now().month.toString())
            .update({
          'Attendance Days': map,
          // map.update(DateTime.now().day.toString(), (value) => status),
          //'Attendance Days': AttendanceSheet()
          // .getAttendanceSheet(DateTime.now().month, DateTime.now().year),
          'Days of Present': list.data()?['Days of Present'] + 1
        });

        print(map);
      } else {
        await cloud.FirebaseFirestore.instance
            .collection("Employees")
            .doc(userName)
            .collection(DateTime.now().year.toString())
            .doc(DateTime.now().month.toString())
            .set({
          'Attendance Days': AttendanceSheet()
              .getAttendanceSheet(DateTime.now().month, DateTime.now().year),
          "Mothly sales": 0.0,
          "Days of Present": 0,
          "Max sale": 0.0,
          "Max Sale Shop": "",
        });
      }
    }
  }

  Future<void> deleteOrder(String uid, String location) async {
    print("g");
    await cloud.FirebaseFirestore.instance
        .collection(location)
        .doc(uid)
        .delete();
  }

  void updateBalance(
      double balance, String location, String shopName, String phno) async {
    try {
      if (balance < 0) {
        Get.dialog(AlertDialog(
          title: Text("Insuficient Balance"),
        ));
        throw Error();
      }
      await cloud.FirebaseFirestore.instance
          .collection(location + "Shops")
          .doc(shopName)
          .update({"Total Balance": balance});
      Get.snackbar("Sucess", "Current balance of $shopName is $balance");
    } catch (E) {
      Get.dialog(AlertDialog(
        title: Text("Error"),
        content: Text("Balance not updated"),
      ));
    }
  }

  Future<void> deleteShop(String Location, String ShopName) async {
    try {
      await cloud.FirebaseFirestore.instance
          .collection(Location + "Shops")
          .doc(ShopName)
          .delete();
      Get.snackbar("Sucess", "$ShopName deleted Sucessfully",
          icon: Icon(
            Icons.done_outline,
            color: Colors.green,
          ));
      Get.back();
    } catch (E) {
      Get.dialog(AlertDialog(
        title: Text("Unable to delete "),
      ));
    }
  }

  // sendSms(String message, List<String> recipents) async {
  //   String _result = await sendSMS(message: message, recipients: recipents)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }
  void live() async {
    final userName = user.displayName;
    final location = await getcurrentLocation();
    final lat = location[7];
    final long = location[8];
    await getPermission();
    Get.snackbar("Live", "Your in Live");
    Geolocator.getPositionStream().listen((event) async {
      await cloud.FirebaseFirestore.instance
          .collection("Employees")
          .doc(userName)
          .update({"Lat": event.latitude, "Long": event.longitude});
    });

    //
  }

  Future<Employe> getEmployee(
      String UserName, String month, String year) async {
    Employe employe;
    final overAllEmployeBase = await cloud.FirebaseFirestore.instance
        .collection('Employees')
        .doc(UserName)
        .get();
    final monthlyEmployeBase = await cloud.FirebaseFirestore.instance
        .collection('Employees')
        .doc(UserName)
        .collection(year)
        .doc(DateTime.now().month.toString())
        .get();
    if (!monthlyEmployeBase.exists) {
      await cloud.FirebaseFirestore.instance
          .collection('Employees')
          .doc(UserName)
          .collection(DateTime.now().year.toString())
          .doc(DateTime.now().month.toString())
          .set({
        'Attendance Days': AttendanceSheet()
            .getAttendanceSheet(DateTime.now().month, DateTime.now().year),
        "Mothly sales": 0.0,
        "Days of Present": 0,
        "Max sale": 0.0,
        "Max Sale Shop": "",
      });
      NewOrder().live();
    }
    employe = Employe(
        email: overAllEmployeBase['email'],
        name: overAllEmployeBase['UserName'],
        daysOfPresent: monthlyEmployeBase['Attendance Days'],
        monthlyMaxSale: monthlyEmployeBase['Max sale'],
        monthlyMaxSaleShop: monthlyEmployeBase['Max Sale Shop'],
        monthlySales: monthlyEmployeBase['Mothly sales'],
        noOfDaysPresent: monthlyEmployeBase['Days of Present'],
        overAllSales: overAllEmployeBase['Sales'],
        job: overAllEmployeBase['Job'],
        lat: overAllEmployeBase['Lat'],
        long: overAllEmployeBase['Long']);
    return employe;
  }

  Future<void> addProduct(
      String company, String product, String SellingPrice, String MRP) async {
    try {
      await cloud.FirebaseFirestore.instance
          .collection(company)
          .doc(product)
          .set(
        {
          "ProductName": product,
          "Selling Price": SellingPrice,
          "MRP": MRP,
          "Upload Time": cloud.Timestamp.now()
        },
      );

      Get.snackbar(
        "Sucess",
        "$product added Sucessfully",
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.done_outline_rounded,
          color: Colors.green,
        ),
      );
    } catch (e) {
      Get.snackbar("ERROR", "SHOP NOT ADDED", shouldIconPulse: true);
    }
  }

  Future<Set<Product>> getAllProducts(Set<String> companies) async {
    Set<Product> products = {};
    for (String Company in companies) {
      if (Company != "--select--") {
        final v =
            await cloud.FirebaseFirestore.instance.collection(Company).get();

        products.addAll([
          ...v.docs
              .map((e) => Product(
                    sno: e["sno"] ?? 0,
                    partNo: e["partNo"] ?? "",
                    barcode: e["barcode"] ?? "",
                    productName: e["ProductName"] ?? "",
                    rack: e["rack"] ?? "",
                    groupName: e["groupName"] ?? "",
                    company: e["company"] ?? "",
                    commodity: e["commodity"] ?? "",
                    salesVat: e["salesVat"] ?? "",
                    section: e["section"] ?? "",
                    cPrice: e["cPrice"] ?? 0.0,
                    pPrice: e["pPrice"] ?? 0.0,
                    margin: e["margin"] ?? 0.0,
                    mrp: e["mrp"] ?? 0.0,
                    sPrice: e["sPrice"] ?? 0.0,
                    splPrice: e["splPrice"] ?? 0.0,
                    unit: e["unit"] ?? "",
                    weight: e["weight"] ?? 0.0,
                    expiryDays: e["expiryDays"] ?? 0,
                    godownTax: e["godownTax"] ?? "",
                    supplier: e["supplier"] ?? "",
                    discound: e["discound"] ?? 0.0,
                  ))
              .toList()
        ]);
      }
    }
    return products;
  }
}
