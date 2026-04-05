import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_record_provider.dart';
import 'package:barishal_surgical/screens/modules/sales_module_screens/sales_invoice_screen.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../models/administration_module_models/categories_model.dart';
import '../../../models/administration_module_models/customer_list_model.dart';
import '../../../models/administration_module_models/employees_model.dart';
import '../../../models/administration_module_models/product_list_model.dart';
import '../../../providers/administration_module_providers/categories_provider.dart';
import '../../../providers/administration_module_providers/customer_list_provider.dart';
import '../../../providers/administration_module_providers/employees_provider.dart';
import '../../../providers/administration_module_providers/products_list_provider.dart';
import '../../../providers/sales_module_providers/sales_provider.dart';
import '../../../utils/utils.dart';

class SalesRecordScreen extends StatefulWidget {
  const SalesRecordScreen({super.key});
  @override
  State<SalesRecordScreen> createState() => _SalesRecordScreenState();
}

class _SalesRecordScreenState extends State<SalesRecordScreen> {
  String isColor = "";
  String isSize = "";
  int? decimal = 0;
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isColor= "${sharedPreferences?.getString('is_color')}";
    isSize= "${sharedPreferences?.getString('is_size')}";
    decimal = int.parse("${sharedPreferences?.getString('decimal')}");
  }

  Color getColor(Set<MaterialState> states) {
    return Colors.blue.shade100;
  }
  Color getColors(Set<MaterialState> states) {
    return Colors.white;
  }
  Color getColorWithDetails(Set<MaterialState> states) {
    return Colors.purple.shade100;
  }
  Color getColorTotal(Set<MaterialState> states) {
    return Colors.blue.shade900;
  }
  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondtDate;

  var toDay = DateTime.now();
  void _firstSelectedDate() async {
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
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
      });
    }
  }

  String? secondPickedDate;
  void _secondSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndSecondtDate = Utils.formatBackEndDate(selectedDate);
      });
    }else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondtDate = Utils.formatBackEndDate(toDay);
      });
    }
  }

  //main dropdowns logic
  bool isAllTypeClicked = true;
  bool isCustomerWiseClicked = false;
  bool isEmployeeWiseClicked = false;
  bool isCategoryWiseClicked = false;
  bool isQuantityWiseClicked = false;
  bool isUserWiseClicked = false;

  //sub dropdowns logic
  bool isWithoutDetailsClicked = true;
  bool isWithDetailsClicked = false;
  bool isCategorySelect = false;
  bool isQuantitySelect = false;

  // dropdown value
  String? _selectCustomerId;
  String? _selectEmployeeId;
  String? _selectCategoryId;
  String? _selectQtyProductId;
  String? _selectUserId;

  // util
  String data = '';
  bool selectArea = false;
//
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Employee',
    'By Category',
    'By Quantity',
    'By User',
  ];
  void _searchTypeDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromLTRB(
      button.localToGlobal(Offset.zero, ancestor: overlay).dx + button.size.width,
      button.localToGlobal(Offset.zero, ancestor: overlay).dy+80.h,
      overlay.size.width - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dx,
      overlay.size.height - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dy,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.teal.shade900,
      items: _searchTypes.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        return PopupMenuItem<String>(
          value: type,
          height: 22.0.h,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                child: Text(type, style: AllTextStyle.saveButtonTextStyle),
              ),
              if (index != _searchTypes.length - 1)
                Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade400),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      setState(() {
        _selectedSearchTypes = selectedValue.toString();
        _selectedSearchTypes == "All"
            ? isAllTypeClicked = true
            : isAllTypeClicked = false;

        _selectedSearchTypes == "By Customer"
            ? isCustomerWiseClicked = true
            : isCustomerWiseClicked = false;

        _selectedSearchTypes == "By Employee"
            ? isEmployeeWiseClicked = true
            : isEmployeeWiseClicked = false;

        _selectedSearchTypes == "By Category"
            ? isCategoryWiseClicked = true
            : isCategoryWiseClicked = false;

        _selectedSearchTypes == "By Quantity"
            ? isQuantityWiseClicked = true
            : isQuantityWiseClicked = false;

        _selectedSearchTypes == "By User"
            ? isUserWiseClicked = true
            : isUserWiseClicked = false;
        emtyMethod();
      });
    }
  }

  String? _selectedRecordTypes = 'Without Details';
  final List<String> _recordType = [
    'Without Details',
    'With Details',
  ];
  void _recordTypeDropdown(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      button.localToGlobal(Offset.zero, ancestor: overlay).dx + button.size.width,
      button.localToGlobal(Offset.zero, ancestor: overlay).dy + 190.h,
      overlay.size.width - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dx,
      overlay.size.height - button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay).dy,
    );

    final String? selectedValue = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.teal.shade900,
      items: _recordType.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        return PopupMenuItem<String>(
          value: type,
          height: 22.0.h,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                child: Text(type, style: AllTextStyle.saveButtonTextStyle),
              ),
              if (index != _recordType.length - 1)
                Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade400),
            ],
          ),
        );
      }).toList(),
    );

    if (selectedValue != null) {
      setState(() {
        _selectedRecordTypes = selectedValue;
        _selectedRecordTypes == "Without Details"
            ? isWithoutDetailsClicked = true
            : isWithoutDetailsClicked = false;
        _selectedRecordTypes == "With Details"
            ? isWithDetailsClicked = true
            : isWithDetailsClicked = false;
      });
    }
  }
  // by user
  String? byUserId;
  String? byUserFullname;
  String userFullName = "";
  final provideSalesdetailsRecordList = [];
  ///Sub total
  double? subTotal;
  double? vatTotal;
  double? discountTotal;
  double? transferCost;
  double? totalAmount;
  double? paidTotal;
  double? dueTotal;
  double? soldQuantity;
  double? totalQuantity;
  double? totalQuantitySD;
  double? totalAmountSD;
  double? totalQuantitySbS;
  @override
  void initState() {
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<ProductListProvider>(context, listen: false).getProductList(context);
    Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList(context);
    Provider.of<EmployeesProvider>(context, listen: false).getEmployees(context);
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,"");
    //Provider.of<SalesProvider>(context,listen: false).getSales(context,"", "", "", "", "", "");
     Provider.of<SalesProvider>(context, listen: false).getSales(context,"","","","",backEndFirstDate,backEndSecondtDate);
    Provider.of<SalesRecordProvider>(context,listen: false).getSalesRecord(context,"", "", "", "", "");
    // Provider.of<SaleBySummeryProvider>(context, listen: false).getSaleBySummery(context, "", backEndFirstDate, backEndSecondtDate);
    super.initState();
  }

  var customerController = TextEditingController();
  var productController = TextEditingController();
  var employeeController = TextEditingController();
  var categoryController = TextEditingController();
  var userController = TextEditingController();

  emtyMethod() {
    setState(() {
      customerController.text= "";
      employeeController.text="";
      categoryController.text="";
      productController.text= "";
      userController.text = "";
      _selectCustomerId = "";
      _selectEmployeeId = "";
      _selectQtyProductId ="";
      _selectUserId = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    ///get Sales
    final allSalesData = Provider.of<SalesProvider>(context).saleslist;
    subTotal = allSalesData.map((e) => e.saleMasterSubTotalAmount).fold(0.0, (p, element) => p!+double.parse(element));
    vatTotal = allSalesData.map((e) => e.saleMasterTaxAmount).fold(0.0, (p, element) => p!+double.parse(element));
    discountTotal = allSalesData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, element) => p!+double.parse(element));
    transferCost = allSalesData.map((e) => e.saleMasterFreight).fold(0.0, (p, element) => p!+double.parse(element));
    totalAmount = allSalesData.map((e) => e.saleMasterTotalSaleAmount).fold(0.0, (p, element) => p!+double.parse(element));
    paidTotal = allSalesData.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    dueTotal = allSalesData.map((e) => e.saleMasterDueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    ///get Sales
    final allSalesRecordData = Provider.of<SalesRecordProvider>(context).salesRecordlist;

    ///get Customer
     final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo !=0).toList();
    ///Categories list
     final allCategoriesData = Provider.of<CategoriesProvider>(context).categoriesList;
    /// Get Employees
     final allGetEmployeesData = Provider.of<EmployeesProvider>(context).employeesList;
    ///get Sale_details
    // final allSaleDetailsData = Provider.of<SaleDetailsProvider>(context).saleDetailsList;
    /// Summassion
    // totalQuantitySD = allSaleDetailsData.map((e) => e.quantity).fold(0.0, (p, element) => p!+double.parse("$element"));
    // totalAmountSD = allSaleDetailsData.map((e) => e.total).fold(0.0, (p, element) => p!+double.parse(element));
    ///get sale_Bysummary
    // final allSaleBySummaryData = Provider.of<SaleBySummeryProvider>(context).saleBySummeryList;
    // totalQuantitySbS = allSaleBySummaryData.map((e) => e.quantityTotal).fold(0.0, (p, element) => p!+double.parse("$element"));
    /// all products list
    final allProductsData = Provider.of<ProductListProvider>(context).productsList;
    /// get user
    // final allGetUserlistData = Provider.of<AllGetUserlistProvider>(context).getAllUserList;
    return Scaffold(
      appBar: CustomAppBar(title: "Sales Record"),
      body: Container(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 8.0.h,bottom: 10.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w,top: 4.0.h,bottom: 4.0.h),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10.0.r),
                border: Border.all(color: const Color.fromARGB(255, 7, 125, 180),width: 1.0.w),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.6), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Search Type", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _searchTypeDropdown(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            height: 25.0.h,
                            decoration: ContDecoration.contDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedSearchTypes ?? 'Please select a type',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                Icon(Icons.arrow_drop_down,color: Colors.grey.shade700),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  isCustomerWiseClicked == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
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
                                  suffixIcon: _selectCustomerId == '' || _selectCustomerId == 'null' || _selectCustomerId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        customerController.clear();
                                        controller.clear();
                                        _selectCustomerId = null;
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
                                return allCustomerData.where((element) =>
                                    element.displayName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                              });
                            },
                            itemBuilder: (context, CustomerListModel suggestion) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                child: Text(suggestion.displayName!,
                                  style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            onSelected: (CustomerListModel suggestion) {
                              setState(() {
                                customerController.text = suggestion.displayName!;
                                _selectCustomerId = suggestion.customerSlNo.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ): Container(),

                  isEmployeeWiseClicked == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Employee", style: AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<EmployeesModel>(
                            controller: employeeController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                  isDense: true,
                                  hintText: 'Select Employee',
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  suffixIcon: _selectEmployeeId == '' || _selectEmployeeId == 'null' || _selectEmployeeId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        employeeController.clear();
                                        controller.clear();
                                        _selectEmployeeId = null;
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
                                employeeController.text = suggestion.displayName!;
                                _selectEmployeeId = suggestion.employeeSlNo.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                  ///by category
                  isCategoryWiseClicked == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("Category",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<CategoriesModel>(
                            controller: categoryController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                  isDense: true,
                                  hintText: 'Select Category',
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  suffixIcon: _selectCategoryId == '' || _selectCategoryId == 'null' || _selectCategoryId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        categoryController.clear();
                                        controller.clear();
                                        _selectCategoryId = null;
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
                                return allCategoriesData.where((element) =>
                                    element.productCategoryName!.toLowerCase().contains(pattern.toLowerCase())).toList();
                              });
                            },
                            itemBuilder: (context, CategoriesModel suggestion) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                child: Text(suggestion.productCategoryName!,
                                  style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            onSelected: (CategoriesModel suggestion) {
                              setState(() {
                                categoryController.text = suggestion.productCategoryName!;
                                _selectCategoryId = suggestion.productCategorySlNo.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  isQuantityWiseClicked == true ?
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1, child: Text("Employee", style: AllTextStyle.textFieldHeadStyle)),
                          Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 25.0.h,
                              margin: EdgeInsets.only(top: 4.h),
                              child: TypeAheadField<EmployeesModel>(
                                controller: employeeController,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                      isDense: true,
                                      hintText: 'Select Employee',
                                      hintStyle: TextStyle(fontSize: 13.sp),
                                      suffixIcon: _selectEmployeeId == '' || _selectEmployeeId == 'null' || _selectEmployeeId == null || controller.text == '' ? null
                                          : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            employeeController.clear();
                                            controller.clear();
                                            _selectEmployeeId = null;
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
                                    employeeController.text = suggestion.displayName!;
                                    _selectEmployeeId = suggestion.employeeSlNo.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1, child: Text("Product",style:AllTextStyle.textFieldHeadStyle)),
                          Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 25.0.h,
                              margin: EdgeInsets.only(top: 4.h),
                              child: TypeAheadField<ProductListModel>(
                                controller: productController,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                    decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                      isDense: true,
                                      hintText: 'Select Product',
                                      hintStyle: TextStyle(fontSize: 13.sp),
                                      suffixIcon: _selectQtyProductId == '' || _selectQtyProductId == 'null' || _selectQtyProductId == null || controller.text == '' ? null
                                          : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController.clear();
                                            controller.clear();
                                            _selectQtyProductId = null;
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
                                    return allProductsData.where((element) =>
                                        element.displayText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                  });
                                },
                                itemBuilder: (context, ProductListModel suggestion) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                    child: Text(suggestion.displayText!,
                                      style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                                onSelected: (ProductListModel suggestion) {
                                  setState(() {
                                    productController.text = suggestion.displayText!;
                                    _selectQtyProductId = suggestion.productSlNo.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : Container(),
                  isUserWiseClicked == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text("User",style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 25.0.h,
                          margin: EdgeInsets.only(top: 4.h),
                          child: TypeAheadField<ProductListModel>(
                            controller: userController,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 10.h, left: 5.0.w),
                                  isDense: true,
                                  hintText: 'Select User',
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  suffixIcon: _selectUserId == '' || _selectUserId == 'null' || _selectUserId == null || controller.text == '' ? null
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        userController.clear();
                                        controller.clear();
                                        _selectUserId = null;
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
                                return allProductsData.where((element) =>
                                    element.displayText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                              });
                            },
                            itemBuilder: (context, ProductListModel suggestion) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                                child: Text(suggestion.displayText!,
                                  style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            onSelected: (ProductListModel suggestion) {
                              setState(() {
                                userController.text = suggestion.displayText!;
                                _selectUserId = suggestion.productSlNo.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ): Container(),
                  isAllTypeClicked == true||isCustomerWiseClicked==true||isEmployeeWiseClicked==true||isUserWiseClicked==true
                      ? Row(
                    children: [
                      Expanded(flex: 1, child: Text("Record Type", style:AllTextStyle.textFieldHeadStyle)),
                      Text(":   ",style:AllTextStyle.textFieldHeadStyle),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _recordTypeDropdown(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            margin: EdgeInsets.only(top: 4.h),
                            height: 25.0.h,
                            decoration: ContDecoration.contDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedRecordTypes ?? 'Please select a type',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                Icon(Icons.arrow_drop_down,color: Colors.grey.shade700),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                  SizedBox(
                    height: 35.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 5.w, top: 5.h, bottom: 5.h),
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.0.r),
                            decoration:ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {_firstSelectedDate();}),
                              child: TextFormField(
                                style: AllTextStyle.dateFormatStyle,
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: firstPickedDate ,
                                    hintStyle: AllTextStyle.dateFormatStyle
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
                        const Text("To"),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
                            height: 25.0.h,
                            padding: EdgeInsets.all(5.0.r),
                            decoration:ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {_secondSelectedDate();
                              }),
                              child: TextFormField(
                                style: AllTextStyle.dateFormatStyle,
                                enabled: false,
                                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 5.w),
                                    filled: true,
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Icon(Icons.calendar_month, color: Color.fromARGB(221, 22, 51, 95), size: 16.r),
                                    ),
                                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                                    hintText: secondPickedDate,
                                    hintStyle: AllTextStyle.dateFormatStyle
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
                  ),
                  /// Date Picker
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(1.0.r),
                      child: InkWell(
                        onTap: () async {
                          // final connectivityResult = await (Connectivity().checkConnectivity());
                          // if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                            SalesProvider().on();
                            SalesRecordProvider().on();
                            // SaleDetailsProvider().on();
                            // SaleBySummeryProvider().on();
                            setState(() {
                              if (isAllTypeClicked && isWithoutDetailsClicked) {
                                data = 'showAllWithoutDetails';
                                ///get sale AllType
                                Provider.of<SalesProvider>(context, listen: false).getSales(context,
                                    "",
                                    "",
                                    "",
                                    "",
                                    backEndFirstDate,
                                    backEndSecondtDate
                                );
                              }
                              else if (isAllTypeClicked && isWithDetailsClicked) {
                                data = 'showAllWithDetails';
                                ///get sale api AllType
                                Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(context,
                                    "",
                                    "",
                                    "",
                                    backEndFirstDate,
                                    backEndSecondtDate
                                );
                              }
                              /// By Customer
                              else if (isCustomerWiseClicked && isWithoutDetailsClicked) {
                                data = 'showByCustomerWithoutDetails';
                                ///get sale CustomerType
                                Provider.of<SalesProvider>(context, listen: false).getSales(context,
                                    "",
                                    _selectCustomerId,
                                    "",
                                    "",
                                    backEndFirstDate,
                                    backEndSecondtDate
                                );
                              }
                              else if (isCustomerWiseClicked && isWithDetailsClicked) {
                                data = 'showByCustomerWithDetails';
                                ///get sales Record api CustomerType
                                Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(context,
                                    "",
                                    _selectCustomerId,
                                    "",
                                    backEndFirstDate,
                                    backEndSecondtDate
                                );
                              }
                              /// By Employee
                              else if (isEmployeeWiseClicked && isWithoutDetailsClicked) {
                                data = 'showByEmployeeWithoutDetails';
                                ///get sales api EmployeeType
                                Provider.of<SalesProvider>(context, listen: false).getSales(context,
                                    "",
                                    "",
                                    _selectEmployeeId,
                                    "",
                                    backEndFirstDate,
                                    backEndSecondtDate,
                                );
                              }
                              else if (isEmployeeWiseClicked && isWithDetailsClicked) {
                                data = 'showByEmployeeWithDetails';
                                ///get sales Record api  EmployeeType
                                Provider.of<SalesRecordProvider>(context, listen: false).getSalesRecord(context,
                                    "",
                                    "",
                                    _selectEmployeeId,
                                    backEndFirstDate,
                                    backEndSecondtDate
                                );
                              }
                              // /// By Category
                              // else if (isCategoryWiseClicked) {
                              //   data = 'showByCategoryDetails';
                              //   ///get sale_details categoryType
                              //   Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(context,
                              //     "$_selectedCategoryTypes",
                              //     "$backEndFirstDate",
                              //     "$backEndSecondtDate",
                              //     "",
                              //   );
                              // }
                              // // By Quantity
                              // else if (isQuantityWiseClicked) {
                              //   data = 'showByQuantityDetails';
                              //   ///get sale_details QuantityType
                              //   Provider.of<SaleDetailsProvider>(context, listen: false).getSaleDetails(context,
                              //     "",
                              //     "$backEndFirstDate",
                              //     "$backEndSecondtDate",
                              //     "$_selectedQuantityTypes",
                              //   );
                              // }
                              // /// By Summary
                              // else if (isSummaryWiseClicked) {
                              //   data = 'showBySummaryDetails';
                              //   ///get sale by Summary
                              //   Provider.of<SaleBySummeryProvider>(context, listen: false).getSaleBySummery(context,
                              //     "$_selectedCategoryTypes",
                              //     "$backEndFirstDate",
                              //     "$backEndSecondtDate",
                              //   );
                              // }
                              // // By User
                              // else if (isUserWiseClicked && isWithoutDetailsClicked) {
                              //   data = 'showByUserWithoutDetails';
                              //   ///get sales api UserType
                              //   Provider.of<GetSaleProvider>(context, listen: false).getGetSale(context,
                              //     "",
                              //     backEndFirstDate,
                              //     backEndSecondtDate,
                              //     _selectedRecordTypes,
                              //     "",
                              //     _selectedUserTypes,
                              //   );
                              // }
                              // else if (isUserWiseClicked && isWithDetailsClicked) {
                              //   data = 'showByUserWithDetails';
                              //   ///get sales Record api UserType
                              //   Provider.of<GetSaleProvider>(context, listen: false).getGetSale(context,
                              //     "",
                              //     backEndFirstDate,
                              //     backEndSecondtDate,
                              //     _selectedRecordTypes,
                              //     "",
                              //     _selectedUserTypes,
                              //   );
                              // }
                            });
                          //}
                          // else{
                          //   Utils.errorSnackBar(context, "Please connect with internet");
                          // }
                        },
                        child: Container(
                          height: 28.0.h,
                          width: 102.0.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 4, 113, 185),
                            borderRadius: BorderRadius.circular(5.0.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(child: Text("Show Report", style:AllTextStyle.saveButtonTextStyle)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            data == 'showAllWithoutDetails'
                ? Expanded(
              child: SalesProvider.isSalesLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesData.isNotEmpty?
              SizedBox(
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
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
                          showCheckboxColumn: true,
                          border: TableBorder.all(color: Colors.blue.shade200, width: 1.w),
                          columns: [
                            DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Sub Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Vat',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Discount',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Transport Cost',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Paid',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Due',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Note',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Status',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                          ],
                          rows: [
                            ...List.generate(
                              allSalesData.length,
                                  (int index) => DataRow(
                                color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                                cells: <DataCell>[
                                  DataCell(Center(child: Text("${index+1}"))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterInvoiceNo))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterSaleDate))),
                                  DataCell(Center(child: Text(allSalesData[index].customerName))),
                                  DataCell(Center(child: Text(allSalesData[index].employeeName??""))),
                                  DataCell(Center(child: Text(allSalesData[index].addedBy))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterSubTotalAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTaxAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalDiscountAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterFreight).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalSaleAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterPaidAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterDueAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterDescription))),
                                  DataCell(Center(child: Container(
                                      decoration: BoxDecoration(
                                          color:allSalesData[index].status=="a"? Colors.teal:Colors.yellow.shade900,
                                          borderRadius: BorderRadius.circular(100.r)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Text(allSalesData[index].status=="a"?"Approved":"Pending",style:TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.w500)),
                                      )))),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: Icon(Icons.collections_bookmark,size: 18.r),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesData[index].saleMasterSlNo)));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Footer row
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                                const DataCell(Center(child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(subTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(vatTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(discountTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(transferCost!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalAmount!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(paidTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(dueTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red)))),
            )
                : data == 'showAllWithDetails'
                ? Expanded(
              child: SalesRecordProvider.isSalesRecordLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 20.0,
                      dataRowMaxHeight: double.infinity,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.purple.shade800),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.blue.shade200, width: 1.w),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Price',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows:
                      List.generate(
                        allSalesRecordData.length,
                            (int index) =>
                            DataRow(
                              color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorWithDetails):MaterialStateProperty.resolveWith(getColors),
                              cells: <DataCell>[
                                DataCell(Center(child: Text("${index+1}"))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterInvoiceNo))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterSaleDate))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(child: Text(allSalesRecordData[index].customerName??"",overflow: TextOverflow.ellipsis)),
                                  ),
                                ),
                                DataCell(Center(child: Text(allSalesRecordData[index].employeeName??""))),
                                DataCell(Center(child: Text(allSalesRecordData[index].addedBy))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(
                                      child:Column(
                                          children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                            return Center(child: Text(allSalesRecordData[index].saleDetails![j].productName,overflow: TextOverflow.ellipsis),
                                            );
                                          })),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsRate).toStringAsFixed(decimal!)),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text("${allSalesRecordData[index].saleDetails![j].saleDetailsTotalQuantity}"),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsTotalAmount).toStringAsFixed(decimal!)),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child:GestureDetector(
                                      child: Icon(Icons.collections_bookmark,size: 18.r),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesRecordData[index].saleMasterSlNo),
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle),)),
            )
                : data == 'showByCustomerWithoutDetails'
                ? Expanded(
              child: SalesProvider.isSalesLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesData.isNotEmpty?
              SizedBox(
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
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
                          showCheckboxColumn: true,
                          border: TableBorder.all(color: Colors.blue.shade200, width: 1.w),
                          columns: [
                            DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Sub Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Vat',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Discount',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Transport Cost',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Paid',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Due',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Note',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Status',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                          ],
                          rows: [
                            ...List.generate(
                              allSalesData.length,
                                  (int index) => DataRow(
                                color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                                cells: <DataCell>[
                                  DataCell(Center(child: Text("${index+1}"))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterInvoiceNo))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterSaleDate))),
                                  DataCell(Center(child: Text(allSalesData[index].customerName))),
                                  DataCell(Center(child: Text(allSalesData[index].employeeName??""))),
                                  DataCell(Center(child: Text(allSalesData[index].addedBy))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterSubTotalAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTaxAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalDiscountAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterFreight).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalSaleAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterPaidAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterDueAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterDescription))),
                                  DataCell(Center(child: Container(
                                    decoration: BoxDecoration(
                                      color:allSalesData[index].status=="a"? Colors.teal:Colors.yellow.shade900,
                                      borderRadius: BorderRadius.circular(100.r)
                                    ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Text(allSalesData[index].status=="a"?"Approved":"Pending",style:TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.w500)),
                                      )))),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: Icon(Icons.collections_bookmark,size: 18.r),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesData[index].saleMasterSlNo)));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Footer row
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                                const DataCell(Center(child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(subTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(vatTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(discountTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(transferCost!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalAmount!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(paidTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(dueTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))),
            )
                : data == 'showByCustomerWithDetails'
                ? Expanded(
              child: SalesRecordProvider.isSalesRecordLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 20.0,
                      dataRowMaxHeight: double.infinity,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.purple.shade800),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.blue.shade200, width: 1.w),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Price',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows:
                      List.generate(
                        allSalesRecordData.length,
                            (int index) =>
                            DataRow(
                              color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorWithDetails):MaterialStateProperty.resolveWith(getColors),
                              cells: <DataCell>[
                                DataCell(Center(child: Text("${index+1}"))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterInvoiceNo))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterSaleDate))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(child: Text(allSalesRecordData[index].customerName??"",overflow: TextOverflow.ellipsis)),
                                  ),
                                ),
                                DataCell(Center(child: Text(allSalesRecordData[index].employeeName??""))),
                                DataCell(Center(child: Text(allSalesRecordData[index].addedBy))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(
                                      child:Column(
                                          children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                            return Center(child: Text(allSalesRecordData[index].saleDetails![j].productName,overflow: TextOverflow.ellipsis),
                                            );
                                          })),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsRate).toStringAsFixed(decimal!)),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text("${allSalesRecordData[index].saleDetails![j].saleDetailsTotalQuantity}"),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsTotalAmount).toStringAsFixed(decimal!)),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child:GestureDetector(
                                      child: Icon(Icons.collections_bookmark,size: 18.r),
                                      onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesRecordData[index].saleMasterSlNo)));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))),
            )
                : data == 'showByEmployeeWithoutDetails'
                ? Expanded(
              child: SalesProvider.isSalesLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesData.isNotEmpty?
              SizedBox(
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
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
                          showCheckboxColumn: true,
                          border: TableBorder.all(color: Colors.blue.shade200, width: 1.w),
                          columns: [
                            DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Sub Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Vat',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Discount',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Transport Cost',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Paid',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Due',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Note',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Status',style:AllTextStyle.tableHeadTextStyle)))),
                            DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                          ],
                          rows: [
                            ...List.generate(
                              allSalesData.length,
                                  (int index) => DataRow(
                                color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
                                cells: <DataCell>[
                                  DataCell(Center(child: Text("${index+1}"))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterInvoiceNo))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterSaleDate))),
                                  DataCell(Center(child: Text(allSalesData[index].customerName))),
                                  DataCell(Center(child: Text(allSalesData[index].employeeName??""))),
                                  DataCell(Center(child: Text(allSalesData[index].addedBy))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterSubTotalAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTaxAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalDiscountAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterFreight).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterTotalSaleAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterPaidAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(double.parse(allSalesData[index].saleMasterDueAmount).toStringAsFixed(decimal!)))),
                                  DataCell(Center(child: Text(allSalesData[index].saleMasterDescription))),
                                  DataCell(Center(child: Container(
                                      decoration: BoxDecoration(
                                          color:allSalesData[index].status=="a"? Colors.teal:Colors.yellow.shade900,
                                          borderRadius: BorderRadius.circular(100.r)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Text(allSalesData[index].status=="a"?"Approved":"Pending",style:TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.w500)),
                                      )))),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: Icon(Icons.collections_bookmark,size: 18.r),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesData[index].saleMasterSlNo)));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Footer row
                            DataRow(
                              cells: <DataCell>[
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                                const DataCell(Center(child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(subTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(vatTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(discountTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(transferCost!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(totalAmount!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(paidTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text(dueTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
                                const DataCell(SizedBox()),const DataCell(SizedBox()),const DataCell(SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle))),
            )
                : data == 'showByEmployeeWithDetails'
                ? Expanded(
              child: SalesRecordProvider.isSalesRecordLoading
                  ? const Center(child: CircularProgressIndicator())
                  :allSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 20.0,
                      dataRowMaxHeight: double.infinity,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.purple.shade800),
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.blue.shade200, width: 1),
                      columns: [
                        DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Employee Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Saved By',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Price',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
                        DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                      ],
                      rows:
                      List.generate(
                        allSalesRecordData.length,
                            (int index) =>
                            DataRow(
                              color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorWithDetails):MaterialStateProperty.resolveWith(getColors),
                              cells: <DataCell>[
                                DataCell(Center(child: Text("${index+1}"))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterInvoiceNo))),
                                DataCell(Center(child: Text(allSalesRecordData[index].saleMasterSaleDate))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(child: Text(allSalesRecordData[index].customerName??"",overflow: TextOverflow.ellipsis)),
                                  ),
                                ),
                                DataCell(Center(child: Text(allSalesRecordData[index].employeeName??""))),
                                DataCell(Center(child: Text(allSalesRecordData[index].addedBy))),
                                DataCell(
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width/2.5,
                                    child: Center(
                                      child:Column(
                                          children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                            return Center(child: Text(allSalesRecordData[index].saleDetails![j].productName,overflow: TextOverflow.ellipsis),
                                            );
                                          })),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsRate).toStringAsFixed(decimal!)),
                                          );
                                        })),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text("${allSalesRecordData[index].saleDetails![j].saleDetailsTotalQuantity}"),
                                          );})),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Column(
                                        children: List.generate(allSalesRecordData[index].saleDetails!.length, (j) {
                                          return Center(child: Text(double.parse(allSalesRecordData[index].saleDetails![j].saleDetailsTotalAmount).toStringAsFixed(decimal!)),
                                          );})),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child:GestureDetector(
                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoiceScreen(salesId: allSalesRecordData[index].saleMasterSlNo)));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
              ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle),)),
            )
                : data == 'showByCategoryDetails'
                ? Expanded(
              child: SizedBox(),
              // child: SaleDetailsProvider.isSaleDetailsloading
              //     ? const Center(
              //     child:
              //     CircularProgressIndicator())
              //     : SizedBox(
              //   width: double.infinity,
              //   height: double.infinity,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           DataTable(
              //             headingRowHeight: 20.0,
              //             dataRowHeight: 20.0,
              //             headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
              //             showCheckboxColumn: true,
              //             border: TableBorder.all(color: Colors.blue.shade200, width: 1),
              //             columns: const [
              //               DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child:  Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Sales Rate',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
              //             ],
              //             rows: [
              //               ...List.generate(
              //                 allSaleDetailsData.length,
              //                     (int index) => DataRow(
              //                   color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
              //                   cells: <DataCell>[
              //                     DataCell(Center(child: Text("${index+1}"))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].invoice))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].date))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].customerName))),
              //                     DataCell(SizedBox(width: 160, child: Text(allSaleDetailsData[index].name.toString().trim()))),
              //                     DataCell(Center(child: Text(double.parse(allSaleDetailsData[index].unitPrice).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text('${allSaleDetailsData[index].quantity}'))),
              //                   ],
              //                 ),
              //               ),
              //               // Footer row
              //               DataRow(
              //                 cells: <DataCell>[
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(Center(child: Text('Total Quantity',style:TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(totalQuantitySD!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            )
                : data == 'showByQuantityDetails'
                ? Expanded(
              child: SizedBox(),
              // child: SaleDetailsProvider.isSaleDetailsloading
              //     ? const Center(
              //     child: CircularProgressIndicator())
              //     : SizedBox(
              //   width: double.infinity,
              //   height: double.infinity,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           DataTable(
              //             headingRowHeight: 20.0,
              //             dataRowHeight: 20.0,
              //             headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
              //             showCheckboxColumn: true,
              //             border: TableBorder.all(color: Colors.blue.shade200, width: 1),
              //             columns: const [
              //               DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child:  Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Sales Rate',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
              //             ],
              //             rows: [
              //               ...List.generate(
              //                 allSaleDetailsData.length,
              //                     (int index) => DataRow(
              //                   color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
              //                   cells: <DataCell>[
              //                     DataCell(Center(child: Text("${index+1}"))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].invoice))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].date))),
              //                     DataCell(Center(child: Text(allSaleDetailsData[index].customerName))),
              //                     DataCell(SizedBox(width: 160, child: Text(allSaleDetailsData[index].name.toString().trim()))),
              //                     DataCell(Center(child: Text(double.parse(allSaleDetailsData[index].unitPrice).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text('${allSaleDetailsData[index].quantity}'))),
              //                   ],
              //                 ),
              //               ),
              //               // Footer row
              //               DataRow(
              //                 cells: <DataCell>[
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(Center(child: Text('Total Quantity',style:TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(totalQuantitySD!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            )
                : data == 'showBySummaryDetails'
                ? Expanded(
              child: SizedBox(),
              // child: SaleBySummeryProvider.isSaleBySummeryloading
              //     ? const Center(child: CircularProgressIndicator())
              //     : SizedBox(width: double.infinity,
              //   height: double.infinity,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           DataTable(
              //             headingRowHeight: 20.0,
              //             dataRowMaxHeight: double.infinity,
              //             headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
              //             showCheckboxColumn: true,
              //             border: TableBorder.all(color: Colors.blue.shade200, width: 1),
              //             columns: const [
              //               DataColumn(label: Expanded(child: Center(child: Text('Product Sl.',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Product ID',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Category',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Product',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Total Qty',style:AllTextStyle.tableHeadTextStyle)))),
              //             ],
              //             rows: [
              //               ...List.generate(
              //                 allSaleBySummaryData.length,
              //                     (int index) => DataRow(
              //                   color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
              //                   cells: <DataCell>[
              //                     DataCell(Center(child: Text("${index+1}"))),
              //                     DataCell(
              //                       SizedBox(
              //                         width:MediaQuery.of(context).size.width/2.5,
              //                         child: Center(
              //                           child:Column(
              //                               children: List.generate(allSaleBySummaryData[index].products!.length, (j) {
              //                                 return Center(child: Text(allSaleBySummaryData[index].products![j].code,overflow: TextOverflow.ellipsis),
              //                                 );
              //                               })),
              //                         ),
              //                       ),
              //                     ),
              //                     DataCell(Center(child: Text(allSaleBySummaryData[index].name))),
              //                     DataCell(
              //                       Center(
              //                         child: Column(
              //                             children: List.generate(allSaleBySummaryData[index].products!.length, (j) {
              //                               return Center(child: Text(allSaleBySummaryData[index].products![j].name),
              //                               );
              //                             })),
              //                       ),
              //                     ),
              //                     DataCell(
              //                       Center(
              //                         child: Column(
              //                             children: List.generate(allSaleBySummaryData[index].products!.length, (j) {
              //                               return Center(child: Text("${allSaleBySummaryData[index].products![j].quantity}"),
              //                               );
              //                             })),
              //                       ),
              //                     ),
              //                     DataCell(Center(child: Text("${allSaleBySummaryData[index].quantityTotal}"))),
              //                   ],
              //                 ),
              //               ),
              //               // Footer row
              //               DataRow(
              //                 cells: <DataCell>[
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(Center(child: Text('Category Wise Total',style:TextStyle(fontWeight: FontWeight.bold)))),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(Center(child: Text('Total Quantity',style:TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(totalQuantitySbS!.toStringAsFixed(0),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            )
                : data == 'showByUserWithoutDetails'
                ? Expanded(
              child: SizedBox(),
              // child: GetSaleProvider.isSaleTypeChange ? const Center(child: CircularProgressIndicator())
              //     :allGetSaleData.isNotEmpty?
              // SizedBox(width: double.infinity, height: double.infinity,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           DataTable(
              //             headingRowHeight: 20.0,
              //             dataRowHeight: 20.0,
              //             headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo.shade900),
              //             showCheckboxColumn: true,
              //             border: TableBorder.all(color: Colors.blue.shade200, width: 1),
              //             columns: const [
              //               DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Sub Total',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Vat',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Discount',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Transport Cost',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Paid',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Due',style:AllTextStyle.tableHeadTextStyle)))),
              //               DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
              //             ],
              //             rows: [
              //               ...List.generate(
              //                 allGetSaleData.length,
              //                     (int index) => DataRow(
              //                   color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColor):MaterialStateProperty.resolveWith(getColors),
              //                   cells: <DataCell>[
              //                     DataCell(Center(child: Text("${index+1}"))),
              //                     DataCell(Center(child: Text(allGetSaleData[index].invoice))),
              //                     DataCell(Center(child: Text(allGetSaleData[index].date))),
              //                     DataCell(Center(child: Text(allGetSaleData[index].customer == null ? allGetSaleData[index].customerName ?? 'N/A' : allGetSaleData[index].customer!.name))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].subtotal).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].vatAmount).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].discountAmount).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].transportCost).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].total).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].paid).toStringAsFixed(decimal!)))),
              //                     DataCell(Center(child: Text(double.parse(allGetSaleData[index].due).toStringAsFixed(decimal!)))),
              //                     DataCell(
              //                       Center(
              //                         child:GestureDetector(
              //                           child: const Icon(Icons.collections_bookmark,size: 18),
              //                           onTap: () {
              //                             if(isSize == "true" && isColor == "true"){
              //                               Navigator.push(context, MaterialPageRoute(builder: (context) => ColorSizeInvoicePage(salesId: "${allGetSaleData[index].id}")));
              //                             }
              //                             else if(isSize == "true"){
              //                               Navigator.push(context, MaterialPageRoute(builder: (context) => SizeInvoicePage(salesId: "${allGetSaleData[index].id}")));
              //                             }
              //                             else if(isColor == "true"){
              //                               Navigator.push(context, MaterialPageRoute(builder: (context) => ColorInvoicePage(salesId: "${allGetSaleData[index].id}")));
              //                             }
              //                             else{
              //                               Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(salesId: "${allGetSaleData[index].id}")));
              //                             }
              //                           },
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               // Footer row
              //               DataRow(
              //                 cells: <DataCell>[
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(SizedBox()),
              //                   const DataCell(Center(child: Text('Total',style:TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(subTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(vatTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(discountTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(transferCost!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(totalAmount!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(paidTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   DataCell(Center(child: Text(dueTotal!.toStringAsFixed(decimal!),style:const TextStyle(fontWeight: FontWeight.bold)))),
              //                   const DataCell(SizedBox()),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style:AllTextStyle.nofoundTextStyle),)),
              //
            )
                : data == 'showByUserWithDetails'
                ? Expanded(
              child: SizedBox(),
            //   child: GetSaleProvider.isSaleTypeChange
            //     ? const Center(child: CircularProgressIndicator())
            //     : allGetSaleData.isNotEmpty?
            // SizedBox(width: double.infinity, height: double.infinity,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: DataTable(
            //         headingRowHeight: 20.0,
            //         dataRowMaxHeight: double.infinity,
            //         headingRowColor: MaterialStateColor.resolveWith((states) => Colors.purple.shade800),
            //         showCheckboxColumn: true,
            //         border: TableBorder.all(color: Colors.blue.shade200, width: 1),
            //         columns: const [
            //           DataColumn(label: Expanded(child: Center(child: Text('Sl.',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Invoice No',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Customer Name',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Product Name',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Price',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Quantity',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Total',style:AllTextStyle.tableHeadTextStyle)))),
            //           DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
            //         ],
            //         rows:
            //         List.generate(
            //           allGetSaleData.length,
            //               (int index) =>
            //               DataRow(
            //                 color:index % 2 == 0 ? MaterialStateProperty.resolveWith(getColorWithDetails):MaterialStateProperty.resolveWith(getColors),
            //                 cells: <DataCell>[
            //                   DataCell(Center(child: Text("${index+1}"))),
            //                   DataCell(Center(child: Text(allGetSaleData[index].invoice))),
            //                   DataCell(Center(child: Text(allGetSaleData[index].date))),
            //                   DataCell(
            //                     SizedBox(
            //                       width:MediaQuery.of(context).size.width/2.5,
            //                       child: Center(child: Text(allGetSaleData[index].customer == null ? allGetSaleData[index].customerName ?? "N/A" : allGetSaleData[index].customer!.name,overflow: TextOverflow.ellipsis)),
            //
            //                     ),
            //                   ),
            //                   DataCell(
            //                     SizedBox(
            //                       width:MediaQuery.of(context).size.width/2.5,
            //                       child: Center(
            //                         child:Column(
            //                             children: List.generate(allGetSaleData[index].saleDetails!.length, (j) {
            //                               return Center(child: Text(allGetSaleData[index].saleDetails![j].name,overflow: TextOverflow.ellipsis),
            //                               );
            //                             })),
            //                       ),
            //                     ),
            //                   ),
            //                   DataCell(
            //                     Center(
            //                       child: Column(
            //                           children: List.generate(allGetSaleData[index].saleDetails!.length, (j) {
            //                             return Center(child: Text(double.parse(allGetSaleData[index].saleDetails![j].unitPrice).toStringAsFixed(decimal!)),
            //                             );
            //                           })),
            //                     ),
            //                   ),
            //                   DataCell(
            //                     Center(
            //                       child: Column(
            //                           children: List.generate(allGetSaleData[index].saleDetails!.length, (j) {
            //                             return Center(child: Text("${allGetSaleData[index].saleDetails![j].quantity}"),
            //                             );
            //                           })),
            //                     ),
            //                   ),
            //                   DataCell(
            //                     Center(
            //                       child: Column(
            //                           children: List.generate(allGetSaleData[index].saleDetails!.length, (j) {
            //                             return Center(child: Text(double.parse(allGetSaleData[index].saleDetails![j].total).toStringAsFixed(decimal!)),
            //                             );
            //                           })),
            //                     ),
            //                   ),
            //                   DataCell(
            //                     Center(
            //                       child:GestureDetector(
            //                         child: const Icon(Icons.collections_bookmark,size: 18,),
            //                         onTap: () {
            //                           if(isSize == "true" && isColor == "true"){
            //                             Navigator.push(context, MaterialPageRoute(builder: (context) => ColorSizeInvoicePage(
            //                                 salesId: "${allGetSaleData[index].id}"),
            //                             ));
            //                           }
            //                           else if(isSize == "true"){
            //                             Navigator.push(context, MaterialPageRoute(builder: (context) => SizeInvoicePage(
            //                                 salesId: "${allGetSaleData[index].id}"),
            //                             ));
            //                           }
            //                           else if(isColor == "true"){
            //                             Navigator.push(context, MaterialPageRoute(builder: (context) => ColorInvoicePage(
            //                                 salesId: "${allGetSaleData[index].id}"),
            //                             ));
            //                           }
            //                           else{
            //                             Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(
            //                                 salesId: "${allGetSaleData[index].id}"),
            //                             ));
            //                           }
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            //
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
