import 'dart:convert';
import 'package:barishal_surgical/providers/sales_module_providers/invoice_due_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_invoice_provider.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_invoice_screen.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/bank_account_provider.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget/custom_appbar.dart';
import '../../../models/administration_module_models/customer_list_model.dart';
import '../../../models/administration_module_models/employees_model.dart';
import '../../../models/administration_module_models/product_list_model.dart';
import '../../../models/sales_module_models/sales_add_to_cart_model.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../utils/all_textstyle.dart';
import '../../../utils/const_model.dart';
import '../../../utils/utils.dart';

class SalesEntryScreen extends StatefulWidget {
  const SalesEntryScreen({super.key});
  @override
  State<SalesEntryScreen> createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
  bool? isFree = false;
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

  Color getColor(Set<MaterialState> states) {
    return Colors.white;
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.blue.shade100;
  }
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _bankPaidController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salesRateController = TextEditingController();
  final TextEditingController _DiscountController = TextEditingController();
  final TextEditingController _VatController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();
  final TextEditingController _taxPercentageController = TextEditingController();
  final TextEditingController _TaxController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _lotNoController = TextEditingController();
  var customerController = TextEditingController();
  var empluyeeNameController = TextEditingController();
  var categoryController = TextEditingController();
  var productController = TextEditingController();
  var expDateController = TextEditingController();
  double discountPercentage = 0.0;
  var customerSlNo;
  String? _selectedBankId;
  String? customerType = 'G';
  var  creditLimit = '';

  String? Salling_Rate = "0.0";
  String? customerMobile;
  String? customerAddress;
  String? categoryId;
  var expireStock = 0;
  String? _selectedCustomer;
  String? _selectedProduct;
  String? employeeSlNo;
  String? previousDue;
  String level = "wholesale";
  var availableStock = 0;
  int quantity = 0;
  String? productUnit;
  String? perUnitConvert;
  String? convertedName = "";
  String? isService;

  ///new calculate
  double subtotal = 0;
  double vatTotall = 0;
  double discountPer = 0;
  double discountAmount = 0;
  double afterDisTotal = 0;
  double vatPer = 0;
  double vatAmount = 0;
  double taxPer = 0.0;
  double taxAmount = 0.0;
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
  bool isChangeDate = false;
  bool isInvoiceDue = false;

  late final Box box;
  bool isSellBtnClk = false;
  bool isMusokBtnClk = false;

//   void _clearInputFields() {
//     productController.text = '';
//     expDateController.text = '';
//     _salesRateController.text = '';
//     _quantityController.text = '';
//     isFree = false;
//     isAdded = true;
//     Total = 0;
//     newQty = 0;
//     newTotal = 0;
//     availableStock = 0;

//     _bankPaidController.text="";
//     _paidController.text = "";
//     _discountPercentController.text = "";
//     _DiscountController.text = "";
//     _vatPercentageController.text="";
//     _VatController.text = "";
//     _transportController.text = "";
//     bankAccountController.text = "";
//     discountPer = 0;
//     transportCost=0;
//     discountAmount = 0;
//     previousDue = "0";
//     vatPer = 0;
//     vatAmount = 0;
//     cashPaid = 0;
//     bankPaid = 0;
//     due = 0;
//     calculateTotal();
//  }

  void removeFromCart(index) {
    salesCartList.removeAt(index);
    due = 0;
    Paid = 0;
    bankPaid = 0;
    discountAmount = 0;
    vatAmount = 0;
    transportCost = 0;
    afterDisTotal = 0;
    isAdded = true;
    bankAccountController.text = "";
    _bankPaidController.text = "0";
    _transportController.text = "0";
    _DiscountController.text = "0";
    _discountPercentController.text = "0";
    _VatController.text = "0";
    _vatPercentageController.text = "0";
    setState(() {
      calculateTotal();
    });
  }
double getDouble(TextEditingController c) {
  return double.tryParse(c.text) ?? 0.0;
}

void calculateTotal() {
  final allGetSalesData = salesCartList;
    double cartTotall = allGetSalesData.map((e) => e.total).fold(0.0, (p, element) => p + double.parse(element!));
    subtotal = double.parse("$cartTotall");
  double afterDiscount = subtotal - discountAmount;

  // VAT & TAX শুধু show হবে
  vatAmount = (afterDiscount * vatPer) / 100;
  taxAmount = (afterDiscount * taxPer) / 100;

  total = afterDiscount + transportCost;
  if (isAdded) {
    cashPaid = double.parse("$total") - double.parse("$bankPaid");
    _paidController.text = "$cashPaid";
  }
  Paid = (cashPaid + bankPaid);
  due = total - Paid;

  setState(() {});
    print("SubTotal===$subtotal");
    print("Total===$total");
    print("afterDisTotal===$afterDisTotal");
    print("vatAmount===$vatAmount");
    print("taxAmount===$taxAmount");
    print("Paid===$Paid");
    print("due===$due");
    print("cashPaid===$cashPaid");
}

  @override
  void initState() {
    _initializeData();
    super.initState();
    ProductListProvider.isProductsListLoading = true;
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
    CustomerListProvider.isCustomerListloading = true;
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
     //_quantityController.text = "1";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<BankAccountProvider>(context, listen: false).getBankAccount(context);
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    // Provider.of<InvoiceDueProvider>(context, listen: false).getInvoiceDue(context,_selectedCustomer??"");
    Provider.of<InvoiceDueProvider>(context, listen: false).invoiceDueList=[];
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    await Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,level,"");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerList = Provider.of<CustomerListProvider>(context, listen: false).customerList;

      if (customerList.isNotEmpty) {
        setState(() {
          _selectedCustomer = customerList.first.customerSlNo.toString();
          customerController.text =
          "${customerList.first.customerName} ${customerList.first.customerCode != "" ? " - ${customerList.first.customerCode}" : ""} ${customerList.first.customerMobile != "" ? " - ${customerList.first.customerMobile}" : ""}";
          _mobileNumberController.text = customerList.first.customerMobile ?? '';
          _addressController.text = customerList.first.customerAddress ?? '';
          customerSlNo = customerList.first.customerSlNo.toString();
          customerType = customerList.first.customerType ?? '';
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
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    result = await Dio().post(
      "${baseUrl}get_customer_due",
      data: {"customerId": "$customerId"},
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }),
    );

    var data = result?.data;
    if (data is List && data.isNotEmpty) {
      setState(() {
        previousDue = "${data[0]['dueAmount']}";
      });
    } else {
      setState(() {
        previousDue = "0"; 
      });
      print("No due records found for this customer.");
    }
  } catch (e) {
    print("Error fetching due amount: $e");
  }
}

  bool isDefaultCustomerSet = false;
  @override
  Widget build(BuildContext context) {
    /// Get Employees
    final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    ///all customer
    final allCustomerList = Provider.of<CustomerListProvider>(context).customerList;
    /// product
    final allProductList = Provider.of<ProductListProvider>(context).productsList;
    ///bank account
    final allBankAccountList = Provider.of<BankAccountProvider>(context).bankAccountList;
    ///Invoice Due
    final allInvoiceDueData = Provider.of<InvoiceDueProvider>(context).invoiceDueList;
    print("allInvoiceDueData========${allInvoiceDueData.length}");
    
    return Scaffold(
        appBar: CustomAppBar(title: 'Sales Entry'),
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
                    margin: EdgeInsets.only(top: 4.r, left: 4.0.w, right: 4.0.w, bottom: 10.h),
                    padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Date to      :", style: AllTextStyle.textFieldHeadStyle),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectedDate();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5.h),
                                      height: 25.0.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.only(top: 3.h, bottom: 5.h, left: 5.w, right: 5.w),
                                      decoration:ContDecoration.contDecoration,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(firstPickedDate == null ? Utils.formatFrontEndDate(DateTime.now()) : firstPickedDate!,
                                              style:AllTextStyle.dateFormatStyle
                                          ),
                                          Icon(Icons.calendar_month, size: 18.r)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () {
                      //           setState(() {
                      //             isChangeDate = !isChangeDate; 
                      //           });
                      //         },
                      //         child: Text("Don't Change Date :",style: AllTextStyle.textFieldHeadStyle),
                      //       ),
                      //       Transform.scale(
                      //         scale: 1.1, 
                      //         child: Checkbox(
                      //           value: isChangeDate, 
                      //           activeColor: Colors.teal.shade900, 
                      //           onChanged: (bool? value) {
                      //             setState(() {
                      //               isChangeDate = value ?? false;
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Sales By    :", style: AllTextStyle.textFieldHeadStyle),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 25.0.h,
                                margin: EdgeInsets.only(top: 4.h,bottom: 4.h),
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
                              ),
                            ),
                          ],
                        ), // Sales by drop down
                      ],
                    ),
                  ),
                  ///my practice
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 4.h, left: 4.0.w, right: 4.0.w, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: Color.fromARGB(255, 7, 125, 180), width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
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
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6.0.r),
                                      topRight: Radius.circular(6.0.r)),
                                  color: Colors.teal.shade900),
                              child: Center(
                                child: Text(
                                  '👥 Customer Information',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, bottom: 4.0.h),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Sales Type :   ", style: AllTextStyle.textFieldHeadStyle),
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                          fillColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
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
                                    Text("Retail",style: AllTextStyle.textFieldHeadStyle),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                          fillColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
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
                                    Text("Wholesale",style: AllTextStyle.textFieldHeadStyle),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 5.w),
                                Text("Customer :", style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 14.w),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    height: 25.0.h,
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
                                              if (customerType == "N") {
                                                _nameController.text = allCustomerList.first.customerName ?? '';
                                              }
                                            });
                                            previousDueAmount(_selectedCustomer);
                                            print("CustomerId========$_selectedCustomer");
                                            print("customerType========$customerType");
                                            InvoiceDueProvider().on();
                                            Provider.of<InvoiceDueProvider>(context, listen: false).getInvoiceDue(context,_selectedCustomer);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 28.w),
                                  child: Text("Name :", style: AllTextStyle.textFieldHeadStyle),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(bottom: 4.h),
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
                                Padding(
                                  padding: EdgeInsets.only(left: 22.w),
                                  child: Text("Mobile :", style: AllTextStyle.textFieldHeadStyle)),
                                 SizedBox(width: 15.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(bottom: 4.h),
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
                                        hintText: 'Mobile No',
                                        hintStyle: AllTextStyle.textValueStyle,
                                        contentPadding: EdgeInsets.only(bottom: isEnabled==false? 10.5.h:8.5.h, left: 5.w),
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
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: Text("Address :", style: AllTextStyle.textFieldHeadStyle)),
                                SizedBox(width: 16.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 40.h,
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
                                          _addressController.text = value.toString();
                                        }
                                        return null;
                                      },
                                      enabled: isEnabled,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.w),
                                       hintText: 'Address',
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
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 3.w),
                                  child: Text("Comment :", style: AllTextStyle.textFieldHeadStyle)),
                                SizedBox(width: 16.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 40.h,
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
                            // Checkbox এবং Label এর অংশ
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isInvoiceDue = !isInvoiceDue;
                                    });
                                  },
                                  child: Text("Invoice Due :", style: AllTextStyle.textFieldHeadStyle),
                                ),
                                Transform.scale(
                                  scale: 1.1,
                                  child: Checkbox(
                                    value: isInvoiceDue,
                                    activeColor: Colors.teal.shade900,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isInvoiceDue = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // কন্ডিশনাল রেন্ডারিং: যদি isInvoiceDue true হয়
                            if (isInvoiceDue) ...[
                              // টাইটেল কার্ড (Due Bills)
                              Card(
                                color: Colors.teal.shade900,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
                                child: Container(
                                  height: 25.h,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      "Due Bills",
                                      style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              
                              // মেইন টেবিল কন্টেইনার
                              Container(
                                height: allInvoiceDueData.isEmpty ? 40.h : allInvoiceDueData.length == 1 ? 55.h : 35.h + (allInvoiceDueData.length * 20.0.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowHeight: 25.0,
                                      dataRowHeight: 25.0,
                                      headingRowColor: MaterialStateProperty.all(Colors.indigo.shade900),
                                      border: TableBorder.all(color: AppColors.isMechanics),
                                      columnSpacing: 200,
                                      columns: [
                                        DataColumn(label: Text('  Invoice', style: AllTextStyle.tableHeadTextStyle)),
                                        DataColumn(label: Text('Due Amount       ', style: AllTextStyle.tableHeadTextStyle)),
                                      ],
                                      rows: allInvoiceDueData.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var data = entry.value;
                                        
                                        return DataRow(
                                          color: MaterialStateProperty.resolveWith(
                                            (states) => index % 2 == 0 ? getColor(states) : getColors(states),
                                          ),
                                          cells: [
                                            DataCell(Text(data.saleMasterInvoiceNo.toString())),
                                            DataCell(Text(data.dueAmount.toString())),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8.h, left: 4.0.w, right: 4.0.w, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
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
                                  color: Colors.teal.shade900),
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
                                          cproductCode = suggestion.productCode.toString();
                                          cproductId = suggestion.productSlNo.toString();
                                          ccategoryName = suggestion.productCategoryName;
                                          cname = suggestion.productName;
                                          cTempvat = suggestion.temporaryVat;
                                          cvat = suggestion.vat;
                                          productUnit = suggestion.unitName;
                                          isService = suggestion.isService;
                                          cpurchaseRate = suggestion.productPurchaseRate;
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text("Amount", style: AllTextStyle.textFieldHeadStyle),
                                ),
                                Expanded(
                                flex: 1,
                                  child: Text(":", style: AllTextStyle.textFieldHeadStyle),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 25.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
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
                                    child: Container(
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
                              Expanded(
                                flex: 1,
                                child: Text(":", style: AllTextStyle.textFieldHeadStyle),
                              ),
                              Expanded(
                                flex: 9,
                                child: Container(
                                  height: 25.h,
                                  margin: EdgeInsets.only(bottom: 4.h),
                                  child: TextField(
                                    style: AllTextStyle.dateFormatStyle,
                                    controller: _lotNoController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                                      hintText: "Lot No.",
                                      hintStyle: AllTextStyle.textValueStyle,
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
                              Expanded(
                                flex: 3,
                                child: Text("Mfg.Date", style: AllTextStyle.textFieldHeadStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(":", style: AllTextStyle.textFieldHeadStyle),
                              ),
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
                              Expanded(
                                flex: 3,
                                child: Text("Exp.Date", style: AllTextStyle.textFieldHeadStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(":", style: AllTextStyle.textFieldHeadStyle),
                              ),
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
                                if (availableStock >= quantity) {
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
                                      expDate: expPickedDate,
                                      mfgDate: mfgPickedDate
                                    ));
                                     calculateTotal();
                                  });
                                }
                                } else {
                                  Utils.errorSnackBar(context, "Stock Unavailable");
                                }
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
                                      color: Colors.teal.shade900,
                                      borderRadius: BorderRadius.circular(5.0.r),
                                    ),
                                    child: Center(child: Text("Add to Cart", style: AllTextStyle.saveButtonTextStyle)))),
                          ),
                        ),
                      ],
                    ),
                  ),
             
                  Container(
                    height: salesCartList.isEmpty ? 40.h : salesCartList.length == 1 ? 55.h : 35.h + (salesCartList.length * 20.0.h),
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5.0.h, bottom: 10.0.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            headingRowColor:
                            MaterialStateColor.resolveWith((states) => Colors.teal.shade900),
                            showCheckboxColumn: true,
                            border: TableBorder.all(color: Colors.blueGrey.shade100, width: 1),
                            columns: [
                              customDataColumn("SL."),
                              customDataColumn("Code"),
                              customDataColumn("Product/Service Name"),
                              customDataColumn("Category"),
                              customDataColumn("Lot No."),
                              customDataColumn("Exp.Date"),
                              customDataColumn("Quantity"),
                              customDataColumn("Rate"),
                              customDataColumn("Total"),
                              customDataColumn("Action")
                            ],
                            rows: List.generate(
                              salesCartList.length,
                                  (int index) => DataRow(
                                    color: MaterialStateProperty.resolveWith((states) {
                                      if (salesCartList[index].isFree == true) {
                                        return Colors.green.shade100;
                                      }
                                      return index % 2 == 0 ? getColor(states) : getColors(states);
                                    }),
                                  cells: <DataCell>[
                                  DataCell(Center(child: Text("${index + 1}"))),
                                  DataCell(Center(child: Text('${salesCartList[index].code}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].name}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].categoryName}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].lotNo}'))),
                                  DataCell(Center(child: Text('${salesCartList[index].expDate}'))),
                                  DataCell( Center(child: Text('${salesCartList[index].quantity}'))),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        (double.tryParse(salesCartList[index].salesRate.toString().replaceAll(",", "").trim()) ?? 0.0).toStringAsFixed(2),
                                      ),
                                    ),
                                  ),
                                  DataCell(Center(child: Text(double.parse('${salesCartList[index].total}').toStringAsFixed(2)))),
                                  DataCell(
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          removeFromCart(index);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.delete, size: 16.r, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ///========cover
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 4.h, left: 4.0.w, right: 4.0.w, bottom: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 2, blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0.r),
                                  topRight: Radius.circular(6.0.r)),
                                  color: Colors.teal.shade900),
                              child: Center(
                                child: Text('💸 Amount Details',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, bottom: 2.0.h),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Sub Total :",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 12.w),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      height: 25.0.h,
                                      padding: EdgeInsets.all(4.0.r),
                                      decoration:ContDecoration.contDecoration,
                                      child: Text(double.parse("$subtotal").toStringAsFixed(1), style: AllTextStyle.textValueStyle,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 4.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Discount  :", style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 8.w),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _discountPercentController,
                                      onChanged: (value) {
                                        setState(() {
                                          discountPer = getDouble(_discountPercentController);
                                          discountAmount = (subtotal * discountPer) / 100;

                                          _DiscountController.text = discountAmount.toStringAsFixed(1);

                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 6.w),
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
                                Text("%", style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 5.w),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 25.0.h,
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _DiscountController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          discountAmount = getDouble(_DiscountController);

                                          discountPer = subtotal == 0 ? 0 : (discountAmount * 100) / subtotal;

                                          _discountPercentController.text = discountPer.toStringAsFixed(1);

                                          calculateTotal();
                                        });
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 6.w),
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
                                Text("VAT          :",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 9.w),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(left: 5.w, right: 5.w,top: 5.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _vatPercentageController,
                                      onChanged: (value) {
                                        setState(() {
                                          vatPer = getDouble(_vatPercentageController);

                                          double afterDiscount = subtotal - discountAmount;

                                          vatAmount = (afterDiscount * vatPer) / 100;

                                          _VatController.text = vatAmount.toStringAsFixed(1);

                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "0",
                                          contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),

                                ///vat Amount
                                Text("%",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 5.w),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(top: 4.0.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _VatController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          double afterDiscount = subtotal - discountAmount;

                                          vatAmount = getDouble(_VatController);

                                          vatPer = afterDiscount == 0 ? 0 : (vatAmount * 100) / afterDiscount;

                                          _vatPercentageController.text = vatPer.toStringAsFixed(1);

                                          calculateTotal();
                                        });
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 6.w),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Tax           :", style: AllTextStyle.textFieldHeadStyle),
                              SizedBox(width: 9.w),
                              /// Tax Percentage Field
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 25.0.h,
                                  margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                                  child: TextField(
                                    style: AllTextStyle.textValueStyle,
                                    controller: _taxPercentageController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        double afterDiscount = subtotal - discountAmount;

                                        taxPer = getDouble(_taxPercentageController);

                                        taxAmount = (afterDiscount * taxPer) / 100;

                                        _TaxController.text = taxAmount.toStringAsFixed(1);

                                        calculateTotal();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "0",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder: TextFieldInputBorder.focusEnabledBorder,
                                      enabledBorder: TextFieldInputBorder.focusEnabledBorder,
                                    ),
                                  ),
                                ),
                              ),

                              Text("%", style: AllTextStyle.textFieldHeadStyle),
                              SizedBox(width: 5.w),
                              /// Tax Amount Field
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 25.0.h,
                                  margin: EdgeInsets.only(top: 4.0.h),
                                  child: TextField(
                                    style: AllTextStyle.textValueStyle,
                                    controller: _TaxController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        double afterDiscount = subtotal - discountAmount;

                                        taxAmount = getDouble(_TaxController);

                                        taxPer = afterDiscount == 0 ? 0 : (taxAmount * 100) / afterDiscount;

                                        _taxPercentageController.text = taxPer.toStringAsFixed(1);

                                        calculateTotal();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 6.w),
                                      hintText: "0.0",
                                      hintStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w400),
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
                              children: [
                                Text("Transport :",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 10.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(top: 4.h, bottom: 4.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _transportController,
                                      onChanged: (value) {
                                        setState(() {
                                          transportCost = getDouble(_transportController);
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(top: 5.h, left: 5.w),
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
                                Text("Total         :",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                   margin: EdgeInsets.only(bottom: 4.h),
                                   height: 25.0.h,
                                   padding: EdgeInsets.all(5.0.r),
                                   decoration:ContDecoration.contDecoration,
                                   child: Text(double.parse("$total").toStringAsFixed(1),style: AllTextStyle.textValueStyle,
                                   ),
                                 )),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Cash Paid :", style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 8.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    child: TextField(style: AllTextStyle.textValueStyle,
                                      controller: _paidController,
                                      onChanged: (value) {
                                        setState(() {
                                          cashPaid = getDouble(_paidController);
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
                                          hintText: double.parse("$cashPaid").toStringAsFixed(1),
                                          hintStyle: TextStyle(fontSize: 13.5.sp,fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                          enabledBorder:TextFieldInputBorder.focusEnabledBorder
                                      ),
                                    ),
                                  ),
                                ),

                                /// bank paid
                                SizedBox(width: 2.w),
                                Text("Bank Paid",style: AllTextStyle.textFieldHeadStyle),
                                SizedBox(width: 2.w),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    child: TextField(
                                      style: AllTextStyle.textValueStyle,
                                      controller: _bankPaidController,
                                      onChanged: (value) {
                                        setState(() {
                                          bankPaid = getDouble(_bankPaidController);
                                          isVisibleBankName = bankPaid > 0;
                                          calculateTotal();
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
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
                                  Expanded(flex: 4, child: Text("Bank         : ",style: AllTextStyle.textFieldHeadStyle)),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    flex: 14,
                                    child: Container(
                                      height: 25.0.h,
                                      width: MediaQuery.of(context).size.width / 2,
                                      margin: EdgeInsets.only(bottom: 4.0.h),
                                      child: TypeAheadField<BankAccountModel>(
                                          controller: bankAccountController,
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                              decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                                isDense: true,
                                                hintText: 'Select Bank',
                                                hintStyle: TextStyle(fontSize: 13.sp),
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
                                              child: Text(suggestion.bankName!,
                                                style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                          onSelected: (BankAccountModel suggestion) {
                                            setState(() {
                                              bankAccountController.text = suggestion.bankName!;
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
                                Text("Due           :   ",style: AllTextStyle.textFieldHeadStyle),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 25.0.h,
                                      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                      decoration:ContDecoration.contDecoration,
                                      child: Text(double.parse("$due").toStringAsFixed(1),style:AllTextStyle.textValueStyle),
                                    )),
                                SizedBox(width: 2.w),
                                Expanded(flex: 2, child: Center(child: Text("Prev.Due ", style: AllTextStyle.textFieldHeadStyle))),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 25.0.h,
                                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
                                    decoration:ContDecoration.contDecoration,
                                    child: SizedBox(
                                      child: Text("$previousDue" == 'null' ? '0' : double.parse("$previousDue").toStringAsFixed(1),
                                        style: TextStyle(color: Colors.red,fontSize: 13.5.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      height: 28.0.h,
                                      width: 90.0.w,
                                      decoration: BoxDecoration(
                                        color: Colors.cyan.shade700,
                                        borderRadius: BorderRadius.circular(5.0.r),
                                      ),
                                      child: Center(child: Text("New Sale", style: AllTextStyle.saveButtonTextStyle),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (customerController.text.isEmpty) {
                                      Utils.errorSnackBar(context, "Customer Field is required");
                                      return;
                                    }
                                    if (customerType == 'G') {
                                      if (_nameController.text.isEmpty) {
                                        Utils.errorSnackBar(context, "Name Field is required");
                                        return;
                                      }
                                      if (_mobileNumberController.text.isEmpty) {
                                        Utils.errorSnackBar(context, "Mobile Field is required");
                                        return;
                                      }
                                      if (due > 0) {
                                        Utils.errorSnackBar(context, "Cash Customer can not due sale");
                                        return;
                                      }
                                    }
                                    if (_bankPaidController.text.isNotEmpty && (_selectedBankId == null || _selectedBankId == '')) {
                                      Utils.errorSnackBar(context, "Please Select Bank Account");
                                      return;
                                    }
                                    if (Paid > total) {
                                      Utils.errorSnackBar(context, "Paid Amount cannot be greater than Total Amount");
                                      return;
                                    }
                                    if (subtotal == 0) {
                                      Utils.errorSnackBar(context, "Please Add to Cart");
                                      return;
                                    }
                                    setState(() {
                                      isSellBtnClk = true;
                                    });
                                    addSales();
                                    //_clearInputFields();
                                  },
                                  child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      height: 28.0.h,
                                      width: 70.0.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.appColor,
                                        borderRadius: BorderRadius.circular(5.0.r),
                                      ),
                                      child: Center(
                                        child: isSellBtnClk
                                            ? SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                              )
                                            : Text("Sale", style: AllTextStyle.saveButtonTextStyle),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Visibility(visible: isVisibleBankName, child: SizedBox(height: 200.h)),
                  allInvoiceDueData.isEmpty ? SizedBox() : Container(
                    height: 25.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.h),
                    child: Card(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0.r),
                            topRight: Radius.circular(6.0.r)),
                            color: AppColors.appColor),
                        child: Center(
                          child: Text('Invoice Wise Due Bills',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                 allInvoiceDueData.isEmpty ? SizedBox() : Container(
                    height: allInvoiceDueData.isEmpty ? 40.h : allInvoiceDueData.length == 1 ? 55.h : 35.h + (allInvoiceDueData.length * 20.0.h),
                  child: InvoiceDueProvider.isInvoiceDueLoading
                      ? const Center(
                      child: CircularProgressIndicator())
                      : SizedBox(
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
                              headingRowHeight: 18.h,
                              dataRowHeight: 18.h,
                              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
                              showCheckboxColumn: true,
                              border: TableBorder.all(color: Colors.blue.shade200, width: 1),
                              columnSpacing: 100,
                              columns: [
                                DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                                DataColumn(label: Expanded(child: Center(child: Text('Due Amount',style:AllTextStyle.tableHeadTextStyle)))), 
                                DataColumn(label: Expanded(child: Center(child: Text('Action',style:AllTextStyle.tableHeadTextStyle)))),                                                       
                              ],
                              rows: [
                                ...List.generate(
                                  allInvoiceDueData.length,
                                    (int index) => DataRow(
                                    color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                                    cells: <DataCell>[
                                      DataCell(Center(child: Text(allInvoiceDueData[index].saleMasterInvoiceNo))),
                                      DataCell(Center(child: Text(allInvoiceDueData[index].dueAmount))),
                                      DataCell(
                                      Center(
                                        child: IconButton(
                                          icon: Icon(Icons.collections_bookmark, color: Colors.black,size: 10.r),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.all(4.r),
                                                  contentPadding: EdgeInsets.all(10.r),
                                                  content: SizedBox(
                                                    width: double.maxFinite,
                                                    child: FutureBuilder(
                                                      future: Provider.of<SalesInvoiceProvider>(context, listen: false).getSalesInvoice(context, allInvoiceDueData[index].saleMasterSlNo),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return SizedBox(
                                                            height: 200.h,
                                                            child: Center(child: CircularProgressIndicator()),
                                                          );
                                                        } else if (snapshot.hasError) {
                                                          return Center(child: Text("Error: ${snapshot.error}"));
                                                        } else if (!snapshot.hasData || snapshot.data == null) {
                                                          return const Center(child: Text("No Data Found"));
                                                        } else {
                                                          int totalQty = snapshot.data!.saleDetails.fold<int>(0,
                                                             (sum, item) => sum + (int.tryParse(item.saleDetailsTotalQuantity.toString()) ?? 0));
                                                             int totalReturnQty = snapshot.data!.saleDetails.fold<int>(0,
                                                             (sum, item) => sum + (int.tryParse(item.returnQuantity.toString()) ?? 0));
                                                          double totalAmount = snapshot.data!.saleDetails.fold<double>(0.0,
                                                              (sum, item) => sum + (double.tryParse(item.saleDetailsTotalAmount.toString()) ?? 0.0));
                                                              

                                                          return SizedBox(
                                                            height: 400.h,
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                     Text("Invoice Details", style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w700)),
                                                                     InkWell(
                                                                      borderRadius: BorderRadius.circular(3.r),
                                                                      onTap: () => Navigator.pop(context),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.blueGrey.shade100,
                                                                          borderRadius: BorderRadius.circular(100.r)
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.all(4.r),
                                                                            child: Icon(Icons.close,color: Colors.blueGrey,),
                                                                          )
                                                                        ),
                                                                      ),
                                                                    )
                                                                    ],
                                                                  ),
                                                                  Divider(),
                                                                  Align(
                                                                    alignment: Alignment.center,
                                                                    child: Container(
                                                                      width: 100.w,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(3.r),
                                                                        border: Border.all(color: Colors.black,width: 1.5.w)),
                                                                      child: Center(child: Text("Sales Invoice",style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.bold)))),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            infoText("Customer Id :", snapshot.data!.sales[0].customerCode??""),
                                                                            infoText("Name :", snapshot.data!.sales[0].customerName??""),
                                                                            infoText("Mobile :", snapshot.data!.sales[0].customerMobile??""),
                                                                            infoText("Attention :", snapshot.data!.sales[0].customerComment??""),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      /// RIGHT
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            infoText("Prepared By:", snapshot.data!.sales[0].addedBy??"", alignEnd: true),
                                                                            infoText("Invoice No:", snapshot.data!.sales[0].saleMasterInvoiceNo??"", alignEnd: true),
                                                                            infoText("Sales Date:", snapshot.data!.sales[0].saleMasterSaleDate??"", alignEnd: true),
                                                                            infoText("Employee:", snapshot.data!.sales[0].employeeName ?? "", alignEnd: true),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 1.h),
                                                                  infoText("Address :", snapshot.data!.sales[0].customerAddress),
                                                                  SizedBox(height: 4.h),
                                                                  /// 🔹 TABLE
                                                                  SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.vertical,
                                                                      child: DataTable(
                                                                        headingRowHeight: 15.h,
                                                                        dataRowHeight: 15.h,
                                                                         headingRowColor: WidgetStateColor.resolveWith((states) => AppColors.appColor),
                                                                        border: TableBorder.all(color: Colors.blueGrey),
                                                                        columns: [
                                                                          DataColumn(label: Text('Sl.',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Product Code',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Description',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Category',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Quantity',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Return Qty',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Unit',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Unit Price',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                          DataColumn(label: Text('Total',style: TextStyle(color:Colors.white,fontSize: 10.sp))),
                                                                        ],
                                                                        rows: [
                                                                          ...List.generate(snapshot.data!.saleDetails.length, (i) {
                                                                            final item = snapshot.data!.saleDetails[i];
                                                                            return DataRow(cells: [
                                                                              DataCell(Text("${i + 1}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.productCode}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.productName}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.productCategoryName}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.saleDetailsTotalQuantity}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.returnQuantity}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.unitName}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.saleDetailsRate}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                              DataCell(Text("${item.saleDetailsTotalAmount}",style: TextStyle(color:Colors.black,fontSize: 10.sp))),
                                                                            ]);
                                                                          }),
                                                                          /// TOTAL ROW
                                                                          DataRow(cells: [
                                                                            DataCell(Text("")),
                                                                            DataCell(Text("")),
                                                                            DataCell(Text("")),
                                                                            DataCell(Text("Total", style: TextStyle(color:Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold))),
                                                                            DataCell(Text("$totalQty", style: TextStyle(color:Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold))),
                                                                            DataCell(Text("$totalReturnQty", style: TextStyle(color:Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold))),
                                                                            DataCell(Text("")),
                                                                            DataCell(Text("")),
                                                                            DataCell(Text("$totalAmount", style: TextStyle(color:Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold))),
                                                                          ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10.h),
                                                                  /// 🔹 SUMMARY
                                                                  Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: SizedBox(
                                                                      width: 200.w,
                                                                      child: Column(
                                                                        children: [
                                                                          summaryRow("Sub Total", snapshot.data!.sales[0].saleMasterSubTotalAmount),
                                                                          summaryRow("Discount", snapshot.data!.sales[0].saleMasterTotalDiscountAmount),
                                                                          summaryRow("Vat", snapshot.data!.sales[0].saleMasterTaxAmount),
                                                                          summaryRow("Transport", snapshot.data!.sales[0].saleMasterFreight),
                                                                          Container(height: 1.h,color: Colors.black26),
                                                                          summaryRow("Total", snapshot.data!.sales[0].saleMasterTotalSaleAmount),
                                                                          summaryRow("Paid", snapshot.data!.sales[0].saleMasterPaidAmount),
                                                                          Container(height: 1.h,color: Colors.black26),
                                                                          summaryRow("Due", snapshot.data!.sales[0].saleMasterDueAmount, isBold: true),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Container(
                                                                      height: 25.h,
                                                                      width: 70.w,
                                                                      margin: EdgeInsets.only(top: 8.h),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.blueGrey,
                                                                        borderRadius: BorderRadius.circular(3.r),
                                                                      ),
                                                                      child: InkWell(
                                                                        borderRadius: BorderRadius.circular(3.r),
                                                                        onTap: () => Navigator.pop(context),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "Close",
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 11.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                      ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ), 
                 SizedBox(height: 100.h),
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
      bankAccountController.text = "";
      discountPer = 0;
      discountAmount = 0;
      previousDue = "0";
      vatPer = 0;
      vatAmount = 0;
      subtotal = 0;
      total = 0;
      cashPaid = 0;
      bankPaid = 0;
      due = 0;
    });
  }

  Future<void> addSales() async {
  String link = "${baseUrl}add_sales";
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  setState(() {
    isSellBtnClk = true;
  });

  try {
    var cartProducts = salesCartList.map((e) {
      return {
        "productId": e.productId.toString(),
        "productCode": e.code ?? "",
        "name": e.name,
        "categoryName": e.categoryName,
        "quantity": e.quantity.toString(),
        "purchaseRate": e.purchaseRate?.toString() ?? "0",
        "salesRate": e.salesRate.toString(),
        "temporary_rate": e.temporaryRate.toString(),
        "temporary_vat": e.temporaryVat.toString(),
        "vat": e.vat?.toString() ?? "0",
        "total": e.total.toString(),
        "Product_LotNo": e.lotNo,
        "Product_ManufactureDate": e.mfgDate,
        "Product_ExpireDate": e.expDate,
        "is_service": e.isService.toString(),
      };
    }).toList();

    Map<String, dynamic> requestData = {
      "sales": {
        "salesId": 0,
        "invoiceNo": "",
        "salesBy": userName,
        "salesType": level,
        "salesFrom": "",
        "customerId": _selectedCustomer,
        "employeeId":  userType == "m" || userType == "a" ? employeeSlNo ?? "" : userEmployeeID,
        "salesDate": backEndFirstDate,
        "total": total.toString(),
        "subTotal": subtotal.toString(),
        "discount": discountAmount.toString(),
        "tax": taxAmount.toString(),
        "taxPercent": taxPer.toString(),
        "vat": vatAmount.toString(),
        "vatPercent": vatPer.toString(),
        "transportCost": transportCost.toString(),
        "paid": Paid.toString(),
        "due": due.toString(),
        "cashPaid": cashPaid.toString(),
        "bankPaid": bankPaid.toString(),
        "previousDue": previousDue.toString(),
        "isShipping": false,
        "note": "Sale from app",
        "accountId": _selectedBankId ?? ""
      },

      "customer":_selectedCustomer == null || _selectedCustomer == "null" || _selectedCustomer == "" || _selectedCustomer == "0"
        ? {
        "Customer_Name": customerType == "G"? _nameController.text.trim(): customerController.text.trim(),
        "Customer_Mobile": _mobileNumberController.text.trim(),
        "Customer_Address": _addressController.text.trim(),
        "Customer_Comment": _commentController.text.trim(),
        "Customer_Type": customerType,
        "status": "a"
      }:null,

      "invoiceDueChecked": false,

      "cart": cartProducts,
    };

    print("------- FULL REQUEST DATA -------");
    print(jsonEncode(requestData));
    print("----------------------------------");

    Response response = await Dio().post(
      link,
      data: requestData,
      options: Options(headers: {
        "Content-Type": "application/json",
        'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
        "Authorization": "Bearer ${sharedPreferences.getString("token")}",
      }),
    );

    var item = response.data;
    print("Sales Entry Response ==> $item");

    if (item["status"] == true || item["success"] == true) {
      emtyMethodAll();
      salesCartList.clear();
       CustomSnackBar.showTopSnackBar(context, "${item["message"]}");
       Navigator.push(context,MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: "${item["salesId"]}")));
    } else {
      Utils.showTopSnackBar(context, "${item["message"] ?? "Failed"}");
    }
  } catch (e) {
    print("Error in addSales: $e");
    Utils.errorSnackBar(
        context, "Connection Error: ${e.toString()}");
  } finally {
    setState(() {
      isSellBtnClk = false;
    });
  }
}
}
Widget infoText(String title, String value, {bool alignEnd = false}) {
  return Row(
    mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Text("$title ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.sp)),
      Flexible(child: Text(value, style: TextStyle(fontSize: 10.sp))),
    ],
  );
}

Widget summaryRow(String title, String value, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.sp)),
      Text(
        value,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    ],
  );
}
