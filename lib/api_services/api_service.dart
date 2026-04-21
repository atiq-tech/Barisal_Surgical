import 'package:barishal_surgical/models/administration_module_models/users_model.dart';
import 'package:barishal_surgical/models/administration_module_models/visits_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_details_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_invoice_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_model.dart';
import 'package:barishal_surgical/models/order_module_models/orders_record_model.dart';
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
  static fetchVisitApi(String? customerId,String? employeeId,String? dateFrom,String? dateTo) async {
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
      return List.from(item).map((e) => VisitsModel.fromMap(e)).toList();
    } catch (e) {
      print(e);
    }
    return null;
  }

  // //==================All Employee List=======================
  // static fetchAllEmployee() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   String link = "${baseUrl}api/v1/getEmployees";
  //   try {
  //     Response response = await Dio().post(link,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var item = jsonDecode(response.data);
  //     return List.from(item).map((e) => EmployeeModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  //==================Product List =======================
  // static fetchAllProduct(String? catId, String? isService) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   List<ProductListModel> allProductList = [];
  //   String link = "${baseUrl}api/v1/getAllProducts";
  //   try {
  //     Response response = await Dio().post(link,
  //         data: {
  //           "catId": "$catId",
  //           "isService": "$isService",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var item = jsonDecode(response.data);
  //     return List.from(item).map((e) => ProductListModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // //==================Customer List=======================
  // static fetchCustomerList(String? customerType,String? employeeId,String? routeId) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   print("Api from employeeId=======${sharedPreferences.getString('employeeId')}");
  //   try {
  //     String url = "${baseUrl}api/v1/getCustomers";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerType": "$customerType",
  //           "employeeId": "${sharedPreferences.getString('employeeId')=="0"||sharedPreferences.getString('employeeId')==0||sharedPreferences.getString('employeeId')=="null"||sharedPreferences.getString('employeeId')==null?"":sharedPreferences.getString('employeeId')}",
  //           "routeId": "$routeId",
  //           "forSearch": "yes",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => CustomerListModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // //==================District List=======================
  // static fetchAllArea() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getDistricts";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => AreaModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // //==================Zone List=======================
  // static fetchAllZone() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getZones";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => ZoneModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // //==================Category List=======================
  // static fetchAllCategory() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getCategories";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => CategoryModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // ///getCurrentStock api
  // //
  // // static Future<List<Stock>?> fetchCurrentStock(BuildContext context,String catId) async {
  // //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // //   print("catId======$catId");
  // //   try {
  // //     String url = "${baseUrl}api/v1/getCurrentStock";
  // //     Response response = await Dio().post(
  // //       data: {
  // //         "catId":catId
  // //       },
  // //       url,
  // //       options: Options(headers: {
  // //         "Content-Type": "application/json",
  // //         'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  // //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  // //       }),
  // //     );
  // //
  // //     if (response.statusCode == 200) {
  // //       var data = jsonDecode(response.data);
  // //       List<Stock> stockList = List.from(data["stock"])
  // //           .map((e) => Stock.fromJson(e))
  // //           .toList();
  // //
  // //       await sharedPreferences.setString('data', jsonEncode(stockList));
  // //       return stockList;
  // //     }
  // //   } catch (e) {
  // //     print("API Errorrrrr: $e");
  // //   }
  // //   return null;
  // // }
  //
  // static Future<List<Stock>?> fetchCurrentStock(BuildContext context, String catId) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   print("catId======$catId");
  //
  //   try {
  //     String url = "${baseUrl}api/v1/getCurrentStock";
  //     Response response = await Dio().post(
  //       url,
  //       data: {
  //         "catId": catId
  //       },
  //       options: Options(headers: {
  //         "Content-Type": "application/json",
  //         'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //       }),
  //     );
  //     print("API Response: ${response.data}");
  //     if (response.statusCode == 200) {
  //       var data = response.data;
  //       if (data is String) {
  //         data = jsonDecode(data);
  //       }
  //
  //       if (data is Map && data.containsKey("stock")) {
  //         List<Stock> stockList = List.from(data["stock"])
  //             .map((e) => Stock.fromJson(e))
  //             .toList();
  //
  //         await sharedPreferences.setString('data', jsonEncode(data["stock"]));
  //         return stockList;
  //       }
  //     }
  //   } catch (e) {
  //     print("API Errorrrrr: $e");
  //   }
  //   return null;
  // }
  //
  //
  // ///getCurrentStock api
  // static fetchAllUser(BuildContext context) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getUsers";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data["data"]).map((e) => AllUserModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // static fetchCustomerDue(String? customerId) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getCustomerDue";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => CustomerDueModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // //==================GetSales List=======================
  // static fetchGetSales(
  //     String? customerId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? employeeId,
  //     String? userId
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getSales";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "employeeId": "$employeeId",
  //           "userId": "$userId"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data["sales"]).map((e) => GetSalesModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // //==================SalesRecord List=======================
  // static fetchSalesRecord(
  //     String? customerId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? employeeId,
  //     String? userId,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getSalesRecord";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "employeeId": "$employeeId",
  //           "userId": "$userId"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => SalesRecordModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // //==================SaleDetails List=======================
  // static fetchSaleDetails(
  //     String? categoryId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? employeeId,
  //     String? productId,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getSaleDetails";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "categoryId": "$categoryId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "employeeId":"$employeeId",
  //           "productId": "$productId",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => SaleDetailsModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  // //==================Get_user_data==================
  // static fetchGetUserData(context) async {
  //   String Link = "${baseUrl}api/v1/get_user_data";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await Dio().get(Link,
  //       data: {
  //         "employeeId": "${sharedPreferences.getString('employee_id')}",
  //       },
  //       options: Options(headers: {
  //         "Content-Type": "application/json",
  //         'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //       }),
  //     );
  //     print('UserDataModel data: ${response.data}');
  //     return UserDataModel.fromMap(jsonDecode(response.data));
  //   } catch (e) {
  //     print("Something is wrong get_user_data=======:$e");
  //   }
  //   return UserDataModel;
  // }
  //
  // ///==================getOrders List=======================
  // static fetchGetOrder(
  //     String? customerId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? status,
  //     String? employeeId,
  //     String? userId,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getOrders";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "process_status": "$status",
  //           //"status": "$status",
  //           "employeeId": "$employeeId",
  //           "userId": "$userId",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data["sales"]).map((e) => GetOrderModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // //==================SalesRecord List=======================
  // static fetchOrderRecord(
  //     String? customerId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? status,
  //     String? employeeId,
  //     String? userId,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getOrderRecords";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "status": "$status",
  //           "employeeId": "$employeeId",
  //           "userId": "$userId"
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data["sales"]).map((e) => OrderRecordModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // ///==================getOrderDetails List=======================
  // static fetchOrderDetails(
  //     String? categoryId,
  //     String? dateFrom,
  //     String? dateTo,
  //     String? status,
  //     String? productId,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getOrderDetails";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "categoryId": "$categoryId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //           "status": "$status",
  //           "productId": "$productId",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data["sales"]).map((e) => OrderDetailsModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // ///==================Invoice=======================
  // static fatchOrdersInvoice(String? salesId) async {
  //   String Link = "${baseUrl}api/v1/getOrders";
  //   OrderInvoiceModel? orderInvoiceModel;
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     var body = {
  //       "salesId": "$salesId",
  //     };
  //     Response response = await Dio().post(Link,
  //         data: body,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     return OrderInvoiceModel.fromMap(jsonDecode(response.data));
  //   } catch (e) {
  //     print("Something is wrong getOrderslist=======:$e");
  //   }
  //   return orderInvoiceModel;
  // }
  //
  // ///==================Invoice=======================
  // static GetSalesInvoice(String? salesId) async {
  //   String Link = "${baseUrl}api/v1/getSales";
  //   SalesInvoiceModel? salesInvoiceModel;
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     var body = {
  //       "salesId": "$salesId",
  //     };
  //     Response response = await Dio().post(Link,
  //         data: body,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     return SalesInvoiceModel.fromMap(jsonDecode(response.data));
  //   } catch (e) {
  //     print("Something is wrong getSaleslist=======:$e");
  //   }
  //   return salesInvoiceModel;
  // }
  //
  // //==================Product List =======================
  // static fetchAllRoute() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   String link = "${baseUrl}api/v1/getCustomerRoutes";
  //   try {
  //     Response response = await Dio().post(link,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var item = jsonDecode(response.data);
  //     return List.from(item).map((e) => RouteModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // ///==================Visits List=======================
  // static fetchVisitsApi(
  //     String? customerId,
  //     String? employeeId,
  //     String? dateFrom,
  //     String? dateTo,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getVisits";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "customerId": "$customerId",
  //           "employeeId": "$employeeId",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => VisitsModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // ///==================Visits List=======================
  // static fetchAttendanceApi(
  //     String? userId,
  //     String? dateFrom,
  //     String? dateTo,
  //     ) async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getAttendanceRecord";
  //     Response response = await Dio().post(url,
  //         data: {
  //           "userId": "$userId",
  //           "employeeId": "${sharedPreferences.getString('employeeId')=="0"||sharedPreferences.getString('employeeId')==0||sharedPreferences.getString('employeeId')=="null"||sharedPreferences.getString('employeeId')==null?"":sharedPreferences.getString('employeeId')}",
  //           "dateFrom": "$dateFrom",
  //           "dateTo": "$dateTo",
  //         },
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => AttendanceModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // ///==================getOutlets List=======================
  // static fetchOutletsApi() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getOutlets";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => OutletsModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
  //
  // //==================Outlets List=======================
  // static fetchOutletsCutomer() async {
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     String url = "${baseUrl}api/v1/getCustomers";
  //     Response response = await Dio().post(url,
  //         options: Options(headers: {
  //           "Content-Type": "application/json",
  //           'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
  //           "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //         }));
  //     var data = jsonDecode(response.data);
  //     return List.from(data).map((e) => OutletsCustomerModel.fromMap(e)).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
}