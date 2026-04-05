import 'package:hive/hive.dart';

class Product {
  String? productId;
  String? productCode;
  String? categoryName;
  String? productName;
  String? quantity;
  String? purchaseRate;
  String? salesRate;
  String? vat;
  String? discount;
  String? discountAmount;
  String? total;

  Product({
    required this.productId,
    required this.productCode,
    required this.categoryName,
    required this.productName,
    required this.quantity,
    required this.purchaseRate,
    required this.salesRate,
    required this.vat,
    required this.discount,
    required this.discountAmount,
    required this.total,
});
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final productId = reader.readString();
    final productCode = reader.readString();
    final categoryName = reader.readString();
    final productName = reader.readString();
    final quantity = reader.readString();
    final purchaseRate = reader.readString();
    final salesRate = reader.readString();
    final vat = reader.readString();
    final discount = reader.readString();
    final discountAmount = reader.readString();
    final total = reader.readString();

    return Product(
      productId: productId,
      productCode: productCode,
      categoryName: categoryName,
      productName: productName,
      quantity: quantity,
      purchaseRate: purchaseRate,
      salesRate: salesRate,
      vat: vat,
      discount: discount,
      discountAmount: discountAmount,
      total: total,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeString("${obj.productId}");
    writer.writeString("${obj.productCode}");
    writer.writeString("${obj.categoryName}");
    writer.writeString("${obj.productName}");
    writer.writeString("${obj.quantity}");
    writer.writeString("${obj.purchaseRate}");
    writer.writeString("${obj.salesRate}");
    writer.writeString("${obj.vat}");
    writer.writeString("${obj.discount}");
    writer.writeString("${obj.discountAmount}");
    writer.writeString("${obj.total}");
  }
}