import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tat/Widgets/AddCompany.dart';
import 'package:tat/Widgets/AddLocation.dart';
import 'package:tat/Widgets/ShopGetter.dart';
import 'package:tat/Shop/Shops.dart';

import '../Widgets/Add.dart';

class GetNew extends StatefulWidget {
  State<GetNew> createState() => _GetNew();
}

class _GetNew extends State<GetNew> {
  void ADD() {
    Get.to(() => Add());
  }

  void ShopAdd() {
    Get.to(() => ShopGetter());
  }

  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              image: const DecorationImage(
                image: AssetImage('images/tatlogo.png'),
                fit: BoxFit.contain,
                opacity: 0.1,
              )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: ADD,
                  label: const Text('Add Product'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    elevation: 10,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  icon: const Icon(Icons.shopping_cart_checkout_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: ShopAdd,
                  label: const Text('Add Shop'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    elevation: 10,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  icon: const Icon(Icons.add_business_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => AddCompany());
                  },
                  label: const Text('Add Company'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    elevation: 10,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  icon: const Icon(Icons.factory_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => AddLocation());
                  },
                  label: const Text('Add Location'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                    elevation: 10,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  icon: const Icon(Icons.add_location),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
