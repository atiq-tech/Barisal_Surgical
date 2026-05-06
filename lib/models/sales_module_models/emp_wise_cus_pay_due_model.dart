import 'dart:convert';

class EmpWiseCusPayDueModel {
    final dynamic id;
    final dynamic date;
    final dynamic invoiceNo;
    final dynamic comment;
    final dynamic attentionComment;
    final dynamic bill;
    final dynamic vat;
    final dynamic subTotal;
    final dynamic transport;
    final dynamic previousDue;
    final dynamic discount;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic employeeName;
    final dynamic returned;
    final dynamic paid;
    final dynamic invoiceDue;
    final dynamic due;

    EmpWiseCusPayDueModel({
        required this.id,
        required this.date,
        required this.invoiceNo,
        required this.comment,
        required this.attentionComment,
        required this.bill,
        required this.vat,
        required this.subTotal,
        required this.transport,
        required this.previousDue,
        required this.discount,
        required this.customerName,
        required this.customerMobile,
        required this.employeeName,
        required this.returned,
        required this.paid,
        required this.invoiceDue,
        required this.due,
    });

    factory EmpWiseCusPayDueModel.fromJson(String str) => EmpWiseCusPayDueModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EmpWiseCusPayDueModel.fromMap(Map<String, dynamic> json) => EmpWiseCusPayDueModel(
        id: json["id"],
        date: json["date"],
        invoiceNo: json["invoice_no"],
        comment: json["comment"],
        attentionComment: json["attentionComment"],
        bill: json["bill"],
        vat: json["vat"],
        subTotal: json["sub_total"],
        transport: json["transport"],
        previousDue: json["previous_due"],
        discount: json["discount"],
        customerName: json["customerName"],
        customerMobile: json["customerMobile"],
        employeeName: json["employeeName"],
        returned: json["returned"],
        paid: json["paid"],
        invoiceDue: json["invoice_due"],
        due: json["due"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "date": date,
        "invoice_no": invoiceNo,
        "comment": comment,
        "attentionComment": attentionComment,
        "bill": bill,
        "vat": vat,
        "sub_total": subTotal,
        "transport": transport,
        "previous_due": previousDue,
        "discount": discount,
        "customerName": customerName,
        "customerMobile": customerMobile,
        "employeeName": employeeName,
        "returned": returned,
        "paid": paid,
        "invoice_due": invoiceDue,
        "due": due,
    };
}
