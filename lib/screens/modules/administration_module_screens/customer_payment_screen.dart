import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/common_widget/commontype_aheadfield.dart';
import 'package:barishal_surgical/common_widget/custom_appbar.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';
import 'package:barishal_surgical/providers/administration_module_providers/customer_list_provider.dart';
import 'package:barishal_surgical/providers/sales_module_providers/bank_account_provider.dart';
import 'package:barishal_surgical/utils/all_textstyle.dart';
import 'package:barishal_surgical/utils/animation_snackbar.dart';
import 'package:barishal_surgical/utils/app_colors.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerPaymentScreen extends StatefulWidget {
  const CustomerPaymentScreen({super.key});
  @override
  State<CustomerPaymentScreen> createState() => _CustomerPaymentScreenState();
}

class _CustomerPaymentScreenState extends State<CustomerPaymentScreen> {
 SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    userImage = "${sharedPreferences?.getString('userImage')}";
    userType = "${sharedPreferences?.getString('userType')}";
    territorieId = "${sharedPreferences?.getString('territorieId')}";
    territoryName = "${sharedPreferences?.getString('territoryName')}";
    unitAreaId = "${sharedPreferences?.getString('unitAreaId')}";
    unitAreaName = "${sharedPreferences?.getString('unitAreaName')}";
    print("profile userName====$userName");
    print("profile userImage====$userImage");
    print("profile userType====$userType");
    print("unitAreaId=user===============$unitAreaId");
    print("territorieId===user=============$territorieId");
    // if(userType =="m" || userType == "a"){
    //   Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("", "", "");
    // }else{
    //   Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("", unitAreaId??"", territorieId??"");
    // }
    setState(() {
    });
  }
  String? userName = "";
  String? userImage = "";
  String? userType = "";
  String? territorieId = "";
  String? territoryName = "";
  String? unitAreaId = "";
  String? unitAreaName = "";

  Color getColor(Set<WidgetState> states) {
    return Colors.blue.shade100;
  }

  Color getColors(Set<WidgetState> states) {
    return Colors.white;
  }

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController customerDueController = TextEditingController();
  final TextEditingController previousDueController = TextEditingController();
  final TextEditingController bankAccountController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController territoriesController = TextEditingController();

   final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _percentageAmountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

//   void calculateTotal({String? changed}) {
//   double payment = double.tryParse(_paymentController.text) ?? 0;
//   double percentAmount = double.tryParse(_percentageAmountController.text) ?? 0;
//   double discount = double.tryParse(_discountController.text) ?? 0;

//   /// Percent changed → discount + total
//   if (changed == "percent") {
//     discount = percentAmount / 2;

//     _discountController.text = discount.toStringAsFixed(2);
//     _totalController.text = (payment + percentAmount).toStringAsFixed(2);
//   }

//   /// Discount changed → percent + total
//   if (changed == "discount") {
//     percentAmount = discount * 2;

//     _percentageAmountController.text =
//         percentAmount.toStringAsFixed(2);
//     _totalController.text = (payment + percentAmount).toStringAsFixed(2);
//   }

//   /// Payment changed → total update
//   if (changed == "payment") {
//     _totalController.text = (payment + percentAmount).toStringAsFixed(2);
//   }
// }

void calculateTotal({String? changed}) {
  double payment = double.tryParse(_paymentController.text) ?? 0;
  double discount = double.tryParse(_discountController.text) ?? 0;
  double percent = double.tryParse(_percentageAmountController.text) ?? 0;

  /// Discount changed → percent
  if (changed == "discount") {
      percent = (discount * 100) / (payment + discount);
      _percentageAmountController.text = percent.toStringAsFixed(2);
  }

  /// Percent changed → discount
  if (changed == "percent") {
      discount = (percent * payment) / (100 - percent);
      _discountController.text = discount.toStringAsFixed(2);
  }

  /// Total
  double total = payment + discount;
  _totalController.text = total.toStringAsFixed(2);

}

  var quantityController = TextEditingController();
  FocusNode quantityFocusNode = FocusNode();

  String? firstPickedDate;
  var backEndFirstDate;
  var toDay = DateTime.now();
  void _firstSelectedDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
      });
    } else {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
      });
    }
  }

  bool _isDropdownOpen = false;
  String? getTransactionType;
  String? _transactionType = 'Receive';
  final List<String> _transactionTypeList = ['Receive', 'Payment'];

  final LayerLink _trTypeLayerLink = LayerLink();
  OverlayEntry? _trTypeOverlayEntry;

  final GlobalKey _trkey = GlobalKey();
  Size _trTypeDropdownSize = Size.zero;

  void _getTrTypeDropdownSize(Duration _) {
    final RenderBox renderBox =
        _trkey.currentContext?.findRenderObject() as RenderBox;
    _trTypeDropdownSize = renderBox.size;
  }

  void _toggleTrTypeDropdown() {
    if (_isDropdownOpen) {
      _removeTrTypeDropdown();
    } else {
      _showTrTypeDropdown();
    }
  }

  void _showTrTypeDropdown() {
    _trTypeOverlayEntry = _createTrTypeOverlayEntry();
    Overlay.of(context).insert(_trTypeOverlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeTrTypeDropdown() {
    _trTypeOverlayEntry?.remove();
    _trTypeOverlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createTrTypeOverlayEntry() {
    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _removeTrTypeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned(
                  width: _trTypeDropdownSize.width,
                  child: CompositedTransformFollower(
                    link: _trTypeLayerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, _trTypeDropdownSize.height + 2),
                    child: Material(
                      elevation: 9.0,
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(5.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            _transactionTypeList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final type = entry.value;
                              return InkWell(
                                onTap: () {
                                  _onSelectedTRType(type);
                                  _removeTrTypeDropdown();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                      child: Text(type,style: TextStyle(fontSize: 13.sp)),
                                    ),
                                    if (index !=
                                        _transactionTypeList.length - 1)
                                      Divider(
                                        height: 1.h,
                                        thickness: 0.8,
                                        color: Colors.indigo.shade400,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _onSelectedTRType(String selectedValue) {
    setState(() {
      _transactionType = selectedValue;
      if (selectedValue == "Receive") {
        getTransactionType = "CR";
      }
      if (selectedValue == "Payment") {
        getTransactionType = "CP";
      }
    });
  }

  bool isBankListClicked = false;
  String? getPaymentType;
  String? _paymentType = 'Cash';
  final List<String> _paymentTypeList = ['Cash', 'Bank'];

  final LayerLink _pTypeLayerLink = LayerLink();
  OverlayEntry? _pTypeOverlayEntry;

  final GlobalKey _pkey = GlobalKey();
  Size _pTypeDropdownSize = Size.zero;

  void _getPTypeDropdownSize(Duration _) {
    final RenderBox renderBox =
        _pkey.currentContext?.findRenderObject() as RenderBox;
    _pTypeDropdownSize = renderBox.size;
  }

  void _togglePTypeDropdown() {
    if (_isDropdownOpen) {
      _removePTypeDropdown();
    } else {
      _showPTypeDropdown();
    }
  }

  void _showPTypeDropdown() {
    _pTypeOverlayEntry = _createPTypeOverlayEntry();
    Overlay.of(context).insert(_pTypeOverlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removePTypeDropdown() {
    _pTypeOverlayEntry?.remove();
    _pTypeOverlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createPTypeOverlayEntry() {
    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _removePTypeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned(
                  width: _pTypeDropdownSize.width,
                  child: CompositedTransformFollower(
                    link: _pTypeLayerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, _pTypeDropdownSize.height + 2),
                    child: Material(
                      elevation: 9.0,
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(5.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            _paymentTypeList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final type = entry.value;
                              return InkWell(
                                onTap: () {
                                  _onSelectedPType(type);
                                  _removePTypeDropdown();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                                      child: Text(type,style: TextStyle(fontSize: 13.sp)),
                                    ),
                                    if (index != _paymentTypeList.length - 1)
                                      Divider(
                                        height: 1.h,
                                        thickness: 0.8,
                                        color: Colors.indigo.shade400,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
  void _onSelectedPType(String selectValue) {
    setState(() {
      _paymentType = selectValue;
      if (selectValue == "Cash") {
        getPaymentType = "cash";
      }
      if (selectValue == "Bank") {
        getPaymentType = "bank";
      }
      _paymentType == "Bank" ? isBankListClicked = true : isBankListClicked = false;
    });
  }

  String? customerId;
  String? invoiceId;
  String customerTypes = "";
  String? bankAccountId;
  String? areaId;
  String? territoriesId;
  bool customerEntryBtnClk = false;

  String? customerDueAmount="0";
 Response? result;
  void customerDue(String? customerId) async {
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
        customerDueAmount = "${data[0]['dueAmount']}";
      });
    }
    print("previousDue======previousDue==========$customerDueAmount");
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
    WidgetsBinding.instance.addPostFrameCallback(_getTrTypeDropdownSize);
    WidgetsBinding.instance.addPostFrameCallback(_getPTypeDropdownSize);
    _initializeData();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    getTransactionType = "CR";
    getPaymentType = "cash";
    // CustomerListProvider.isCustomerLoading = true;
    // Provider.of<CustomerListProvider>(context, listen: false).customerList = [];
    // //Provider.of<RegionProvider>(context, listen: false).getRegion();
    // TerritoriesProvider.isTerritoriesloading = true;
    // Provider.of<TerritoriesProvider>(context, listen: false).territoriesList = [];
    // Provider.of<BankAccountProvider>(context, listen: false).getBankAccount();
    // Provider.of<CustomerPaymentsProvider>(context, listen: false).getCustomerPayments("","","",backEndFirstDate,backEndFirstDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final allAreaData = Provider.of<RegionProvider>(context).regionList;
    //final allTerritoriesData = Provider.of<TerritoriesProvider>(context).territoriesList;
    final allCustomerData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.customerSlNo!=0).toList();
    print("Customer length==============${allCustomerData.length}");
    // final allCustomerPaymentData = Provider.of<CustomerPaymentsProvider>(context).customerPaymentsList;
    final allBankAccountList = Provider.of<BankAccountProvider>(context).bankAccountList;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: "Customer Payment"),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color.fromARGB(255, 7, 125, 180),
                    width: 1.w,
                  ),
                  boxShadow: [
                    // ignore: deprecated_member_use
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5.r,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Payment Date",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: userType == "m" || userType =="a"? Container(
                            margin: EdgeInsets.only(bottom: 4.h),
                            height:25.h,
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                                FocusScope.of(context,).requestFocus(quantityFocusNode);
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  suffixIcon: Padding(padding: EdgeInsets.only(left: 20.w),
                                    child: Icon(Icons.calendar_month,color: Colors.black87,size: 16.r),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate,
                                  hintStyle:AllTextStyle.dropDownlistStyle,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ):Container(
                            margin: EdgeInsets.only(bottom: 4.h),
                            height:25.h,
                            decoration: ContDecoration.contDecoration,
                            child: GestureDetector(
                              onTap: (() {
                                //_firstSelectedDate();
                                FocusScope.of(context,).requestFocus(quantityFocusNode);
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 5.w),
                                  // suffixIcon: Padding(padding: EdgeInsets.only(left: 20.w),
                                  //   child: Icon(Icons.calendar_month,color: Colors.black87,size: 16.r),
                                  // ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: firstPickedDate,
                                  hintStyle:AllTextStyle.dropDownlistStyle,
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
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Trans. Type",
                            style: AllTextStyle.textFieldHeadStyle,
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: CompositedTransformTarget(
                            link: _trTypeLayerLink,
                            child: GestureDetector(
                              onTap: _toggleTrTypeDropdown,
                              child: Container(
                                key: _trkey,
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 25.h,
                                decoration: ContDecoration.contDecoration,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_transactionType!,style: AllTextStyle.dateFormatStyle),
                                    GestureDetector(
                                      onTap: _toggleTrTypeDropdown,
                                      child: Icon(
                                        color: Colors.grey.shade700,
                                        _isDropdownOpen
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Payment Type",
                            style: AllTextStyle.textFieldHeadStyle,
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: CompositedTransformTarget(
                            link: _pTypeLayerLink,
                            child: GestureDetector(
                              onTap: _togglePTypeDropdown,
                              child: Container(
                                key: _pkey,
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 25.h,
                                decoration: ContDecoration.contDecoration,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_paymentType!,style: AllTextStyle.dateFormatStyle),
                                    GestureDetector(
                                      onTap: _togglePTypeDropdown,
                                      child: Icon(
                                        color: Colors.grey.shade700,
                                        _isDropdownOpen
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    isBankListClicked == true
                    ? Row(
                      children: [
                        Expanded(flex: 6,child: Text("Bank account",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 25.h,
                            width:MediaQuery.of(context).size.width / 2,
                            margin: EdgeInsets.only(bottom: 4.h),
                            child: CommonTypeAheadField<BankAccountModel>(
                              controller: bankAccountController,
                              suggestionList: allBankAccountList,
                              hintText: 'Select Account',
                              selectedValueId: bankAccountId,
                              onValueIdChanged: (id) {
                                setState(() {
                                  bankAccountId = id;
                                });
                              },
                              displayText:(ba) =>"${ba.accountNumber} - ${ba.accountName} (${ba.bankName})",
                              valueId:(ba) => ba.accountId.toString(),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
                  Row(
                    children: [
                      Expanded(flex: 6, child: Text("Customer",style:AllTextStyle.textFieldHeadStyle)),
                      const Expanded(flex: 1, child: Text(":")),
                      Expanded(
                        flex: 11,
                        child: Container(
                            height: 25.h,
                            decoration: ContDecoration.contDecoration,
                          //   child: TypeAheadField<CustomersModel>(
                          //   controller: customerController,
                          //   builder: (context, controller, focusNode) {
                          //     return TextField(
                          //       controller: controller,
                          //       focusNode: focusNode,
                          //       style: AllTextStyle.textValueStyle,
                          //       decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.only(left: 5.w, top: 2.5.h),
                          //         isDense: true,
                          //         hintText: 'Select Customer',
                          //         hintStyle: AllTextStyle.textValueStyle,
                          //         suffixIcon: customerId == '' || customerId == 'null' || customerId == null || controller.text == ''
                          //             ? null
                          //             : GestureDetector(
                          //                 onTap: () {
                          //                   setState(() {
                          //                     customerController.clear();
                          //                     controller.clear();
                          //                     customerId = null;
                          //                   });
                          //                   // Clear করার পর নতুনভাবে customer লোড
                          //                   // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("",areaId??"", territoriesId??"");
                          //                   if(userType =="m" || userType == "a"){
                          //                       Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("",areaId??"", territoriesId??"");
                          //                     }else{
                          //                       Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("", unitAreaId??"", territorieId??"");
                          //                     }
                          //                 },
                          //                 child: Padding(
                          //                   padding: EdgeInsets.all(5.r),
                          //                   child: Icon(Icons.close, size: 16.r),
                          //                 ),
                          //               ),
                          //         suffixIconConstraints: BoxConstraints(maxHeight: 30.h),
                          //         filled: false,
                          //         fillColor: Colors.white,
                          //         border: InputBorder.none,
                          //       ),
                          //       onTap: () {
                          //         // কার্সর রাখলেই নতুনভাবে লোড হবে
                          //         // Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("",areaId??"", territoriesId??"");
                          //         if(userType =="m" || userType == "a"){
                          //             Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("",areaId??"", territoriesId??"");
                          //           }else{
                          //             Provider.of<CustomerListProvider>(context, listen: false).getCustomerList("", unitAreaId??"", territorieId??"");
                          //           }
                          //         // আগের সিলেকশন থাকলে clear হবে
                          //         if (customerId != null &&
                          //             customerId != '' &&
                          //             customerId != 'null') {
                          //           setState(() {
                          //             customerController.clear();
                          //             controller.clear();
                          //             customerId = null;
                          //           });
                          //         }
                          //       },
                          //     );
                          //   },
                          //   suggestionsCallback: (pattern) async {
                          //     return Future.delayed(const Duration(seconds: 1), () {
                          //       return allCustomerData
                          //           .where((element) => element.displayName
                          //               .toLowerCase()
                          //               .contains(pattern.toLowerCase()))
                          //           .toList()
                          //           .cast<CustomersModel>();
                          //     });
                          //   },
                          //   itemBuilder: (context, CustomersModel suggestion) {
                          //     return Padding(
                          //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                          //       child: Text(
                          //         "${suggestion.displayName}",
                          //         style: TextStyle(fontSize: 12.sp),
                          //         maxLines: 1,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     );
                          //   },
                          //   onSelected: (CustomersModel suggestion) {
                          //     customerController.text = "${suggestion.displayName}";
                          //     setState(() {
                          //       customerId = suggestion.customerSlNo.toString();
                          //     });
                          //     print("customerId==select======$customerId");
                          //     customerDue(customerId??"");
                          //   },
                          // ),
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Due Amount",
                            style: AllTextStyle.textFieldHeadStyle,
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: ContDecoration.contDecoration,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
                              child: Text("$customerDueAmount",style: AllTextStyle.dateFormatStyle),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(flex: 6,child: Text("Description",style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 13.sp),
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 5.w),
                                hintText: "Note",
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(flex: 6, child: Text("Payment", style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 13.sp),
                              controller: _paymentController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                                filled: true,
                                hintText: "0",
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                              ),
                              onChanged: (_) => calculateTotal(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(flex: 6, child: Text("Discount", style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 6,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  height: 25.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: TextField(
                                    style: TextStyle(fontSize: 13.sp),
                                    controller: _percentageAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                                      filled: true,
                                      hintText: "0",
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                      enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                                    ),
                                    onChanged: (_) => calculateTotal(changed: "percent"),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                height: 25.h,
                                decoration: ContDecoration.contDecoration,
                                child: Center(child: Text("%", style: AllTextStyle.textFieldHeadStyle))),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 4.h),
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 13.sp),
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                                filled: true,
                                hintText: "0",
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                              ),
                              onChanged: (_) => calculateTotal(changed: "discount"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(flex: 6, child: Text("Total", style: AllTextStyle.textFieldHeadStyle)),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 25.h,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: TextStyle(fontSize: 13.sp),
                              controller: _totalController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                                filled: true,
                                hintText: "0",
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                focusedBorder:TextFieldInputBorder.focusEnabledBorder,
                                enabledBorder:TextFieldInputBorder.focusEnabledBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ///=====customer loading hide
                    //HiddenItemsLoading(controller: quantityController,focusNode: quantityFocusNode),
                    SizedBox(height: 4.h),
                    Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                    onTap: () {
                      // if (customerController.text == '') {
                      //   Utils.showTopSnackBar(context, "Customer is required");
                      // } else if (_paymentType == "Bank" && bankAccountController.text == '') {
                      //   Utils.showTopSnackBar(context, "Bank account is required");
                      // }  else if (_paymentController.text == '') {
                      //   Utils.showTopSnackBar(context, "Payment Amount is required");
                      // }
                      // else {
                      //   setState(() {
                      //     customerEntryBtnClk = true;
                      //   });
                      //   Utils.closeKeyBoard(context);
                      //   addCustomerPayment(context).then((value) {
                      //     Provider.of<CustomerPaymentsProvider>(context, listen: false)
                      //         .getCustomerPayments("", "", "", backEndFirstDate, backEndFirstDate);
                      //     setState(() {});
                      //   });
                      //   FocusScope.of(context).requestFocus(quantityFocusNode);
                      // }

                      // FocusScope.of(context).requestFocus(quantityFocusNode);
                      // FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      height: 28.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.appColor,
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 2,
                            blurRadius: 5.r,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: customerEntryBtnClk
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: CircularProgressIndicator(color: Colors.white))
                            : Text("Save", style: AllTextStyle.saveButtonTextStyle),
                      ),
                    ),
                    ),
                  ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // Expanded(
            //   flex: 3,
            //   child: CustomerPaymentsProvider.isCustomerPaymentsLoading
            //   ? const Center(child: CircularProgressIndicator())
            //   : allCustomerPaymentData.isNotEmpty
            //   ? Expanded(
            //     child: SizedBox(
            //       height: MediaQuery.of(context).size.height / 1.31,
            //       width: double.infinity,
            //       child: Container(
            //         width: double.infinity,
            //         height: double.infinity,
            //         padding: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 10.h),
            //         child: SingleChildScrollView(
            //           scrollDirection: Axis.vertical,
            //           child: SingleChildScrollView(
            //             scrollDirection: Axis.horizontal,
            //             child: Container(
            //               padding: EdgeInsets.only(bottom: 16.h),
            //               child: Column(
            //                 crossAxisAlignment:CrossAxisAlignment.start,
            //                 children: [
            //                   DataTable(
            //                     headingRowHeight: 20.h,
            //                     // ignore: deprecated_member_use
            //                     dataRowHeight: 20.h,
            //                     headingRowColor:WidgetStateColor.resolveWith((states) => AppColors.appColor),
            //                     showCheckboxColumn: true,
            //                     border: TableBorder.all(color: Colors.black54,width: 1.w),
            //                     columns: [
            //                       DataColumn(label: Expanded(child: Center(child: Text('Transaction Id',style: AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Date',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Customer',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Transaction Type',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Payment by',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Description',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Discount',style:AllTextStyle.tableHeadTextStyle)))),
            //                       DataColumn(label: Expanded(child: Center(child: Text('Amount',style:AllTextStyle.tableHeadTextStyle)))),
            //                       //DataColumn(label: Expanded(child: Center(child: Text('Invoice',style:AllTextStyle.tableHeadTextStyle)))),
                             
            //                     ],
            //                     rows: List.generate(
            //                       allCustomerPaymentData.length,
            //                       (int index) => DataRow(
            //                         color:index % 2 == 0? WidgetStateProperty.resolveWith(AppColors.getColors): WidgetStateProperty.resolveWith(AppColors.getAll),
            //                         cells: <DataCell>[
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentInvoice.toString()))),
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentDate.toString()))),
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].customerName.toString()))),
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].transactionType.toString()))),
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].paymentBy.toString()))),
            //                           DataCell(Center(child: Text(allCustomerPaymentData[index].cPaymentNotes.toString()))),
            //                           DataCell(Center(child: Text((allCustomerPaymentData[index].discount ?? 0).toString()))),
            //                           DataCell(Center(child: Text(double.parse(allCustomerPaymentData[index].cPaymentAmount.toString()).toStringAsFixed(2)))),
            //                         //   DataCell(
            //                         //   Center(
            //                         //     child:GestureDetector(
            //                         //       child: Icon(Icons.collections_bookmark,size: 18.r),
            //                         //       onTap: () {
            //                         //         Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPaymentInvoice(paymentId: allCustomerPaymentData[index].cPaymentId),
            //                         //         ));
            //                         //       },
            //                         //     ),
            //                         //   ),
            //                         // ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(height: 10.h),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ): Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: AllTextStyle.nofoundTextStyle))),
            // ),
          
          ],
        ),
      ),
    );
  }

  emptyMethod() {
    setState(() {
      _descriptionController.text = "";
      customerController.text = '';
      _areaController.text = '';
      _discountController.text = '';
      _percentageAmountController.text = '';
      _totalController.text = '';
      territoriesController.text = '';
      previousDueController.text = "";
      bankAccountController.text = "";
      _paymentType = 'Cash';
      getPaymentType = "cash";
      getTransactionType = "CR";
      _transactionType ="Receive";
    });
  }

  Future<String> addCustomerPayment(context) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String Link = "${baseUrl}add_customer_payment";
    try {
      Response response = await Dio().post(Link,
        data: {
            "CPayment_Paymentby": getPaymentType.toString(),
            "CPayment_TransactionType": getTransactionType.toString(),
            "CPayment_amount": _paymentController.text.toString().trim(),
            "CPayment_customerID": customerId.toString(),
            "CPayment_date": backEndFirstDate,
            "CPayment_id": 0,
            "discount": _discountController.text.toString().trim(),
            "CPayment_notes": _descriptionController.text.trim(),
            "CPayment_previous_due": customerDueAmount.toString(),
            "account_id": bankAccountId.toString(),
        },

        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
            "Cookie": "laravel_session=${sharedPreferences.getString('sessionId')}",
          },
        ),
      );
      var data = response.data;
      print("add_customer_payment======$data");
      if (data['success'] == true) {
        setState(() {
          customerEntryBtnClk = false;
        });
        CustomSnackBar.showTopSnackBar(context, "${data["message"]}");
        emptyMethod();
        setState(() {
          customerEntryBtnClk = false;
        });
      //   Navigator.push(context,
      //   MaterialPageRoute(builder: (context) =>CustomerPaymentInvoice(paymentId: "${data["paymentId"]}"),
      //   ),
      // );
      Navigator.push(context,
        MaterialPageRoute(builder: (context) =>CustomerPaymentScreen(),
        ),
      );
        return "true";
      } else {
        Utils.showTopSnackBar(context, "${data["message"]}");
        setState(() {
          customerEntryBtnClk = false;
        });
        return "";
      }
    } catch (e) {
      Utils.showTopSnackBar(context, e.toString());
      setState(() {
        customerEntryBtnClk = false;
      });
      return "";
    }
  }
}
