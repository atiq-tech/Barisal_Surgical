import 'dart:convert';

class OrdersRecordModel {
  final dynamic saleMasterSlNo;
  final dynamic saleMasterInvoiceNo;
  final dynamic salseCustomerIdNo;
  final dynamic customerType;
  final dynamic customerName;
  final dynamic customerMobile;
  final dynamic customerAddress;
  final dynamic customerComment;
  final dynamic employeeId;
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
  final dynamic customerNameMaster;
  final dynamic customerMobileMaster;
  final dynamic customerAddressMaster;
  final dynamic totalReturnAmount;
  final dynamic netPayment;
  final dynamic invoiceDueAmount;
  final dynamic ownerName;
  final dynamic customerTypeMaster;
  final dynamic binNo;
  final dynamic accountName;
  final dynamic accountNumber;
  final dynamic bankName;
  final dynamic employeeName;
  final dynamic employeeIdAlt;
  final dynamic branchName;
  final dynamic addedBy;
  final dynamic deletedByAlt;
  final List<SaleDetail>? saleDetails;

  OrdersRecordModel({
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.customerType,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.customerComment,
    required this.employeeId,
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
    required this.totalReturnAmount,
    required this.netPayment,
    required this.invoiceDueAmount,
    required this.ownerName,
    required this.customerTypeMaster,
    required this.binNo,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.employeeName,
    required this.employeeIdAlt,
    required this.branchName,
    required this.addedBy,
    required this.deletedByAlt,
    this.saleDetails,
  });

  factory OrdersRecordModel.fromJson(String str) => OrdersRecordModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrdersRecordModel.fromMap(Map<String, dynamic> json) => OrdersRecordModel(
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    customerType: json["customerType"],
    customerName: json["customerName"],
    customerMobile: json["customerMobile"],
    customerAddress: json["customerAddress"],
    customerComment: json["customerComment"],
    employeeId: json["employee_id"],
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
    totalReturnAmount: json["total_return_amount"],
    netPayment: json["net_payment"],
    invoiceDueAmount: json["invoiceDueAmount"],
    ownerName: json["owner_name"],
    customerTypeMaster: json["Customer_Type"],
    binNo: json["bin_no"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    employeeName: json["Employee_Name"],
    employeeIdAlt: json["Employee_ID"],
    branchName: json["Branch_name"],
    addedBy: json["added_by"],
    deletedByAlt: json["deleted_by"],
    saleDetails: json["saleDetails"] == null ? [] : List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "customerType": customerType,
    "customerName": customerName,
    "customerMobile": customerMobile,
    "customerAddress": customerAddress,
    "customerComment": customerComment,
    "employee_id": employeeId,
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
    "total_return_amount": totalReturnAmount,
    "net_payment": netPayment,
    "invoiceDueAmount": invoiceDueAmount,
    "owner_name": ownerName,
    "Customer_Type": customerTypeMaster,
    "bin_no": binNo,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "Employee_Name": employeeName,
    "Employee_ID": employeeIdAlt,
    "Branch_name": branchName,
    "added_by": addedBy,
    "deleted_by": deletedByAlt,
    "saleDetails": saleDetails == null ? [] : List<dynamic>.from(saleDetails!.map((x) => x.toMap())),
  };
}

class SaleDetail {
  final dynamic saleDetailsSlNo;
  final dynamic saleMasterIdNo;
  final dynamic productIdNo;
  final dynamic orderQuantity;
  final dynamic saleDetailsTotalQuantity;
  final dynamic purchaseRate;
  final dynamic saleDetailsRate;
  final dynamic temporaryRate;
  final dynamic saleDetailsDiscount;
  final dynamic discountAmount;
  final dynamic saleDetailsTax;
  final dynamic saleDetailsTemporaryVat;
  final dynamic saleDetailsTotalAmount;
  final dynamic lotNo;
  final dynamic manufactureDate;
  final dynamic expireDate;
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
  final dynamic productCode;
  final dynamic productName;
  final dynamic productCategoryName;
  final dynamic unitName;
  final dynamic returnQty;

  SaleDetail({
    required this.saleDetailsSlNo,
    required this.saleMasterIdNo,
    required this.productIdNo,
    required this.orderQuantity,
    required this.saleDetailsTotalQuantity,
    required this.purchaseRate,
    required this.saleDetailsRate,
    required this.temporaryRate,
    required this.saleDetailsDiscount,
    required this.discountAmount,
    required this.saleDetailsTax,
    required this.saleDetailsTemporaryVat,
    required this.saleDetailsTotalAmount,
    required this.lotNo,
    required this.manufactureDate,
    required this.expireDate,
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
    required this.productCode,
    required this.productName,
    required this.productCategoryName,
    required this.unitName,
    required this.returnQty,
  });

  factory SaleDetail.fromMap(Map<String, dynamic> json) => SaleDetail(
    saleDetailsSlNo: json["SaleDetails_SlNo"],
    saleMasterIdNo: json["SaleMaster_IDNo"],
    productIdNo: json["Product_IDNo"],
    orderQuantity: json["Order_Quantity"],
    saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"],
    purchaseRate: json["Purchase_Rate"],
    saleDetailsRate: json["SaleDetails_Rate"],
    temporaryRate: json["temporary_rate"],
    saleDetailsDiscount: json["SaleDetails_Discount"],
    discountAmount: json["Discount_amount"],
    saleDetailsTax: json["SaleDetails_Tax"],
    saleDetailsTemporaryVat: json["SaleDetails_Temporary_Vat"],
    saleDetailsTotalAmount: json["SaleDetails_TotalAmount"],
    lotNo: json["LotNo"],
    manufactureDate: json["ManufactureDate"],
    expireDate: json["ExpireDate"],
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
    productCode: json["Product_Code"],
    productName: json["Product_Name"],
    productCategoryName: json["ProductCategory_Name"],
    unitName: json["Unit_Name"],
    returnQty: json["return_qty"],
  );

  Map<String, dynamic> toMap() => {
    "SaleDetails_SlNo": saleDetailsSlNo,
    "SaleMaster_IDNo": saleMasterIdNo,
    "Product_IDNo": productIdNo,
    "Order_Quantity": orderQuantity,
    "SaleDetails_TotalQuantity": saleDetailsTotalQuantity,
    "Purchase_Rate": purchaseRate,
    "SaleDetails_Rate": saleDetailsRate,
    "temporary_rate": temporaryRate,
    "SaleDetails_Discount": saleDetailsDiscount,
    "Discount_amount": discountAmount,
    "SaleDetails_Tax": saleDetailsTax,
    "SaleDetails_Temporary_Vat": saleDetailsTemporaryVat,
    "SaleDetails_TotalAmount": saleDetailsTotalAmount,
    "LotNo": lotNo,
    "ManufactureDate": manufactureDate,
    "ExpireDate": expireDate,
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
    "Product_Code": productCode,
    "Product_Name": productName,
    "ProductCategory_Name": productCategoryName,
    "Unit_Name": unitName,
    "return_qty": returnQty,
  };
}