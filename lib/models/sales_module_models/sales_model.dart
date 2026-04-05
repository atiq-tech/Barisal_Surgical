import 'dart:convert';

class SalesModel {
  final dynamic invoiceText;
  final dynamic saleMasterSlNo;
  final dynamic saleMasterInvoiceNo;
  final dynamic salseCustomerIdNo;
  final dynamic salesModelEmployeeId;
  final dynamic saleMasterSaleDate;
  final dynamic saleMasterDescription;
  final dynamic saleMasterSaleType;
  final dynamic accountId;
  final dynamic saleMasterTotalSaleAmount;
  final dynamic saleMasterTotalDiscountAmount;
  final dynamic saleMasterTaxAmount;
  final dynamic saleMasterFreight;
  final dynamic saleMasterSubTotalAmount;
  final dynamic cashPaid;
  final dynamic bankPaid;
  final dynamic saleMasterPaidAmount;
  final dynamic saleMasterDueAmount;
  final dynamic saleMasterPreviousDue;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic branchId;
  final dynamic customerCode;
  final dynamic customerName;
  final dynamic customerMobile;
  final dynamic customerAddress;
  final dynamic customerType;
  final dynamic accountName;
  final dynamic accountNumber;
  final dynamic bankName;
  final dynamic employeeName;
  final dynamic employeeId;
  final dynamic branchName;
  final dynamic addedBy;

  SalesModel({
    required this.invoiceText,
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.salesModelEmployeeId,
    required this.saleMasterSaleDate,
    required this.saleMasterDescription,
    required this.saleMasterSaleType,
    required this.accountId,
    required this.saleMasterTotalSaleAmount,
    required this.saleMasterTotalDiscountAmount,
    required this.saleMasterTaxAmount,
    required this.saleMasterFreight,
    required this.saleMasterSubTotalAmount,
    required this.cashPaid,
    required this.bankPaid,
    required this.saleMasterPaidAmount,
    required this.saleMasterDueAmount,
    required this.saleMasterPreviousDue,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.branchId,
    required this.customerCode,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerType,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.employeeName,
    required this.employeeId,
    required this.branchName,
    required this.addedBy,
  });

  factory SalesModel.fromJson(String str) => SalesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesModel.fromMap(Map<String, dynamic> json) => SalesModel(
    invoiceText: json["invoice_text"],
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    salesModelEmployeeId: json["employee_id"],
    saleMasterSaleDate: json["SaleMaster_SaleDate"],
    saleMasterDescription: json["SaleMaster_Description"],
    saleMasterSaleType: json["SaleMaster_SaleType"],
    accountId: json["accountId"],
    saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
    saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"],
    saleMasterTaxAmount: json["SaleMaster_TaxAmount"],
    saleMasterFreight: json["SaleMaster_Freight"],
    saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"],
    cashPaid: json["cashPaid"],
    bankPaid: json["bankPaid"],
    saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
    saleMasterDueAmount: json["SaleMaster_DueAmount"],
    saleMasterPreviousDue: json["SaleMaster_Previous_Due"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    branchId: json["branch_id"],
    customerCode: json["Customer_Code"],
    customerName: json["Customer_Name"],
    customerMobile: json["Customer_Mobile"],
    customerAddress: json["Customer_Address"],
    customerType: json["Customer_Type"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    employeeName: json["Employee_Name"],
    employeeId: json["Employee_ID"],
    branchName: json["Branch_name"],
    addedBy: json["added_by"],
  );

  Map<String, dynamic> toMap() => {
    "invoice_text": invoiceText,
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "employee_id": salesModelEmployeeId,
    "SaleMaster_SaleDate": saleMasterSaleDate,
    "SaleMaster_Description": saleMasterDescription,
    "SaleMaster_SaleType": saleMasterSaleType,
    "accountId": accountId,
    "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
    "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
    "SaleMaster_TaxAmount": saleMasterTaxAmount,
    "SaleMaster_Freight": saleMasterFreight,
    "SaleMaster_SubTotalAmount": saleMasterSubTotalAmount,
    "cashPaid": cashPaid,
    "bankPaid": bankPaid,
    "SaleMaster_PaidAmount": saleMasterPaidAmount,
    "SaleMaster_DueAmount": saleMasterDueAmount,
    "SaleMaster_Previous_Due": saleMasterPreviousDue,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "branch_id": branchId,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
    "Customer_Mobile": customerMobile,
    "Customer_Address": customerAddress,
    "Customer_Type": customerType,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "Employee_Name": employeeName,
    "Employee_ID": employeeId,
    "Branch_name": branchName,
    "added_by": addedBy,
  };
}
