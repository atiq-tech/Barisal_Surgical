import 'dart:convert';

class ProductListModel {
    final dynamic productSlNo;
    final dynamic productCode;
    final dynamic productName;
    final dynamic productCategoryId;
    final dynamic color;
    final dynamic brand;
    final dynamic productSize;
    final dynamic productDarNo;
    final dynamic productHsCode;
    final dynamic productGsCode;
    final dynamic productLotNo;
    final dynamic productDutyPercent;
    final dynamic productOtherCost;
    final dynamic productManufactureDate;
    final dynamic productExpireDate;
    final dynamic vat;
    final dynamic temporaryVat;
    final dynamic salesVat;
    final dynamic purchaseVat;
    final dynamic productReOrederLevel;
    final dynamic productPurchaseRate;
    final dynamic productSellingPrice;
    final dynamic temporaryRate;
    final dynamic productMinimumSellingPrice;
    final dynamic productWholesaleRate;
    final dynamic oneCartunEqual;
    final dynamic isService;
    final dynamic isFactory;
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
        required this.productSize,
        required this.productDarNo,
        required this.productHsCode,
        required this.productGsCode,
        required this.productLotNo,
        required this.productDutyPercent,
        required this.productOtherCost,
        required this.productManufactureDate,
        required this.productExpireDate,
        required this.vat,
        required this.temporaryVat,
        required this.salesVat,
        required this.purchaseVat,
        required this.productReOrederLevel,
        required this.productPurchaseRate,
        required this.productSellingPrice,
        required this.temporaryRate,
        required this.productMinimumSellingPrice,
        required this.productWholesaleRate,
        required this.oneCartunEqual,
        required this.isService,
        required this.isFactory,
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
        productSize: json["Product_Size"],
        productDarNo: json["Product_DarNo"],
        productHsCode: json["Product_HSCode"],
        productGsCode: json["Product_GSCode"],
        productLotNo: json["Product_LotNo"],
        productDutyPercent: json["Product_DutyPercent"],
        productOtherCost: json["Product_OtherCost"],
        productManufactureDate: json["Product_ManufactureDate"],
        productExpireDate: json["Product_ExpireDate"],
        vat: json["vat"],
        temporaryVat: json["temporary_vat"],
        salesVat: json["sales_vat"],
        purchaseVat: json["purchase_vat"],
        productReOrederLevel: json["Product_ReOrederLevel"],
        productPurchaseRate: json["Product_Purchase_Rate"],
        productSellingPrice: json["Product_SellingPrice"],
        temporaryRate: json["temporary_rate"],
        productMinimumSellingPrice: json["Product_MinimumSellingPrice"],
        productWholesaleRate: json["Product_WholesaleRate"],
        oneCartunEqual: json["one_cartun_equal"],
        isService: json["is_service"],
        isFactory: json["is_factory"],
        unitId: json["Unit_ID"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime:json["UpdateTime"],
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
        "Product_Size": productSize,
        "Product_DarNo": productDarNo,
        "Product_HSCode": productHsCode,
        "Product_GSCode": productGsCode,
        "Product_LotNo": productLotNo,
        "Product_DutyPercent": productDutyPercent,
        "Product_OtherCost": productOtherCost,
        "Product_ManufactureDate": productManufactureDate,
        "Product_ExpireDate": productExpireDate,
        "vat": vat,
        "temporary_vat": temporaryVat,
        "sales_vat": salesVat,
        "purchase_vat": purchaseVat,
        "Product_ReOrederLevel": productReOrederLevel,
        "Product_Purchase_Rate": productPurchaseRate,
        "Product_SellingPrice": productSellingPrice,
        "temporary_rate": temporaryRate,
        "Product_MinimumSellingPrice": productMinimumSellingPrice,
        "Product_WholesaleRate": productWholesaleRate,
        "one_cartun_equal": oneCartunEqual,
        "is_service": isService,
        "is_factory": isFactory,
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
