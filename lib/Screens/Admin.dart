import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tat/Screens/splashScreen.dart';
import 'package:tat/Widgets/OrderviewCard.dart';

import '../Widgets/Areas.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() {
    return _AdminScreen();
  }
}

class _AdminScreen extends State<AdminScreen> {
  Locations DropDownView = Locations.Karur_Local;
  String Location = "Locations.Karur_Local";
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(),
            actions: [
              DropdownButton(
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
                    });
                  })
            ],
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(Location)
                  .orderBy('Ordered time', descending: true)
                  .snapshots(),
              builder: (context, OrderSnapCuts) {
                if (OrderSnapCuts.connectionState == ConnectionState.waiting) {
                  return Center(child: SplashScreen());
                }
                if (!OrderSnapCuts.hasData ||
                    OrderSnapCuts.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No Orders Found at $Location'),
                  );
                }
                if (OrderSnapCuts.hasError) {
                  return const Center(
                      child: Text(
                          'An Error Occured Try To Restart or Contact +91 9787874607'));
                }
                final RecivedOrders = OrderSnapCuts.data!.docs;

                return ListView.builder(
                    itemCount: RecivedOrders.length,
                    itemBuilder: (context, index) {
                      var filteredOrder = "";
                      var order = RecivedOrders[index]
                          .data()['Orders']
                          .toString()
                          .split(",");

                      for (int i = 0; i < order.length; i++) {
                        if (!order[i].endsWith('null')) {
                          filteredOrder += order[i];
                        }
                      }
                      return Column(children: [
                        OrderViewCard(
                          items: filteredOrder,
                          Shopname: RecivedOrders[index].data()['Shopname'],
                          useremail: RecivedOrders[index].data()['Ordered by'],
                          timestamp:
                              RecivedOrders[index].data()['Ordered time'],
                        )
                      ]);
                    });
              })),
    );
  }
}
