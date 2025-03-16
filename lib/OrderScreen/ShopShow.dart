// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tat/Firebase/NewOrder.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../Shop/Shops.dart';
// import '../Shop/bloc/ShopBloc.dart';
//
// class ShopScreen extends StatelessWidget {
//   const ShopScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ShopBloc()
//         ..add(FetchLocationsEvent()), // Fetch locations when UI loads
//       child: const ShopView(),
//     );
//   }
// }
//
// class ShopView extends StatelessWidget {
//   const ShopView({super.key});
//
//   void _launchDialer(String phoneNumber) async {
//     if (await canLaunchUrl(Uri(scheme: 'tel', path: phoneNumber))) {
//       await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
//     } else {
//       Get.dialog(const AlertDialog(
//         content: Text("Can't open Dialer"),
//         title: Text("ERROR"),
//       ));
//     }
//   }
//
//   void launchMap(String lat, String long) async {
//     final Uri _url = Uri.parse(
//         "https://www.google.com/search?q=$lat%2C$long&oq=$lat%2C$long");
//     launchUrl(_url);
//   }
//
//   void setBalance(BuildContext context, double curBalance, String name, String phno) {
//     double balance = 0.0;
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Update"),
//         content: TextFormField(
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             balance = double.tryParse(value) ?? 0.0;
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.read<ShopBloc>().add(UpdateBalanceEvent(
//                   newBalance: balance + curBalance, shopName: name, phone: phno));
//               Get.back();
//             },
//             icon: const Icon(Icons.add),
//           ),
//           IconButton(
//             onPressed: () {
//               context.read<ShopBloc>().add(UpdateBalanceEvent(
//                   newBalance: curBalance - balance, shopName: name, phone: phno));
//               Get.back();
//             },
//             icon: const Icon(Icons.minimize),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.read<ShopBloc>().add(FetchLocationsEvent());
//             },
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             BlocBuilder<ShopBloc, ShopState>(
//               builder: (context, state) {
//                 if (state is LocationFetchSuccess) {
//                   return LocationDrop(locations: state.locations);
//                 }
//                 return const CircularProgressIndicator();
//               },
//             ),
//             BlocBuilder<ShopBloc, ShopState>(
//               builder: (context, state) {
//                 if (state is ShopFetchSuccess) {
//                   return ShopDrop(shops: state.shopList);
//                 }
//                 return const Text("Select a location first");
//               },
//             ),
//             BlocBuilder<ShopBloc, ShopState>(
//               builder: (context, state) {
//                 if (state is ShopSelected) {
//                   return ShopDet(shop: state.shop);
//                 }
//                 return const Text("Select a Shop");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LocationDrop extends StatelessWidget {
//   final Set<String> locations;
//   const LocationDrop({required this.locations, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       elevation: 50,
//       dropdownColor: Theme.of(context).colorScheme.primaryContainer,
//       borderRadius: BorderRadius.circular(20),
//       value: context.watch<ShopBloc>().selectedLocation,
//       items: locations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//       onChanged: (value) {
//         if (value != null) {
//           context.read<ShopBloc>().add(SelectLocationEvent(location: value));
//         }
//       },
//     );
//   }
// }
//
// class ShopDrop extends StatelessWidget {
//   final Set<Shop> shops;
//   const ShopDrop({required this.shops, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Shop>(
//       elevation: 50,
//       dropdownColor: Theme.of(context).colorScheme.primaryContainer,
//       borderRadius: BorderRadius.circular(20),
//       value: context.watch<ShopBloc>().selectedShop,
//       items: shops.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
//       onChanged: (value) {
//         if (value != null) {
//           context.read<ShopBloc>().add(SelectShopEvent(shop: value));
//         }
//       },
//     );
//   }
// }
//
// class ShopDet extends StatelessWidget {
//   final Shop shop;
//   const ShopDet({required this.shop, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.60,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Spacer(),
//                 Text(shop.name, style: GoogleFonts.lexend(fontSize: 25)),
//                 const Spacer(),
//                 IconButton(
//                   onPressed: () {
//                     Get.dialog(AlertDialog(
//                       title: Text("Delete ${shop.name}"),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             NewOrder().deleteShop(
//                                 context.read<ShopBloc>().selectedLocation, shop.name);
//                             Get.back();
//                           },
//                           child: const Text("Yes"),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: const Text("No"),
//                         ),
//                       ],
//                     ));
//                   },
//                   icon: const Icon(Icons.delete_rounded),
//                 ),
//               ],
//             ),
//             Text("Total Purchase: ${shop.total}"),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Total Balance: ${shop.balance}"),
//                 IconButton(
//                   onPressed: () => setBalance(context, shop.balance, shop.name, shop.phno),
//                   icon: const Icon(Icons.change_circle),
//                 ),
//               ],
//             ),
//             TextButton.icon(
//               onPressed: () => _launchDialer("+91${shop.phno}"),
//               label: Text("Phno: ${shop.phno}"),
//               icon: const Icon(Icons.phone_rounded),
//             ),
//             TextButton.icon(
//               onPressed: () => launchMap(shop.lat, shop.long),
//               label: const Text("GET DIRECTION"),
//               icon: const Icon(Icons.location_on_rounded),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
