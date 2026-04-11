import 'dart:convert';

class OrdersDetailsModel {
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
    final dynamic productCategoryId;
    final dynamic productCategoryName;
    final dynamic saleMasterInvoiceNo;
    final dynamic saleMasterSaleDate;
    final dynamic customerCode;
    final dynamic customerName;

    OrdersDetailsModel({
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
        required this.productCategoryId,
        required this.productCategoryName,
        required this.saleMasterInvoiceNo,
        required this.saleMasterSaleDate,
        required this.customerCode,
        required this.customerName,
    });

    factory OrdersDetailsModel.fromJson(String str) => OrdersDetailsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrdersDetailsModel.fromMap(Map<String, dynamic> json) => OrdersDetailsModel(
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
        productCategoryId: json["ProductCategory_ID"],
        productCategoryName: json["ProductCategory_Name"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        saleMasterSaleDate: json["SaleMaster_SaleDate"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
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
        "AddTime": addTime.toIso8601String(),
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Product_Code": productCode,
        "Product_Name": productName,
        "ProductCategory_ID": productCategoryId,
        "ProductCategory_Name": productCategoryName,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "SaleMaster_SaleDate": saleMasterSaleDate,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
    };
}
