// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

//   /// Initialize notification
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
//     await _notificationsPlugin.initialize(initSettings);
//   }

//   /// Show notification (only title)
//   static Future<void> showNotification(String title, int id) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'attendance_channel',
//       'Attendance',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );
//     const NotificationDetails details = NotificationDetails(android: androidDetails);
//     await _notificationsPlugin.show(
//       id,
//       title, 
//       "",   
//       details,
//     );
//   }

//   static Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }

//   static Future<void> cancelAll() async {
//     await _notificationsPlugin.cancelAll();
//   }
// }
