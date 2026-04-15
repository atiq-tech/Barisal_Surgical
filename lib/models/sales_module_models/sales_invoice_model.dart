import 'dart:convert';

class SalesInvoiceModel {
  final List<SaleDetail> saleDetails;
  final List<Sale> sales;

  SalesInvoiceModel({
    required this.saleDetails,
    required this.sales,
  });

  factory SalesInvoiceModel.fromJson(String str) => SalesInvoiceModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory SalesInvoiceModel.fromMap(Map<String, dynamic> json) => SalesInvoiceModel(
    saleDetails: List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
    sales: List<Sale>.from(json["sales"].map((x) => Sale.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "saleDetails": List<dynamic>.from(saleDetails.map((x) => x.toJson())),
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
  };
}

class SaleDetail {
  final dynamic saleDetailsSlNo;
  final dynamic saleMasterIdNo;
  final dynamic productIdNo;
  final dynamic orderQuantity; // নতুন
  final dynamic saleDetailsTotalQuantity;
  final dynamic purchaseRate;
  final dynamic saleDetailsRate;
  final dynamic temporaryRate; // নতুন
  final dynamic saleDetailsDiscount;
  final dynamic discountAmount;
  final dynamic saleDetailsTax;
  final dynamic saleDetailsTemporaryVat; // নতুন
  final dynamic saleDetailsTotalAmount;
  final dynamic lotNo; // নতুন
  final dynamic manufactureDate; // নতুন
  final dynamic expireDate; // নতুন
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
  final dynamic productLotNo; // নতুন
  final dynamic productExpireDate; // নতুন
  final dynamic productCategoryName;
  final dynamic unitName;
  final dynamic returnQuantity; // নতুন

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
    required this.productLotNo,
    required this.productExpireDate,
    required this.productCategoryName,
    required this.unitName,
    required this.returnQuantity,
  });

  factory SaleDetail.fromJson(String str) => SaleDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

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
    productLotNo: json["Product_LotNo"],
    productExpireDate: json["Product_ExpireDate"],
    productCategoryName: json["ProductCategory_Name"],
    unitName: json["Unit_Name"],
    returnQuantity: json["return_quantity"],
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
    "Product_LotNo": productLotNo,
    "Product_ExpireDate": productExpireDate,
    "ProductCategory_Name": productCategoryName,
    "Unit_Name": unitName,
    "return_quantity": returnQuantity,
  };
}

class Sale {
  final dynamic invoiceText;
  final dynamic saleMasterSlNo;
  final dynamic saleMasterInvoiceNo;
  final dynamic salseCustomerIdNo;
  final dynamic customerTypeShort; // 'customerType'
  final dynamic customerNameNull; // 'customerName'
  final dynamic customerMobileNull; // 'customerMobile'
  final dynamic customerAddressNull; // 'customerAddress'
  final dynamic customerComment;
  final dynamic employeeIdShort; // 'employee_id'
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
  final dynamic deletedByShort; // 'DeletedBy'
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;
  final dynamic customerCode;
  final dynamic customerName;
  final dynamic customerMobile;
  final dynamic customerAddress;
  final dynamic ownerName;
  final dynamic customerType;
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
  final dynamic deletedByLong; // 'deleted_by'

  Sale({
    required this.invoiceText,
    required this.saleMasterSlNo,
    required this.saleMasterInvoiceNo,
    required this.salseCustomerIdNo,
    required this.customerTypeShort,
    required this.customerNameNull,
    required this.customerMobileNull,
    required this.customerAddressNull,
    required this.customerComment,
    required this.employeeIdShort,
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
    required this.deletedByShort,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
    required this.customerCode,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
    required this.ownerName,
    required this.customerType,
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
    required this.deletedByLong,
  });

  factory Sale.fromJson(String str) => Sale.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sale.fromMap(Map<String, dynamic> json) => Sale(
    invoiceText: json["invoice_text"],
    saleMasterSlNo: json["SaleMaster_SlNo"],
    saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
    salseCustomerIdNo: json["SalseCustomer_IDNo"],
    customerTypeShort: json["customerType"],
    customerNameNull: json["customerName"],
    customerMobileNull: json["customerMobile"],
    customerAddressNull: json["customerAddress"],
    customerComment: json["customerComment"],
    employeeIdShort: json["employee_id"],
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
    deletedByShort: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
    customerCode: json["Customer_Code"],
    customerName: json["Customer_Name"],
    customerMobile: json["Customer_Mobile"],
    customerAddress: json["Customer_Address"],
    ownerName: json["owner_name"],
    customerType: json["Customer_Type"],
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
    deletedByLong: json["deleted_by"],
  );

  Map<String, dynamic> toMap() => {
    "invoice_text": invoiceText,
    "SaleMaster_SlNo": saleMasterSlNo,
    "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
    "SalseCustomer_IDNo": salseCustomerIdNo,
    "customerType": customerTypeShort,
    "customerName": customerNameNull,
    "customerMobile": customerMobileNull,
    "customerAddress": customerAddressNull,
    "customerComment": customerComment,
    "employee_id": employeeIdShort,
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
    "DeletedBy": deletedByShort,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
    "Customer_Mobile": customerMobile,
    "Customer_Address": customerAddress,
    "owner_name": ownerName,
    "Customer_Type": customerType,
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
    "deleted_by": deletedByLong,
  };
}





// import 'dart:convert';
//
// class SalesInvoiceModel {
//   final List<SaleDetail> saleDetails;
//   final List<Sale> sales;
//
//   SalesInvoiceModel({
//     required this.saleDetails,
//     required this.sales,
//   });
//
//   factory SalesInvoiceModel.fromJson(String str) => SalesInvoiceModel.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory SalesInvoiceModel.fromMap(Map<String, dynamic> json) => SalesInvoiceModel(
//     saleDetails: List<SaleDetail>.from(json["saleDetails"].map((x) => SaleDetail.fromMap(x))),
//     sales: List<Sale>.from(json["sales"].map((x) => Sale.fromMap(x))),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "saleDetails": List<dynamic>.from(saleDetails.map((x) => x.toJson())),
//     "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
//   };
// }
//
// class SaleDetail {
//   final String saleDetailsSlNo;
//   final String saleMasterIdNo;
//   final String productIdNo;
//   final String saleDetailsTotalQuantity;
//   final String purchaseRate;
//   final String deliveryQuantity;
//   final String saleDetailsRate;
//   final String saleDetailsDiscount;
//   final String discountAmount;
//   final String saleDetailsTax;
//   final String saleDetailsTotalAmount;
//   final String isService;
//   final String status;
//   final String addBy;
//   final String addTime;
//   final dynamic updateBy;
//   final dynamic updateTime;
//   final dynamic deletedBy;
//   final dynamic deletedTime;
//   final String lastUpdateIp;
//   final String branchId;
//   final String productName;
//   final String productCategoryName;
//   final String unitName;
//   final String branchName;
//
//   SaleDetail({
//     required this.saleDetailsSlNo,
//     required this.saleMasterIdNo,
//     required this.productIdNo,
//     required this.saleDetailsTotalQuantity,
//     required this.purchaseRate,
//     required this.deliveryQuantity,
//     required this.saleDetailsRate,
//     required this.saleDetailsDiscount,
//     required this.discountAmount,
//     required this.saleDetailsTax,
//     required this.saleDetailsTotalAmount,
//     required this.isService,
//     required this.status,
//     required this.addBy,
//     required this.addTime,
//     required this.updateBy,
//     required this.updateTime,
//     required this.deletedBy,
//     required this.deletedTime,
//     required this.lastUpdateIp,
//     required this.branchId,
//     required this.productName,
//     required this.productCategoryName,
//     required this.unitName,
//     required this.branchName,
//   });
//
//   factory SaleDetail.fromJson(String str) => SaleDetail.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory SaleDetail.fromMap(Map<String, dynamic> json) => SaleDetail(
//     saleDetailsSlNo: json["SaleDetails_SlNo"]??"",
//     saleMasterIdNo: json["SaleMaster_IDNo"]??"",
//     productIdNo: json["Product_IDNo"]??"",
//     saleDetailsTotalQuantity: json["SaleDetails_TotalQuantity"]??"",
//     purchaseRate: json["Purchase_Rate"]??"",
//     deliveryQuantity: json["Delivery_Quantity"]??"",
//     saleDetailsRate: json["SaleDetails_Rate"]??"",
//     saleDetailsDiscount: json["SaleDetails_Discount"]??"",
//     discountAmount: json["Discount_amount"]??"",
//     saleDetailsTax: json["SaleDetails_Tax"]??"",
//     saleDetailsTotalAmount: json["SaleDetails_TotalAmount"]??"",
//     isService: json["is_service"]??"",
//     status: json["status"]??"",
//     addBy: json["AddBy"]??"",
//     addTime: json["AddTime"]??"",
//     updateBy: json["UpdateBy"],
//     updateTime: json["UpdateTime"],
//     deletedBy: json["DeletedBy"],
//     deletedTime: json["DeletedTime"],
//     lastUpdateIp: json["last_update_ip"]??"",
//     branchId: json["branch_id"]??"",
//     productName: json["Product_Name"]??"",
//     productCategoryName: json["ProductCategory_Name"]??"",
//     unitName: json["Unit_Name"]??"",
//     branchName: json["Branch_name"]??"",
//   );
//
//   Map<String, dynamic> toMap() => {
//     "SaleDetails_SlNo": saleDetailsSlNo,
//     "SaleMaster_IDNo": saleMasterIdNo,
//     "Product_IDNo": productIdNo,
//     "SaleDetails_TotalQuantity": saleDetailsTotalQuantity,
//     "Purchase_Rate": purchaseRate,
//     "Delivery_Quantity": deliveryQuantity,
//     "SaleDetails_Rate": saleDetailsRate,
//     "SaleDetails_Discount": saleDetailsDiscount,
//     "Discount_amount": discountAmount,
//     "SaleDetails_Tax": saleDetailsTax,
//     "SaleDetails_TotalAmount": saleDetailsTotalAmount,
//     "is_service": isService,
//     "status": status,
//     "AddBy": addBy,
//     "AddTime": addTime,
//     "UpdateBy": updateBy,
//     "UpdateTime": updateTime,
//     "DeletedBy": deletedBy,
//     "DeletedTime": deletedTime,
//     "last_update_ip": lastUpdateIp,
//     "branch_id": branchId,
//     "Product_Name": productName,
//     "ProductCategory_Name": productCategoryName,
//     "Unit_Name": unitName,
//     "Branch_name": branchName,
//   };
// }
//
// class Sale {
//   final String saleMasterSlNo;
//   final String saleMasterInvoiceNo;
//   final String salseCustomerIdNo;
//   final String saleCustomerType;
//   final dynamic saleCustomerName;
//   final dynamic saleCustomerMobile;
//   final dynamic saleCustomerAddress;
//   final String employeeId;
//   final String routeId;
//   final String saleMasterSaleDate;
//   final String isOrder;
//   final String processStatus;
//   final String saleMasterDescription;
//   final String saleMasterSaleType;
//   final dynamic paymentType;
//   final String saleMasterTotalSaleAmount;
//   final String saleMasterTotalDiscountAmount;
//   final String saleMasterTaxAmount;
//   final String saleMasterFreight;
//   final String saleMasterSubTotalAmount;
//   final String saleMasterPaidAmount;
//   final String saleMasterDueAmount;
//   final String saleMasterPreviousDue;
//   final String status;
//   final String addBy;
//   final String addTime;
//   final dynamic updateBy;
//   final dynamic updateTime;
//   final dynamic deletedBy;
//   final dynamic deletedTime;
//   final String lastUpdateIp;
//   final String branchId;
//   final String customerCode;
//   final String customerName;
//   final String ownerName;
//   final String customerMobile;
//   final String customerAddress;
//   final String customerType;
//   final String employeeName;
//   final String branchName;
//   final String addedBy;
//
//   Sale({
//     required this.saleMasterSlNo,
//     required this.saleMasterInvoiceNo,
//     required this.salseCustomerIdNo,
//     required this.saleCustomerType,
//     required this.saleCustomerName,
//     required this.saleCustomerMobile,
//     required this.saleCustomerAddress,
//     required this.employeeId,
//     required this.routeId,
//     required this.saleMasterSaleDate,
//     required this.isOrder,
//     required this.processStatus,
//     required this.saleMasterDescription,
//     required this.saleMasterSaleType,
//     required this.paymentType,
//     required this.saleMasterTotalSaleAmount,
//     required this.saleMasterTotalDiscountAmount,
//     required this.saleMasterTaxAmount,
//     required this.saleMasterFreight,
//     required this.saleMasterSubTotalAmount,
//     required this.saleMasterPaidAmount,
//     required this.saleMasterDueAmount,
//     required this.saleMasterPreviousDue,
//     required this.status,
//     required this.addBy,
//     required this.addTime,
//     required this.updateBy,
//     required this.updateTime,
//     required this.deletedBy,
//     required this.deletedTime,
//     required this.lastUpdateIp,
//     required this.branchId,
//     required this.customerCode,
//     required this.customerName,
//     required this.ownerName,
//     required this.customerMobile,
//     required this.customerAddress,
//     required this.customerType,
//     required this.employeeName,
//     required this.branchName,
//     required this.addedBy,
//   });
//
//   factory Sale.fromJson(String str) => Sale.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory Sale.fromMap(Map<String, dynamic> json) => Sale(
//     saleMasterSlNo: json["SaleMaster_SlNo"]??"",
//     saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"]??"",
//     salseCustomerIdNo: json["SalseCustomer_IDNo"]??"",
//     saleCustomerType: json["customerType"]??"",
//     saleCustomerName: json["customerName"],
//     saleCustomerMobile: json["customerMobile"],
//     saleCustomerAddress: json["customerAddress"],
//     employeeId: json["employee_id"]??"",
//     routeId: json["route_id"]??"",
//     saleMasterSaleDate: json["SaleMaster_SaleDate"]??"",
//     isOrder: json["is_order"]??"",
//     processStatus: json["process_status"]??"",
//     saleMasterDescription: json["SaleMaster_Description"]??"",
//     saleMasterSaleType: json["SaleMaster_SaleType"]??"",
//     paymentType: json["payment_type"],
//     saleMasterTotalSaleAmount: json["SaleMaster_TotalSaleAmount"]??"",
//     saleMasterTotalDiscountAmount: json["SaleMaster_TotalDiscountAmount"]??"",
//     saleMasterTaxAmount: json["SaleMaster_TaxAmount"]??"",
//     saleMasterFreight: json["SaleMaster_Freight"]??"",
//     saleMasterSubTotalAmount: json["SaleMaster_SubTotalAmount"]??"",
//     saleMasterPaidAmount: json["SaleMaster_PaidAmount"]??"",
//     saleMasterDueAmount: json["SaleMaster_DueAmount"]??"",
//     saleMasterPreviousDue: json["SaleMaster_Previous_Due"]??"",
//     status: json["status"]??"",
//     addBy: json["AddBy"]??"",
//     addTime: json["AddTime"]??"",
//     updateBy: json["UpdateBy"],
//     updateTime: json["UpdateTime"],
//     deletedBy: json["DeletedBy"],
//     deletedTime: json["DeletedTime"],
//     lastUpdateIp: json["last_update_ip"]??"",
//     branchId: json["branch_id"]??"",
//     customerCode: json["Customer_Code"]??"",
//     customerName: json["Customer_Name"]??"",
//     ownerName: json["owner_name"]??"",
//     customerMobile: json["Customer_Mobile"]??"",
//     customerAddress: json["Customer_Address"]??"",
//     customerType: json["Customer_Type"]??"",
//     employeeName: json["Employee_Name"]??"",
//     branchName: json["Branch_name"]??"",
//     addedBy: json["addedBy"]??"",
//   );
//
//   Map<String, dynamic> toMap() => {
//     "SaleMaster_SlNo": saleMasterSlNo,
//     "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
//     "SalseCustomer_IDNo": salseCustomerIdNo,
//     "customerType": saleCustomerType,
//     "customerName": saleCustomerName,
//     "customerMobile": saleCustomerMobile,
//     "customerAddress": saleCustomerAddress,
//     "employee_id": employeeId,
//     "route_id": routeId,
//     "SaleMaster_SaleDate": saleMasterSaleDate,
//     "is_order": isOrder,
//     "process_status": processStatus,
//     "SaleMaster_Description": saleMasterDescription,
//     "SaleMaster_SaleType": saleMasterSaleType,
//     "payment_type": paymentType,
//     "SaleMaster_TotalSaleAmount": saleMasterTotalSaleAmount,
//     "SaleMaster_TotalDiscountAmount": saleMasterTotalDiscountAmount,
//     "SaleMaster_TaxAmount": saleMasterTaxAmount,
//     "SaleMaster_Freight": saleMasterFreight,
//     "SaleMaster_SubTotalAmount": saleMasterSubTotalAmount,
//     "SaleMaster_PaidAmount": saleMasterPaidAmount,
//     "SaleMaster_DueAmount": saleMasterDueAmount,
//     "SaleMaster_Previous_Due": saleMasterPreviousDue,
//     "status": status,
//     "AddBy": addBy,
//     "AddTime": addTime,
//     "UpdateBy": updateBy,
//     "UpdateTime": updateTime,
//     "DeletedBy": deletedBy,
//     "DeletedTime": deletedTime,
//     "last_update_ip": lastUpdateIp,
//     "branch_id": branchId,
//     "Customer_Code": customerCode,
//     "Customer_Name": customerName,
//     "owner_name": ownerName,
//     "Customer_Mobile": customerMobile,
//     "Customer_Address": customerAddress,
//     "Customer_Type": customerType,
//     "Employee_Name": employeeName,
//     "Branch_name": branchName,
//     "addedBy": addedBy,
//   };
// }
