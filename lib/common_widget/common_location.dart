import 'package:barishal_surgical/utils/const_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static Future<Map<String, dynamic>?> fetchAndUploadLocation() async {
    try {
      // 1. Location Permission Check & Request
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Permission Denied");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Permission Denied Forever");
        return null;
      }

      // 2. GPS On ache kina check kora
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location Service is disabled.");
        return null;
      }

      // 3. Current Position Get Kora (Eikhane wait korbe)
      // Time-out add kora hoyeche jate infinite loop-e na thake
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // --- CRITICAL CHECK: Lat/Long valid na pawa porjonto code eikhan theke niche nambena ---
      if (position.latitude == 0.0 || position.longitude == 0.0) {
        print("Error: Latitude and Longitude are 0.0. API hit aborted.");
        return null;
      }

      // 4. Address Get kora (Optional, context-er jonno)
      String address = "Unknown Address";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        if (placemarks.isNotEmpty) {
          address = "${placemarks[0].name}, ${placemarks[0].locality}";
        }
      } catch (e) {
        print("Geocoding failed, but continuing for API hit...");
      }

      // 5. SharedPrefs theke data neya
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      String? token = prefs.getString("token");
      String? sessionId = prefs.getString("sessionId");

      // 6. Final Validation: User ID na thakle API pathano jabe na
      if (userId == null || userId.isEmpty) {
        print("User ID not found in SharedPreferences. API hit aborted.");
        return null;
      }

      // 7. API Hit - Eikhane asha mane amra Lat/Long peye gechi
      var formData = dio.FormData.fromMap({
        "userId": userId,
        "lat": position.latitude.toString(),
        "lng": position.longitude.toString(),
        "address": address.toString(),
      });

      print("Valid Lat/Long Found. Sending to API:$userId, ${position.latitude}, ${position.longitude}");

      await dio.Dio().post(
        "${baseUrl}lat_lng_update",
        data: formData,
        options: dio.Options(headers: {
          "Device-Type": "mobile",
          "Authorization": "Bearer $token",
          "Cookie": "ci_session=$sessionId",
        }),
      );

      // UI update korar jonno data return
      return {
        'lat': position.latitude,
        'long': position.longitude,
        'address': address,
      };

    } catch (e) {
      print("Error in LocationService: $e");
      return null;
    }
  }
}