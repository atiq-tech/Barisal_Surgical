import 'package:barishal_surgical/common_widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _statusMessage = "ফিঙ্গারপ্রিন্ট যাচাই করতে নিচের বাটনে ক্লিক করুন";

  Future<void> _authenticate() async {
    try {
      // ১. ডিভাইস সাপোর্ট করে কি না চেক
      final bool isDeviceSupported = await auth.isDeviceSupported();
      final bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (!isDeviceSupported || !canCheckBiometrics) {
        setState(() => _statusMessage = "আপনার ফোনে বায়োমেট্রিক সাপোর্ট নেই!");
        return;
      }

      // ২. অথেন্টিকেশন শুরু (AuthenticationOptions ছাড়াই)
      // ৩.০.১ ভার্সনে এইভাবে সরাসরি authenticate করা যায়
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'আপনার পরিচয় নিশ্চিত করতে আঙুলের ছাপ দিন',
        // এখানে biometricOnly বা stickyAuth সরাসরি দেওয়ার দরকার নেই
        // কারণ ডিফল্টভাবেই এটি বায়োমেট্রিক চেক করে
      );

      if (didAuthenticate) {
        setState(() => _statusMessage = "সফলভাবে ভেরিফাইড হয়েছে! ✅");
        // ভেরিফিকেশন সফল হলে পরবর্তী কাজ এখানে করুন
      } else {
        setState(() => _statusMessage = "ভেরিফিকেশন সম্পন্ন হয়নি।");
      }
    } catch (e) {
      setState(() => _statusMessage = "এরর: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "এমপ্লয়ি ভেরিফিকেশন"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("স্ক্যান শুরু করুন"),
            ),
          ],
        ),
      ),
    );
  }
}








///================== with employee id ==================
// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:dio/dio.dart';

// class BiometricAuthScreen extends StatefulWidget {
//   final String employeeId; // আপনার প্রোজেক্ট অনুযায়ী এখানে এমপ্লয়ি আইডি পাস করবেন

//   const BiometricAuthScreen({super.key, required this.employeeId});

//   @override
//   State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
// }

// class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
//   final LocalAuthentication auth = LocalAuthentication();
//   final Dio dio = Dio(); // Dio ইনিশিয়ালাইজ করা
  
//   String _statusMessage = "ফিঙ্গারপ্রিন্ট যাচাই করতে নিচের বাটনে ক্লিক করুন";
//   bool _isLoading = false; // লোডিং স্টেট দেখানোর জন্য

//   // সার্ভারে ডেটা পাঠানোর ফাংশন
//   Future<void> _sendAttendanceData() async {
//     setState(() {
//       _isLoading = true;
//       _statusMessage = "সার্ভারে তথ্য পাঠানো হচ্ছে...";
//     });

//     try {
//       // আপনার অরিজিনাল API URL এখানে বসাবেন
//       const String apiUrl = "https://your-api-url.com/api/attendance"; 

//       final response = await dio.post(
//         apiUrl,
//         data: {
//           "employee_id": widget.employeeId,
//           "timestamp": DateTime.now().toIso8601String(),
//           "status": "Verified",
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _statusMessage = "অভিনন্দন! আপনার অ্যাটেনডেন্স সফলভাবে নেওয়া হয়েছে। ✅";
//         });
//       } else {
//         setState(() {
//           _statusMessage = "সার্ভারে সমস্যা হচ্ছে। পুনরায় চেষ্টা করুন।";
//         });
//       }
//     } on DioException catch (e) {
//       setState(() {
//         _statusMessage = "নেটওয়ার্ক এরর: ${e.message}";
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // ফিঙ্গারপ্রিন্ট অথেন্টিকেশন ফাংশন
//   Future<void> _authenticate() async {
//     try {
//       final bool isDeviceSupported = await auth.isDeviceSupported();
//       final bool canCheckBiometrics = await auth.canCheckBiometrics;

//       if (!isDeviceSupported || !canCheckBiometrics) {
//         setState(() => _statusMessage = "আপনার ফোনে বায়োমেট্রিক সাপোর্ট নেই!");
//         return;
//       }

//       final bool didAuthenticate = await auth.authenticate(
//         localizedReason: 'আপনার পরিচয় নিশ্চিত করতে আঙুলের ছাপ দিন',
//       );

//       if (didAuthenticate) {
//         // ফিঙ্গারপ্রিন্ট মিললে API কল করা হবে
//         await _sendAttendanceData();
//       } else {
//         setState(() => _statusMessage = "ভেরিফিকেশন সম্পন্ন হয়নি।");
//       }
//     } catch (e) {
//       setState(() => _statusMessage = "ত্রুটি: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("এমপ্লয়ি ভেরিফিকেশন"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // লোডিং হলে প্রগ্রেস বার দেখাবে, নাহলে আইকন
//               _isLoading 
//                 ? const CircularProgressIndicator()
//                 : const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
              
//               const SizedBox(height: 30),
              
//               Text(
//                 _statusMessage,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
              
//               const SizedBox(height: 40),
              
//               if (!_isLoading) // লোডিং চললে বাটন হাইড থাকবে
//                 ElevatedButton.icon(
//                   onPressed: _authenticate,
//                   icon: const Icon(Icons.touch_app),
//                   label: const Text("স্ক্যান শুরু করুন"),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }