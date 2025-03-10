import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tat/Screens/splashScreen.dart';
import 'package:tat/Widgets/Grb.dart';
import 'package:tat/OrderScreen/model/Orders.dart';
import 'package:tat/main.dart';
import '../Products/model/Product.dart';
import '../companies/comapnies.dart';

class Add extends StatefulWidget {
  State<Add> createState() => _Addstate();
}

class _Addstate extends State<Add> {
  String company = "--select--";
  String product = "";
  String SellingPrice = "";
  String MRP = "";
  late Product o;
  final key = GlobalKey<FormState>();
  bool status = false;
  bool uploadStatus = false;
  Set<String> companies = {};
  SetCompanies() async {
    final tempcomp = await Companies().GetCompany();
    setState(() {
      companies = tempcomp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetCompanies();
  }

  void upload() async {
    try {
      setState(() {
        uploadStatus = true;
      });
      await FirebaseFirestore.instance.collection(company).doc(product).set(
        {
          "ProductName": product,
          "Selling Price": SellingPrice,
          "MRP": MRP,
          "Upload Time": Timestamp.now()
        },
      );
      setState(() {
        uploadStatus = false;
      });
      Get.snackbar(
        "Sucess",
        "$product added Sucessfully",
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.done_outline_rounded,
          color: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Container(
          width: double.infinity,
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (widget.Status == "p")
                DropdownButton(
                    elevation: 50,
                    autofocus: true,
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    value: company,
                    items: companies
                        .map((e) => DropdownMenuItem(
                              value: e,
                              key: UniqueKey(),
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (values) {
                      setState(() {
                        company = values!;
                      });
                    }),
                if (company != "--select--")
                  TextFormField(
                    decoration: InputDecoration(labelText: "product"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3)
                        return "Enter a valid shopname";
                    },
                    onChanged: (values) {
                      setState(() {
                        product = values!;
                      });
                    },
                    onSaved: (values) {
                      setState(() {
                        product = values!;
                      });
                    },
                  ),
                if (product != null && product.length > 3 && !product.isEmpty)
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Selling Price"),
                    validator: (values) {
                      if (values!.isEmpty) return "Enter Selling price";
                      double? sp = double.tryParse(values!);
                      if (sp == null) return "enter a valid Price";
                    },
                    onChanged: (values) {
                      setState(() {
                        SellingPrice = values!;
                      });
                    },
                    onSaved: (values) {
                      setState(() {
                        SellingPrice = values!;
                      });
                    },
                  ),

                if (SellingPrice != null &&
                    double.tryParse(SellingPrice) != null)
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "MRP"),
                    validator: (values) {
                      if (values!.isEmpty) return "Enter Selling price";
                      double? sp = double.tryParse(values!);
                      if (sp == null) return "enter a valid Price";
                    },
                    onChanged: (values) {
                      setState(() {
                        MRP = values!;
                      });
                    },
                    onSaved: (values) {
                      setState(() {
                        MRP = values!;
                      });
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (double.tryParse(MRP) != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (uploadStatus) SplashScreen(),
                      if (!uploadStatus)
                        ElevatedButton(
                          onPressed: upload,
                          child: Text('ADD'),
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
