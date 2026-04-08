import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barishal_surgical/utils/const_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_widget/custom_appbar.dart';
import '../../../providers/sales_module_providers/sales_invoice_provider.dart';
import '../../../providers/sales_module_providers/sales_provider.dart';
import '../../../utils/all_textstyle.dart';

class SalesInvoiceScreen extends StatefulWidget {
  const SalesInvoiceScreen({super.key, required this.salesId});
  final String salesId;
  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
  double totalDue = 0.0;
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
    Provider.of<SalesProvider>(context, listen: false).getSales(context,"", "", "", "", "");
    super.initState();
  }

  Future<void> printInvoice(data) async {
    final pdf = pw.Document();
    final  logoImg = await rootBundle.load('images/mglogo.webp');
    final  logoImage = logoImg.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.only(left:0.0.w,right: 0.0.w,top:20.0.h,bottom:15.0.h),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logoImage), width: 180.w, height: 180.h),
              pw.Text(companyName, style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                repotHeading, 
                textAlign: pw.TextAlign.center, 
                style: pw.TextStyle(
                  fontSize: 25.sp, 
                  fontWeight: pw.FontWeight.bold
                ),
              ),
              pw.SizedBox(height: 25.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              pw.Text("Sales Invoice", style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 35.h),
              pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                          children: [
                            pw.Text(
                                "Customer: ",
                                style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                            pw.Text(data!.sales[0].customerName,
                                style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                          ]),
                          pw.SizedBox(height: 15.h),
                          pw.Row(
                          children: [
                            pw.Text(
                                "Contact: ",
                                style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold,)),
                            pw.Text(data.sales[0].customerMobile,
                                style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold,)),
                          ]),
                        ]
                    ),
                    ///====
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                        children: [
                          pw.Text("Date: ",style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data.sales[0].saleMasterSaleDate,style: pw.TextStyle(fontSize: 23.sp,fontWeight: pw.FontWeight.bold)),
                        ]),
                        pw.SizedBox(height: 15.h),
                        pw.Row(
                        children: [
                          pw.Text("Saved by:", style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data.sales[0].addedBy,style: pw.TextStyle(fontSize: 23.sp,fontWeight: pw.FontWeight.bold)),
                        ]),
                      ]
                    ),
                  ]
                ),
              ]),
              pw.SizedBox(height: 35.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Sl.',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Description',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Qty',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Price',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Total',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                ],
              ),
              pw.SizedBox(height: 5.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              for (int i = 0; i < data.saleDetails.length; i++) ...[
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 10.0.h),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(" ${(i + 1).toString()}.",
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(data.saleDetails[i].productName,
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(width: 100.w),
                      pw.SizedBox(width: 100.w),
                      pw.SizedBox(width: 100.w),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 5.0.h),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(width: 50.w),
                      pw.SizedBox(width: 150.w),
                      pw.Text(
                        data.saleDetails[i].saleDetailsTotalQuantity,
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        data.saleDetails[i].saleDetailsRate,
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(data.saleDetails[i].saleDetailsTotalAmount,
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Divider between items
                pw.SizedBox(height: 5.h),
                pw.Divider(color: PdfColors.black, thickness: 5),
                pw.SizedBox(height: 5.h),
              ],

              ///====subtotal part
              pw.Padding(
                padding: pw.EdgeInsets.only(top: 20.0.h),
                child:  pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 20.0.h),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(children: []),
                            pw.Row(children: []),
                          ]
                        ),
                        ///====
                        pw.Column(
                        children: [
                          pw.Row(children: [
                            pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.SizedBox(height: 10.0.h),
                              pw.Text(""),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text("Sub Total:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text("(-)Discount:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text("(+)Vat:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.h),
                              pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.w),
                              pw.SizedBox(height: 15.h),
                              pw.Text("Net Total:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text("Cash Received:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.h),
                              pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.h),
                              pw.SizedBox(height: 15.h),
                              pw.Text("Cash Returned:", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                            ]),
                            pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.SizedBox(height: 18.0.h),
                              pw.Text(data.sales[0].saleMasterSubTotalAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text(data.sales[0].saleMasterTotalDiscountAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text(data.sales[0].saleMasterTaxAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.h),
                              pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.w),
                              pw.SizedBox(height: 15.h),
                              pw.Text(data.sales[0].saleMasterTotalSaleAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.0.h),
                              pw.Text(data.sales[0].saleMasterPaidAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10.h),
                              pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.w),
                              pw.SizedBox(height: 15.h),
                              pw.Text(data.sales[0].saleMasterDueAmount, style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                            ]),
                          ]),
                        ]
                        ),
                      ]
                  ),
                 ]
                ),
              ),
              pw.SizedBox(height: 45.h),
              pw.Text("Contact no: 01946-700300",textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 28.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              pw.Text("Software by: Big Technology, Contact no: 01946-700300",textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 28.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 25.h),
              // pw.SizedBox(height: 15 * PdfPageFormat.mm),
              // pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //     children: [
              //         pw.Text('Received by:',
              //             style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 fontSize: 28,decoration: pw.TextDecoration.underline)),
              //         pw.Text('Check by:',
              //             style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 fontSize: 28,decoration: pw.TextDecoration.underline)),
              //         pw.Text('Authorized by:',
              //             style: pw.TextStyle(
              //                 fontWeight: pw.FontWeight.bold,
              //                 fontSize: 28,
              //               decoration: pw.TextDecoration.underline
              //             )),
              //     ]),
              // pw.SizedBox(height: 10 * PdfPageFormat.mm),
              // pw.SizedBox(height: 25.h),
              // pw.Text('** THANK YOU FOR YOUR BUSINESS **',
              //     style: pw.TextStyle(
              //         fontWeight: pw.FontWeight.bold,
              //         fontSize: 28)),
              // pw.SizedBox(height: 2 * PdfPageFormat.mm),
              // pw.Divider(),
            ],
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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
      appBar: CustomAppBar(title: "Sales Invoice"),
      body:FutureBuilder(
          future: Provider.of<SalesInvoiceProvider>(context).getSalesInvoice(context, widget.salesId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              /// Total Calculation
              int totalQty = snapshot.data!.saleDetails.fold<int>(0,(sum, item) => sum + int.tryParse(item.saleDetailsTotalQuantity.toString())!);
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
                          child: Text("Sales Invoice",style: AllTextStyle.cashStatementHeadingTextStyle)),
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
                                    text: 'Sales By:',
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
                                DataCell(Center(child: Text("${snapshot.data!.saleDetails[index].saleDetailsTotalQuantity}"))),
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





// import 'dart:convert' show utf8;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../common_widget/custom_appbar.dart';
// import '../../../utils/all_textstyle.dart';
//
// class SalesInvoiceScreen extends StatefulWidget {
//   const SalesInvoiceScreen({super.key,
//     //required this.salesId
//   });
//   //final String salesId;
//   @override
//   State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
// }
// class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
//   double totalDue = 0.0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "Sales Invoice"),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(10.r),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 5.0.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Icon(Icons.print,color: Colors.teal.shade900),
//                   SizedBox(width: 3.0.w),
//                   Text("Print",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal.shade900,fontSize: 18.0.sp)),
//                 ],
//               ),
//               Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider()),
//               Align(
//                   alignment: Alignment.center,
//                   child: Text("Sales Invoice",style: AllTextStyle.cashStatementHeadingTextStyle)),
//               Padding(padding: EdgeInsets.symmetric(vertical: 1.h),child: Divider()),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             text: 'Customer Id : ',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: "",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),RichText(
//                           text: TextSpan(
//                             text: 'Name : ',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: "",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),RichText(
//                           text: TextSpan(
//                             text: 'Mobile : ',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: "",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             text: 'Sales By:',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: "",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Invoice No:',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   text: "",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Sales Date:',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w700
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                   //text: Utils.formatFrontEndDate("${22-02-2025}"),
//                                   text: "${22-02-2025}",
//                                   style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               RichText(
//                 text: TextSpan(
//                   text: 'Address : ',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 10.sp,
//                       fontWeight: FontWeight.w700
//                   ),
//                   children: <TextSpan>[
//                     TextSpan(
//                         text: "",
//                         style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(padding: EdgeInsets.symmetric(vertical: 2.h),child: Divider()),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   headingRowHeight: 20.0.h,
//                   dataRowHeight: 20.0.h,
//                   showCheckboxColumn: true,
//                   border: TableBorder.all(color: Colors.black54, width: 1.w),
//                   dataTextStyle: TextStyle(fontSize: 10.sp, color: Colors.black),
//                   columns: [
//                     DataColumn(label: Center(child: Text('SL',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                     DataColumn(label: Padding(
//                       padding: EdgeInsets.only(left: 40.0.w),
//                       child: Text('Description',style: TextStyle(fontSize: 10.sp, color: Colors.black)),
//                     )),
//                     DataColumn(label: Center(child: Text('Qnty',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                     DataColumn(label: Center(child: Text('Unit Price',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                     DataColumn(label: Center(child: Text('Total',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                   ],
//                   rows: List.generate(
//                     ///snapshot.data?.saleDetails.length ?? 0,
//                     5,
//                         (int index) {
//                       return DataRow(cells: <DataCell>[
//                         DataCell(Center(child: Text("${index + 1}"))),
//                         DataCell(Center(child: Text('',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                         DataCell(Center(child: Text("",style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                         DataCell(Center(child: Text('',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                         DataCell(Center(child: Text('',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
//                       ]);
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Previous Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Current Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Divider(color: Colors.black),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Total Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 100.0.w),
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Sub Total:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Discount:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Vat:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Transport Cost:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Divider(color: Colors.black,height: 2.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Total:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Paid:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                           ],
//                         ),
//                         Divider(color: Colors.black,height: 2.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
//                             Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               SelectableText("In Word:${"1000"}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
//               SizedBox(height: 10.h),
//               Text("Note:${"Thank You"}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
//               SizedBox(height: 10.h),
//             ],),
//         ),
//       ),
//
//
//
//       // body: FutureBuilder(
//       //   future: Provider.of<SalesInvoiceProvider>(context).getSalesInvoice(context, widget.salesId),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       double previousDue = double.tryParse(snapshot.data?.sales[0].saleMasterPreviousDue ?? '') ?? 0.0;
//       //       double dueAmount = double.tryParse(snapshot.data?.sales[0].saleMasterDueAmount ?? '') ?? 0.0;
//       //       totalDue = previousDue + dueAmount;
//       //       return const Center(
//       //         child: CircularProgressIndicator(),
//       //       );
//       //     } else if (snapshot.hasData) {
//       //       return SingleChildScrollView(
//       //         child: Container(
//       //           padding: const EdgeInsets.all(10),
//       //           child: Column(
//       //             crossAxisAlignment: CrossAxisAlignment.start,
//       //             children: [
//       //               const SizedBox(height: 10.0),
//       //               Align(
//       //                 alignment: Alignment.topLeft,
//       //                 child: SizedBox(
//       //                   height: 30,
//       //                   child: ElevatedButton(
//       //                     onPressed: () {
//       //                       createPdf(snapshot.data);
//       //                     },
//       //                     style: ElevatedButton.styleFrom(
//       //                         elevation: 5,
//       //                         backgroundColor: Colors.green.shade100
//       //                     ),
//       //                     child: const Text("Save As PDF",style: TextStyle(color: Colors.black)),
//       //                   ),
//       //                 ),
//       //               ),
//       //               const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
//       //               Align(
//       //                   alignment: Alignment.center,
//       //                   child: Text("Sales Invoice",style: AllTextStyle.cashStatementHeadingTextStyle)),
//       //               const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
//       //               Row(
//       //                 crossAxisAlignment: CrossAxisAlignment.start,
//       //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                 children: [
//       //                   Expanded(
//       //                     flex: 5,
//       //                     child: Column(
//       //                       crossAxisAlignment: CrossAxisAlignment.start,
//       //                       children: [
//       //                         RichText(
//       //                           text: TextSpan(
//       //                             text: 'Customer Id : ',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: snapshot.data?.sales[0].customerCode??"",
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),RichText(
//       //                           text: TextSpan(
//       //                             text: 'Name : ',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: snapshot.data?.sales[0].customerName??"",
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),RichText(
//       //                           text: TextSpan(
//       //                             text: 'Mobile : ',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: snapshot.data?.sales[0].customerMobile??"",
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                   Expanded(
//       //                     flex: 5,
//       //                     child: Column(
//       //                       crossAxisAlignment: CrossAxisAlignment.end,
//       //                       children: [
//       //                         RichText(
//       //                           text: TextSpan(
//       //                             text: 'Sales By:',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: snapshot.data?.sales[0].addedBy??"",
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),
//       //                         RichText(
//       //                           text: TextSpan(
//       //                             text: 'Invoice No:',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: snapshot.data?.sales[0].saleMasterInvoiceNo??"",
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),
//       //                         RichText(
//       //                           text: TextSpan(
//       //                             text: 'Sales Date:',
//       //                             style: const TextStyle(
//       //                                 color: Colors.black,
//       //                                 fontSize: 10,
//       //                                 fontWeight: FontWeight.w700
//       //                             ),
//       //                             children: <TextSpan>[
//       //                               TextSpan(
//       //                                   text: Utils.formatFrontEndDate("${snapshot.data?.sales[0].saleMasterSaleDate}"),
//       //                                   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                               ),
//       //                             ],
//       //                           ),
//       //                         ),
//       //                         // RichText(
//       //                         //   text: TextSpan(
//       //                         //     text: 'Employee:',
//       //                         //     style: const TextStyle(
//       //                         //         color: Colors.black,
//       //                         //         fontSize: 10,
//       //                         //         fontWeight: FontWeight.w700
//       //                         //     ),
//       //                         //     children: <TextSpan>[
//       //                         //       TextSpan(
//       //                         //           text: "${snapshot.data?.sales[0].employeeName}",
//       //                         //           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                         //       ),
//       //                         //     ],
//       //                         //   ),
//       //                         // ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //               RichText(
//       //                 text: TextSpan(
//       //                   text: 'Address : ',
//       //                   style: const TextStyle(
//       //                       color: Colors.black,
//       //                       fontSize: 10,
//       //                       fontWeight: FontWeight.w700
//       //                   ),
//       //                   children: <TextSpan>[
//       //                     TextSpan(
//       //                         text: snapshot.data?.sales[0].customerAddress??"",
//       //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
//       //                     ),
//       //                   ],
//       //                 ),
//       //               ),
//       //               const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
//       //               SingleChildScrollView(
//       //                 scrollDirection: Axis.horizontal,
//       //                 child: DataTable(
//       //                   headingRowHeight: 20.0,
//       //                   dataRowHeight: 20.0,
//       //                   showCheckboxColumn: true,
//       //                   border: TableBorder.all(color: Colors.black54, width: 1),
//       //                   dataTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
//       //                   columns: const [
//       //                     DataColumn(label: Center(child: Text('SL',style: TextStyle(fontSize: 10, color: Colors.black)))),
//       //                     DataColumn(label: Padding(
//       //                       padding: EdgeInsets.only(left: 40.0),
//       //                       child: Text('Description',style: TextStyle(fontSize: 10, color: Colors.black)),
//       //                     )),
//       //                     DataColumn(label: Center(child: Text('Qnty',style: TextStyle(fontSize: 10, color: Colors.black)))),
//       //                     DataColumn(label: Center(child: Text('Unit Price',style: TextStyle(fontSize: 10, color: Colors.black)))),
//       //                     DataColumn(label: Center(child: Text('Total',style: TextStyle(fontSize: 10, color: Colors.black)))),
//       //                   ],
//       //                   rows: List.generate(
//       //                     snapshot.data?.saleDetails.length ?? 0,
//       //                         (int index) {
//       //                       return DataRow(cells: <DataCell>[
//       //                         DataCell(Center(child: Text("${index + 1}"))),
//       //                         DataCell(Center(child: Text(snapshot.data?.saleDetails[index].productName ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
//       //                         DataCell(Center(child: Text("${snapshot.data?.saleDetails[index].saleDetailsTotalQuantity ?? ''} ${snapshot.data?.saleDetails[index].unitName??""}",style: const TextStyle(fontSize: 10, color: Colors.black)))),
//       //                         DataCell(Center(child: Text(snapshot.data?.saleDetails[index].saleDetailsRate ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
//       //                         DataCell(Center(child: Text(snapshot.data?.saleDetails[index].saleDetailsTotalAmount ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
//       //                       ]);
//       //                     },
//       //                   ),
//       //                 ),
//       //               ),
//       //               const SizedBox(height: 10),
//       //               Row(
//       //                 crossAxisAlignment: CrossAxisAlignment.start,
//       //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                 children: [
//       //                   const Expanded(
//       //                     flex: 5,
//       //                     child: Column(
//       //                       crossAxisAlignment: CrossAxisAlignment.start,
//       //                       children: [
//       //                         // Text(
//       //                         //   "Previous Due: ${snapshot.data?.sales[0].saleMasterPreviousDue??""}",
//       //                         //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         // ),
//       //                         // Text(
//       //                         //   "Current Due: ${snapshot.data?.sales[0].saleMasterDueAmount??""}",
//       //                         //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         // ),
//       //                         // const Divider(color: Colors.black, endIndent: 60),
//       //                         // Text(
//       //                         //   "Total Due: ${double.parse("${double.parse(snapshot.data?.sales[0].saleMasterPreviousDue??"0.0") + double.parse(snapshot.data?.sales[0].saleMasterDueAmount??"0.0")}").toStringAsFixed(2)}",
//       //                         //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         // ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                   Expanded(
//       //                     flex: 5,
//       //                     child: Column(
//       //                       crossAxisAlignment: CrossAxisAlignment.end,
//       //                       children: [
//       //                         Text(
//       //                           "Sub Total:  ${snapshot.data?.sales[0].saleMasterSubTotalAmount??""}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         Text(
//       //                           "Vat: ${snapshot.data?.sales[0].saleMasterTaxAmount??""}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         Text(
//       //                           "Discount: ${snapshot.data?.sales[0].saleMasterTotalDiscountAmount??""}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         Text(
//       //                           "Transport Cost: ${snapshot.data?.sales[0].saleMasterFreight??""}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         // Text(
//       //                         //   "Previous Due: ${allSalesInvoicesModelData.sales[0].saleMasterPreviousDue}",
//       //                         //   style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
//       //                         // ),
//       //                         const Divider(color: Colors.black,height: 2, indent: 80),
//       //                         Text(
//       //                           "Total: ${double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0")}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         Text(
//       //                           "Paid:  ${snapshot.data?.sales[0].saleMasterPaidAmount??""}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                         const Divider(color: Colors.black,height: 2, indent: 80),
//       //                         Text(
//       //                           "Due: ${(double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0")) - double.parse(snapshot.data?.sales[0].saleMasterPaidAmount??"0.0")}",
//       //                           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
//       //                         ),
//       //                       ],
//       //                     ),
//       //                   ),
//       //                 ],
//       //               ),
//       //               const SizedBox(height: 20),
//       //               SelectableText(
//       //                 "In Word: ${converter.convertDouble(double.parse(double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0").toStringAsFixed(2)))}".toUpperCase(),
//       //                 style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
//       //               ),
//       //               const SizedBox(height: 10),
//       //               Text("Note: ${snapshot.data?.sales[0].saleMasterDescription??""}",
//       //                   style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
//       //               const SizedBox(height: 10),
//       //             ],),
//       //         ),
//       //       );
//       //     } else {
//       //       return Container();
//       //     }
//       //   },
//       // ),
//     );
//   }
// }