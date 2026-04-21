// import 'package:workmanager/workmanager.dart';
// import 'notification_service.dart';

// const String inAttendanceTask = "in_attendance_task";
// const String outAttendanceTask = "out_attendance_task";

// /// অবশ্যই top-level এবং entry-point annotate করতে হবে
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await NotificationService.init();

//     if (task == inAttendanceTask) {
//       await NotificationService.showNotification(
//         //"Please give your In Attendance",
//         "Did you give attendance today? If not, please do.",
//         1,
//       );
//     }
//     //  else if (task == outAttendanceTask) {
//     //   await NotificationService.showNotification(
//     //     "Please give your Out Attendance",
//     //     2,
//     //   );
//     // }

//     return Future.value(true);
//   });
// }














// import 'package:workmanager/workmanager.dart';
// import 'notification_service.dart';

// const String inAttendanceTask = "in_attendance_task";
// const String outAttendanceTask = "out_attendance_task";

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await NotificationService.init();

//     if (task == inAttendanceTask) {
//       await NotificationService.showNotification(
//         "Please give your In Attendance",
//         1,
//       );
//     } else if (task == outAttendanceTask) {
//       await NotificationService.showNotification(
//         "Please give your Out Attendance",
//         2,
//       );
//     }

//     return Future.value(true);
//   });
// }










// // background_task.dart
// import 'package:workmanager/workmanager.dart';
// import 'notification_service.dart';

// // const String inAttendanceTask = "in_attendance_task";
// // const String outAttendanceTask = "out_attendance_task";
// const String inAttendanceTask = "দয়া করে আজকের In Attendance দিন!";
// const String outAttendanceTask = "দয়া করে আজকের Out Attendance দিন!";

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await NotificationService.init();

//     if (task == inAttendanceTask) {
//       await NotificationService.showNotification(
//         "Attendance Reminder",
//         "দয়া করে আজকের In Attendance দিন!",
//         1,
//       );
//     } else if (task == outAttendanceTask) {
//       await NotificationService.showNotification(
//         "Attendance Reminder",
//         "দয়া করে আজকের Out Attendance দিন!",
//         2,
//       );
//     }

//     return Future.value(true);
//   });
// }
