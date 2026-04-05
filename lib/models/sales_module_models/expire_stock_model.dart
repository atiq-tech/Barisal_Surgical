import 'dart:convert';

class ExpireStockModel {
    final dynamic expDate;
    final dynamic inQuantity;
    final dynamic outQuantity;
    final dynamic stock;

    ExpireStockModel({
        required this.expDate,
        required this.inQuantity,
        required this.outQuantity,
        required this.stock,
    });

    factory ExpireStockModel.fromJson(String str) => ExpireStockModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ExpireStockModel.fromMap(Map<String, dynamic> json) => ExpireStockModel(
        expDate: json["exp_date"],
        inQuantity: json["in_quantity"],
        outQuantity: json["out_quantity"],
        stock: json["stock"],
    );

    Map<String, dynamic> toMap() => {
        "exp_date": expDate,
        "in_quantity": inQuantity,
        "out_quantity": outQuantity,
        "stock": stock,
    };
}
