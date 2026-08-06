// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // 🟢 Naye Package ka Import
// import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
//
// class PaytmService {
//   /// Extract MID directly from paymentUrl query parameter
//   static String? _extractMidFromUrl(String url) {
//     try {
//       final uri = Uri.parse(url);
//       return uri.queryParameters['mid'];
//     } catch (e) {
//       return null;
//     }
//   }
//
//   static Future<void> processPaytmTransaction({
//     required BuildContext context,
//     required String orderId,
//     required String txnToken,
//     required String paymentUrl,
//     required String amount,
//     bool isStaging = true,
//   }) async {
//     final String mid = _extractMidFromUrl(paymentUrl) ?? "FAEClA31908078249088";
//
//     final String callbackUrl = isStaging
//         ? "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId"
//         : "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
//
//     try {
//       // 🎯 FIX: Naye package me class ka naam `AllInOneSdk` hai
//       var response = await AllInOneSdk.startTransaction(
//         mid,
//         orderId,
//         amount,
//         txnToken,
//         callbackUrl,
//         isStaging,
//         true, // restrictAppInvoke
//       );
//
//       debugPrint("Paytm SDK Response: $response");
//
//       if (response != null && context.mounted) {
//         final responseMap = Map<String, dynamic>.from(response);
//         String status = responseMap['STATUS'] ?? responseMap['status'] ?? '';
//         String respMsg = responseMap['RESPMSG'] ??
//             responseMap['message'] ??
//             'Transaction completed';
//
//         if (status == 'TXN_SUCCESS') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   "Payment Successful! Txn ID: ${responseMap['TXNID'] ?? ''}"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Payment Failed: $respMsg"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } on PlatformException catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Paytm SDK Error: ${e.message}"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Something went wrong: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }