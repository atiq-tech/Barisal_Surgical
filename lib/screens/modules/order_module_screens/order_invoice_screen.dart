import 'package:barishal_surgical/common_widget/common_location.dart';
import 'package:barishal_surgical/models/order_module_models/orders_invoice_model.dart';
import 'package:barishal_surgical/providers/order_module_providers/orders_invoice_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../providers/sales_module_providers/sales_provider.dart';
import '../../../utils/all_textstyle.dart';

class OrdersInvoiceScreen extends StatefulWidget {
  const OrdersInvoiceScreen({super.key, required this.salesId});
  final String salesId;
  @override
  State<OrdersInvoiceScreen> createState() => _OrdersInvoiceScreenState();
}

class _OrdersInvoiceScreenState extends State<OrdersInvoiceScreen> {
  double totalDue = 0.0;
  String companyName = "";
  String repotHeading = "";
  String dueStatus = "";
  String invoiceNote = "";
  String headerImg = "";
  String footerImg = "";

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
          dueStatus = data['dueStatus'] ?? "";
          invoiceNote = data['InvoiceNote'] ?? "";
        });

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_company_profile-------Company_Name======$companyName");
    print("get_company_profile-------Company_Name======$repotHeading");
    print("get_company_profile-------dueStatus======$dueStatus");
    print("get_company_profile-------invoiceNote======$invoiceNote");
  }

  void getCurrentBranch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(
        "${baseUrl}get_current_branch",
        options: Options(headers: {
          "Content-Type": "application/json",
          'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );

      if (response.statusCode == 200) {
        var data = response.data is List ? response.data[0] : response.data;

        setState(() {
          headerImg = data['Branch_header'] ?? "";
          footerImg = data['Branch_footer'] ?? "";
        });

        /// START AUTO TIME CHECK EVERY 1 SECOND
        //startAutoStartTimeChecker();
      }
    } catch (e) {
      print("Error fetching company profile: $e");
    }
    print("get_current_branch-------Branch_header======$headerImg");
    print("get_current_branch-------Branch_footer======$footerImg");
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
    getCompanyProfile();
    getCurrentBranch();
    Provider.of<SalesProvider>(context, listen: false).getSales(context,"", "", "", "", "");
    super.initState();
  }

 // ইমেজ ফেচ করার জন্য উন্নত ফাংশন
Future<Uint8List?> _fetchImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Image Load Failed: Status ${response.statusCode}');
      return null; 
    }
  } catch (e) {
    print('Error fetching image: $e');
    return null;
  }
}

  Future<void> printInvoice(OrdersInvoiceModel? data) async {
  if (data == null || data.sales.isEmpty) return;

  String currentDateTime = DateFormat('M/d/yyyy, h:mm a').format(DateTime.now());
  
  // ইমেজগুলো ফেচ করা
  final Uint8List? netHeader = await _fetchImage("$imageBaseUrl$headerImg");
  final Uint8List? netFooter = await _fetchImage("$imageBaseUrl$footerImg");
  
  final pdf = pw.Document();
  
  /// লোকাল লোগো লোড করা
  // Uint8List? logoImage;
  // try {
  //   final logoImg = await rootBundle.load('images/brsgcl.png');
  //   logoImage = logoImg.buffer.asUint8List();
  // } catch (e) {
  //   print("Local logo not found: $e");
  // }


  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(3),
      build: (context) => [
        pw.Text(currentDateTime, style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
        if (netHeader != null) 
        pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80, width: 500)),
        pw.SizedBox(height: 10),
        // --- Header Section ---
        // pw.Row(
        //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: pw.CrossAxisAlignment.start,
        //   children: [
        //     pw.Column(
        //       crossAxisAlignment: pw.CrossAxisAlignment.start,
        //       children: [
        //         if (netHeader != null) 
        //         pw.Center(child: pw.Image(pw.MemoryImage(netHeader), height: 80, width: 500)),
        //         pw.SizedBox(height: 10),
        //         pw.Text(currentDateTime, 
        //             style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
        //         // --- Header Section (Logo & Company Name in One Row) ---
        //         pw.Row(
        //           mainAxisAlignment: pw.MainAxisAlignment.start, // লোগো এবং নামকে বাম দিক থেকে সাজাবে
        //           crossAxisAlignment: pw.CrossAxisAlignment.center, // লম্বালম্বি মাঝ বরাবর থাকবে
        //           children: [
        //           // বাম পাশে লোগো
        //          if (logoImage != null) pw.Image(pw.MemoryImage(logoImage), width: 50, height: 40),
        //             pw.SizedBox(width: 10),// লোগো এবং নামের মাঝে ফাঁকা জায়গা
        //           pw.Text(
        //           "BARISAL\nSURGICAL", 
        //               style: pw.TextStyle(
        //                 fontSize: 25, 
        //                 fontWeight: pw.FontWeight.bold, 
        //                 fontStyle: pw.FontStyle.italic,
        //                 color: PdfColors.green900
        //               )
        //             ),
        //           ],
        //         ),
        //         pw.SizedBox(height: 5),
        //         pw.Text("(Importer, Indenter, Wholesaler & General Supplier)", 
        //             style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
        //       ],
        //     ),
        //     pw.Container(
        //       height: 90,
        //       width: 1,
        //       decoration: pw.BoxDecoration(
        //         border: pw.Border.all(width: 1.5, color: PdfColors.green900)
        //       ),
        //     ),
        //     pw.Column(
        //       crossAxisAlignment: pw.CrossAxisAlignment.end,
        //       children: [
        //         pw.Text("Rizia Mansion, 34/1, Mitford Road, Dhaka-1100", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
        //         pw.Text("Phone: 9577294, 9512133", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
        //         pw.Text("E-mail: barishalsurgical@gmail.com", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
        //         pw.Text("Web: www.barishalsurgical.com", style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
        //       ],
        //     ),
        //   ],
        // ),
        
        pw.Divider(thickness: 1.5, color: PdfColors.green900),
        
        // --- Invoice Title ---
        pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            child: pw.Text("Order Invoice", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
                _buildInfoRow("Customer ID:", data.sales[0].customerCode??""),
                _buildInfoRow("Name:", data.sales[0].customerName??""),
                _buildInfoRow("Mobile:", data.sales[0].customerMobile??""),
                _buildInfoRow("Attention:", data.sales[0].customerComment??""), 
                
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _buildInfoRow("Prepared By:", data.sales[0].addedBy??""),
                _buildInfoRow("Invoice No.:", data.sales[0].saleMasterInvoiceNo??""),
                _buildInfoRow("Sales Date:", data.sales[0].saleMasterSaleDate??""),
                _buildInfoRow("Employee:", data.sales[0].employeeName??""),
              ],
            ),
          ],
        ),
        _buildInfoRow("Address:", data.sales[0].customerAddress),
        pw.SizedBox(height: 20),

        // --- Product Table ---
        pw.Table(
          border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
          columnWidths: {
            0: const pw.FixedColumnWidth(25), 
            1: const pw.FixedColumnWidth(60), // Sl
            2: const pw.FlexColumnWidth(3),  // Description
            3: const pw.FixedColumnWidth(40), // Qty
            //4: const pw.FixedColumnWidth(40), // Ret Qty
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
                //_buildTableCell("Ret. Qty", isHeader: true),
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
                  _buildTableCell(item.orderQuantity.toString()),
                  //_buildTableCell("0"), // Return Qty static 0
                  _buildTableCell(item.unitName),
                  _buildTableCell(item.saleDetailsRate),
                  _buildTableCell(item.saleDetailsTotalAmount.toString()),
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
                //_buildTableCell("0", isHeader: true),
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
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  data.sales[0].bankName != null && data.sales[0].bankName != "null" 
                    ? pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                        columnWidths: const {
                          0: pw.FixedColumnWidth(25), // SL
                          1: pw.FlexColumnWidth(),    // Bank Name
                          2: pw.FixedColumnWidth(50), // Amount
                        },
                        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          // Table Header
                          pw.TableRow(
                            decoration: pw.BoxDecoration(color: PdfColors.grey200),
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Center(child: pw.Text("SL", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Center(child: pw.Text("Bank", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Center(child: pw.Text("Amount", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
                              ),
                            ],
                          ),
                          // Table Data Row
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Center(child: pw.Text("1", style: pw.TextStyle(fontSize: 8))),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Text(
                                  "${data.sales[0].bankName ?? ""}", 
                                  style: pw.TextStyle(fontSize: 8),
                                  softWrap: true,
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Center(
                                  child: pw.Text(
                                    "${data.sales[0].bankPaid}", 
                                    style: pw.TextStyle(fontSize: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ): pw.SizedBox(),
                      pw.SizedBox(height: 8.h),
                      dueStatus== "true" ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                      _buildSummaryRow("Previous Due:", data.sales[0].saleMasterPreviousDue),
                      _buildSummaryRow("Current Due:", data.sales[0].saleMasterDueAmount),
                      pw.Divider(thickness: 0.5, color: PdfColors.black),
                      _buildSummaryRow(
                        "Total Due:", 
                        (double.parse("${data.sales[0].saleMasterPreviousDue}") + 
                        double.parse("${data.sales[0].saleMasterDueAmount}"))
                        .toStringAsFixed(2), 
                        isBold: true
                      ),
                    ]): pw.SizedBox(),
                ],
              ),
            ),
            pw.SizedBox(width: 30.w),
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
        
        pw.SizedBox(height: 30),
        pw.Text(
          "In Word: ${numberToWords(double.parse(data.sales[0].saleMasterTotalSaleAmount.toString()).toInt())} BDT only",
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, 
            fontSize: 10,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          "Note: $invoiceNote", 
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, 
            fontSize: 10,
          ),
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
        if (netFooter != null) 
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 20),
            child: pw.Image(pw.MemoryImage(netFooter), height: 50, width: 500),
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
    total += double.tryParse(item.orderQuantity.toString()) ?? 0;
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

// String text এর বদলে dynamic text ব্যবহার করুন
pw.Widget _buildTableCell(dynamic text, {bool isHeader = false, pw.TextAlign align = pw.TextAlign.center}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text?.toString() ?? "", // এখানে null চেক এবং toString() করে দেওয়া হয়েছে
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 9, 
        fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal
      ),
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
    return Scaffold(
      appBar: CustomAppBar(title: "Order Invoice"),
      body: FutureBuilder(
          future: Provider.of<OrdersInvoiceProvider>(context).getOrdersInvoice(context, widget.salesId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              /// Total Calculation
              int totalQty = snapshot.data!.saleDetails.fold<int>(0,(sum, item) => sum + int.tryParse(item.orderQuantity.toString())!);
              double totalAmount = snapshot.data!.saleDetails.fold<double>(0.0,(sum, item) => sum + double.tryParse(item.saleDetailsTotalAmount.toString())!);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
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
                          child: Text("Order Invoice",style: AllTextStyle.cashStatementHeadingTextStyle)),
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
                                ),RichText(
                                  text: TextSpan(
                                    text: 'Mobile : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data!.sales[0].customerMobile,
                                          style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Attention : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data!.sales[0].customerComment,
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
                                    text: 'Prepared By: ',
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
                                    text: 'Invoice No: ',
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
                                    text: 'Sales Date: ',
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
                                RichText(
                                  text: TextSpan(
                                    text: 'Employee: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data!.sales[0].employeeName??"",
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
                            DataColumn(label: Center(child: Text('Sl.', style: TextStyle(fontWeight: FontWeight.bold)))),
                            DataColumn(label: Padding(
                              padding: EdgeInsets.only(left: 10.0.w),
                              child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(label: Center(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Unit Price', style: TextStyle(fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)))),
                          ],
                          rows: [
                            // Table Data Rows
                            ...List.generate(snapshot.data!.saleDetails.length, (index) {
                              return DataRow(cells: [
                                DataCell(Center(child: Text("${index + 1}"))),
                                DataCell(Text("${snapshot.data!.saleDetails[index].productName}", style: TextStyle(fontSize: 10.sp))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].orderQuantity}"))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsRate}"))),
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsTotalAmount}"))),
                              ]);
                            }),
                            // Total Row
                            DataRow(
                              cells: [
                                DataCell(SizedBox()),
                                DataCell(Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Center(child: Text("$totalQty", style: TextStyle(fontWeight: FontWeight.bold)))),
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
                                snapshot.data!.sales[0].bankName != null && snapshot.data!.sales[0].bankName != "null" 
                                ? Table(
                                border: TableBorder.all(color: Colors.grey.shade300),
                                columnWidths: const {
                                  0: FixedColumnWidth(35), 
                                  1: FlexColumnWidth(),    
                                  2: FixedColumnWidth(60), 
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle, 
                                children: [
                                  // Table Header
                                  TableRow(
                                    decoration: BoxDecoration(color: Colors.grey.shade200),
                                    children: [
                                      Center(child: Text("SL", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                      Center(child: Text("Bank", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                      Center(child: Text("Amount", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Center(child: Text("1", style: TextStyle(fontSize: 10.sp))),
                                      Padding(
                                        padding: EdgeInsets.all(2.w), 
                                        child: Text(
                                          "${snapshot.data!.sales[0].bankName??""}", 
                                          style: TextStyle(fontSize: 9.sp),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, 
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.w), 
                                        child: Text(
                                          snapshot.data!.sales[0].bankPaid, 
                                          style: TextStyle(fontSize: 9.sp),
                                          softWrap: true,
                                          overflow: TextOverflow.visible, 
                                          textAlign: TextAlign.center, 
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ):SizedBox(),
                                SizedBox(height: 5.h),
                                dueStatus == "true" ? Column(
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
                                    Container(height: 1.h,color: Colors.black),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                        Text(double.parse("${double.parse('${snapshot.data!.sales[0].saleMasterPreviousDue}') + double.parse('${snapshot.data!.sales[0].saleMasterDueAmount}')}").toStringAsFixed(2),style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.0.w),
                          Expanded(
                            flex: 4,
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
                                    Text("Tr. Cost:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
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
                      Text("Note: $invoiceNote", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              );
            }else {
              return const SizedBox();
            }
          }
      )
    );
  }
}
