import 'dart:convert';

class CustomerPaymentsModel {
    final dynamic cPaymentId;
    final dynamic cPaymentDate;
    final dynamic cPaymentInvoice;
    final dynamic saleId;
    final dynamic cPaymentCustomerId;
    final dynamic cPaymentTransactionType;
    final dynamic cPaymentAmount;
    final dynamic cPaymentPaymentby;
    final dynamic accountId;
    final dynamic cPaymentPreviousDue;
    final dynamic otherPreviousDue;
    final dynamic cPaymentNotes;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic customerCode;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic saleMasterInvoiceNo;
    final dynamic accountName;
    final dynamic accountNumber;
    final dynamic bankName;
    final dynamic transactionType;
    final dynamic paymentBy;
    final dynamic addedBy;
    final dynamic customerPaymentsModelDeletedBy;

    CustomerPaymentsModel({
        required this.cPaymentId,
        required this.cPaymentDate,
        required this.cPaymentInvoice,
        required this.saleId,
        required this.cPaymentCustomerId,
        required this.cPaymentTransactionType,
        required this.cPaymentAmount,
        required this.cPaymentPaymentby,
        required this.accountId,
        required this.cPaymentPreviousDue,
        required this.otherPreviousDue,
        required this.cPaymentNotes,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.customerCode,
        required this.customerName,
        required this.customerMobile,
        required this.saleMasterInvoiceNo,
        required this.accountName,
        required this.accountNumber,
        required this.bankName,
        required this.transactionType,
        required this.paymentBy,
        required this.addedBy,
        required this.customerPaymentsModelDeletedBy,
    });

    factory CustomerPaymentsModel.fromJson(String str) => CustomerPaymentsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerPaymentsModel.fromMap(Map<String, dynamic> json) => CustomerPaymentsModel(
        cPaymentId: json["CPayment_id"],
        cPaymentDate: json["CPayment_date"],
        cPaymentInvoice: json["CPayment_invoice"],
        saleId: json["saleId"],
        cPaymentCustomerId: json["CPayment_customerID"],
        cPaymentTransactionType: json["CPayment_TransactionType"],
        cPaymentAmount: json["CPayment_amount"],
        cPaymentPaymentby: json["CPayment_Paymentby"],
        accountId: json["account_id"],
        cPaymentPreviousDue: json["CPayment_previous_due"],
        otherPreviousDue: json["other_previous_due"],
        cPaymentNotes: json["CPayment_notes"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        customerCode: json["Customer_Code"],
        customerName: json["Customer_Name"],
        customerMobile: json["Customer_Mobile"],
        saleMasterInvoiceNo: json["SaleMaster_InvoiceNo"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
        transactionType: json["transaction_type"],
        paymentBy: json["payment_by"],
        addedBy: json["added_by"],
        customerPaymentsModelDeletedBy: json["deleted_by"],
    );

    Map<String, dynamic> toMap() => {
        "CPayment_id": cPaymentId,
        "CPayment_date": cPaymentDate,
        "CPayment_invoice": cPaymentInvoice,
        "saleId": saleId,
        "CPayment_customerID": cPaymentCustomerId,
        "CPayment_TransactionType": cPaymentTransactionType,
        "CPayment_amount": cPaymentAmount,
        "CPayment_Paymentby": cPaymentPaymentby,
        "account_id": accountId,
        "CPayment_previous_due": cPaymentPreviousDue,
        "other_previous_due": otherPreviousDue,
        "CPayment_notes": cPaymentNotes,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Customer_Code": customerCode,
        "Customer_Name": customerName,
        "Customer_Mobile": customerMobile,
        "SaleMaster_InvoiceNo": saleMasterInvoiceNo,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_name": bankName,
        "transaction_type": transactionType,
        "payment_by": paymentBy,
        "added_by": addedBy,
        "deleted_by": customerPaymentsModelDeletedBy,
    };
}
