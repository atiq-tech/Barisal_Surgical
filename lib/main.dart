import 'package:barishal_surgical/providers/administration_module_providers/employee_attendance_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/users_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/visits_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_details_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_invoice_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_provider.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_record_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/invoice_due_provider.dart';
import 'package:barishal_surgical/splash_seccen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:barishal_surgical/notification_service/call_back_discapter.dart';
//import 'package:barishal_surgical/notification_service/notification_service.dart';
import 'package:barishal_surgical/providers/administration_module_providers/areas_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/branches_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/categories_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/products_list_provider.dart';
import 'package:barishal_surgical/providers/administration_module_providers/employees_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/bank_account_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/expire_stock_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_details_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_invoice_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_record_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/total_stock_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:workmanager/workmanager.dart';
import 'hive/hive_adapter.dart';

late final SharedPreferences sharedPreferences;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.init();
  // await requestNotificationPermission();

  // await Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );
  
  // await Workmanager().registerOneOffTask(
  //   DateTime.now().millisecondsSinceEpoch.toString(),
  //   inAttendanceTask,
  //   initialDelay: const Duration(seconds: 5),
  // );

  sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('product');
  await Hive.openBox('profile');
  /// Top
  // await Hive.openBox('todaySales');
  // await Hive.openBox('monthlySales');
  // await Hive.openBox('totalDue');
  // await Hive.openBox('cashBalance');
  runApp(const MyApp());
}

// Future<void> requestNotificationPermission() async {
//   final status = await Permission.notification.status;
//   if (!status.isGranted) {
//     await Permission.notification.request();
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MultiProvider(
        providers: [
         ChangeNotifierProvider<OrdersDetailsProvider>(create: (_) => OrdersDetailsProvider()),
         ChangeNotifierProvider<OrdersRecordProvider>(create: (_) => OrdersRecordProvider()),
         ChangeNotifierProvider<CustomerListProvider>(create: (_) => CustomerListProvider()),
         ChangeNotifierProvider<ProductListProvider>(create: (_) => ProductListProvider()),
         ChangeNotifierProvider<TotalStockProvider>(create: (_) => TotalStockProvider()),
         ChangeNotifierProvider<EmployeesProvider>(create: (_) => EmployeesProvider()),
         ChangeNotifierProvider<BranchesProvider>(create: (_) => BranchesProvider()),
         ChangeNotifierProvider<VisitsProvider>(create: (_) => VisitsProvider()),
         ChangeNotifierProvider<AreasProvider>(create: (_) => AreasProvider()),
         ChangeNotifierProvider<SalesProvider>(create: (_) => SalesProvider()),

         ChangeNotifierProvider<UsersProvider>(create: (_) => UsersProvider()),
         ChangeNotifierProvider<OrdersProvider>(create: (_) => OrdersProvider()),
         ChangeNotifierProvider<InvoiceDueProvider>(create: (_) => InvoiceDueProvider()),
         ChangeNotifierProvider<CategoriesProvider>(create: (_) => CategoriesProvider()),
         ChangeNotifierProvider<SalesRecordProvider>(create: (_) => SalesRecordProvider()),
         ChangeNotifierProvider<ExpireStockProvider>(create: (_) => ExpireStockProvider()),
         ChangeNotifierProvider<BankAccountProvider>(create: (_) => BankAccountProvider()),
         ChangeNotifierProvider<SalesDetailsProvider>(create: (_) => SalesDetailsProvider()),
         ChangeNotifierProvider<SalesInvoiceProvider>(create: (_) => SalesInvoiceProvider()),
         ChangeNotifierProvider<OrdersInvoiceProvider>(create: (_) => OrdersInvoiceProvider()),
         ChangeNotifierProvider<EmployeeAttendanceProvider>(create: (_) => EmployeeAttendanceProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Barishal Surgical',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:const AnimatedSplashScreen(),
        ),
      ),
    );
  }
}

