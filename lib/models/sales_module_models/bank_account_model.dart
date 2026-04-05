import 'dart:convert';

class BankAccountModel {
    final dynamic accountId;
    final dynamic accountName;
    final dynamic accountNumber;
    final dynamic accountType;
    final dynamic bankName;
    final dynamic branchName;
    final dynamic initialBalance;
    final dynamic description;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;

    BankAccountModel({
        required this.accountId,
        required this.accountName,
        required this.accountNumber,
        required this.accountType,
        required this.bankName,
        required this.branchName,
        required this.initialBalance,
        required this.description,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
    });

    factory BankAccountModel.fromJson(String str) => BankAccountModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BankAccountModel.fromMap(Map<String, dynamic> json) => BankAccountModel(
        accountId: json["account_id"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        accountType: json["account_type"],
        bankName: json["bank_name"],
        branchName: json["branch_name"],
        initialBalance: json["initial_balance"],
        description: json["description"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
    );

    Map<String, dynamic> toMap() => {
        "account_id": accountId,
        "account_name": accountName,
        "account_number": accountNumber,
        "account_type": accountType,
        "bank_name": bankName,
        "branch_name": branchName,
        "initial_balance": initialBalance,
        "description": description,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
    };
}
