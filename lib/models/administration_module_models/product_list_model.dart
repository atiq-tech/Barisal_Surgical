import 'dart:convert';

class ProductListModel {
  final dynamic productSlNo;
  final dynamic productCode;
  final dynamic productName;
  final dynamic productCategoryId;
  final dynamic color;
  final dynamic brand;
  final dynamic size;
  final dynamic vat;
  final dynamic productReOrederLevel;
  final dynamic productPurchaseRate;
  final dynamic productSellingPrice;
  final dynamic productMinimumSellingPrice;
  final dynamic productWholesaleRate;
  final dynamic perUnitConvert;
  final dynamic convertedName;
  final dynamic isService;
  final dynamic unitId;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;
  final dynamic displayText;
  final dynamic productCategoryName;
  final dynamic brandName;
  final dynamic unitName;
  final dynamic addedBy;
  final dynamic productListModelDeletedBy;

  ProductListModel({
    required this.productSlNo,
    required this.productCode,
    required this.productName,
    required this.productCategoryId,
    required this.color,
    required this.brand,
    required this.size,
    required this.vat,
    required this.productReOrederLevel,
    required this.productPurchaseRate,
    required this.productSellingPrice,
    required this.productMinimumSellingPrice,
    required this.productWholesaleRate,
    required this.perUnitConvert,
    required this.convertedName,
    required this.isService,
    required this.unitId,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
    required this.displayText,
    required this.productCategoryName,
    required this.brandName,
    required this.unitName,
    required this.addedBy,
    required this.productListModelDeletedBy,
  });

  factory ProductListModel.fromJson(String str) => ProductListModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory ProductListModel.fromMap(Map<String, dynamic> json) => ProductListModel(
    productSlNo: json["Product_SlNo"],
    productCode: json["Product_Code"],
    productName: json["Product_Name"],
    productCategoryId: json["ProductCategory_ID"],
    color: json["color"],
    brand: json["brand"],
    size: json["size"],
    vat: json["vat"],
    productReOrederLevel: json["Product_ReOrederLevel"],
    productPurchaseRate: json["Product_Purchase_Rate"],
    productSellingPrice: json["Product_SellingPrice"],
    productMinimumSellingPrice: json["Product_MinimumSellingPrice"],
    productWholesaleRate: json["Product_WholesaleRate"],
    perUnitConvert: json["per_unit_convert"],
    convertedName: json["converted_name"],
    isService: json["is_service"],
    unitId: json["Unit_ID"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
    displayText: json["display_text"],
    productCategoryName: json["ProductCategory_Name"],
    brandName: json["brand_name"],
    unitName: json["Unit_Name"],
    addedBy: json["added_by"],
    productListModelDeletedBy: json["deleted_by"],
  );

  Map<String, dynamic> toMap() => {
    "Product_SlNo": productSlNo,
    "Product_Code": productCode,
    "Product_Name": productName,
    "ProductCategory_ID": productCategoryId,
    "color": color,
    "brand": brand,
    "size": size,
    "vat": vat,
    "Product_ReOrederLevel": productReOrederLevel,
    "Product_Purchase_Rate": productPurchaseRate,
    "Product_SellingPrice": productSellingPrice,
    "Product_MinimumSellingPrice": productMinimumSellingPrice,
    "Product_WholesaleRate": productWholesaleRate,
    "per_unit_convert": perUnitConvert,
    "converted_name": convertedName,
    "is_service": isService,
    "Unit_ID": unitId,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
    "display_text": displayText,
    "ProductCategory_Name": productCategoryName,
    "brand_name": brandName,
    "Unit_Name": unitName,
    "added_by": addedBy,
    "deleted_by": productListModelDeletedBy,
  };
}
