import 'dart:convert';

class SalesModel {
  final dynamic invoiceText;
  final dynamic saleMasterSlNo;
  final dynamic saleMasterInvoiceNo;
  final dynamic salseCustomerIdNo;
  final dynamic customerType;
  final dynamic customerName;
  final dynamic customerMobile;
  final dynamic customerAddress;
  final dynamic customerComment;
  final dynamic salesModelEmployeeId;
  final dynamic saleMasterSaleDate;
  final dynamic saleMasterDescription;
  final dynamic saleMasterSaleType;
  final dynamic accountId;
  final dynamic showInvoiceDue;
  final dynamic saleMasterTotalSaleAmount;
  final dynamic saleMasterTotalDiscountAmount;
  final dynamic saleMasterTaxAmount;
  final dynamic taxAmount;
  final dynamic saleMasterFreight;
  final dynamic saleMasterSubTotalAmount;
  final dynamic cashPaid;
  final dynamic bankPaid;
  final dynamic saleMasterPaidAmount;
  final dynamic saleMasterDueAmount;
  final dynamic saleMasterPreviousDue;
  final dynamic isShipping;
  final dynamic isMushokBill;
  final dynamic carton;
  final dynamic conditions;
  final dynamic isOrder;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;
  final dynamic customerCode;
  final dynamic customerNameMaster; // Customer_Name from JSON
  final dynamic customerMobileMaster; // Customer_Mobile from JSON
  final dynamic customerAddressMaster; // Customer_Address from JSON
  final dynamic ownerName;
  final dynamic customerTypeMaster; // Customer_Type from JSON
  final dynamic binNo;
  final dynamic calculatedTax;
  final dynamic totalReturnAmount;
  final dynamic netPayment;
  final dynamic invoiceDueAmount;
  final dynamic accountName;
  final dynamic accountNumber;
  final dynamic bankName;
  final dynamic employeeName;
  final dynamic employeeId;
  final dynamic branchName;
  final dynamic addedBy;
  final dynamic deletedByAlt; // deleted_by from JSON

  SalesModel({
    required this.invoiceText,
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.customerType,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerComment,
    required this.salesModelEmployeeId,
    required this.saleMasterSaleDate,
    required this.saleMasterDescription,
    required this.saleMasterSaleType,
    required this.accountId,
    required this.showInvoiceDue,
    required this.saleMasterTotalSaleAmount,
    required this.saleMasterTotalDiscountAmount,
    required this.saleMasterTaxAmount,
    required this.taxAmount,
    required this.saleMasterFreight,
    required this.saleMasterSubTotalAmount,
    required this.cashPaid,
    required this.bankPaid,
    required this.saleMasterPaidAmount,
    required this.saleMasterDueAmount,
    required this.saleMasterPreviousDue,
    required this.isShipping,
    required this.isMushokBill,
    required this.carton,
    required this.conditions,
    required this.isOrder,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
    required this.customerCode,
    required this.customerNameMaster,
    required this.customerMobileMaster,
    required this.customerAddressMaster,
    required this.ownerName,
    required this.customerTypeMaster,
    required this.binNo,
    required this.calculatedTax,
    required this.totalReturnAmount,
    required this.netPayment,
    required this.invoiceDueAmount,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.employeeName,
    required this.employeeId,
    required this.branchName,
    required this.addedBy,
    required this.deletedByAlt,
  });

  factory SalesModel.fromJson(String str) => SalesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesModel.fromMap(Map<String, dynamic> json) => SalesModel(
    invoiceText: json["invoice_text"],
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    customerType: json["customerType"],
    customerName: json["customerName"],
    customerMobile: json["customerMobile"],
    customerAddress: json["customerAddress"],
    customerComment: json["customerComment"],
    salesModelEmployeeId: json["employee_id"],
    saleMasterSaleDate: json["SaleMaster_SaleDate"],
    saleMasterDescription: json["SaleMaster_Description"],
    saleMasterSaleType: json["SaleMaster_SaleType"],
    accountId: json["accountId"],
    showInvoiceDue: json["ShowInvoiceDue"],
    saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"],
    saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"],
    saleMasterTaxAmount: json["SaleMaster_TaxAmount"],
    taxAmount: json["tax_amount"],
    saleMasterFreight: json["SaleMaster_Freight"],
    saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"],
    cashPaid: json["cashPaid"],
    bankPaid: json["bankPaid"],
    saleMasterPaidAmount: json["SaleMaster_PaidAmount"],
    saleMasterDueAmount: json["SaleMaster_DueAmount"],
    saleMasterPreviousDue: json["SaleMaster_Previous_Due"],
    isShipping: json["isShipping"],
    isMushokBill: json["is_mushok_bill"],
    carton: json["carton"],
    conditions: json["conditions"],
    isOrder: json["is_order"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
    customerCode: json["Customer_Code"],
    customerNameMaster: json["Customer_Name"],
    customerMobileMaster: json["Customer_Mobile"],
    customerAddressMaster: json["Customer_Address"],
    ownerName: json["owner_name"],
    customerTypeMaster: json["Customer_Type"],
    binNo: json["bin_no"],
    calculatedTax: json["calculated_tax"],
    totalReturnAmount: json["total_return_amount"],
    netPayment: json["net_payment"],
    invoiceDueAmount: json["invoiceDueAmount"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    employeeName: json["Employee_Name"],
    employeeId: json["Employee_ID"],
    branchName: json["Branch_name"],
    addedBy: json["added_by"],
    deletedByAlt: json["deleted_by"],
  );

  Map<String, dynamic> toMap() => {
    "invoice_text": invoiceText,
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "customerType": customerType,
    "customerName": customerName,
    "customerMobile": customerMobile,
    "customerAddress": customerAddress,
    "customerComment": customerComment,
    "employee_id": salesModelEmployeeId,
    "SaleMaster_SaleDate": saleMasterSaleDate,
    "SaleMaster_Description": saleMasterDescription,
    "SaleMaster_SaleType": saleMasterSaleType,
    "accountId": accountId,
    "ShowInvoiceDue": showInvoiceDue,
    "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
    "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
    "SaleMaster_TaxAmount": saleMasterTaxAmount,
    "tax_amount": taxAmount,
    "SaleMaster_Freight": saleMasterFreight,
    "SaleMaster_SubTotalAmount": saleMasterSubTotalAmount,
    "cashPaid": cashPaid,
    "bankPaid": bankPaid,
    "SaleMaster_PaidAmount": saleMasterPaidAmount,
    "SaleMaster_DueAmount": saleMasterDueAmount,
    "SaleMaster_Previous_Due": saleMasterPreviousDue,
    "isShipping": isShipping,
    "is_mushok_bill": isMushokBill,
    "carton": carton,
    "conditions": conditions,
    "is_order": isOrder,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
    "Customer_Code": customerCode,
    "Customer_Name": customerNameMaster,
    "Customer_Mobile": customerMobileMaster,
    "Customer_Address": customerAddressMaster,
    "owner_name": ownerName,
    "Customer_Type": customerTypeMaster,
    "bin_no": binNo,
    "calculated_tax": calculatedTax,
    "total_return_amount": totalReturnAmount,
    "net_payment": netPayment,
    "invoiceDueAmount": invoiceDueAmount,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "Employee_Name": employeeName,
    "Employee_ID": employeeId,
    "Branch_name": branchName,
    "added_by": addedBy,
    "deleted_by": deletedByAlt,
  };
}
