import 'dart:convert';

class EcpWiseSalesReportModel {
    final dynamic employeeName;
    final dynamic customerName;
    final dynamic productName;
    final dynamic quantity;
    final dynamic amount;

    EcpWiseSalesReportModel({
        required this.employeeName,
        required this.customerName,
        required this.productName,
        required this.quantity,
        required this.amount,
    });

    factory EcpWiseSalesReportModel.fromJson(String str) => EcpWiseSalesReportModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EcpWiseSalesReportModel.fromMap(Map<String, dynamic> json) => EcpWiseSalesReportModel(
        employeeName: json["employeeName"],
        customerName: json["customerName"],
        productName: json["productName"],
        quantity: json["quantity"],
        amount: json["amount"],
    );

    Map<String, dynamic> toMap() => {
        "employeeName": employeeName,
        "customerName": customerName,
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
    };
}
