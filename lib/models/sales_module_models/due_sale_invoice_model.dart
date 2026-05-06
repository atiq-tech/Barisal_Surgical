import 'dart:convert';

class DueSaleInvoiceModel {
    final dynamic saleMasterSlNo;
    final dynamic saleMasterInvoiceNo;
    final dynamic saleMasterSaleDate;
    final dynamic saleMasterTotalSaleAmount;
    final dynamic saleMasterPaidAmount;
    final dynamic saleMasterDueAmount;
    final dynamic saleMasterTaxAmount;
    final dynamic taxAmount;
    final dynamic saleMasterTotalDiscountAmount;
    final dynamic saleMasterFreight;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic customerPaid;
    final dynamic returnAmount;
    final dynamic remainingDue;

    DueSaleInvoiceModel({
        required this.saleMasterSlNo,
        required this.saleMasterInvoiceNo,
        required this.saleMasterSaleDate,
        required this.saleMasterTotalSaleAmount,
        required this.saleMasterPaidAmount,
        required this.saleMasterDueAmount,
        required this.saleMasterTaxAmount,
        required this.taxAmount,
        required this.saleMasterTotalDiscountAmount,
        required this.saleMasterFreight,
        required this.customerName,
        required this.customerMobile,
        required this.customerPaid,
        required this.returnAmount,
        required this.remainingDue,
    });

    factory DueSaleInvoiceModel.fromJson(String str) => DueSaleInvoiceModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DueSaleInvoiceModel.fromMap(Map<String, dynamic> json) => DueSaleInvoiceModel(
        saleMasterSlNo: json["SaleMaster_SlNo"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        saleMasterSaleDate: json["SaleMaster_SaleDate"],
        saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
        saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
        saleMasterDueAmount: json["SaleMaster_DueAmount"],
        saleMasterTaxAmount: json["SaleMaster_TaxAmount"],
        taxAmount: json["tax_amount"],
        saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"],
        saleMasterFreight: json["SaleMaster_Freight"],
        customerName: json["Customer_Name"],
        customerMobile: json["Customer_Mobile"],
        customerPaid: json["customer_paid"],
        returnAmount: json["return_amount"],
        remainingDue: json["remaining_due"],
    );

    Map<String, dynamic> toMap() => {
        "SaleMaster_SlNo": saleMasterSlNo,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "SaleMaster_SaleDate": saleMasterSaleDate,
        "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
        "SaleMaster_PaidAmount": saleMasterPaidAmount,
        "SaleMaster_DueAmount": saleMasterDueAmount,
        "SaleMaster_TaxAmount": saleMasterTaxAmount,
        "tax_amount": taxAmount,
        "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
        "SaleMaster_Freight": saleMasterFreight,
        "Customer_Name": customerName,
        "Customer_Mobile": customerMobile,
        "customer_paid": customerPaid,
        "return_amount": returnAmount,
        "remaining_due": remainingDue,
    };
}
