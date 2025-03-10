// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tat/Widgets/Orders.dart';
//
// class Grb {
//   void put() async {
//     for (Orders o in products) {
//       await FirebaseFirestore.instance.collection("GRB").doc(o.Products).set({
//         "ProductName": o.Products,
//         "Selling Price": o.SellingPrice,
//         "MRP": o.MRP,
//         "Upload Time": Timestamp.now()
//       });
//     }
//   }
//
//   var products = [
//     Orders(
//         Products: "ALOO BHUJIA 135GR",
//         SellingPrice: " 35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "BADAM DRING MIX 20GR",
//         SellingPrice: "7.60",
//         MRP: "10.00",
//         Quantity: '0'),
//     Orders(
//         Products: "BADAM DRINK 200GR",
//         SellingPrice: "104.00",
//         MRP: "125.00",
//         Quantity: '0'),
//     Orders(
//         Products: "BADAM DRINK MIX 10GR",
//         SellingPrice: "3.80",
//         MRP: "5.00",
//         Quantity: '0'),
//     Orders(
//         Products: "BOMBAY MIXTURE 15GR",
//         SellingPrice: "46.00",
//         MRP: "60.00",
//         Quantity: '0'),
//     Orders(
//         Products: " BUTTER MURUKKU 135GR",
//         SellingPrice: "35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GARLIC MIXTURE 15GR",
//         SellingPrice: "46.00",
//         MRP: "60.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAM MIX 160GR",
//         SellingPrice: " 95.00",
//         MRP: "145.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAM MIX 175GR",
//         SellingPrice: " 95.00",
//         MRP: "145.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAMUN 125GR",
//         SellingPrice: "33.00",
//         MRP: "40.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAMUN 175GR",
//         SellingPrice: "124.00",
//         MRP: "145.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAMUN 300GR",
//         SellingPrice: " 63.00",
//         MRP: "75.00",
//         Quantity: '0'),
//     Orders(
//         Products: "GULAB JAMUN 500GR",
//         SellingPrice: "113.00",
//         MRP: "135.00",
//         Quantity: '0'),
//     Orders(
//         Products: "KERALA MIXTURE 150GR",
//         SellingPrice: "40.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "LEMON RICE POWDER 20G",
//         SellingPrice: "6.00",
//         MRP: "10.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MADRAS MIXTURE 20GR",
//         SellingPrice: "46.00",
//         MRP: "60.00",
//         Quantity: '0'),
//     Orders(
//         Products: " MASALA GREEN PEAS 135GR",
//         SellingPrice: "35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MASALA GREEN PEAS 30GR",
//         SellingPrice: "92.00",
//         MRP: "120.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MASALA PEANUT 135GR",
//         SellingPrice: "35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: " MASALA PEEANUT 15GR",
//         SellingPrice: "46.00",
//         MRP: "60.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MEDRAS MIXTURE 135GR",
//         SellingPrice: "35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MOONG DAL 135GR",
//         SellingPrice: "35.00",
//         MRP: "55.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MOONG DAL 15GR",
//         SellingPrice: "47.00",
//         MRP: "60.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MOONG DAL 30GR",
//         SellingPrice: "92.00",
//         MRP: "120.00",
//         Quantity: '0'),
//     Orders(
//         Products: "MYSORE PAK 200GR",
//         SellingPrice: "126.00",
//         MRP: "150.00",
//         Quantity: '0'),
//     Orders(
//         Products: "PAYASAM MIX 100GR",
//         SellingPrice: "37.00",
//         MRP: "99.00",
//         Quantity: '0'),
//     Orders(
//         Products: "PAYASAM MIX 180GRT",
//         SellingPrice: "45.00",
//         MRP: "99.00",
//         Quantity: '0'),
//     Orders(
//         Products: "PULIYOGARE POWDER 27GR",
//         SellingPrice: "8.00",
//         MRP: "10.00",
//         Quantity: '0'),
//     Orders(
//         Products: "RASOGOLLA 300GR",
//         SellingPrice: "63.00",
//         MRP: " 75.00",
//         Quantity: '0'),
//     Orders(
//         Products: " RASOGOLLA 500GR",
//         SellingPrice: "112.92",
//         MRP: " 135.00",
//         Quantity: '0'),
//     Orders(
//         Products: " RASOGOLLA125GR",
//         SellingPrice: "33.00",
//         MRP: "40.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN CAKE BUTTERSCOTCH 100GR",
//         SellingPrice: "34.00",
//         MRP: "40.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN CAKE ELACHI 100GR",
//         SellingPrice: "34.00",
//         MRP: "40.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN CAKE PINEAPPLE 100GR",
//         SellingPrice: "34.00",
//         MRP: "40.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI BUTTER SCOTCH 100GR",
//         SellingPrice: "30.00",
//         MRP: "35.00",
//         Quantity: '0'),
//     Orders(
//         Products: " SOAN PAPDI BUTTER SCOTCH 200GR",
//         SellingPrice: "59.00",
//         MRP: " 70.00",
//         Quantity: '0'),
//     Orders(
//         Products: " SOAN PAPDI CHCO 200GR",
//         SellingPrice: "59.00",
//         MRP: " 70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI CHOCOLATE 100GR",
//         SellingPrice: "30.00",
//         MRP: "35.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI COCONUT 200GR",
//         SellingPrice: "59.00",
//         MRP: "70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI ELACHI 200GR",
//         SellingPrice: "59.00",
//         MRP: "70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI ELACHI 100GR",
//         SellingPrice: "30.00",
//         MRP: "35.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI MANGO 200GR",
//         SellingPrice: "59.00",
//         MRP: "70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI ORANGE 200GR",
//         SellingPrice: "59.00",
//         MRP: "70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI ORANGE100GR",
//         SellingPrice: "30.00",
//         MRP: "35.00",
//         Quantity: '0'),
//     Orders(
//         Products: " SOAN PAPDI PINEAPPLE 100GR",
//         SellingPrice: "30.00",
//         MRP: "35.00",
//         Quantity: '0'),
//     Orders(
//         Products: "SOAN PAPDI PINEAPPLE 200GR",
//         SellingPrice: "59.00",
//         MRP: "70.00",
//         Quantity: '0'),
//     Orders(
//         Products: "TOMATO RICE POWDER 25GR",
//         SellingPrice: "7.00",
//         MRP: "10.00",
//         Quantity: '0'),
//     Orders(
//         Products: "TURMERIC POWDER 50GR",
//         SellingPrice: "8.22",
//         MRP: "17.00",
//         Quantity: '0'),
//   ];
// }
