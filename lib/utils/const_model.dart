
String imageBaseUrl = "https://api.swiftsurgical.net/";//imgUrlbase
String baseUrl = "https://api.swiftsurgical.net/api/v1/";//sub
String hrUrl = "https://hr.swiftsurgical.net/public/api/";  //hr
String apiSecretKey = 'BSHR210';

List dashboardItems = [
    {"name": "Order Entry", "image": "images/orderEntry.png"},
    {"name": "Order Record", "image": "images/orderRecord.png"},
    {"name": "Order Invoice", "image": "images/orderInvoice.png"},
    {"name": "Sales Entry", "image": "images/salesEntry.png"},
    {"name": "Sales Record", "image": "images/srecord.png"},
    {"name": "Sales Invoice", "image": "images/sInvc.png"},
    
    {"name": "Product List", "image": "images/productlist.png"},
    {"name": "Category List", "image": "images/catelist.png"},
    {"name": "Customer List", "image": "images/customerlist.png"},
    {"name": "Logout", "image": "images/logout.png"},
    {"name": "Visit Entry", "image": "images/visite.png"},
    {"name": "Visit List", "image": "images/vhistory.png"},
    {"name": "Attendance", "image": "images/attend.png"},
  ];


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../config/app_url.dart';

// class AddOrderProvider extends ChangeNotifier {
//   static final ValueNotifier<bool> isLoading = ValueNotifier(false);
//   static Future<Map<String, dynamic>> addOrder({
//     required String customerName,
//     required String customerPhone,
//     required String customerAddress,
//     required String productId,
//     required String visualPrice,
//     required String quantity,
//     required String note,
//     required BuildContext context,
//   }) async {
//     isLoading.value = true;
//     try {
//       final String apiKey = AppUrl.apiKey;

//       final response = await http.post(
//         Uri.parse(AppUrl.addOrderEndPint),
//         headers: {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           "customer_name": customerName,
//           "customer_phone": customerPhone,
//           "customer_address": customerAddress,
//           "product_id": productId,
//           "visual_price": visualPrice,
//           "quantity": quantity,
//           "note": note,
//         },
//       );

//       print('Request URL: ${AppUrl.addOrderEndPint}');
//       print('Request Body: ${jsonEncode({
//             "customer_name": customerName,
//             "customer_phone": customerPhone,
//             "customer_address": customerAddress,
//             "product_id": productId,
//             "visual_price": visualPrice,
//             "quantity": quantity,
//             "note": note,
//           })}');
//       print('Response: ${response.body}');
// // In your provider methods:
//       // if response code 200 ok
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);

//         if (responseData['status'] == true) {
//           return responseData;
//         } else {
//           throw Exception(
//               responseData['message'] ?? 'An unknown error occurred.');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);

//         if (errorData['errors'] != null &&
//             errorData['errors']['message'] != null) {
//           throw Exception(errorData['errors']['message'][0]);
//         } else {
//           throw Exception(
//               'Request failed with status code: ${response.statusCode}');
//         }
//       }
//     } catch (e) {
//       rethrow;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

