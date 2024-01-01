// To parse this JSON data, do
//
//     final transactions = transactionsFromJson(jsonString);

import 'dart:convert';

Transactions transactionsFromJson(String str) => Transactions.fromJson(json.decode(str));

String transactionsToJson(Transactions data) => json.encode(data.toJson());

class Transactions {
  List<TransactionsData> data;
  bool success;
  String status;

  Transactions({
    required this.data,
    required this.success,
    required this.status,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    data: List<TransactionsData>.from(json["data"].map((x) => TransactionsData.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String,dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class TransactionsData {
  int id;
  String transactionId;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String transactionType;
  String amount;
  String transactionFees;
  DateTime transactionDate;
  String finalAmount;
  String amountToCollect;
  String transactionStatus;
  String adminCharge;
  String agentCharge;
  String note;
  String mode;
  String debitAmount;
  String totalRecords;

  TransactionsData({
    required this.id,
    required this.transactionId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.transactionType,
    required this.amount,
    required this.transactionFees,
    required this.transactionDate,
    required this.finalAmount,
    required this.amountToCollect,
    required this.transactionStatus,
    required this.adminCharge,
    required this.agentCharge,
    required this.note,
    required this.mode,
    required this.debitAmount,
    required this.totalRecords,
  });

  factory TransactionsData.fromJson(Map<String, dynamic> json) => TransactionsData(
    id: json["id"]??0,
    transactionId: json["transaction_id"] ?? "",
    senderId: json["sender_id"] ?? "",
    senderName: json["sender_name"] ?? "",
    receiverId: json["receiver_id"] ?? "",
    receiverName: json["receiver_name"] ?? "",
    transactionType: json["transaction_type"] ?? "",
    amount: json["amount"] ?? "",
    transactionFees: json["transaction_fees"] ?? "",
    transactionDate: DateTime.parse(json["transaction_date"]),
    finalAmount: json["final_amount"] ?? "",
    amountToCollect: json["amount_to_collect"] ?? "",
    transactionStatus: json["transaction_status"] ?? "",
    adminCharge: json["admin_charge"] ?? "",
    agentCharge: json["agent_charge"] ?? "",
    note: json["note"] ?? "",
    mode: json["mode"]??"",
    debitAmount: json["debit_amount"]??"",
    totalRecords: json["totalRecords"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_id": transactionId,
    "sender_id": senderId,
    "sender_name": senderName,
    "receiver_id": receiverId,
    "receiver_name": receiverName,
    "transaction_type": transactionType,
    "amount": amount,
    "transaction_fees": transactionFees,
    "transaction_date": transactionDate.toString(),
    "final_amount": finalAmount,
    "amount_to_collect": amountToCollect,
    "transaction_status": transactionStatus,
    "admin_charge": adminCharge,
    "agent_charge": agentCharge,
    "note": note,
    "mode": mode,
    "debit_amount": debitAmount,
    "totalRecords": totalRecords,
  };
}

enum TransactionType {
  CREDIT,
  DEBIT,
  TRANSFER,
}

final transactionTypeValues = EnumValues({
  "credit": TransactionType.CREDIT,
  "debit": TransactionType.DEBIT,
  "transfer": TransactionType.TRANSFER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
