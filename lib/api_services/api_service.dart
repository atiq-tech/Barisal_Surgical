import 'package:barishal_surgical/models/administration_module_models/employee_attendance_model.dart';
import 'package:barishal_surgical/models/administration_module_models/users_model.dart';
import 'package:barishal_surgical/models/administration_module_models/visits_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_details_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_invoice_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_record_model.dart';
import 'package:barishal_surgical/models/sales_module_models/customer_due_model.dart';
import 'package:barishal_surgical/models/sales_module_models/due_sale_invoice_model.dart';
import 'package:barishal_surgical/models/sales_module_models/emp_wise_cus_pay_due_model.dart';
import 'package:barishal_surgical/models/sales_module_models/invoice_due_model.dart';
import 'package:barishal_surgical/models/sales_module_models/sales_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:barishal_surgical/auth/global_function.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';
import 'package:barishal_surgical/models/sales_module_models/expire_stock_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/global_logout.dart';
import '../models/administration_module_models/areas_model.dart';
import '../models/administration_module_models/branches_model.dart';
import '../models/administration_module_models/categories_model.dart';
import '../models/administration_module_models/customer_list_model.dart';
import '../models/administration_module_models/employees_model.dart';
import '../models/administration_module_models/product_list_model.dart';
import '../models/sales_module_models/sales_invoice_model.dart';
import '../models/sales_module_models/sales_model.dart';
import '../models/sales_module_models/sales_record_model.dart';
import '../models/sales_module_models/total_stock_model.dart';
import '../utils/const_model.dart';

class ApiService{
  ///==================get_bank_accounts List =======================
  static fetchBankAccount(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_bank_accounts";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => BankAccountModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  ///==================Product List =======================
  static fetchProductListApi(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_products";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => ProductListModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  

  ///==================fetchCurrentStockApi =======================
  static fetchTotalStockApi(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_total_stock";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      print("TotalStock===$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => TotalStockModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

///==================get_expire_stock =======================
  static fetchExpireStockApi(BuildContext context,String? productId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_expire_stock";
    try {
      Response response = await Dio().post(link,
        data: {
          "productId": productId
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      print("TotalStock===$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => ExpireStockModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  


  ///==================Categories List=======================new
  static fetchCategoriesListApi(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_categories";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => CategoriesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  ///==================get_branches List=======================new
  static fetchBranchesApi(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_branches";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => BranchesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///==================get_branches List=======================new
  static fetchAreasApi(BuildContext context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_areas";
    try {
      Response response = await Dio().post(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => AreasModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

    ///==================fetchEmployeesApi List=======================new
    static fetchEmployeesApi(BuildContext context) async {
      SharedPreferences? sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();
      String link = "${baseUrl}get_employees";
      try {
        Response response = await Dio().post(link,
            options: Options(headers: {
              "Content-Type": "application/json",
              'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
              "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            }));
        var item = response.data;
        if(item is! List){
          if(item['status'] == 401 && item['success'] == false) {
            ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
            LogoutService.fetchLogout(context);
          }
        }
        return List.from(item).map((e) => EmployeesModel.fromMap(e)).toList();
      } catch (e) {
        print(e);
      }
      return null;
    }
  
    ///==================get_users List=======================new
    static fetchUsersApi(BuildContext context) async {
      SharedPreferences? sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();
      String link = "${baseUrl}get_users";
      try {
        Response response = await Dio().post(link,
            options: Options(headers: {
              "Content-Type": "application/json",
              'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
              "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            }));
        var item = response.data;
        if(item is! List){
          if(item['status'] == 401 && item['success'] == false) {
            ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
            LogoutService.fetchLogout(context);
          }
        }
        return List.from(item).map((e) => UsersModel.fromMap(e)).toList();
      } catch (e) {
        print(e);
      }
      return null;
    }

  ///==================get_customers List======================
  static fetchCustomerListApi(BuildContext context,String? customerType,String? employeeId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_customers";
    try {
      Response response = await Dio().post(link,
          data: {
            "customerType": "$customerType",
            "employeeId": "$employeeId"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      print("Customer=====$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => CustomerListModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

///==================get_Orders List=====================
  static fetchOrders(BuildContext context,String? userId, String? customerId, String? employeeId,
  String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_orders";
    try {
    Response response = await Dio().post(link,
      data: {
          "userId": userId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "isOrder": "true",
          "invoiceNo": ""
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }));
    var item = response.data;
    print("get_orders=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
    return List.from(item["sales"]).map((e) => OrdersModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  ///==================OrdersRecord List======================
  static fetchOrdersRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_orders_record";
    try {
    Response response = await Dio().post(link,
      data: {
          "userId": userId,
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "isOrder": "true",
          "invoiceNo": ""
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }));
    var item = response.data;
    print("get_orders_record=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
    return List.from(item).map((e) => OrdersRecordModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///==================get_Sales List=====================
  static fetchSales(BuildContext context,String? userId, String? customerId, String? employeeId,
  String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_sales";
    try {
    Response response = await Dio().post(link,
        data: {
            "userId": userId,
            "customerId": customerId,
            "employeeId": employeeId,
            "dateFrom": dateFrom,
            "dateTo": dateTo,
            "status": "a",
            "invoiceNo": ""
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    var item = response.data;
    print("get_sales=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
    return List.from(item["sales"]).map((e) => SalesModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

///==================SalesRecord List======================
  static fetchSalesRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_sales_record";
    try {
    Response response = await Dio().post(link,
        data: {
            "userId": userId,
            "customerId": customerId,
            "employeeId": employeeId,
            "dateFrom": dateFrom,
            "dateTo": dateTo,
            "status": "a",
            "invoiceNo": ""
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    var item = response.data;
    print("get_sales_record=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
    return List.from(item).map((e) => SalesRecordModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///==================SalesDetails List======================
  static fetchSalesDetails(BuildContext context,String? categoryId,String? productId,String? employeeId,
    String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_sale_details";
    try {
    Response response = await Dio().post(link,
      data: {
          "categoryId": categoryId,
          "productId": productId,
          "employeeId": employeeId,
          "isCourier": "0",
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": "a"
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }));
    var item = response.data;
    print("get_sale_details=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
   return List.from(item).map((e) => SalesDetailsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
  
  ///==================get_order_details List======================
  static fetchOrdersDetails(BuildContext context,String? categoryId,String? productId,
    String? dateFrom, String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_order_details";
    try {
    Response response = await Dio().post(link,
      data: {
          "categoryId": categoryId,
          "productId": productId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "isOrder": "true"
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }));
    var item = response.data;
    print("get_order_details=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
   return List.from(item).map((e) => OrdersDetailsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///==================Invoice=======================
  static fetchSalesInvoice(String? salesId) async {
    String Link = "${baseUrl}get_sales";
    SalesInvoiceModel? salesInvoiceModel;
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var body = {
        "salesId": "$salesId",
      };
      Response response = await Dio().post(Link,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      return SalesInvoiceModel.fromMap(response.data);
      //return SalesInvoiceModel.fromMap(jsonDecode(response.data));
    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return salesInvoiceModel;
  }
  
  ///==================get_orders=======================
  static fetchOrdersInvoice(String? salesId) async {
    String Link = "${baseUrl}get_orders";
    OrdersInvoiceModel? ordersInvoiceModel;
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var body = {
        "salesId": "$salesId",
      };
      Response response = await Dio().post(Link,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      return OrdersInvoiceModel.fromMap(response.data);
    } catch (e) {
      print("Something is wrong getSaleslist=======:$e");
    }
    return ordersInvoiceModel;
  }


  ///==================get_invoice_due List======================
  static fetchInvoiceDue(BuildContext context,String? customerId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_invoice_due";
    print("customerId----get_invoice_due: $customerId");
    try {
    Response response = await Dio().post(link,
      data: {
         "customerId": "$customerId",
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }));
    var item = response.data;
    print("get_invoice_due=====$item");
    if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
   return List.from(item).map((e) => InvoiceDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================get_visits List =======================
  static fetchVisitApi(BuildContext context,String? customerId,String? employeeId,String? dateFrom,String? dateTo) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_visits";
    try {
      Response response = await Dio().post(link,
       data: {
          "customerId": customerId,
          "employeeId": employeeId,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
         },
         
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      print("get_visits=====$item");
     if(item is! List){
      if(item['status'] == 401 && item['success'] == false) {
        ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
        LogoutService.fetchLogout(context);
      }
    }
      return List.from(item).map((e) => VisitsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //==================get_visits List =======================
  static Future<List<EmployeeAttendanceModel>> fetchEmployeeAttendance(
  BuildContext context,
  String? employeeId,
  String? dateFrom,
  String? dateTo,
) async {

  String link = "${hrUrl}get_employee_attendance";

  try {
    Response response = await Dio().post(
      link,
      data: {
        "employee_id": employeeId,
        "from_date": dateFrom,
        "to_date": dateTo,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $apiSecretKey",
          "Content-Type": "application/json", // ✅ FIX (406 issue solve)
        },
      ),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data;

      /// 🔥 safe list extract
      List list = data["attendance"] ?? [];

      return list
          .map((e) => EmployeeAttendanceModel.fromMap(e))
          .toList();
    } else {
      return [];
    }

  } on DioException catch (e) {
    print("Dio Error Status: ${e.response?.statusCode}");
    print("Dio Error Data: ${e.response?.data}");
  } catch (e) {
    print("Error: $e");
  }

  /// ❌ never return null
  return [];
}

//==================get_customer_due =======================
  static fetchCustomerDueApi(BuildContext context,String? customerId,String? districtId,String? salesId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_customer_due";
    try {
      Response response = await Dio().post(link,
        data: {
          "customerId": customerId,
          "districtId": districtId,
          "salesId": salesId
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      print("CustomerDue===$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => CustomerDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

//==================get_due_sale_invoice =======================
  static fetchDueSaleInvoiceApi(BuildContext context,String? customerId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_due_sale_invoice";
    try {
      Response response = await Dio().post(link,
        data: {
          "customerId": customerId,
          "isEdit": "yes"
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      print("DueSaleInvoice===$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item).map((e) => DueSaleInvoiceModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

//==================get_emp_wise_cus_pay_due=======================
  static fetchEmpWiseCusPayDueApi(BuildContext context, 
    String? customerId,
    String? employeeId,
    String? searchType,
    String? paymentType,
    String? dateFrom,
    String? dateTo
    ) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String link = "${baseUrl}get_emp_wise_cus_pay_due";
    try {
      Response response = await Dio().post(link,
        data: {
          "customerId": customerId,
          "employeeId": employeeId,
          "searchType": searchType,
          "paymentType": paymentType,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
      var item = response.data;
      print("EmpWiseCusPayDue===$item");
      if(item is! List){
        if(item['status'] == 401 && item['success'] == false) {
          ErrorSnackbarHelper.showSnackbar("🎁 Session Expired! Please Log in Again!");
          LogoutService.fetchLogout(context);
        }
      }
      return List.from(item["payments"]).map((e) => EmpWiseCusPayDueModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }
}