import 'dart:convert';

class InvoiceDueModel {
    final dynamic saleMasterSlNo;
    final dynamic saleMasterInvoiceNo;
    final dynamic saleMasterTotalSaleAmount;
    final dynamic saleMasterPaidAmount;
    final dynamic customerCode;
    final dynamic customerName;
    final dynamic ownerName;
    final dynamic customerMobile;
    final dynamic customerAddress;
    final dynamic invoiceDue;
    final dynamic customerPayment;
    final dynamic payment;
    final dynamic dueAmount;

    InvoiceDueModel({
        required this.saleMasterSlNo,
        required this.saleMasterInvoiceNo,
        required this.saleMasterTotalSaleAmount,
        required this.saleMasterPaidAmount,
        required this.customerCode,
        required this.customerName,
        required this.ownerName,
        required this.customerMobile,
        required this.customerAddress,
        required this.invoiceDue,
        required this.customerPayment,
        required this.payment,
        required this.dueAmount,
    });

    factory InvoiceDueModel.fromJson(String str) => InvoiceDueModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InvoiceDueModel.fromMap(Map<String, dynamic> json) => InvoiceDueModel(
        saleMasterSlNo: json["SaleMaster_SlNo"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
        saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
        ownerName: json["owner_name"],
        customerMobile: json["Customer_Mobile"],
        customerAddress: json["Customer_Address"],
        invoiceDue: json["invoiceDue"],
        customerPayment: json["customerPayment"],
        payment: json["payment"],
        dueAmount: json["dueAmount"],
    );

    Map<String, dynamic> toMap() => {
        "SaleMaster_SlNo": saleMasterSlNo,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
        "SaleMaster_PaidAmount": saleMasterPaidAmount,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
        "owner_name": ownerName,
        "Customer_Mobile": customerMobile,
        "Customer_Address": customerAddress,
        "invoiceDue": invoiceDue,
        "customerPayment": customerPayment,
        "payment": payment,
        "dueAmount": dueAmount,
    };
}
