import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InterNetChecker extends StatefulWidget {
  const InterNetChecker({super.key});

  @override
  State<InterNetChecker> createState() => _InterNetCheckerState();
}

class _InterNetCheckerState extends State<InterNetChecker> {
  bool isConnected = false;
  StreamSubscription? _internetStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _internetStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = true;
          });

          // Get.snackbar(
          //     icon: Icon(Icons.wifi_off_rounded),
          //     "Disconnected",
          //     "Turn on you network ");
          break;
        default:
          setState(() {
            isConnected = false;
          });
          break;
      }
      print(isConnected);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _internetStreamSubscription?.cancel();
    super.dispose();
    //
  }

  void check() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(isConnected ? Icons.wifi : Icons.wifi_off_rounded),
        color: isConnected ? Colors.green : Colors.red,
        onPressed: check,
      ),
    );
  }
}
