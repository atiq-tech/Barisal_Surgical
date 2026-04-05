import 'dart:convert';

class SalesRecordModel {
  final dynamic saleMasterSlNo;
  final dynamic saleMasterInvoiceNo;
  final dynamic salseCustomerIdNo;
  final dynamic employeeId;
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
  final dynamic employeeName;
  final dynamic branchName;
  final dynamic addedBy;
  final dynamic deletedBy;
  final List<SaleDetail>? saleDetails;

  SalesRecordModel({
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.employeeId,
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
    required this.employeeName,
    required this.branchName,
    required this.addedBy,
    required this.deletedBy,
    required this.saleDetails,
  });

  factory SalesRecordModel.fromJson(String str) => SalesRecordModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesRecordModel.fromMap(Map<String, dynamic> json) => SalesRecordModel(
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    employeeId: json["employee_id"],
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
    employeeName: json["Employee_Name"],
    branchName: json["Branch_name"],
    addedBy: json["added_by"],
    deletedBy: json["deleted_by"],
    saleDetails: json["saleDetails"] == null || json["saleDetails"] == [] ? [] : List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "employee_id": employeeId,
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
    "Employee_Name": employeeName,
    "Branch_name": branchName,
    "added_by": addedBy,
    "deleted_by": deletedBy,
    "saleDetails": List<dynamic>.from(saleDetails!.map((x) => x.toJson())),
  };
}

class SaleDetail {
  final dynamic saleDetailsSlNo;
  final dynamic saleMasterIdNo;
  final dynamic productIdNo;
  final dynamic saleDetailsTotalQuantity;
  final dynamic purchaseRate;
  final dynamic saleDetailsRate;
  final dynamic saleDetailsDiscount;
  final dynamic discountAmount;
  final dynamic saleDetailsTax;
  final dynamic saleDetailsTotalAmount;
  final dynamic isFree;
  final dynamic isService;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;
  final dynamic productName;
  final dynamic productCategoryName;

  SaleDetail({
    required this.saleDetailsSlNo,
    required this.saleMasterIdNo,
    required this.productIdNo,
    required this.saleDetailsTotalQuantity,
    required this.purchaseRate,
    required this.saleDetailsRate,
    required this.saleDetailsDiscount,
    required this.discountAmount,
    required this.saleDetailsTax,
    required this.saleDetailsTotalAmount,
    required this.isFree,
    required this.isService,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
    required this.productName,
    required this.productCategoryName,
  });

  factory SaleDetail.fromJson(String str) => SaleDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleDetail.fromMap(Map<String, dynamic> json) => SaleDetail(
    saleDetailsSlNo: json["SaleDetails_SlNo"],
    saleMasterIdNo: json["SaleMaster_IDNo"],
    productIdNo: json["Product_IDNo"],
    saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"],
    purchaseRate: json["Purchase_Rate"],
    saleDetailsRate: json["SaleDetails_Rate"],
    saleDetailsDiscount: json["SaleDetails_Discount"],
    discountAmount: json["Discount_amount"],
    saleDetailsTax: json["SaleDetails_Tax"],
    saleDetailsTotalAmount: json["SaleDetails_TotalAmount"],
    isFree: json["is_free"],
    isService: json["is_service"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
    productName: json["Product_Name"],
    productCategoryName: json["ProductCategory_Name"],
  );

  Map<String, dynamic> toMap() => {
    "SaleDetails_SlNo": saleDetailsSlNo,
    "SaleMaster_IDNo": saleMasterIdNo,
    "Product_IDNo": productIdNo,
    "SaleDetails_TotalQuantity": saleDetailsTotalQuantity,
    "Purchase_Rate": purchaseRate,
    "SaleDetails_Rate": saleDetailsRate,
    "SaleDetails_Discount": saleDetailsDiscount,
    "Discount_amount": discountAmount,
    "SaleDetails_Tax": saleDetailsTax,
    "SaleDetails_TotalAmount": saleDetailsTotalAmount,
    "is_free": isFree,
    "is_service": isService,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
    "Product_Name": productName,
    "ProductCategory_Name": productCategoryName,
  };
}
