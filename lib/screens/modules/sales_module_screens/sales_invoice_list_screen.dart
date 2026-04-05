import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barishal_surgical/models/sales_module_models/sales_invoice_model.dart';
import 'package:barishal_surgical/models/sales_module_models/sales_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_provider.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget/custom_appbar.dart';
import '../../../providers/sales_module_providers/sales_invoice_provider.dart';
import '../../../utils/all_textstyle.dart';

class SalesInvoiceListScreen extends StatefulWidget {
  const SalesInvoiceListScreen({super.key});

  @override
  State<SalesInvoiceListScreen> createState() => _SalesInvoiceListScreenState();
}

class _SalesInvoiceListScreenState extends State<SalesInvoiceListScreen> {

  var invoiceController = TextEditingController();
  String? _selectedInvoice;
  double totalDue = 0.0;
  String userName = "";
  SharedPreferences? sharedPreferences;
  Future<void> _initializeData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = "${sharedPreferences?.getString('userName')}";
    print("userName======$userName");
  }

  String companyName = "";
  String repotHeading = "";
   void getCompanyProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(
        "${baseUrl}get_company_profile",
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      if (response.statusCode == 200) {
        var data = response.data is List ? response.data[0] : response.data;

        setState(() {
          companyName = data['Company_Name'] ?? "";
          repotHeading = data['Repot_Heading'] ?? "";
        });

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_company_profile-------Company_Name======$companyName");
    print("get_company_profile-------Company_Name======$repotHeading");
  }

  @override
  void initState() {
    getCompanyProfile();
    _initializeData();
    Provider.of<SalesProvider>(context, listen: false).getSales(context,"", "", "", "", "", "");
    Provider.of<SalesInvoiceProvider>(context, listen: false).getSalesInvoice(context, "");
    // TODO: implement initState
    super.initState();
  }

 Future<void> printInvoice(SalesInvoiceModel? data) async {
  String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
  final pdf = pw.Document();
  // লোগো লোড করা
  final logoImg = await rootBundle.load('images/brsgcl.png');
  final logoImage = logoImg.buffer.asUint8List();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(3), // মার্জিন একটু বাড়িয়ে দেওয়া হয়েছে সুন্দর দেখানোর জন্য
      build: (context) => [
        // --- Header Section ---
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(currentDateTime, 
                    style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
                // --- Header Section (Logo & Company Name in One Row) ---
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start, // লোগো এবং নামকে বাম দিক থেকে সাজাবে
                  crossAxisAlignment: pw.CrossAxisAlignment.center, // লম্বালম্বি মাঝ বরাবর থাকবে
                  children: [
                  // বাম পাশে লোগো
                  pw.Image(pw.MemoryImage(logoImage), width: 80, height: 50),
                  pw.SizedBox(width: 15), // লোগো এবং নামের মাঝে ফাঁকা জায়গা
                  pw.Text(
                  "BARISAL\nSURGICAL", 
                      style: pw.TextStyle(
                        fontSize: 25, 
                        fontWeight: pw.FontWeight.bold, 
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.green900
                      )
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Text("(Importer, Indenter, Wholesaler & General Supplier)", 
                    style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
              ],
            ),
            pw.Container(
              height: 90,
              width: 1,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1.5, color: PdfColors.green900)
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("Rizia Mansion, 34/1, Mitford Road, Dhaka-1100", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                pw.Text("Phone: 9577294, 9512133", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                pw.Text("E-mail: barishalsurgical@gmail.com", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                pw.Text("Web: www.barishalsurgical.com", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 1.5, color: PdfColors.green900),
        
        // --- Invoice Title ---
        pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            child: pw.Text("Sales Invoice", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ),
        ),
        pw.Divider(thickness: 1.5, color: PdfColors.green900),

        // --- Customer & Invoice Info ---
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Customer Name:", data!.sales[0].customerName),
                _buildInfoRow("Customer ID:", "C00780"), 
                _buildInfoRow("Address:", "Manikganj, Bangladesh"),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _buildInfoRow("Prepared By:", data.sales[0].addedBy),
                _buildInfoRow("Invoice No.:", data.sales[0].saleMasterInvoiceNo),
                _buildInfoRow("Sales Date:", data.sales[0].saleMasterSaleDate),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),

        // --- Product Table ---
        pw.Table(
          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
          columnWidths: {
            0: const pw.FixedColumnWidth(25), 
            1: const pw.FixedColumnWidth(60), // Sl
            2: const pw.FlexColumnWidth(3),  // Description
            3: const pw.FixedColumnWidth(40), // Qty
            4: const pw.FixedColumnWidth(40), // Ret Qty
            5: const pw.FixedColumnWidth(40), // Unit
            6: const pw.FixedColumnWidth(50), // Rate
            7: const pw.FixedColumnWidth(60), // Total
          },
          children: [
            // Table Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell("Sl.", isHeader: true),
                _buildTableCell("Product Code", isHeader: true),
                _buildTableCell("Description", isHeader: true),
                _buildTableCell("Qty", isHeader: true),
                _buildTableCell("Ret. Qty", isHeader: true),
                _buildTableCell("Unit", isHeader: true),
                _buildTableCell("Rate", isHeader: true),
                _buildTableCell("Total", isHeader: true),
              ],
            ),
            // Table Body
            ...data.saleDetails.asMap().entries.map((entry) {
              int i = entry.key;
              var item = entry.value;
              return pw.TableRow(
                children: [
                  _buildTableCell("${i + 1}"),
                  _buildTableCell(item.productCode,),
                  _buildTableCell(item.productName, align: pw.TextAlign.left),
                  _buildTableCell(item.saleDetailsTotalQuantity),
                  _buildTableCell("0"), // Return Qty static 0
                  _buildTableCell(item.unitName),
                  _buildTableCell(item.saleDetailsRate),
                  _buildTableCell(item.saleDetailsTotalAmount),
                ],
              );
            }).toList(),
            // --- Total Row ---
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey50),
              children: [
                _buildTableCell(""), 
                _buildTableCell(""),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text("Total", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                ),
                _buildTableCell(_calculateTotalQty(data.saleDetails), isHeader: true),
                _buildTableCell("0", isHeader: true),
                _buildTableCell(""),
                _buildTableCell(""),
                _buildTableCell(data.sales[0].saleMasterTotalSaleAmount, isHeader: true),
              ],
            ),
          ],
        ),

        // --- Calculation Summary ---
        pw.SizedBox(height: 10),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(top: 10),
                child: pw.Text("In Word: Twenty Four Thousand Nine Hundred Fifty BDT only", 
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                children: [
                  _buildSummaryRow("Sub Total:", data.sales[0].saleMasterSubTotalAmount),
                  _buildSummaryRow("Discount:", data.sales[0].saleMasterTotalDiscountAmount),
                  _buildSummaryRow("VAT:", data.sales[0].saleMasterTaxAmount),
                  _buildSummaryRow("Transport:", "0.00"),
                  pw.Divider(thickness: 0.5),
                  _buildSummaryRow("Total:", data.sales[0].saleMasterTotalSaleAmount, isBold: true),
                  _buildSummaryRow("Paid:", data.sales[0].saleMasterPaidAmount),
                   pw.Divider(thickness: 0.5),
                  _buildSummaryRow("Due:", data.sales[0].saleMasterDueAmount, isBold: true),
                ],
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 60),

        // --- Signature Section ---
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Container(width: 80, decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 1)))),
                pw.SizedBox(height: 2),
                pw.Text("Received by", style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Column(
              children: [
                pw.Container(width: 80, decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 1)))),
                pw.SizedBox(height: 2),
                pw.Text("Authorized by", style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

// --- Helper Functions ---

String _calculateTotalQty(List<dynamic> details) {
  double total = 0;
  for (var item in details) {
    total += double.tryParse(item.saleDetailsTotalQuantity.toString()) ?? 0;
  }
  return total.toStringAsFixed(0); 
}

pw.Widget _buildInfoRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text("$label ", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
      ],
    ),
  );
}

pw.Widget _buildTableCell(String text, {bool isHeader = false, pw.TextAlign align = pw.TextAlign.center}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(fontSize: 9, fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal),
    ),
  );
}

pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    ),
  );
}


  String numberToWords(int number) {
    if (number == 0) return "Zero";

    final List<String> units = [
      "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
      "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
    ];

    final List<String> tens = [
      "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
    ];

    String convertLessThanThousand(int num) {
      if (num == 0) return "";
      if (num < 20) return units[num];
      if (num < 100) return tens[num ~/ 10] + (num % 10 != 0 ? " ${units[num % 10]}" : "");
      return units[num ~/ 100] + " Hundred" + (num % 100 != 0 ? " " + convertLessThanThousand(num % 100) : "");
    }

    String words = "";
    if (number >= 1000000) {
      words += "${convertLessThanThousand(number ~/ 1000000)} Million ";
      number %= 1000000;
    }
    if (number >= 1000) {
      words += "${convertLessThanThousand(number ~/ 1000)} Thousand ";
      number %= 1000;
    }
    if (number > 0) {
      words += convertLessThanThousand(number);
    }

    return words.trim();
  }

  @override
  Widget build(BuildContext context) {
    ///invoice
    final allSalesInvoicesData = Provider.of<SalesProvider>(context).saleslist;

    return Scaffold(
      appBar: CustomAppBar(title: "Sales Invoice List"),
      body: Container(
        padding: EdgeInsets.all(8.0.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.0.r),
                decoration: BoxDecoration(
                  color:Colors.blue.shade100,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text("Invoice No    :", style: AllTextStyle.textFieldHeadStyle)),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 25.h,
                        decoration: ContDecoration.contDecoration,
                        child: TypeAheadField<SalesModel>(
                          controller: invoiceController,
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, overflow: TextOverflow.ellipsis),
                              decoration: InputDecoration(contentPadding: EdgeInsets.only(bottom: 8.h, left: 5.0.w),
                                isDense: true,
                                hintText: 'Select Invoice',
                                hintStyle: TextStyle(fontSize: 13.sp),
                                suffixIcon: _selectedInvoice == '' || _selectedInvoice == 'null' || _selectedInvoice == null || controller.text == '' ? null
                                    : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      invoiceController.clear();
                                      controller.clear();
                                      _selectedInvoice = null;
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
                              return allSalesInvoicesData.where((element) =>
                                  element.invoiceText!.toLowerCase().contains(pattern.toLowerCase())).toList();
                            });
                          },
                          itemBuilder: (context, SalesModel suggestion) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 4.h),
                              child: Text(suggestion.invoiceText!,
                                style: TextStyle(fontSize: 12.sp), maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          onSelected: (SalesModel suggestion) {
                            setState(() {
                              invoiceController.text = suggestion.invoiceText!;
                              _selectedInvoice = suggestion.saleMasterSlNo.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              invoiceController.text != "" ? Container(
                margin: EdgeInsets.only(top: 1.0.h),
                child: FutureBuilder(
                    future: Provider.of<SalesInvoiceProvider>(context)
                        .getSalesInvoice(context, _selectedInvoice),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 320.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasData) {
                      /// Total Calculation
                      int totalQty = snapshot.data!.saleDetails.fold<int>(0,(sum, item) => sum + int.tryParse(item.saleDetailsTotalQuantity.toString())!);
                      double totalAmount = snapshot.data!.saleDetails.fold<double>(0.0,(sum, item) => sum + double.tryParse(item.saleDetailsTotalAmount.toString())!);

                      return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0.h),
                          GestureDetector(
                            onTap:() {
                              printInvoice(snapshot.data);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.print, color: Colors.teal.shade900),
                                SizedBox(width: 3.0.w),
                                Text("Print", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal.shade900, fontSize: 18.0.sp)),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider()),
                          Align(alignment: Alignment.center,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0.r),
                                  border: Border.all(color: Colors.black, width: 1.5.w)
                              ),
                            child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text("Sales Invoice",style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                          ))),
                          Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Customer Id : ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.sales[0].customerCode,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),RichText(
                                      text: TextSpan(
                                        text: 'Name : ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.sales[0].customerName,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Employee : ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.sales[0].employeeName,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Prepared By:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.sales[0].addedBy,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Invoice No:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot.data!.sales[0].saleMasterInvoiceNo,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Sales Date:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            //text: Utils.formatFrontEndDate("${22-02-2025}"),
                                              text: snapshot.data!.sales[0].saleMasterSaleDate,
                                              style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Address : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:snapshot.data!.sales[0].customerAddress,
                                    style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 2.h),child: Divider()),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: 20.0.h,
                              dataRowHeight: 20.0.h,
                              showCheckboxColumn: true,
                              border: TableBorder.all(color: Colors.black54, width: 1.w),
                              dataTextStyle: TextStyle(fontSize: 10.sp, color: Colors.black),
                              columns: [
                                DataColumn(label: Center(child: Text('Sl.', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text('Product Code', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Padding(
                                  padding: EdgeInsets.only(left: 40.0.w),
                                  child: Text('Description', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(label: Center(child: Text('Qty', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text('Return Qty', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text('Unit', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text('Unit Price', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                                DataColumn(label: Center(child: Text('Total', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                              ],
                              rows: [
                                // Table Data Rows
                                ...List.generate(snapshot.data!.saleDetails.length, (index) {
                                  return DataRow(cells: [
                                    DataCell(Center(child: Text("${index + 1}"))),
                                    DataCell(Text("${snapshot.data!.saleDetails[index].productCode}", style: TextStyle(fontSize: 10.sp))),
                                    DataCell(Text("${snapshot.data!.saleDetails[index].productName}", style: TextStyle(fontSize: 10.sp))),
                                    DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsTotalQuantity}"))),
                                    DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsTotalQuantity}"))),
                                    DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].unitName}"))),
                                    DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsRate}"))),
                                    DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsTotalAmount}"))),
                                  ]);
                                }),
                                // Total Row
                                DataRow(
                                  cells: [
                                    DataCell(SizedBox()),
                                    DataCell(SizedBox()),
                                    DataCell(Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Center(child: Text("$totalQty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                    DataCell(Center(child: Text("$totalQty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                    DataCell(SizedBox()),
                                    DataCell(SizedBox()),
                                    DataCell(Center(child: Text('$totalAmount', style: TextStyle(fontWeight: FontWeight.bold)))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Previous Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterPreviousDue, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Current Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterDueAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Divider(color: Colors.black),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(double.parse("${double.parse('${snapshot.data!.sales[0].saleMasterPreviousDue}') + double.parse('${snapshot.data!.sales[0].saleMasterDueAmount}')}").toStringAsFixed(2),style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 100.0.w),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Sub Total:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterSubTotalAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Discount:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterTotalDiscountAmount,style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Vat:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterTaxAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Transport Cost:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterFreight, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Divider(color: Colors.black,height: 2.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterTotalSaleAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Paid:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterPaidAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Divider(color: Colors.black,height: 2.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(snapshot.data!.sales[0].saleMasterDueAmount, style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          SelectableText(
                            "In Word: ${numberToWords(double.parse(snapshot.data!.sales[0].saleMasterTotalSaleAmount).toInt())} BDT only",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),
                          SizedBox(height: 10.h),
                          Text("Note:${snapshot.data!.sales[0].saleMasterDescription}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    );
                  }else {
                  return const SizedBox();
                  }
                 }
                ),
              ): Container(),
            ],),
        ),
      ),
    );
  }
}