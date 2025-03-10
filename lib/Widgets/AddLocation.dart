import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tat/Beat/Areas.dart';

import '../companies/comapnies.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  String location = "";
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Location"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: "Enter Location"),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await Areas().AddLocation(location);
                      controller.clear();
                    },
                    child: Text('Add')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
