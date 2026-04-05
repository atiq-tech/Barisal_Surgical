import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barishal_surgical/models/sales_module_models/sales_model.dart';
import 'package:barishal_surgical/providers/sales_module_providers/sales_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../common_widget/custom_appbar.dart';
import '../../../utils/all_textstyle.dart';

class OrderInvoiceListScreen extends StatefulWidget {
  const OrderInvoiceListScreen({super.key});

  @override
  State<OrderInvoiceListScreen> createState() => _OrderInvoiceListScreenState();
}

class _OrderInvoiceListScreenState extends State<OrderInvoiceListScreen> {

  var invoiceController = TextEditingController();
  String? _selectedInvoice;
  double totalDue = 0.0;

  @override
  void initState() {
    // Provider.of<GetSalesProvider>(context, listen: false).getGatSales("", "", "", "", "",);
    // Provider.of<SalesInvoiceProvider>(context, listen: false).getSalesInvoice(context, "");
    ///Provider.of<EmployeesProvider>(context, listen: false).getEmployees();
    // TODO: implement initState
    super.initState();
  }

  // late Future<Uint8List> imageBytes;
  // Future<Uint8List> fetchImageData(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     throw Exception('Failed to load image');
  //   }
  // }
  ///
  // Future<void> printInvoice() async {
  //   final pdf = pw.Document();
  //   final  logoImg = await rootBundle.load('images/mglogo.webp');
  //   final  logoImage = logoImg.buffer.asUint8List();
  //   pdf.addPage(
  //     pw.MultiPage(
  //       margin: pw.EdgeInsets.all(0.r),
  //       build: (pw.Context context) {
  //         int totalQuantity = 0;
  //         int totalAmount = 0;
  //
  //         for (int index = 0; index < 5; index++) {
  //           totalQuantity += 10;
  //           totalAmount += 15000;
  //         }
  //         return [
  //           pw.Row(children: [
  //             pw.Image(pw.MemoryImage(logoImage), width: 110.w, height: 120.h),
  //             pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 pw.Text('Link Up Technology Ltd.', style: pw.TextStyle(fontSize: 30.sp,fontWeight: pw.FontWeight.bold)),
  //                 pw.Text('Mirpur 10, Dhaka', style: pw.TextStyle(fontSize: 30.sp,fontWeight: pw.FontWeight.bold)),
  //               ],
  //             ),
  //
  //           ]),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //           pw.SizedBox(height: 6.0.h),
  //           pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Align(
  //             alignment: pw.Alignment.center,
  //             child: pw.Text('Sales Invoice', style: pw.TextStyle(fontSize: 35.sp,fontWeight: pw.FontWeight.bold)),
  //           ),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Row(
  //              children: [
  //               pw.Text('Customer Id: ', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('C0051106', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //              ],
  //            ),
  //            pw.Row(
  //             children: [
  //              pw.Text('Name: ', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //              pw.Text('Iftikar Islam Atiq', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //              ],
  //            ),
  //           pw.Row(
  //             children: [
  //               pw.Text('Mobile: ', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('01566998850', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             children: [
  //               pw.Text('Sales by: ', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('admin', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             children: [
  //               pw.Text('Invoice No.:', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('250100004', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             children: [
  //               pw.Text('Sales Date:', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('2025-02-17', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             children: [
  //               pw.Text('Address: ', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //               pw.Text('Mohammadpur-1207', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.SizedBox(height: 10.0.h),
  //           pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //           pw.SizedBox(height: 10.0.h),
  //
  //         pw.Table(
  //         border: pw.TableBorder.all(color: PdfColors.black, width: 2.5.w),
  //         columnWidths: {
  //         0: pw.FlexColumnWidth(1),
  //         1: pw.FlexColumnWidth(3),
  //         2: pw.FlexColumnWidth(1),
  //         3: pw.FlexColumnWidth(2),
  //         4: pw.FlexColumnWidth(2),
  //         },
  //         children: [
  //         pw.TableRow(
  //         children: [
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('SL', style: pw.TextStyle(fontSize: 25.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('Description', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('Qty', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('Unit Price', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('Total', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         ],
  //         ),
  //         for (int index = 0; index < 5; index++)
  //         pw.TableRow(
  //         children: [
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('${index + 1}', style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
  //         child: pw.Container(
  //         width: 100.w,
  //         child: pw.Text(
  //         'Hopson Water Sealer 0.91Ltr.- P00249',
  //         style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold),
  //         textAlign: pw.TextAlign.justify,
  //         softWrap: true,
  //         ),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('10', style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('1500', style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('15000', style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         ],
  //         ),
  //         pw.TableRow(
  //         children: [
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('Total:', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('$totalQuantity', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         pw.Padding(
  //         padding: pw.EdgeInsets.symmetric(vertical: 3.h),
  //         child: pw.Center(
  //         child: pw.Text('$totalAmount', style: pw.TextStyle(fontSize: 24.sp, fontWeight: pw.FontWeight.bold)),
  //         ),
  //         ),
  //         ],
  //         ),
  //         ],
  //         ),
  //           pw.SizedBox(height: 15.h),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Expanded(
  //                 flex: 5,
  //                 child: pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                   children: [
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Prev. Due:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("10500:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Cur. Due:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Total Due:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.SizedBox(height: 62.0.h),
  //                   ],
  //                 ),
  //               ),
  //               pw.SizedBox(width: 4.w),
  //               pw.Container(width: 2.0.w,height: 190.h,color: PdfColors.black),
  //               pw.SizedBox(width: 4.w),
  //               pw.Expanded(
  //                 flex: 5,
  //                 child: pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                   children: [
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Sub Total:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Discount:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Vat:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Tr. Cost:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Total:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Paid:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                     pw.Container(width: double.infinity,height: 2.5.h,color: PdfColors.black),
  //                     pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text("Due:", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                         pw.Text("1000:00", style: pw.TextStyle(fontSize: 22.sp,fontWeight: pw.FontWeight.bold)),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           pw.SizedBox(height: 15.h),
  //           pw.Text(
  //             "In Word: ${numberToWords(75000)} BDT only",
  //             style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25.sp),
  //           ),
  //           //pw.Text('In Word: 1000:00', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //           pw.SizedBox(height: 5.h),
  //           pw.Text('Note: Requisition Sale', style: pw.TextStyle(fontSize: 25.sp,fontWeight: pw.FontWeight.bold)),
  //         ];
  //       },
  //     ),
  //   );
  //
  //   try {
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdf.save(),
  //     );
  //   } catch (e) {
  //     print("Error printing: $e");
  //   }
  // }


  Future<void> printInvoice() async {
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
              pw.Text("Link Up Technology Ltd.", style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold)),
              pw.Text("Mirpur-10,Dhaka", style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 25.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              pw.Text("Order Invoice", style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold)),
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
                                      pw.Text("Atiq",
                                          style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                                    ]),
                                pw.SizedBox(height: 15.h),
                                pw.Row(
                                    children: [
                                      pw.Text(
                                          "Contact: ",
                                          style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold,)),
                                      pw.Text("01522359855",
                                          style: pw.TextStyle(fontSize: 22.sp, fontWeight: pw.FontWeight.bold,)),
                                    ]),
                              ]
                          ),
                          ///====
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Row(
                                    children: [
                                      pw.Text(
                                          "Date: ",
                                          style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                                      pw.Text("23-02-2025",
                                          style: pw.TextStyle(fontSize: 23.sp,
                                              fontWeight: pw.FontWeight.bold)),
                                    ]),
                                pw.SizedBox(height: 15.h),
                                pw.Row(
                                    children: [
                                      pw.Text("Saved by:", style: pw.TextStyle(fontSize: 23.sp, fontWeight: pw.FontWeight.bold)),
                                      pw.Text('Admin',
                                          style: pw.TextStyle(fontSize: 23.sp,
                                              fontWeight: pw.FontWeight.bold)),
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
                  pw.Text('SL',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Description',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Qty',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Price',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                  pw.Text('Total',style: pw.TextStyle(fontSize: 26.sp,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                ],
              ),
              pw.SizedBox(height: 5.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              for (int i = 0; i < 2; i++) ...[
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 10.0.h),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(" ${(i + 1).toString()}.",
                        style: pw.TextStyle(fontSize: 28.sp, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center,
                      ),
                      pw.Text("Dulux Paint 5Ltr.-P00567",
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
                        "10",
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        "1500",
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text("15000",
                        style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
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
                              //crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                                          pw.SizedBox(height: 10.0.h),
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                                          pw.SizedBox(height: 10.0.h),
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                                          pw.SizedBox(height: 10.h),
                                          pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.w),
                                          pw.SizedBox(height: 15.h),
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                                          pw.SizedBox(height: 10.0.h),
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
                                          pw.SizedBox(height: 10.h),
                                          pw.Container(color: PdfColors.black,height: 5.h, width: 230.0.w),
                                          pw.SizedBox(height: 15.h),
                                          pw.Text("1500", style: pw.TextStyle(fontSize: 26.sp, fontWeight: pw.FontWeight.bold)),
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
              pw.Text("Contact no:",textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 28.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5.h),
              pw.Divider(color: PdfColors.black, thickness: 5),
              pw.SizedBox(height: 5.h),
              pw.Text("Software by: Big Technology, Contact no: 01946-700300",textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 28.sp, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 25.h),
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
    ///invoice
    final allSalesInvoicesData = Provider.of<SalesProvider>(context).saleslist;
    ///
    List<Map<String, dynamic>> saleDetails = [
      {"description": "Hopson Water Sealer 0.91Ltr. - P00249","productCode": "P00249", "category": "Paint", "order qty": 12,"delivery Qty": 5, "unit": "Box", "unitPrice": 137.00, "total": 1548.00},
      {"description": "Dulux Paint 5Ltr. - P00567", "productCode": "P00567", "category": "Paint", "order qty": 8, "delivery Qty": 8, "unit": "Pcs", "unitPrice": 200.00, "total": 1600.00},
    ];

    // Total Calculation
    int totalOrdQty = saleDetails.fold<int>(0, (sum, item) => sum + (item["order qty"] as int));
    int totalDQty = saleDetails.fold<int>(0, (sum, item) => sum + (item["delivery Qty"] as int));
    double totalAmount = saleDetails.fold(0.0, (sum, item) => sum + item["total"]);
    
    return Scaffold(
      appBar: CustomAppBar(title: "Order Invoice List"),
      body: Container(
        padding: EdgeInsets.all(8.0.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.0.r),
                decoration: BoxDecoration(
                  color:Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(6.0.r),
                  border: Border.all(color: Colors.teal,width: 1.0.w),
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
                        // child: TypeAheadFormField(
                        //   textFieldConfiguration: TextFieldConfiguration(
                        //       onChanged: (value){
                        //         if (value == '') {
                        //           _selectedInvoice = '';
                        //         }
                        //       },
                        //       style: TextStyle(fontSize: 12,color: Colors.grey.shade600),
                        //       controller: invoiceController,
                        //       decoration: InputDecoration(
                        //         contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        //         hintText: 'Select Invoice',
                        //         isDense: true,
                        //         hintStyle: const TextStyle(fontSize: 12.0),
                        //         suffix: _selectedInvoice == '' ? null : GestureDetector(
                        //           onTap: () {
                        //             setState(() {
                        //               invoiceController.text = '';
                        //             });
                        //           },
                        //           child: const Padding(
                        //             padding: EdgeInsets.symmetric(horizontal: 3),
                        //             child: Icon(Icons.close,size: 14,),
                        //           ),
                        //         ),
                        //       )
                        //   ),
                        //   suggestionsCallback: (pattern) {
                        //     return allSalesInvoicesData
                        //         .where((element) => element
                        //         .saleMasterInvoiceNo
                        //         .toLowerCase()
                        //         .contains(pattern
                        //         .toString()
                        //         .toLowerCase()))
                        //         .take(allSalesInvoicesData.length)
                        //         .toList();
                        //     // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                        //   },
                        //   itemBuilder: (context, suggestion) {
                        //     return SizedBox(
                        //       width: double.infinity,
                        //       child: Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        //         child: Text("${suggestion.saleMasterInvoiceNo} - ${suggestion.customerName}",
                        //             style: const TextStyle(fontSize: 12),
                        //             maxLines: 1, overflow: TextOverflow.ellipsis),
                        //       ),
                        //     );
                        //   },
                        //   transitionBuilder: (context, suggestionsBox, controller) {
                        //     return suggestionsBox;
                        //   },
                        //   onSuggestionSelected: (GetSalesModel suggestion) {
                        //     // invoiceController.text = suggestion.saleMasterInvoiceNo!;
                        //     setState(() {
                        //       invoiceController.text = "${suggestion.saleMasterInvoiceNo} - ${suggestion.customerName}";
                        //       _selectedInvoice = suggestion.saleMasterSlNo.toString();
                        //       ///////Provider.of<AllSalesInvoiceProvider>(context, listen: false).getAllSalesInvoice(context, _selectedInvoice);
                        //       Provider.of<SalesInvoiceProvider>(context, listen: false).getSalesInvoice(context, _selectedInvoice);
                        //     });
                        //   },
                        //   onSaved: (value) {},
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              invoiceController.text == "" ? Container(
                margin: EdgeInsets.only(top: 1.0.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.0.h),
                      GestureDetector(
                        onTap:printInvoice,
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
                            child: Text("Order Invoice",style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black)),
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
                                          text: "C00581",
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
                                          text: "Iftikar Islam Atiq",
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
                                        //text: Utils.formatFrontEndDate("${22-02-2025}"),
                                          text: "Atiqur Rahman Atiq",
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
                                          text: "Admin",
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
                                          text: "100552698",
                                          style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Date:',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        //text: Utils.formatFrontEndDate("${22-02-2025}"),
                                          text: "22-02-2025",
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
                                text: "Mohammadpur-1207,Dhaka",
                                style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w400)
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2.h),child: Divider()),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: DataTable(
                      //     headingRowHeight: 20.0.h,
                      //     dataRowHeight: 20.0.h,
                      //     showCheckboxColumn: true,
                      //     border: TableBorder.all(color: Colors.black54, width: 1.w),
                      //     dataTextStyle: TextStyle(fontSize: 10.sp, color: Colors.black),
                      //     columns: [
                      //       DataColumn(label: Center(child: Text('SL',style: AllTextStyle.menuHeadTextStyle))),
                      //       DataColumn(label: Padding(
                      //         padding: EdgeInsets.only(left: 40.0.w),
                      //         child: Text('Description',style: AllTextStyle.menuHeadTextStyle),
                      //       )),
                      //       DataColumn(label: Center(child: Text('Qty',style: AllTextStyle.menuHeadTextStyle))),
                      //       DataColumn(label: Center(child: Text('Unit Price',style: AllTextStyle.menuHeadTextStyle))),
                      //       DataColumn(label: Center(child: Text('Total',style: AllTextStyle.menuHeadTextStyle))),
                      //     ],
                      //     rows: List.generate(
                      //       ///snapshot.data?.saleDetails.length ?? 0,
                      //       2,
                      //           (int index) {
                      //         return DataRow(cells: <DataCell>[
                      //           DataCell(Center(child: Text("${index + 1}"))),
                      //           DataCell(Center(child: Text('Hopson Water Sealer 0.91Ltr. - P00249',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
                      //           DataCell(Center(child: Text("12",style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
                      //           DataCell(Center(child: Text('137.00',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
                      //           DataCell(Center(child: Text('1548.00',style: TextStyle(fontSize: 10.sp, color: Colors.black)))),
                      //         ]);
                      //       },
                      //     ),
                      //   ),
                      // ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 20.0.h,
                          dataRowHeight: 20.0.h,
                          showCheckboxColumn: true,
                          border: TableBorder.all(color: Colors.black54, width: 1.w),
                          dataTextStyle: TextStyle(fontSize: 10.sp, color: Colors.black),
                          columns: [
                            DataColumn(label: Center(child: Text('SL', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Product Code', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Padding(
                              padding: EdgeInsets.only(left: 40.0.w),
                              child: Text('Description', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)),
                            )),
                            DataColumn(label: Center(child: Text('Order Qty', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Delivery Qty', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Unit', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Unit Price', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                            DataColumn(label: Center(child: Text('Total', style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.bold)))),
                          ],
                          rows: [
                            // Table Data Rows
                            ...List.generate(saleDetails.length, (index) {
                              var item = saleDetails[index];
                              return DataRow(cells: [
                                DataCell(Center(child: Text("${index + 1}"))),
                                DataCell(Center(child: Text("${item["productCode"]}"))),
                                DataCell(Text(item["description"], style: TextStyle(fontSize: 10.sp))),
                                DataCell(Center(child: Text("${item["order qty"]}"))),
                                DataCell(Center(child: Text('${item["delivery Qty"]}'))),
                                DataCell(Center(child: Text('${item["unit"]}'))),
                                DataCell(Center(child: Text('${item["unitPrice"]}'))),
                                DataCell(Center(child: Text('${item["total"]}'))),
                              ]);
                            }),
                            // Total Row
                            DataRow(
                              cells: [
                                DataCell(SizedBox()),
                                DataCell(SizedBox()), // Empty SL Column
                                DataCell(Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Center(child: Text("$totalOrdQty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(Center(child: Text("$totalDQty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                DataCell(SizedBox()), 
                                DataCell(SizedBox()),// Empty Unit Price Column
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
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Current Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Divider(color: Colors.black),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
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
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Discount:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Vat:",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Transport Cost:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Divider(color: Colors.black,height: 2.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Paid:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Divider(color: Colors.black,height: 2.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Due:", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w700)),
                                    Text("1000", style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w500),
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
                        "In Word: ${numberToWords(179509)} BDT only",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text("Note:${"Requisition Sale"}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                // child: Center(
                //   child: Text("Sales Invoice List"),
                //   // child: FutureBuilder(
                //   //   future: Provider.of<SalesInvoiceProvider>(context, listen: false)
                //   //       .getSalesInvoice(context, _selectedInvoice),
                //   //   builder: (context, snapshot) {
                //   //     if (snapshot.connectionState == ConnectionState.waiting) {
                //   //       double previousDue = double.tryParse(snapshot.data?.sales[0].saleMasterPreviousDue ?? '') ?? 0.0;
                //   //       double dueAmount = double.tryParse(snapshot.data?.sales[0].saleMasterDueAmount ?? '') ?? 0.0;
                //   //
                //   //       // Sum the values
                //   //       totalDue = previousDue + dueAmount;
                //   //       return const Center(
                //   //         child: CircularProgressIndicator(),
                //   //       );
                //   //     } else if (snapshot.hasData) {
                //   //       return Container(
                //   //         child: Column(
                //   //           crossAxisAlignment: CrossAxisAlignment.start,
                //   //           children: [
                //   //             const SizedBox(height: 10.0),
                //   //             Align(
                //   //               alignment: Alignment.topLeft,
                //   //               child: SizedBox(
                //   //                 height: 30,
                //   //                 child: ElevatedButton(
                //   //                   onPressed: () {
                //   //                     createPdf(snapshot.data);
                //   //                   },
                //   //                   style: ElevatedButton.styleFrom(
                //   //                       elevation: 5,
                //   //                       backgroundColor: Colors.green.shade100
                //   //                   ),
                //   //                   child: const Text("Save As PDF",style: TextStyle(color: Colors.black)),
                //   //                 ),
                //   //               ),
                //   //             ),
                //   //             const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
                //   //             const Align(
                //   //                 alignment: Alignment.center,
                //   //                 child: Text("Sales Invoice",style: AllTextStyle.cashStatementHeadingTextStyle)),
                //   //             const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
                //   //             Row(
                //   //               crossAxisAlignment: CrossAxisAlignment.start,
                //   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   //               children: [
                //   //                 Expanded(
                //   //                   flex: 5,
                //   //                   child: Column(
                //   //                     crossAxisAlignment: CrossAxisAlignment.start,
                //   //                     children: [
                //   //                       RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Customer Id : ',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: snapshot.data?.sales[0].customerCode??"",
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Name : ',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: snapshot.data?.sales[0].customerName??"",
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Mobile : ',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: snapshot.data?.sales[0].customerMobile??"",
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),
                //   //                     ],
                //   //                   ),
                //   //                 ),
                //   //                 Expanded(
                //   //                   flex: 5,
                //   //                   child: Column(
                //   //                     crossAxisAlignment: CrossAxisAlignment.end,
                //   //                     children: [
                //   //                       RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Sales By:',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: snapshot.data?.sales[0].addedBy??"",
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),
                //   //                       RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Invoice No:',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: snapshot.data?.sales[0].saleMasterInvoiceNo??"",
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),
                //   //                       RichText(
                //   //                         text: TextSpan(
                //   //                           text: 'Sales Date:',
                //   //                           style: const TextStyle(
                //   //                               color: Colors.black,
                //   //                               fontSize: 10,
                //   //                               fontWeight: FontWeight.w700
                //   //                           ),
                //   //                           children: <TextSpan>[
                //   //                             TextSpan(
                //   //                                 text: Utils.formatFrontEndDate("${snapshot.data?.sales[0].saleMasterSaleDate}"),
                //   //                                 style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                             ),
                //   //                           ],
                //   //                         ),
                //   //                       ),
                //   //                       // RichText(
                //   //                       //   text: TextSpan(
                //   //                       //     text: 'Employee:',
                //   //                       //     style: const TextStyle(
                //   //                       //         color: Colors.black,
                //   //                       //         fontSize: 10,
                //   //                       //         fontWeight: FontWeight.w700
                //   //                       //     ),
                //   //                       //     children: <TextSpan>[
                //   //                       //       TextSpan(
                //   //                       //           text: "${snapshot.data?.sales[0].employeeName}",
                //   //                       //           style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                       //       ),
                //   //                       //     ],
                //   //                       //   ),
                //   //                       // ),
                //   //                     ],
                //   //                   ),
                //   //                 ),
                //   //               ],
                //   //             ),
                //   //             RichText(
                //   //               text: TextSpan(
                //   //                 text: 'Address : ',
                //   //                 style: const TextStyle(
                //   //                     color: Colors.black,
                //   //                     fontSize: 10,
                //   //                     fontWeight: FontWeight.w700
                //   //                 ),
                //   //                 children: <TextSpan>[
                //   //                   TextSpan(
                //   //                       text: snapshot.data?.sales[0].customerAddress??"",
                //   //                       style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w400)
                //   //                   ),
                //   //                 ],
                //   //               ),
                //   //             ),
                //   //             const Padding(padding: EdgeInsets.symmetric(vertical: 5),child: Divider()),
                //   //             SingleChildScrollView(
                //   //               scrollDirection: Axis.horizontal,
                //   //               child: DataTable(
                //   //                 headingRowHeight: 20.0,
                //   //                 dataRowHeight: 20.0,
                //   //                 showCheckboxColumn: true,
                //   //                 border: TableBorder.all(color: Colors.black54, width: 1),
                //   //                 dataTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
                //   //                 columns: const [
                //   //                   // Set the name of the column
                //   //                   DataColumn(label: Center(child: Text('SL',style: TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                   DataColumn(label: Padding(
                //   //                     padding: EdgeInsets.only(left: 40.0),
                //   //                     child: Text('Description',style: TextStyle(fontSize: 10, color: Colors.black)),
                //   //                   )),
                //   //                   DataColumn(label: Center(child: Text('Qnty',style: TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                   DataColumn(label: Center(child: Text('Unit Price',style: TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                   DataColumn(label: Center(child: Text('Total',style: TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                 ],
                //   //                 rows: List.generate(
                //   //                   //allSalesInvoicesModelData?.saleDetails.length ?? 0,
                //   //                   snapshot.data?.saleDetails.length ?? 0,
                //   //                       (int index) {
                //   //                     return DataRow(cells: <DataCell>[
                //   //                       DataCell(Center(child: Text("${index + 1}"))),
                //   //                       DataCell(Center(child: Text(snapshot.data?.saleDetails[index].productName ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                       DataCell(Center(child: Text("${snapshot.data?.saleDetails[index].saleDetailsTotalQuantity ?? ''} ${snapshot.data?.saleDetails[index].unitName??""}",style: const TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                       DataCell(Center(child: Text(snapshot.data?.saleDetails[index].saleDetailsRate ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                       DataCell(Center(child: Text(snapshot.data?.saleDetails[index].saleDetailsTotalAmount ?? '',style: const TextStyle(fontSize: 10, color: Colors.black)))),
                //   //                     ]);
                //   //                   },
                //   //                 ),
                //   //               ),
                //   //             ),
                //   //             const SizedBox(height: 10),
                //   //             Row(
                //   //               crossAxisAlignment: CrossAxisAlignment.start,
                //   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   //               children: [
                //   //                 const Expanded(
                //   //                   flex: 5,
                //   //                   child: Column(
                //   //                     crossAxisAlignment: CrossAxisAlignment.start,
                //   //                     children: [
                //   //                       // Text(
                //   //                       //   "Previous Due: ${snapshot.data?.sales[0].saleMasterPreviousDue??""}",
                //   //                       //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       // ),
                //   //                       // Text(
                //   //                       //   "Current Due: ${snapshot.data?.sales[0].saleMasterDueAmount??""}",
                //   //                       //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       // ),
                //   //                       // const Divider(color: Colors.black, endIndent: 60),
                //   //                       // Text(
                //   //                       //   "Total Due: ${double.parse("${double.parse(snapshot.data?.sales[0].saleMasterPreviousDue??"0.0") + double.parse(snapshot.data?.sales[0].saleMasterDueAmount??"0.0")}").toStringAsFixed(2)}",
                //   //                       //   style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       // ),
                //   //                     ],
                //   //                   ),
                //   //                 ),
                //   //                 Expanded(
                //   //                   flex: 5,
                //   //                   child: Column(
                //   //                     crossAxisAlignment: CrossAxisAlignment.end,
                //   //                     children: [
                //   //                       Text(
                //   //                         "Sub Total:  ${snapshot.data?.sales[0].saleMasterSubTotalAmount??""}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       Text(
                //   //                         "Vat: ${snapshot.data?.sales[0].saleMasterTaxAmount??""}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       Text(
                //   //                         "Discount: ${snapshot.data?.sales[0].saleMasterTotalDiscountAmount??""}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       Text(
                //   //                         "Transport Cost: ${snapshot.data?.sales[0].saleMasterFreight??""}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       // Text(
                //   //                       //   "Previous Due: ${allSalesInvoicesModelData.sales[0].saleMasterPreviousDue}",
                //   //                       //   style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                //   //                       // ),
                //   //                       const Divider(color: Colors.black,height: 2, indent: 80),
                //   //                       Text(
                //   //                         "Total: ${double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0")}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       Text(
                //   //                         "Paid:  ${snapshot.data?.sales[0].saleMasterPaidAmount??""}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                       const Divider(color: Colors.black,height: 2, indent: 100),
                //   //                       Text(
                //   //                         "Due: ${(double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0")) - double.parse(snapshot.data?.sales[0].saleMasterPaidAmount??"0.0")}",
                //   //                         style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),
                //   //                       ),
                //   //                     ],
                //   //                   ),
                //   //                 ),
                //   //               ],
                //   //             ),
                //   //             const SizedBox(height: 20),
                //   //             SelectableText(
                //   //               "In Word: ${converter.convertDouble(double.parse(double.parse(snapshot.data?.sales[0].saleMasterTotalSaleAmount??"0.0").toStringAsFixed(2)))}".toUpperCase(),
                //   //               style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                //   //             ),
                //   //             const SizedBox(height: 10),
                //   //             Text("Note: ${snapshot.data?.sales[0].saleMasterDescription??""}",
                //   //                 style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                //   //             const SizedBox(height: 10),
                //   //           ],),
                //   //       );
                //   //     } else {
                //   //       return Container();
                //   //     }
                //   //   },
                //   // ),
                // ),
              ): Container(),
            ],),
        ),
      ),
    );
  }

//   var converter = NumberToCharacterConverter('en');
//   final pdf = pw.Document();
//   int apiLevel = 0;
//
//   createPdf(SalesInvoiceModel? salesInvoiceModel) async {
//     final tableHeaders = [
//       'Sl.',
//       'Product',
//       'Qnty',
//       'Unit Price',
//       'Total',
//     ];
//
//     final tableData = salesInvoiceModel!.saleDetails.map((SaleDetail e) {
//       return [
//         salesInvoiceModel.saleDetails.indexOf(e) + 1,
//         utf8.decode(utf8.encode(e.productName)),
//         "${e.saleDetailsTotalQuantity} ${e.unitName}",
//         e.saleDetailsRate,
//         e.saleDetailsTotalAmount,
//       ];
//     }).toList();
//
//     final iconImage = (await rootBundle.load('images/dplogo.png')).buffer.asUint8List();
//
//     // final data = await rootBundle.load("fonts/noto_serif.ttf");
//     // final  dataint = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
//
//     final font = await rootBundle.load('fonts/nikosh.ttf');
//     final ttf = pw.Font.ttf(font);
//
//     // final ttf = pw.Font.ttf(data);
//
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     //wait korun apnar kaj ti ekorci
//
//     final androidInfo = await deviceInfoPlugin.androidInfo;
//     apiLevel = androidInfo.version.sdkInt;
//     PermissionStatus storagePermission;
//     print("apiLevel $apiLevel");
//     if(apiLevel < 33) {
//       storagePermission = await Permission.storage.request();
//       if (storagePermission == PermissionStatus.granted) {
//         try {
//           pdf.addPage(
//             pw.MultiPage(
//               pageFormat: PdfPageFormat.a4,
//               build: (context) {
//                 return [
//                   ///top header
//                   pw.Column(
//                     children: [
//                       pw.Row(
//                         children: [
//                           pw.Image(
//                             pw.MemoryImage(iconImage),
//                             height: 70,
//                             width: 100,
//                           ),
//                           pw.SizedBox(width: 10 * PdfPageFormat.mm),
//                           pw.Column(
//                             mainAxisSize: pw.MainAxisSize.min,
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Text('DAILY PASAR (Sister Concern of SAIRAH TRADING SDN BHD)',
//                                 style: pw.TextStyle(fontSize: 12.0, fontWeight: pw.FontWeight.bold),
//                                 overflow: pw.TextOverflow.clip,
//                               ),
//                               pw.Text(
//                                 'NO 15, Jalan 3/10B Spring Crest Industrial Park, 68100,Selayang,\nBatu Caves, Selangor, 68100',
//                                 style: pw.TextStyle(
//                                   fontSize: 10.0, fontWeight: pw.FontWeight.bold,
//                                   // font: ttf,
//                                   font: ttf,
//                                   color: PdfColors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       pw.SizedBox(height: 5 * PdfPageFormat.mm),
//                       pw.Container(
//                         height: 1,
//                         width: double.infinity,
//                         color: PdfColors.black,
//                       ),
//                       pw.SizedBox(height: 3),
//                       pw.Container(
//                         height: 1,
//                         width: double.infinity,
//                         color: PdfColors.black,
//                       ),
//                       pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                     ],
//                   ),
//
//                   ///mid data table
//                   pw.Divider(color: PdfColors.grey),
//                   pw.Align(
//                     alignment: pw.Alignment.center,
//                     child: pw.Text(
//                       'Sales Invoice',
//                       style: pw.TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: pw.FontWeight.bold
//                       ),
//                     ),
//                   ),
//                   pw.Divider(color: PdfColors.grey),
//                   pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Expanded(
//                         flex: 5,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.RichText(
//                               text: pw.TextSpan(
//                                 text: 'Customer Id:',  // Bold text
//                                 style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                                 children: <pw.TextSpan>[
//                                   pw.TextSpan(
//                                     text:  salesInvoiceModel.sales[0].customerCode,  // Normal text
//                                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             pw.RichText(
//                               text: pw.TextSpan(
//                                 text: 'Customer:',  // Bold text
//                                 style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                                 children: <pw.TextSpan>[
//                                   pw.TextSpan(
//                                     text:  salesInvoiceModel.sales[0].customerName,  // Normal text
//                                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             pw.RichText(
//                               text: pw.TextSpan(
//                                 text: 'Mobile:',  // Bold text
//                                 style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                                 children: <pw.TextSpan>[
//                                   pw.TextSpan(
//                                     text:  salesInvoiceModel.sales[0].customerMobile,  // Normal text
//                                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 5,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.end,
//                           children: [
//                             pw.Row(
//                                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                                 children: [
//                                   pw.Text(
//                                     "Sales By: ",
//                                     style: pw.TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: pw.FontWeight.bold,
//                                     ),
//                                   ),
//                                   pw.Text(
//                                     salesInvoiceModel.sales[0].addedBy,
//                                     style: const pw.TextStyle(fontSize: 10),
//                                   ),
//                                 ]),
//                             pw.Row(
//                                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                                 children: [
//                                   pw.Text(
//                                     "Invoice No: ",
//                                     style: pw.TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: pw.FontWeight.bold,
//                                     ),
//                                   ),
//                                   pw.Text(
//                                       salesInvoiceModel.sales[0].saleMasterInvoiceNo,
//                                       style: const pw.TextStyle(fontSize: 10),
//                                       textAlign: pw.TextAlign.right
//                                   ),
//                                 ]),
//                             pw.Row(
//                                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                                 children: [
//                                   pw.Text(
//                                     "Sales Date ",
//                                     style: pw.TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: pw.FontWeight.bold,
//                                     ),
//                                   ),
//                                   pw.Text(
//                                     Utils.formatFrontEndDate(salesInvoiceModel.sales[0].saleMasterSaleDate),
//                                     style: const pw.TextStyle(fontSize: 10),
//                                   ),
//                                 ]),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   pw.RichText(
//                     text: pw.TextSpan(
//                       text: 'Address : ',  // Bold text
//                       style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                       children: <pw.TextSpan>[
//                         pw.TextSpan(
//                           text: salesInvoiceModel.sales[0].customerAddress ?? "",  // Normal text
//                           style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                         ),
//                       ],
//                     ),
//                   ),
//
//
//                   //   // pw.Text(
//                   //   //   utf8.decode(utf8.encode(salesInvoiceModel.sales[0].customerAddress)),
//                   //   //   style: pw.TextStyle(
//                   //   //     fontSize: 12,
//                   //   //     font: ttf,
//                   //   //   ),
//                   //   // ),
//                   // ]),
//                   pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                   pw.Divider(),
//                   pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                   pw.TableHelper.fromTextArray(
//                     headers: tableHeaders,
//                     data: tableData,
//                     border: pw.TableBorder.all(color: PdfColors.black),
//                     headerStyle: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 10
//                     ),
//                     cellStyle: pw.TextStyle(
//                         font: ttf,
//                         fontSize: 10
//                     ),
//                     // headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
//                     cellHeight: 30.0,
//                     cellAlignments: {
//                       0: pw.Alignment.center,
//                       1: pw.Alignment.center,
//                       2: pw.Alignment.center,
//                       3: pw.Alignment.center,
//                       4: pw.Alignment.center,
//                     },
//                   ),
//                   pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                   pw.Row(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Expanded(
//                         flex: 5,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             // pw.Text(
//                             //   "Previous Due: ${salesInvoiceModel.sales[0].saleMasterPreviousDue}",
//                             //   style: pw.TextStyle(
//                             //     fontSize: 10,
//                             //     fontWeight: pw.FontWeight.bold,
//                             //   ),
//                             // ),
//                             // pw.Text(
//                             //   "Current Due: ${salesInvoiceModel.sales[0].saleMasterDueAmount}",
//                             //   style: pw.TextStyle(
//                             //     fontSize: 10,
//                             //     fontWeight: pw.FontWeight.bold,
//                             //   ),
//                             // ),
//                             // pw.Divider(color: PdfColors.black, endIndent: 60),
//                             // pw.Text(
//                             //   "Total Due: ${double.parse("${double.parse(
//                             //       salesInvoiceModel.sales[0].saleMasterPreviousDue) + double.parse(
//                             //       salesInvoiceModel.sales[0].saleMasterDueAmount)}").toStringAsFixed(
//                             //       2)}",
//                             //   style: pw.TextStyle(
//                             //     fontSize: 10,
//                             //     fontWeight: pw.FontWeight.bold,
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       pw.Expanded(
//                         flex: 5,
//                         child: pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.end,
//                           children: [
//                             pw.Text(
//                               "Sub Total:  ${salesInvoiceModel.sales[0].saleMasterSubTotalAmount}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Text(
//                               "Vat: ${salesInvoiceModel.sales[0].saleMasterTaxAmount}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Text(
//                               "Discount: ${salesInvoiceModel.sales[0].saleMasterTotalDiscountAmount}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Text(
//                               "Transport Cost: ${salesInvoiceModel.sales[0].saleMasterFreight}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             // pw.Text(
//                             //   "Previous Due:  ${allSalesInvoiceModel.sales[0].saleMasterPreviousDue}",
//                             //   style: pw.TextStyle(
//                             //     fontSize: 12,
//                             //     fontWeight: pw.FontWeight.bold,
//                             //   ),
//                             // ),
//                             pw.Divider(color: PdfColors.black,height: 2, indent: 80),
//                             pw.Text(
//                               "Total: ${double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount)}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Text(
//                               "Paid:  ${salesInvoiceModel.sales[0].saleMasterPaidAmount}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Divider(color: PdfColors.black,height: 2, indent: 100),
//                             pw.Text(
//                               "Due: ${(double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount)) - double.parse(salesInvoiceModel.sales[0].saleMasterPaidAmount)}",
//                               style: pw.TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   pw.SizedBox(
//                     height: 20,
//                   ),
//                   pw.Text(
//                       "In Word: ${converter.convertDouble(double.parse(double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount).toStringAsFixed(2)))}".toUpperCase(),
//                       style: pw.TextStyle(fontSize: 10,
//                         fontWeight: pw.FontWeight.bold,
//                       )),
//                   pw.SizedBox(
//                     height: 10,
//                   ),
//                   pw.Text(
//                       "Note: ${salesInvoiceModel.sales[0].saleMasterDescription}",
//                       style: pw.TextStyle(fontSize: 10,
//                         fontWeight: pw.FontWeight.bold,
//                       )),
//                   pw.SizedBox(height: 15 * PdfPageFormat.mm),
//                   pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Column(children: [
//                           pw.Text('Received by',
//                               style: pw.TextStyle(
//                                   fontWeight: pw.FontWeight.bold,
//                                   fontSize: 10))
//                         ]),
//                         pw.Column(children: [
//                           pw.Text('Check by',
//                               style: pw.TextStyle(
//                                   fontWeight: pw.FontWeight.bold,
//
//                                   fontSize: 10))
//                         ]),
//                         pw.Column(children: [
//                           pw.Text('Authorized by',
//                               style: pw.TextStyle(
//                                   fontWeight: pw.FontWeight.bold,
//                                   fontSize: 10))
//                         ]),
//                       ]),
//                   pw.SizedBox(height: 10 * PdfPageFormat.mm),
//                   pw.Text('** THANK YOU FOR YOUR BUSINESS **',
//                       style: pw.TextStyle(
//                           fontWeight: pw.FontWeight.bold,
//                           fontSize: 10)),
//                   pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                   pw.Divider(),
//                 ];
//               },
//               footer: (context) {
//                 return pw.Column(children: [
//                   pw.SizedBox(height: 5 * PdfPageFormat.mm),
//                   pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Row(children: [
//                           pw.Text(Utils.formatBackEndDate(DateTime.now()),style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                           pw.SizedBox(width: 10),
//                           pw.Text(DateFormat.jm().format(DateTime.now()),style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                         ]),
//                         pw.Text("Developed by: : Link-Up Technologoy"
//                             "\nContact no: 01911978897",style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                       ])
//                 ]);
//               },
//             ),
//           );
//
//           final bytes = await pdf.save();
//
//           SaveFile.saveAndLaunchFile(
//               bytes,
//               'Daily_Pasar_invoice${salesInvoiceModel.sales[0].saleMasterInvoiceNo}.pdf',
//               apiLevel,
//               context);
//         } catch (e) {
//           print("Error $e ");
//
//           /*apiLevel >= 33
//             ? ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Already saved in your device"),
//                 ),
//               )
//             :*/
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text("Already saved in your device"),
//               action: SnackBarAction(
//                 label: "Open",
//                 onPressed: () {
//                   OpenFile.open(
//                       '/storage/emulated/0/Download/daily_pasar_invoice${salesInvoiceModel.sales[0].saleMasterInvoiceNo}.pdf');
//                 },
//               ),
//             ),
//           );
//           //   print("Saved already");
//         }
//       }
//       else if (storagePermission.isDenied) {
//         Utils.toastMsg("Required Storage Permission");
//         openAppSettings();
//       } else if (storagePermission.isPermanentlyDenied) {
//         await openAppSettings();
//       }
//     }
//     else if(apiLevel>=33){
//       try {
//         pdf.addPage(
//           pw.MultiPage(
//             pageFormat: PdfPageFormat.a4,
//
//             build: (context) {
//               return [
//                 ///top header
//                 pw.Column(
//                   children: [
//                     pw.Row(
//                       children: [
//                         pw.Image(
//                           pw.MemoryImage(iconImage),
//                           height: 70,
//                           width: 100,
//                         ),
//                         pw.SizedBox(width: 10 * PdfPageFormat.mm),
//                         pw.Column(
//                           mainAxisSize: pw.MainAxisSize.min,
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text(
//                               'DAILY PASAR (Sister Concern of SAIRAH TRADING SDN BHD).',
//                               style: pw.TextStyle(
//                                 fontSize: 12.0,
//                                 fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                             pw.Text(
//                               'NO 15, Jalan 3/10B Spring Crest Industrial Park, 68100,Selayang,\nBatu Caves, Selangor, 68100\n01965-712323 , 01753-885115',
//                               style: pw.TextStyle(
//                                 fontSize: 10.0,
//                                 fontWeight: pw.FontWeight.bold,
//                                 font: ttf,
//                                 color: PdfColors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 5 * PdfPageFormat.mm),
//                     pw.Container(
//                       height: 1,
//                       width: double.infinity,
//                       color: PdfColors.black,
//                     ),
//                     pw.SizedBox(height: 3),
//                     pw.Container(
//                       height: 1,
//                       width: double.infinity,
//                       color: PdfColors.black,
//                     ),
//                     pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                   ],
//                 ),
//
//                 ///mid data table
//                 pw.Divider(color: PdfColors.grey),
//                 pw.Align(
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     'Sales Invoice',
//                     style: pw.TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.Divider(color: PdfColors.grey),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Expanded(
//                       flex: 5,
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.RichText(
//                             text: pw.TextSpan(
//                               text: 'Customer Id:',  // Bold text
//                               style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               children: <pw.TextSpan>[
//                                 pw.TextSpan(
//                                   text:  salesInvoiceModel.sales[0].customerCode,  // Normal text
//                                   style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.RichText(
//                             text: pw.TextSpan(
//                               text: 'Customer:',  // Bold text
//                               style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               children: <pw.TextSpan>[
//                                 pw.TextSpan(
//                                   text:  salesInvoiceModel.sales[0].customerName,  // Normal text
//                                   style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           pw.RichText(
//                             text: pw.TextSpan(
//                               text: 'Mobile:',  // Bold text
//                               style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               children: <pw.TextSpan>[
//                                 pw.TextSpan(
//                                   text:  salesInvoiceModel.sales[0].customerMobile,  // Normal text
//                                   style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     pw.Expanded(
//                       flex: 5,
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.end,
//                         children: [
//                           pw.Row(
//                               mainAxisAlignment: pw.MainAxisAlignment.end,
//                               children: [
//                                 pw.Text(
//                                   "Sales By: ",
//                                   style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold,),
//                                 ),
//                                 pw.Text(
//                                   salesInvoiceModel.sales[0].addedBy,
//                                   style: const pw.TextStyle(fontSize: 10),
//                                 ),
//                               ]),
//                           pw.Row(
//                               mainAxisAlignment: pw.MainAxisAlignment.end,
//                               children: [
//                                 pw.Text(
//                                   "Invoice No: ",
//                                   textAlign: pw.TextAlign.right,
//                                   style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold,),
//                                 ),
//                                 pw.Text(
//                                   salesInvoiceModel.sales[0].saleMasterInvoiceNo,
//                                   style: const pw.TextStyle(fontSize: 10),
//                                 ),
//                               ]),
//                           pw.Row(
//                               mainAxisAlignment: pw.MainAxisAlignment.end,
//                               children: [
//                                 pw.Text(
//                                   "Sales Date ",
//                                   style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold,),
//                                 ),
//                                 pw.Text(
//                                   Utils.formatFrontEndDate(salesInvoiceModel.sales[0].saleMasterSaleDate),
//                                   style: const pw.TextStyle(fontSize: 10),
//                                 ),
//                               ]),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Address : ',  // Bold text
//                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//                     children: <pw.TextSpan>[
//                       pw.TextSpan(
//                         text: salesInvoiceModel.sales[0].customerAddress ?? "",  // Normal text
//                         style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 pw.Divider(),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 pw.TableHelper.fromTextArray(
//                   headers: tableHeaders,
//                   data: tableData,
//                   border: pw.TableBorder.all(color: PdfColors.black),
//                   headerStyle: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold,
//                       fontSize: 10
//                   ),
//                   cellStyle: pw.TextStyle(
//                       font: ttf,
//                       fontSize: 10
//                   ),
//                   // headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
//                   cellHeight: 30.0,
//                   cellAlignments: {
//                     0: pw.Alignment.center,
//                     1: pw.Alignment.center,
//                     2: pw.Alignment.center,
//                     3: pw.Alignment.center,
//                     4: pw.Alignment.center,
//                   },
//                 ),
//                 pw.SizedBox(height: 3 * PdfPageFormat.mm),
//                 pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Expanded(
//                       flex: 5,
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           // pw.Text(
//                           //   "Previous Due: ${salesInvoiceModel.sales[0].saleMasterPreviousDue}",
//                           //   style: pw.TextStyle(
//                           //     fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           // ),
//                           // pw.Text(
//                           //   "Current Due: ${salesInvoiceModel.sales[0].saleMasterDueAmount}",
//                           //   style: pw.TextStyle(
//                           //     fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           // ),
//                           // pw.Divider(color: PdfColors.black, endIndent: 60),
//                           // pw.Text(
//                           //   "Total Due: ${double.parse("${double.parse(salesInvoiceModel.sales[0].saleMasterPreviousDue) + double.parse(salesInvoiceModel.sales[0].saleMasterDueAmount)}").toStringAsFixed(2)}",
//                           //   style: pw.TextStyle(
//                           //     fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           // ),
//                         ],
//                       ),
//                     ),
//                     pw.Expanded(
//                       flex: 5,
//                       child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.end,
//                         children: [
//                           pw.Text(
//                             "Sub Total:  ${salesInvoiceModel.sales[0].saleMasterSubTotalAmount}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                           pw.Text(
//                             "Vat: ${salesInvoiceModel.sales[0].saleMasterTaxAmount}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                           pw.Text(
//                             "Discount: ${salesInvoiceModel.sales[0].saleMasterTotalDiscountAmount}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                           pw.Text(
//                             "Transport Cost: ${salesInvoiceModel.sales[0].saleMasterFreight}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                           // pw.Text(
//                           //   "Previous Due: ${allSalesInvoiceModel.sales[0].saleMasterPreviousDue}",
//                           //   style: pw.TextStyle(
//                           //     fontSize: 12, fontWeight: pw.FontWeight.bold,),
//                           // ),
//                           pw.Divider(color: PdfColors.black,height: 2, indent: 80),
//                           pw.Text(
//                             "Total: ${double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount)}",
//                             style: pw.TextStyle(
//                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
//                           ),
//                           pw.Text(
//                             "Paid:  ${salesInvoiceModel.sales[0].saleMasterPaidAmount}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                           pw.Divider(color: PdfColors.black,height: 2, indent: 100),
//                           pw.Text(
//                             "Due: ${(double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount)) - double.parse(salesInvoiceModel.sales[0].saleMasterPaidAmount)}",
//                             style: pw.TextStyle(
//                               fontSize: 10, fontWeight: pw.FontWeight.bold,),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text("In Word: ${converter.convertDouble(double.parse(double.parse(salesInvoiceModel.sales[0].saleMasterTotalSaleAmount).toStringAsFixed(2)))}".toUpperCase(),
//                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold,)),
//                 pw.SizedBox(height: 10),
//                 pw.Text("Note: ${salesInvoiceModel.sales[0].saleMasterDescription}",
//                     style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold,)),
//                 pw.SizedBox(height: 15 * PdfPageFormat.mm),
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Column(children: [
//                         pw.Text('Received by',
//                             style: pw.TextStyle(
//                                 fontWeight: pw.FontWeight.bold, fontSize: 10))
//                       ]),
//                       pw.Column(children: [
//                         pw.Text('Check by',
//                             style: pw.TextStyle(
//                                 fontWeight: pw.FontWeight.bold, fontSize: 10))
//                       ]),
//                       pw.Column(children: [
//                         pw.Text('Authorized by',
//                             style: pw.TextStyle(
//                                 fontWeight: pw.FontWeight.bold, fontSize: 10))
//                       ]),
//                     ]),
//                 pw.SizedBox(height: 10 * PdfPageFormat.mm),
//                 pw.Text('** THANK YOU FOR YOUR BUSINESS **',
//                     style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold, fontSize: 10)),
//                 pw.SizedBox(height: 2 * PdfPageFormat.mm),
//                 pw.Divider(),
//               ];
//             },
//             footer: (context) {
//               return pw.Column(children: [
//                 pw.SizedBox(height: 5 * PdfPageFormat.mm),
//                 pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Row(children: [
//                         pw.Text(Utils.formatBackEndDate(DateTime.now()),style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                         pw.SizedBox(width: 10),
//                         pw.Text(DateFormat.jm().format(DateTime.now()),style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                       ]),
//                       pw.Text("Developed by: : Link-Up Technologoy"
//                           "\nContact no: 01911978897",style: pw.TextStyle(fontSize: 10.0,fontWeight: pw.FontWeight.bold)),
//                     ])
//               ]);
//             },
//           ),
//         );
//
//         final bytes = await pdf.save();
//
//         SaveFile.saveAndLaunchFile(
//             bytes,
//             'Daily_Pasar_invoice${salesInvoiceModel.sales[0].saleMasterInvoiceNo}.pdf',
//             apiLevel,
//             context);
//       } catch (e) {
//         print("Error $e ");
//
//         /*apiLevel >= 33
//             ? ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Already saved in your device"),
//                 ),
//               )
//             :*/
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("Already saved in your device"),
//             action: SnackBarAction(
//               label: "Open",
//               onPressed: () {
//                 OpenFile.open(
//                     '/storage/emulated/0/Download/daily_pasar_invoice${salesInvoiceModel.sales[0].saleMasterInvoiceNo}.pdf');
//               },
//             ),
//           ),
//         );
//         //   print("Saved already");
//       }
//     }
//   }
}