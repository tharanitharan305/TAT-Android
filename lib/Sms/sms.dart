// import 'package:background_sms/background_sms.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// _getPermission() async => await [
//       Permission.sms,
//     ].request();
//
// Future<bool> _isPermissionGranted() async =>
//     await Permission.sms.status.isGranted;
//
// _sendMessage(String phoneNumber, String message, String to, String total,
//     {int? simSlot}) async {
//   final result = await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber, message: message);
//   if (result == SmsStatus.sent) {
//     Get.snackbar("Sucess", "SMS sent to $phoneNumber $to with total of $total");
//   } else if (result == SmsStatus.failed) {
//     Get.snackbar("FAILED", "SMS SENT FAILED",
//         icon: Icon(Icons.warning), shouldIconPulse: true);
//   }
// }
//
// Future<bool?> get _supportCustomSim async =>
//     await BackgroundSms.isSupportCustomSim;
// Future<void> sendSmsBill(
//     String order, String total, String phno, String by, String to) async {
//   String messsage =
//       "வணக்கம்,தரணி ஏ டிரேடர்ஸ் அனுப்பிய செய்தி உங்கள் ஆர்டர்கள் பெறப்பட்டது மொத்தம்: $total";
//   if ((await _supportCustomSim)!)
//     _sendMessage(phno, messsage, to, total, simSlot: 1);
//   else
//     _sendMessage(phno, messsage, to, total);
//   if (await _isPermissionGranted()) {
//   } else
//     _getPermission();
// }
