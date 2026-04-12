class SalesAddToCartModel {
  String? productId;
  String? name;
  String? code;
  String? categoryId;
  String? categoryName;
  String? lotNo;
  String? purchaseRate;
  String? salesRate;
  String? temporaryRate;
  String? mfgDate;
  String? expDate;
  String? quantity;
  String? vat;
  String? temporaryVat;
  String? discount;
  String? discountAmount;
  String? total;
  String? note;
  String? isService;
  String? unitName;
  final bool? isFree;

  SalesAddToCartModel({
    required this.productId,
    required this.name,
    required this.code,
    required this.categoryId,
    required this.categoryName,
    required this.lotNo,
    required this.purchaseRate,
    required this.temporaryRate,
    required this.salesRate,
    required this.mfgDate,
    required this.expDate,
    required this.quantity,
    required this.discount,
    required this.temporaryVat,
    required this.vat,
    required this.discountAmount,
    required this.total,
    required this.note,
    required this.isService,
    required this.unitName,
    this.isFree = false,
  });
}