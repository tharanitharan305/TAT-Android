import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tat/Screens/Admin.dart';
import 'package:tat/Widgets/OrderPreview.dart';
import 'package:tat/Widgets/Orders.dart';
import 'package:tat/Widgets/comapnies.dart';
import '../Widgets/Areas.dart';
import '../Widgets/OrderFormat.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() {
    return _OrderScreen();
  }
}

class _OrderScreen extends State<OrderScreen> {
  final key = GlobalKey<FormState>();
  String StateString = "Select a company name to get Product";
  bool ViewScrool = true;
  bool Admin = false;
  int Quantity = 0;
  companies company = companies.Elite;
  String ShopName = "";
  Set<Orders>? Products;
  Set<Orders> overAllOrders = {Orders(Products: 'null', Quantity: '0')};
  String Location = "";
  Locations DropDownView = Locations.Karur_Local;
  bool SendState = false;
  bool shopStatus = false;
  bool productStatus = false;
  bool locationStatus = false;
  void onSubmit() {
    setState(() {
      StateString = 'Uploading Order please wait...';
    });
    if (key.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) => OrderPreview(
                Order: overAllOrders,
                Shopname: ShopName,
                Location: Location,
              ));

      setState(() {
        StateString = 'Order sent succesfully...';
      });
    }
  }

  void onNextOrder() {
    for (int i = 0; i < Products!.length; i++) {
      if (Products?.elementAt(i) != null &&
          Products?.elementAt(i).Quantity != '0') {
        Orders check = Products!.elementAt(i);
        overAllOrders.add(check);
      }
    }
    setState(() {
      ViewScrool = false;
      StateString = "Order update Success Continue to next...";
      SendState = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Home')),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Form(
            key: key,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Shop name'),
              onSaved: (value) {
                ShopName = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 5) {
                  return 'Enter a valid ShopName';
                }
              },
              onChanged: (value) {
                ShopName = value;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              DropdownButton(
                  onTap: () => setState(() {
                        shopStatus = key.currentState!.validate();
                      }),
                  elevation: 50,
                  autofocus: true,
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  value: company,
                  items: companies.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            key: UniqueKey(),
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (values) {
                    setState(() {
                      company = values!;
                      productStatus = true;
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  onPressed: productStatus && locationStatus && shopStatus
                      ? () {
                          var companyProducts =
                              OrderFormat().getCompany(company);
                          setState(() {
                            Products = companyProducts;
                            ViewScrool = true;
                          });
                        }
                      : null,
                  child: const Text('Get Product'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  onPressed: shopStatus && locationStatus && productStatus
                      ? onNextOrder
                      : null,
                  child: const Text('Submit')),
              DropdownButton(
                  onTap: () => setState(() {
                        shopStatus = key.currentState!.validate();
                      }),
                  elevation: 50,
                  autofocus: true,
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  value: DropDownView,
                  items: Locations.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            key: UniqueKey(),
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (values) {
                    setState(() {
                      DropDownView = values!;
                      Location = values.toString();
                      locationStatus = true;
                    });
                  })
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                if (!ViewScrool) Text(StateString),
                if (Admin)
                  AdminScreen()
                //else if (Products == null)

                else if (ViewScrool && Products != null)
                  ...?Products?.map((e) {
                    return Card(
                      child: Column(
                        children: [
                          Row(children: [
                            Text(
                              e.Products,
                              style: GoogleFonts.bitter(
                                  textStyle: const TextStyle(
                                      letterSpacing: 1, fontSize: 20)),
                            ),
                            const SizedBox(
                              width: 200,
                            ),
                            Expanded(child: Text(e.Quantity.toString())),
                          ]),
                          Form(
                              child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'quantity'),
                            onChanged: (value) {
                              setState(() {
                                e.Quantity = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                          )),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  }),
              ],
            )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          disabledElevation: 0,
          enableFeedback: true,
          onPressed: !ViewScrool ? onSubmit : null,
          child: const Icon(Icons.check)),
    );
  }
}
