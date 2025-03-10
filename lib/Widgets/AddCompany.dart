import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../companies/comapnies.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  String location = "";
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Company"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: "Enter Company Name"),
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
                      await Companies().AddCompany(location);
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
