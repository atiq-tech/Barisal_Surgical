import 'dart:convert';

class CustomerDueModel {
    final dynamic customerSlNo;
    final dynamic customerName;
    final dynamic customerCode;
    final dynamic customerAddress;
    final dynamic customerMobile;
    final dynamic ownerName;
    final dynamic billAmount;
    final dynamic invoicePaid;
    final dynamic cashReceived;
    final dynamic paidOutAmount;
    final dynamic returnedAmount;
    final dynamic paidAmount;
    final dynamic dueAmount;

    CustomerDueModel({
        required this.customerSlNo,
        required this.customerName,
        required this.customerCode,
        required this.customerAddress,
        required this.customerMobile,
        required this.ownerName,
        required this.billAmount,
        required this.invoicePaid,
        required this.cashReceived,
        required this.paidOutAmount,
        required this.returnedAmount,
        required this.paidAmount,
        required this.dueAmount,
    });

    factory CustomerDueModel.fromJson(String str) => CustomerDueModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerDueModel.fromMap(Map<String, dynamic> json) => CustomerDueModel(
        customerSlNo: json["Customer_SlNo"],
        customerName: json["Customer_Name"],
        customerCode: json["Customer_Code"],
        customerAddress: json["Customer_Address"],
        customerMobile: json["Customer_Mobile"],
        ownerName: json["owner_name"],
        billAmount: json["billAmount"],
        invoicePaid: json["invoicePaid"],
        cashReceived: json["cashReceived"],
        paidOutAmount: json["paidOutAmount"],
        returnedAmount: json["returnedAmount"],
        paidAmount: json["paidAmount"],
        dueAmount: json["dueAmount"],
    );

    Map<String, dynamic> toMap() => {
        "Customer_SlNo": customerSlNo,
        "Customer_Name": customerName,
        "Customer_Code": customerCode,
        "Customer_Address": customerAddress,
        "Customer_Mobile": customerMobile,
        "owner_name": ownerName,
        "billAmount": billAmount,
        "invoicePaid": invoicePaid,
        "cashReceived": cashReceived,
        "paidOutAmount": paidOutAmount,
        "returnedAmount": returnedAmount,
        "paidAmount": paidAmount,
        "dueAmount": dueAmount,
    };
}
