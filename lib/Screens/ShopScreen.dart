import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tat/Firebase/NewOrder.dart';
import 'package:tat/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Beat/Areas.dart';
import '../Shop/Shops.dart';
import '../companies/comapnies.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double balance = 999;
  Shop ShopName = Shop("Shop name", 0, 0, "", "", "", "", "", "", "", "");
  Set<Shop> ShopsList = {};
  Set<String> locations = {};
  bool shopStatus = false;
  bool locationStatus = false;
  String Location = "--select--";
  SetLocation() async {
    final tempLoc = await Areas().GetLocations();
    setState(() {
      locations = tempLoc;
    });
  }

  Future<void> GetitShops(String Location) async {
    final list =getShop(Location);
    final dupe = await list;
    setState(() {
      ShopsList = {ShopName, ...dupe};
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SetLocation();
  }

  Widget ShopDrop() {
    return DropdownButton(
        elevation: 50,
        autofocus: true,
        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        value: ShopName,
        items: ShopsList.map((e) => DropdownMenuItem(
              value: e,
              key: UniqueKey(),
              child: Text(e.name),
            )).toList(),
        onChanged: (values) {
          setState(() {
            ShopName = values!;
            shopStatus = true;
          });
        });
  }

  Widget LocationDrop() {
    return DropdownButton(
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
            Location = values.toString();
            locationStatus = true;
            GetitShops(Location);
          });
        });
  }

  void _launchDialer(String phoneNumber) async {
    print(phoneNumber);
    // String url = 'tel:$phoneNumber';
    // Uri uri = Uri.parse(url);
    // print(uri);
    if (await canLaunchUrl(Uri(scheme: 'tel', path: phoneNumber))) {
      await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
    } else {
      Get.dialog(AlertDialog(
        content: Text("Can't open Dialer"),
        title: Text("ERROR"),
      ));
    }
  }

  void launchMap(String lat, String long) async {
    //   NewOrder().sendSms("Your Current Balance is ", ["+919787874607"]);
    final Uri _url = Uri.parse(
        "https://www.google.com/search?q=$lat%2C$long&oq=$lat%2C$long&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQLhhA0gEINTY5M2owajSoAgCwAgA&sourceid=chrome&ie=UTF-8");
    launchUrl(_url);
    print(lat);
    print(long);
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  void setBalance(double curBalance, String name, String phno) {
    double balance = 0.0;
    Get.dialog(AlertDialog(
      title: Text("Update"),
      content: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            balance = double.parse(value);
          });
        },
        onSaved: (value) {
          setState(() {
            balance = double.parse(value!);
          });
        },
      ),
      actions: [
        IconButton(
            onPressed: () {
              NewOrder()
                  .updateBalance(balance + curBalance, Location, name, phno);
              Get.back();
            },
            icon: Icon(Icons.add)),
        IconButton(
            onPressed: () {
              NewOrder()
                  .updateBalance(curBalance - balance, Location, name, phno);
              Get.back();
            },
            icon: Icon(Icons.minimize))
      ],
    ));
  }

  Widget ShopDet(Shop shop) {
    if (ShopName.name == "Shop name") {
      return Text("Select a Shop");
    }
    return Card(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.60,
          // color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    shop.name,
                    style: GoogleFonts.lexend(fontSize: 25),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text("Delete ${shop.name}"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  NewOrder().deleteShop(Location, shop.name);
                                },
                                child: Text("Yes")),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("No")),
                          ],
                        ));
                      },
                      icon: Icon(Icons.delete_rounded))
                ],
              ),
              Text("Total Purchase: ${shop.total}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Balance: ${shop.balance}"),
                  IconButton(
                      onPressed: () =>
                          setBalance(shop.balance, shop.name, shop.phno),
                      icon: Icon(Icons.change_circle))
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  _launchDialer("+91${shop.phno}");
                },
                label: Text("Phno: ${shop.phno}"),
                icon: Icon(Icons.phone_rounded),
              ),
              TextButton.icon(
                onPressed: () {
                  launchMap(shop.lat, shop.long);
                },
                label: Text("GET DIRECTION"),
                icon: Icon(Icons.location_on_rounded),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [LocationDrop(), ShopDrop(), ShopDet(ShopName)],
        ),
      ),
    );
  }
}
