import 'dart:convert';
import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/administration_module_models/employees_model.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/employees_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/bank_account_provider.dart';
import 'package:barishal_surgical/screens/modules/order_module_screens/order_invoice_screen.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:barishal_surgical/common_widget/custom_btmnbar/custom_navbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/administration_module_models/customer_list_model.dart';
import '../../../models/administration_module_models/product_list_model.dart';
import '../../../models/sales_module_models/sales_add_to_cart_model.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/const_model.dart';
import '../../../utils/utils.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({super.key});
  @override
  State<OrderEntryScreen> createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  Color getColor(Set<MaterialState> states) {
    return Color.fromARGB(255, 249, 182, 255);
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  String userName = "";
  String? userEmployeeID = "";
  String? userEmployeeName = "";
  String? userType = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    userEmployeeID = "${sharedPreferences?.getString('employeeId')}";
    userEmployeeName = "${sharedPreferences?.getString('employeeName')}";
    userType = "${sharedPreferences?.getString('userType')}";
    print("userName======$userName");
  }

  final  _nameController = TextEditingController();
  final  _paidController = TextEditingController();
  final  _bankPaidController = TextEditingController();
  final  bankAccountController = TextEditingController();
  final  accountController = TextEditingController();
  final  _discountPercentController = TextEditingController();
  final  _mobileNumberController = TextEditingController();
  final  _addressController = TextEditingController();
  final  _salesRateController = TextEditingController();
  final  _DiscountController = TextEditingController();
  final  _VatController = TextEditingController();
  final  _lotNoController = TextEditingController();
  final  _vatPercentageController = TextEditingController();
  final  _quantityController = TextEditingController();
  final  _transportController = TextEditingController();
  var customerController = TextEditingController();
  var empluyeeNameController = TextEditingController();
  var categoryController = TextEditingController();
  var productController = TextEditingController();
  var invoiceController = TextEditingController();
  final  _discountController = TextEditingController();
  final  _commentController = TextEditingController();

  var customerSlNo;
  String?  customerType = 'G';
  var  creditLimit = '0';

  String? Salling_Rate = "0.0";
  String? customerMobile;
  String? customerAddress;
  String? categoryId;
  String? _selectedCustomer;
  String? _selectedProduct;
  String? employeeSlNo;
  String? _selectedBankId;
  String? employeeName;
  String? previousDue;
  String level = "wholesale";
  var availableStock = 0;
  int quantity = 0;
  String? productUnit;
  String? isService;
  ///new calculate
  double CartTotal = 0;
  double TotalDiscountAmount = 0;
  double afterVatTotal = 0;
  double Amount = 0;
  double Transport = 0;
  double discountVatTotal = 0;
  double TotalAmount = 0;
  ///
  ///new calculate
  double subtotal = 0;
  double vatTotall = 0;
  double discountPer = 0;
  double discountAmount = 0;
  double afterDisTotal = 0;
  double vatPer = 0;
  double vatAmount = 0;
  double transportCost = 0;
  double total = 0;
  double cashPaid = 0;
  double bankPaid = 0;
  double Paid = 0;
  double due = 0;
  ///
  List<SalesAddToCartModel> salesCartList = [];

  String? cproductId;
  String? cproductCode;
  String? ccategoryName;
  String? cname;
  String? cTempRate;
  String? csalesRate;
  String? cTempvat;
  String? cvat;
  String? cquantity;
  String? ctotal;
  String? cpurchaseRate;

  double h1TextSize = 16.0;
  double h2TextSize = 11.0;
  double Total = 0.0;
  ///
  int newQty = 0;
  double newTotal = 0;

  bool isVisible = false;
  bool isEnabled = false;
  bool isVisibleBankName = false;
  bool isAdded = false;

  late final Box box;
  bool isSellBtnClk = false;
  void _clearInputFields() {
    productController.text = '';
    _lotNoController.text = '';
    _salesRateController.text = '';
    _quantityController.text = '';
    isAdded = true;
    Total = 0;
    newQty = 0;
    newTotal = 0;
    availableStock = 0;

    _bankPaidController.text="";
    _paidController.text = "";
    _discountPercentController.text = "";
    _DiscountController.text = "";
    _vatPercentageController.text="";
    _VatController.text = "";
    _transportController.text = "";
    bankAccountController.text = "";
    discountPer = 0;
    transportCost=0;
    discountAmount = 0;
    previousDue = "0";
    vatPer = 0;
    vatAmount = 0;
    cashPaid = 0;
    bankPaid = 0;
    due = 0;
    calculateTotal();
 }

  void removeFromCart(index) {
    salesCartList.removeAt(index);
    calculateTotal();
    emtyMethod();
  }
  emtyMethod() {
    setState(() {
      due = 0;
      total = 0;
      CartTotal = 0;
      TotalDiscountAmount = 0;
      TotalAmount = 0;
      Paid = 0;
      _paidController.text = "";
      accountController.text = "";
      _bankPaidController.text = "";
      _transportController.text = "";
      _paidController.text = "";
      _discountController.text = "";
      _DiscountController.text = "";
      _discountPercentController.text = "";
      _VatController.text = "";
      _vatPercentageController.text = "";
    });
  }

  void calculateTotal() {
  final allGetSalesData = salesCartList;
  double cartTotall = allGetSalesData.map((e) => e.total).fold(0.0, (p, element) => p + double.parse(element!));
  subtotal = double.parse("$cartTotall");
  afterDisTotal = subtotal - discountAmount;
  vatTotall = 0;
  vatAmount = 0;
  if (_vatPercentageController.text.isNotEmpty) {
    double vatPer = double.parse(_vatPercentageController.text);
    vatAmount = (afterDisTotal * vatPer) / 100;
    vatTotall = vatAmount;
  } else if (_VatController.text.isNotEmpty) {
    vatAmount = double.parse(_VatController.text);
    vatTotall = vatAmount;
  } else {
    vatTotall = allGetSalesData.map((e) => e.vat).fold(0.0, (p, element) => p + double.parse(element!));
  }
  total = afterDisTotal + vatTotall + transportCost;
  if (isAdded) {
    cashPaid = double.parse("$total") - double.parse("$bankPaid");
    _paidController.text = "$cashPaid";
  }

  Paid = (cashPaid + bankPaid);
  due = total - Paid;

  setState(() {
  });
   print("SubTotal===$subtotal");
    print("Total===$total");
    print("afterDisTotal===$afterDisTotal");
    print("Paid===$Paid");
    print("due===$due");
    print("cashPaid===$cashPaid");
}

  String myAddress = "Loading...";
    double? myLat, myLong;
    Future<void> _initLocation() async {
    var result = await LocationService.fetchAndUploadLocation();
    if (result != null) {
      setState(() {
        myLat = result['lat'];
        myLong = result['long'];
        myAddress = result['address'];
      });
    }
  }

  @override
  void initState() {
    _initLocation();
    _initializeData();
    super.initState();
    getSalesInvoice();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
     Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    ProductListProvider.isProductsListLoading = true;
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
    CustomerListProvider.isCustomerListloading = true;
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
    Provider.of<BankAccountProvider>(context, listen: false).getBankAccount(context);
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    await Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerList = Provider.of<CustomerListProvider>(context, listen: false).customerList;

      if (customerList.isNotEmpty) {
        setState(() {
          _selectedCustomer = customerList.first.customerSlNo.toString();
          customerController.text = "${customerList.first.customerName} ${customerList.first.customerCode != "" ? " - ${customerList.first.customerCode}" : ""} ${customerList.first.customerMobile != "" ? " - ${customerList.first.customerMobile}" : ""}";
          _mobileNumberController.text = customerList.first.customerMobile ?? '';
          _addressController.text = customerList.first.customerAddress ?? '';
          customerSlNo = customerList.first.customerSlNo.toString();
          customerType = customerList.first.customerType ?? 'G';
          creditLimit = customerList.first.customerCreditLimit?.toString() ?? '';
          _nameController.text = customerList.first.customerName??"";

          if (_selectedCustomer == "0") {
            isVisible = true;
            isEnabled = true;
            _nameController.text = customerList.first.customerName??"";
          } else {
            isVisible = false;
            isEnabled = false;
          }
        });
      }
    });
    print("customertttype=====$customerType");
  }

   Response? response;
  void totalStack(String? cproductId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    response = await Dio().post("${baseUrl}get_product_stock",
      data: {"productId": "$cproductId"},
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }),
    );
    setState(() {
      availableStock = response!.data;
    });
    print("availableStock====$availableStock");
    print("cproductId====$cproductId");

  }


  Response? result;
  void previousDueAmount(String? customerId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    result = await Dio().post("${baseUrl}get_customer_due",
        data: {"customerId": "$customerId"},
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    var data = result?.data;
    if (data != null) {
      setState(() {
        previousDue = "${data[0]['dueAmount']}";
      });
    }
  }

  ///invoiceNo
  String? invoiceNo;
  getSalesInvoice() async {
    String link = "${baseUrl}api/v1/getSaleInvoice";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(
        link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      setState(() {
        invoiceController.text = jsonDecode(response.data);
      });
      print("invoiceNo Code===========> ${invoiceController.text}");
    } catch (e) {
      print(e);
    }
  }
  double totalAmount = 0;
  @override
  Widget build(BuildContext context) {
    final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    final allCustomerList = Provider.of<CustomerListProvider>(context).customerList;
    final allBankAccountList = Provider.of<BankAccountProvider>(context).bankAccountList;
    final allProductList = Provider.of<ProductListProvider>(context).productsList;
    totalAmount = salesCartList.map((e) => e.total).fold(0.0, (p, element) => p+double.parse(element!));
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appColor,
        title: const Text("Order Entry",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationBarView()),
            );
          },
        ),
       ),
        body:ModalProgressHUD(
          blur: 2,
          inAsyncCall: CustomerListProvider.isCustomerListloading,
          progressIndicator: Utils.showSpinKitLoad(),
          child:
          Container(
            padding: EdgeInsets.all(8.0.r),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 4.h, left: 4.0.w, right: 4.0.w, bottom: 10.h),
                    padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,top: 4.0.h),
                    decoration: BoxDecoration(
                      color: AppColors.appCard,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 3,child: Text("Date to", style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(
                              flex: 9,
                              child: userType == "a" || userType == "m" ? GestureDetector(
                                onTap: (() {
                                  _selectedDate();
                                  //FocusScope.of(context).requestFocus(quantityFocusNode);
                                }),
                                child: Container(
                                  height: 25.0.h,
                                  decoration: ContDecoration.contDecoration,
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 5),
                                        suffixIcon: const Padding(padding: EdgeInsets.only(left: 20),
                                          child: Icon(Icons.calendar_month, color: Colors.black87, size: 16)),
                                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                                        hintText: firstPickedDate, hintStyle:AllTextStyle.dropDownlistStyle
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ):GestureDetector(
                                onTap: (() {
                                }),
                                child: Container(
                                  height: 25.0.h,
                                  margin: EdgeInsets.only(bottom: 4.h),
                                  decoration: ContDecoration.contDecoration,
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 5),
                                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                                        hintText: firstPickedDate, hintStyle:AllTextStyle.dropDownlistStyle
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3,child: Text("Sales By", style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                            Expanded(
                              flex: 9,
                              child: userType == "a" || userType == "m" ? Container(
                                height: 25.0.h,
                                margin: EdgeInsets.only(bottom: 4.h,top: 4.h),
                                child: TypeAheadField<EmployeesModel>(
                                  controller: empluyeeNameController,
                                  builder: (context, controller, focusNode) {
                                    return TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                        isDense: true,
                                        hintText: 'Select Employee',
                                        hintStyle: TextStyle(fontSize: 13.sp),
                                        suffixIcon: employeeSlNo == '' || employeeSlNo == 'null' || employeeSlNo == null || controller.text == '' ? null
                                            : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              empluyeeNameController.clear();
                                              controller.clear();
                                              employeeSlNo = null;
                                            });
                                          },
                                          child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                        ),
                                        suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (pattern) async {
                                    return Future.delayed(const Duration(seconds: 1), () {
                                      return allGetEmployeesData.where((element) =>
                                          element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                    });
                                  },
                                  itemBuilder: (context, EmployeesModel suggestion) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                      child: Text(suggestion.displayName!,
                                        style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                  onSelected: (EmployeesModel suggestion) {
                                    setState(() {
                                      empluyeeNameController.text = suggestion.displayName!;
                                      employeeSlNo = suggestion.employeeSlNo.toString();
                                    });
                                  },
                                ),
                              ) : Container(
                                height: 25.h,
                                margin: EdgeInsets.only(bottom: 4.h),
                                decoration:ContDecoration.contDecoration,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                  child: Text("$userEmployeeName",style: AllTextStyle.dateFormatStyle),
                                )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ///my practice
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 4.h, left: 4.0.w, right: 4.0.w, bottom: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.appCard,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: Color.fromARGB(255, 7, 125, 180), width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0.w),topRight: Radius.circular(6.0.w)),
                              color: AppColors.appColor),
                              child: Center(child: Text('📦 Customer Information', style: AllTextStyle.tableHeadTextStyle),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.0.w),
                          child: Column(
                            children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 3,child: Text("Sales Type", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Radio(
                                                fillColor: MaterialStateColor.resolveWith((states) => AppColors.appColor),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                value: "retail",
                                                groupValue: level,
                                                onChanged: (value) {
                                                  setState(() {
                                                    level = value.toString();
                                                    CustomerListProvider().on();
                                                    customerController.text = '';
                                                    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
                                                  });
                                                }),
                                          ),
                                          Text("Retail", style: AllTextStyle.textFieldHeadStyle),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      Row(
                                        children: [
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Radio(
                                                fillColor: MaterialStateColor.resolveWith((states) => AppColors.appColor),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                value: "wholesale",
                                                groupValue: level,
                                                onChanged: (value) {
                                                  setState(() {
                                                    level = value.toString();
                                                    CustomerListProvider().on();
                                                    customerController.text = '';
                                                    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
                                                  });
                                                }),
                                          ),
                                          Text("Wholesale", style: AllTextStyle.textFieldHeadStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ), // radio button
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Customer", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 4.h,right: 4.w),
                                    height: 25.h,
                                    decoration: ContDecoration.contDecoration,
                                    child: TypeAheadField<CustomerListModel>(
                                      controller: customerController,
                                      builder: (context, controller, focusNode) {
                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                          decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                            isDense: true,
                                            hintText: 'Select Customer',
                                            hintStyle: TextStyle(fontSize: 13.sp),
                                            suffixIcon: _selectedCustomer == '' || _selectedCustomer == 'null' || _selectedCustomer == null || controller.text == '' ? null
                                                : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  customerController.clear();
                                                  controller.clear();
                                                  _selectedCustomer = null;
                                                  customerController.text="";
                                                  _selectedCustomer = "";
                                                  _nameController.text = '';
                                                  _mobileNumberController.text = '';
                                                  _addressController.text = '';
                                                });
                                              },
                                              child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                            ),
                                            suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                          ),
                                        );
                                      },
                                      suggestionsCallback: (pattern) async {
                                        return Future.delayed(const Duration(seconds: 1), () {
                                          return allCustomerList.where((element) =>
                                              element.customerName.toLowerCase().contains(pattern.toLowerCase())).toList();
                                        });
                                      },
                                      itemBuilder: (context, CustomerListModel suggestion) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                          child: Text(suggestion.displayName??"",
                                            style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      },
                                      onSelected: (CustomerListModel suggestion) {
                                        customerController.text = suggestion.displayName;
                                         setState(() {
                                          _selectedCustomer = suggestion.customerSlNo.toString();
                                          customerSlNo = suggestion.customerSlNo.toString();
                                          customerType = suggestion.customerType.toString();
                                          if (_selectedCustomer == "0") {
                                            isVisible = true;
                                            isEnabled = true;
                                            _nameController.text = '';
                                            _mobileNumberController.text = '';
                                            _addressController.text = '';
                                          } else {
                                            isEnabled = false;
                                            isVisible = false;
                                            _nameController.text = suggestion.customerName.toString();
                                            _mobileNumberController.text = suggestion.customerMobile.toString();
                                            _addressController.text = suggestion.customerAddress.toString();
                                            creditLimit = suggestion.customerCreditLimit.toString();
                                          }
                                          if (customerType == "G") {
                                            _nameController.text = allCustomerList.first.customerName ?? '';
                                          }
                                        });
                                        previousDueAmount(_selectedCustomer);
                                        print("customerType========$customerType");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ), // drop down
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Name", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(right: 4.w, bottom: 4.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _nameController,
                                      enabled: isEnabled,
                                      validator: (value) {
                                        if (value != null || value != '') {
                                          _nameController.text = value.toString();
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(bottom: isEnabled==false? 10.5.h:8.5.h, left: 5.w),
                                        hintText: "Customer Name",
                                        hintStyle: AllTextStyle.textValueStyle,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Mobile  No", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 25.0.w,
                                    margin: EdgeInsets.only(bottom: 4.h,right: 4.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      style: AllTextStyle.textValueStyle,
                                      enabled: isEnabled,
                                      controller: _mobileNumberController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value != null || value != '') {
                                          _mobileNumberController.text = value.toString();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Mobile No",
                                          hintStyle: AllTextStyle.dropDownlistStyle,
                                          contentPadding: EdgeInsets.only(bottom: 9.h, left: 5.w),
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Address", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 30.h,
                                    margin: EdgeInsets.only(bottom: 5.h,right: 5.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      style: AllTextStyle.textValueStyle,
                                      maxLines: 2,
                                      controller: _addressController,
                                      validator: (value) {
                                        if (value != null || value != '') {
                                          _addressController.text =
                                              value.toString();
                                        }
                                        return null;
                                      },
                                      enabled: isEnabled,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.w),
                                        hintText: "Address",
                                        hintStyle: AllTextStyle.dropDownlistStyle,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Comment", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 35.h,
                                    margin: EdgeInsets.only(bottom: 5.h,right: 5.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0.r),
                                      color: Colors.grey[50],
                                    ),
                                    child: TextFormField(
                                      style: AllTextStyle.textValueStyle,
                                      maxLines: 2,
                                      controller: _commentController,
                                      validator: (value) {
                                        if (value != null || value != '') {
                                          _commentController.text = value.toString();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.w),
                                       hintText: 'Attention Comment',
                                       hintStyle: AllTextStyle.textValueStyle,
                                       border: InputBorder.none,
                                       focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                       enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8.h, left: 4.0.w, right: 4.0.w, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.appCard,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0.r),topRight: Radius.circular(6.0.r)),
                                  color: AppColors.appColor),
                              child: Center(child: Text('🥡 Product Information', style: AllTextStyle.tableHeadTextStyle)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0.h, left: 4.0.w, right: 4.0.w, bottom: 2.0.h),
                          child: Column(
                            children: [
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Product", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                      height: 25.h,
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      decoration: ContDecoration.contDecoration,
                                    child: TypeAheadField<ProductListModel>(
                                      controller: productController,
                                      builder: (context, controller, focusNode) {
                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                            isDense: true,
                                            hintText: 'Select Product',
                                            hintStyle: TextStyle(fontSize: 13.sp),
                                            suffixIcon: _selectedProduct == null || controller.text.isEmpty ? null
                                                : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  productController.clear();
                                                  controller.clear();
                                                  _selectedProduct = null;
                                                  _salesRateController.text = '';
                                                  _quantityController.text = '';
                                                });
                                              },
                                              child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                            enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                          ),
                                        );
                                      },
                                      suggestionsCallback: (pattern) async {
                                        return Future.delayed(const Duration(seconds: 1), () {
                                          return allProductList.where((element) =>
                                              element.displayText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                        });
                                      },
                                      itemBuilder: (context, ProductListModel suggestion) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                          child: Text(suggestion.displayText!,
                                            style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      },
                                      onSelected: (ProductListModel suggestion) {
                                            productController.text = suggestion.productName;
                                            setState(() {
                                              _selectedProduct = suggestion.productSlNo.toString();
                                              cproductId = suggestion.productSlNo.toString();
                                              cproductCode = suggestion.productCode.toString();
                                              ccategoryName = suggestion.productCategoryName;
                                              cname = suggestion.productName;
                                              cTempvat = suggestion.temporaryVat;
                                              cvat = suggestion.vat;
                                              productUnit = suggestion.unitName;
                                              isService = suggestion.isService;
                                              cpurchaseRate = suggestion.productPurchaseRate;
                                              _VatController.text = suggestion.vat;
                                              cTempRate = suggestion.temporaryRate;
                                              _salesRateController.text = suggestion.productSellingPrice;
                                              Total = _quantityController.text == "" ? double.parse(_salesRateController.text) : (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                              totalStack(cproductId);
                                              _lotNoController.text = suggestion.productLotNo ?? '';
                                              mfgPickedDate = suggestion.productManufactureDate != null ? Utils.formatFrontEndDate(DateTime.parse(suggestion.productManufactureDate!)) : null;
                                              expPickedDate = suggestion.productExpireDate != null ? Utils.formatFrontEndDate(DateTime.parse(suggestion.productExpireDate!)) : null;
                                            });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ), 
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Sale Rate", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: 25.0.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _salesRateController,
                                      onChanged: (value) {
                                        setState(() {
                                          Total = _salesRateController.text == "null" ? 0 : (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                          hintText: "0",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Center(child: Text("Qty",style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(left: 5.w),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _quantityController,
                                      onChanged: (value) {
                                        setState(() {
                                          Total = (double.parse(_quantityController.text) * double.parse(_salesRateController.text));
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                          hintText: "0",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), // quantity
                            SizedBox(height: 2.w),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Amount", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 8.w, right: 5.w, top: 5.h),
                                    decoration:ContDecoration.contDecoration,
                                    child: Text("$Total", style: AllTextStyle.textValueStyle),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0.r),
                                    ),
                                    child: SizedBox(
                                      height: 25.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           availableStock != 0 ? Text("Stock,", style: TextStyle(color: Colors.green.shade700,fontSize: 11.sp,fontWeight: FontWeight.bold)): Text("Stock,", style: TextStyle(color: Colors.red,fontSize: 11.sp,fontWeight: FontWeight.bold)),
                                          Text("$availableStock ${productUnit ?? ""}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 11.sp,color:availableStock != 0 ? Colors.green.shade700 : Colors.red,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                            children: [
                              Expanded(flex: 3,child: Text("Lot No.",style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(
                                flex: 9,
                                child: Container(
                                  height: 25.h,
                                  margin: EdgeInsets.only(bottom: 4.h,top: 2.h),
                                  child: TextField(
                                    style: AllTextStyle.textFieldHeadStyle,
                                    controller: _lotNoController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                      hintText: "Lot No.",
                                      hintStyle: AllTextStyle.dropDownlistStyle,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                      enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 3,child: Text("Mfg.Date", style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(
                                flex: 9,
                                child: GestureDetector(
                                  onTap: () {
                                    _mfgDate();
                                  },
                                  child: Container(
                                    height: 25.0.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 3.h, bottom: 5.h, left: 5.w, right: 5.w),
                                    decoration:ContDecoration.contDecoration,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(mfgPickedDate ?? "mm/dd/yyyy",style: AllTextStyle.dateFormatStyle),
                                        Icon(Icons.calendar_month, size: 18.r)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 3,child: Text("Exp.Date", style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                              Expanded(
                                flex: 9,
                                child: GestureDetector(
                                  onTap: () {
                                    _expDate();
                                  },
                                  child: Container(
                                    height: 25.0.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 3.h, bottom: 5.h, left: 5.w, right: 5.w),
                                    decoration:ContDecoration.contDecoration,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(expPickedDate ?? "mm/dd/yyyy",style:AllTextStyle.dateFormatStyle),
                                        Icon(Icons.calendar_month, size: 18.r)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                           ),
                          ]),
                        ),
                        
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              quantity = int.parse(_quantityController.text);
                              if (productController.text != '' || productController.text.isNotEmpty) {
                                // if (availableStock >= quantity) {
                                if (_quantityController.text == "") {
                                  Utils.errorSnackBar(context, "Please Select Quantity");
                                }
                                else {
                                  setState(() {
                                    int findIndex = salesCartList.indexWhere((item) => item.productId == "$cproductId");
                                    if (findIndex > -1) {
                                      newQty = int.parse("${salesCartList[findIndex].quantity}") + int.parse(_quantityController.text);
                                      newTotal = double.parse("${salesCartList[findIndex].salesRate}") * newQty;
                                    }
                                    salesCartList.add(SalesAddToCartModel(
                                      productId: cproductId,
                                      code: cproductCode,
                                      name: cname,
                                      categoryId: categoryId,
                                      categoryName: ccategoryName,
                                      lotNo: _lotNoController.text,
                                      purchaseRate: cpurchaseRate,
                                      temporaryRate: cTempRate,
                                      salesRate: _salesRateController.text,
                                      quantity: findIndex > -1 ? "$newQty" : _quantityController.text,
                                      total: findIndex > -1 ? "$newTotal" : "$Total",
                                      temporaryVat: "${double.parse(findIndex > -1 ? "$newTotal" : "$Total") * double.parse("$cTempvat") / 100}",
                                      vat: "${double.parse(findIndex > -1 ? "$newTotal" : "$Total") * double.parse("$cvat") / 100}",
                                      note:"",
                                      isService: isService,
                                      unitName: productUnit,
                                      discount: '',
                                      discountAmount: '',
                                      mfgDate: mfgPickedDate,
                                      expDate: expPickedDate
                                    ));

                                    CartTotal += Total;
                                    _VatController.text = "0";
                                    afterVatTotal = CartTotal;
                                    discountVatTotal = afterVatTotal;
                                    Paid = discountVatTotal;
                                    categoryController.text = '';
                                    productController.text = '';
                                    _salesRateController.text = '';
                                    _lotNoController.text = '';
                                    setState(() {
                                      Amount = 0;
                                      Total = 0;
                                    });
                                     calculateTotal();
                                  });
                                }
                                // } else {
                                //   Utils.errorSnackBar(context, "Stock Unavailable");
                                // }
                              } else {
                                Utils.errorSnackBar(context, "Please Select Product");
                              }
                            },
                            child: Card(
                                elevation: 5.0,
                                child: Container(
                                    height: 28.0.h,
                                    width: 100.0.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.appColor,
                                      borderRadius: BorderRadius.circular(5.0.r),
                                    ),
                                    child: Center(child: Text("Add to Cart", style: AllTextStyle.saveButtonTextStyle)))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0.h),
                  Container(
                    height: salesCartList.isEmpty ? 40.h : salesCartList.length == 1 ? 55.h : 35.h + (salesCartList.length * 20.0.h),
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5.0.h,bottom: 5.0.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                headingRowHeight: 20.0,
                                dataRowHeight: 20.0,
                                headingRowColor: MaterialStateColor.resolveWith((states) =>AppColors.appColor),
                                showCheckboxColumn: true,
                                border: TableBorder.all(color: Colors.blueGrey, width: 1.w),
                                columns: [
                                  DataColumn(label: Expanded(child: Center(child: Text('SL.', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Code', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Product/Service Name', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Category', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Quantity', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Rate', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Total Amount', style: AllTextStyle.tableHeadTextStyle)))),
                                  DataColumn(label: Expanded(child: Center(child: Text('Action', style: AllTextStyle.tableHeadTextStyle)))),
                                ],
                                rows: List.generate(
                                  salesCartList.length,
                                      (int index) => DataRow(
                                    color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                                    cells: <DataCell>[
                                      DataCell(Center(child: Text("${index+1}"))),
                                      DataCell(Center(child: Text('${salesCartList[index].code}'))),
                                      DataCell(Center(child: Text('${salesCartList[index].name}'))),
                                      DataCell(Center(child: Text('${salesCartList[index].categoryName}'))),
                                      DataCell(Center(child: Text('${salesCartList[index].quantity}'))),
                                      DataCell(Center(child: Text('${salesCartList[index].salesRate}'))),
                                      DataCell(Center(child: Text('${salesCartList[index].total}'))),
                                      DataCell(Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              removeFromCart(index);
                                              setState(() {
                                              });
                                            },
                                            child: Icon(Icons.delete,size: 16.r,color: Colors.red)
                                        ),
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                              // Text("Total : $totalAmount",style: AllTextStyle.subTotalTextStyle)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 10.h),
                 Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 4, left: 4.0, right: 4.0, bottom: 5),
                    decoration: BoxDecoration(
                      color: AppColors.appCard,
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                          color: const Color.fromARGB(255, 7, 125, 180),
                          width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                          width: double.infinity,
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0)),
                              color: AppColors.appColor),
                              child: const Center(
                                child: Text(
                                  '💸 Amount Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 3,child: Text("Sub Total", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                flex: 9,
                                child: Container(
                                  margin: EdgeInsets.only(top: 4.h),
                                  height: 25.h,
                                  padding: EdgeInsets.only(left: 6.w, right: 5.w, top: 5.h, bottom: 5.h),
                                  decoration:ContDecoration.contDecoration,
                                  child: Text(double.parse("$subtotal").toStringAsFixed(0), style: AllTextStyle.textValueStyle,
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 3,child: Text("Discount", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(right: 5.w),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _discountPercentController,
                                      onChanged: (value) {
                                        _transportController.text = '';
                                        _paidController.text = '';
                                        _bankPaidController.text = '';
                                        ///discount per
                                        setState(() {
                                          if (value.trim().isEmpty) {
                                          discountPer = 0;
                                          } else {
                                            discountPer = double.tryParse(value) ?? 0;
                                          }
                                          discountAmount = (subtotal * discountPer) / 100;
                                          _DiscountController.text = double.parse("$discountAmount").toStringAsFixed(0);
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 3.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                                ///dis Amount
                                Expanded(flex: 1,child: Center(child: Text("%", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _DiscountController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _transportController.text = '';
                                        _paidController.text = '';
                                        _bankPaidController.text = '';
                                        setState(() {
                                          if (value.trim().isEmpty) {
                                            discountAmount = 0;
                                          } else {
                                            discountAmount = double.tryParse(value) ?? 0;
                                          }
                                          discountPer = (discountAmount * 100) / subtotal;
                                          _discountPercentController.text = double.parse("$discountPer").toStringAsFixed(0);
                                          calculateTotal();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 4.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Vat", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(right: 4.w,top: 3.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _vatPercentageController,
                                      onChanged: (value) {
                                        _transportController.text = '';
                                        _paidController.text = '';
                                        _bankPaidController.text = '';

                                        setState(() {
                                          double totalAmount = subtotal - discountAmount;
                                          // Reset previous vat before calculation
                                          vatAmount = 0;
                                          vatTotall = 0;

                                          if (value.isNotEmpty) {
                                            vatPer = double.tryParse(value) ?? 0.0;
                                            vatAmount = (totalAmount * vatPer) / 100;
                                            vatTotall = vatAmount;
                                            _VatController.text = vatAmount.toStringAsFixed(0);
                                          } else {
                                            vatPer = 0;
                                            _VatController.clear();
                                          }
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1,child: Center(child: Text("%", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(top: 3.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _VatController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _transportController.text = '';
                                        _paidController.text = '';
                                        _bankPaidController.text = '';

                                        setState(() {
                                          double totalAmount = subtotal - discountAmount;
                                          // Reset previous vat before calculation
                                          vatAmount = 0;
                                          vatTotall = 0;

                                          if (value.isNotEmpty) {
                                            vatAmount = double.tryParse(value) ?? 0.0;
                                            vatPer = (vatAmount * 100) / totalAmount;
                                            vatTotall = vatAmount;
                                            _vatPercentageController.text = vatPer.toStringAsFixed(0);
                                          } else {
                                            vatPer = 0;
                                            _vatPercentageController.clear();
                                          }
                                          calculateTotal();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 4.w),
                                        hintText: "${vatAmount == 0 ? vatTotall : vatAmount}",
                                        hintStyle: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.w400),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Transport", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(top: 3.h, bottom: 3.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _transportController,
                                      onChanged: (value) {
                                       setState(() {
                                        if (value.trim().isEmpty) {
                                          transportCost = 0;
                                        } else {
                                          transportCost = double.tryParse(value) ?? 0;
                                        }
                                        calculateTotal();
                                      });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5.h, left: 3.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 3,child: Text("Total", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 3.h),
                                    height: 25.h,
                                    padding: EdgeInsets.all(5.r),
                                    decoration:ContDecoration.contDecoration,
                                    child: Text(double.parse("$total").toStringAsFixed(0),style: AllTextStyle.textValueStyle,
                                    ),
                                  )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3,child: Text("Cash Paid", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(bottom: 3.h),
                                    child: TextField(style: AllTextStyle.textValueStyle,
                                      controller: _paidController,
                                      onChanged: (value) {
                                      setState(() {
                                        if (value.trim().isEmpty) {
                                          cashPaid = 0;
                                        } else {
                                          cashPaid = double.tryParse(value) ?? 0;
                                        }
                                        isAdded = false;
                                        calculateTotal();
                                      });
                                    },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 3.w),
                                        hintText: "0",
                                        hintStyle: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3,child: Center(child: Text("Bank Paid",style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.h,
                                    margin: EdgeInsets.only(bottom: 3.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _bankPaidController,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_bankPaidController.text == "" || _bankPaidController.text == '0') {
                                            isVisibleBankName = false;
                                            accountController.text = "";
                                          } else {
                                            isVisibleBankName = true;
                                          }
                                        });
                                        
                                        setState(() {
                                          if (value.trim().isEmpty) {
                                            bankPaid = 0;
                                          } else {
                                            bankPaid = double.tryParse(value) ?? 0;
                                          }
                                          isAdded = false;
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
                                        hintText: "0",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isVisibleBankName,
                              child: Row(
                                children: [
                                Expanded(flex: 3,child: Text("Bank", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                flex: 9,
                                child: Container(
                                 height: 25.h,
                                 width: MediaQuery.of(context).size.width / 2,
                                 margin: const EdgeInsets.only(bottom: 4.0),
                                 decoration:ContDecoration.contDecoration,
                                 child: TypeAheadField<BankAccountModel>(
                                  controller: bankAccountController,
                                  builder: (context, controller, focusNode) {
                                    return TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                        isDense: true,
                                        hintText: 'Select Bank',
                                        hintStyle: TextStyle(fontSize: 11.sp),
                                        suffixIcon: _selectedBankId == '' || _selectedBankId == 'null' || _selectedBankId == null || controller.text == '' ? null
                                            : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bankAccountController.clear();
                                              controller.clear();
                                              _selectedBankId = null;
                                            });
                                          },
                                          child: Padding(padding: EdgeInsets.all(5.r), child: Icon(Icons.close, size: 16.r)),
                                        ),
                                        suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                        enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (pattern) async {
                                    return Future.delayed(const Duration(seconds: 1), () {
                                      return allBankAccountList.where((element) =>
                                          element.bankName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                    });
                                  },
                                  itemBuilder: (context, BankAccountModel suggestion) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                      child: Text("${suggestion.accountName} - ${suggestion.bankName} - ${suggestion.accountNumber}",
                                        style: TextStyle(fontSize: 10.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                  onSelected: (BankAccountModel suggestion) {
                                    setState(() {
                                      bankAccountController.text = "${suggestion.accountName} - ${suggestion.bankName} - ${suggestion.accountNumber}";
                                      _selectedBankId = suggestion.accountId.toString();
                                    });
                                  },
                                ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 3,child: Text("Due", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(flex: 1,child: Text(":", style: AllTextStyle.textFieldHeadStyle)),
                                Expanded(
                                flex: 3,
                                child: Container(
                                  height: 25.h,
                                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                  decoration:ContDecoration.contDecoration,
                                  child: Text(double.parse("$due").toStringAsFixed(1),style:AllTextStyle.textValueStyle),
                                )),
                                Expanded(flex: 3, child: Center(child: Text("Prev.Due ", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                    decoration:ContDecoration.contDecoration,
                                    child: SizedBox(
                                    child: Text(
                                      (double.tryParse(previousDue?.toString() ?? '') ?? 0)
                                          .toStringAsFixed(1),
                                      style: TextStyle(color: Colors.red, fontSize: 13.sp),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      height: 28.h,
                                      width: 115.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                      child: Center(child: Text("New Order", style: AllTextStyle.saveButtonTextStyle),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () {
                                    if (customerController.text == '') {
                                      Utils.errorSnackBar(context, "Customer Field is required");
                                    }
                                    else if (customerType == 'G') {
                                      if (_nameController.text == '') {
                                        Utils.errorSnackBar(context, "Name Field is required");
                                      } else if (_mobileNumberController.text == '') {
                                        Utils.errorSnackBar(context, "Mobile Field is required");
                                      }
                                      else if (_bankPaidController.text.isNotEmpty && (_selectedBankId == null || _selectedBankId == '')) {
                                        Utils.errorSnackBar(context, "Please Select Bank Account");
                                      } 
                                      else if (Paid > total) {
                                        Utils.errorSnackBar(context, "Paid Amount cannot be greater than Total Amount");
                                      }
                                       else {
                                        setState(() {
                                          isSellBtnClk = true;
                                        });
                                        if (subtotal == 0) {
                                          setState(() {
                                            isSellBtnClk = false;
                                          });
                                          Utils.errorSnackBar(context, "Please Add to Cart");
                                        } else {
                                          addOrder();
                                          _clearInputFields();
                                        }
                                      }
                                    } 
                                    else {
                                    if (_bankPaidController.text.isNotEmpty && (_selectedBankId == null || _selectedBankId == '')) {
                                      Utils.errorSnackBar(context, "Please Select Bank Account");
                                    } 
                                    else if (Paid > total) {
                                      Utils.errorSnackBar(context, "Paid Amount cannot be greater than Total Amount");
                                    }
                                    else if (customerType == 'G' && due > 0) {
                                      Utils.errorSnackBar(context, "Cash Customer can not due sale");
                                    }
                                    else {
                                      setState(() {
                                        isSellBtnClk = true;
                                      });
                                      if (subtotal == 0) {
                                        setState(() {
                                          isSellBtnClk = false;
                                        });
                                        Utils.errorSnackBar(context, "Please Add to Cart");
                                      } else {
                                        addOrder();
                                        _clearInputFields();
                                      }
                                     }
                                    }
                                  },
                                  child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      height: 28.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.appColor,
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                      child: Center(child: isSellBtnClk ? SizedBox(height:20.h,width:20.w,child: CircularProgressIndicator(color: Colors.white,))
                                          : Text("Order", style: AllTextStyle.saveButtonTextStyle)),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Visibility(visible: isVisibleBankName, child: SizedBox(height: 200.h)),
                  SizedBox(height: 120.0.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  String? firstPickedDate;
  var backEndFirstDate;
  void _selectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
      });
    }
  }

  String? mfgPickedDate; // শুরুতে null থাকবে
var backEndMfgDate;

void _mfgDate() async {
  final mfgDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050));
      
  if (mfgDate != null) {
    setState(() {
      // ডেট সিলেক্ট করলে ভ্যালু সেট হবে
      mfgPickedDate = Utils.formatFrontEndDate(mfgDate);
      backEndMfgDate = Utils.formatBackEndDate(mfgDate);
    });
  }
}

String? expPickedDate; // শুরুতে null থাকবে
var backEndExpDate;

void _expDate() async {
  final expDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050));
      
  if (expDate != null) {
    setState(() {
      expPickedDate = Utils.formatFrontEndDate(expDate);
      backEndExpDate = Utils.formatBackEndDate(expDate);
    });
  }
}

  emtyMethodAll() {
    setState(() {
      _nameController.text = "";
      _paidController.text = "";
      _discountPercentController.text = "";
      _mobileNumberController.text = "";
      _addressController.text = "";
      _salesRateController.text = "";
      _DiscountController.text = "";
      _VatController.text = "";
      _quantityController.text = "";
      _transportController.text = "";
      accountController.text = "";
      discountPer = 0;
      discountAmount = 0;
      previousDue = "";
      vatPer = 0;
      vatAmount = 0;
      subtotal = 0;
      total = 0;
      cashPaid = 0;
      bankPaid = 0;
      due = 0;

    });
  }

  addOrder() async {
  String link = "${baseUrl}add_order";
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  try {
    /// 🛒 CART DATA
    var cartProducts = salesCartList.map((e) {
      return {
        "productId": e.productId,
        "productCode": e.code,
        "name": e.name,
        "categoryName": e.categoryName,
        "quantity": e.quantity,
        "purchaseRate": e.purchaseRate,
        "temporary_rate": e.temporaryRate,
        "salesRate": e.salesRate,
        "temporary_vat": e.temporaryVat ?? 0,
        "vat": e.vat ?? 0,
        "total": e.total,
        "Product_LotNo": e.lotNo ?? "",
        "Product_ManufactureDate": e.mfgDate ?? "",
        "Product_ExpireDate": e.expDate ?? "",
        "is_service": e.isService.toString(),
      };
    }).toList();

    /// 🧾 SALES DATA
    var salesData = {
      "salesId": 0,
      "invoiceNo": "",
      "salesBy": userName,
      "employeeId": userType == "m" || userType == "a" ? employeeSlNo ?? "" : userEmployeeID,
      "salesFrom": "1",
      "customerId": _selectedCustomer ?? "0",
      "salesDate": backEndFirstDate,
      "salesType": level,
      "total": total,
      "discount": discountAmount,
      "vat": vatAmount,
      "vatPercent": 0,
      "transportCost": transportCost,
      "subTotal": subtotal,
      "accountId": _selectedBankId?? 0,
      "cashPaid": accountController.text == "" ? Paid : 0,
      "bankPaid": accountController.text != "" ? Paid : 0,
      "paid": Paid,
      "due": due,
      "previousDue": previousDue,
      "note": "Order from app",
    };

    /// 👤 CUSTOMER DATA
    var customerData =_selectedCustomer == null || _selectedCustomer == "null" || _selectedCustomer == "" || _selectedCustomer == "0"
        ?  {
      "Customer_Name": customerType == 'G'? _nameController.text.trim(): customerController.text.trim(),
      "Customer_Mobile": _mobileNumberController.text.trim(),
      "Customer_Address": _addressController.text.trim(),
      "Customer_Type": "$customerType",
      "Customer_Email": "",
    }:null;

    print("🧾 SALES DATA:\n$salesData");
    print("👤 CUSTOMER DATA:\n$customerData");
    print("🛒 CART PRODUCTS:\n$cartProducts");

    /// 🔗 API CALL
    Response response = await Dio().post(
      link,
      data: {
        "sales": salesData,
        "customer": customerData,
        "cart": cartProducts,
      },
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
      }),
    );

    var item = response.data;
    print("✅ API Response:\n$item");

    if (item["success"] == true) {
      setState(() {
        isSellBtnClk = false;
      });

      emtyMethodAll();
      salesCartList.clear();
      CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
      Navigator.push(context,MaterialPageRoute(builder: (context) => OrdersInvoiceScreen(salesId: "${item["salesId"]}")));
    } else {
      setState(() {
        isSellBtnClk = false;
      });
      Utils.showTopSnackBar(context, "${item["errorMsg"] ?? "Order entry failed"}");
    }
  } catch (e) {
    setState(() {
      isSellBtnClk = false;
    });
    print("❌ Error during sales submission: $e");
    Utils.showTopSnackBar(context, e.toString());
  }
}
}

