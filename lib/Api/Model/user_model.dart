// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserData data;

  UserModel({
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    data: UserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class UserData {
  int id;
  String usersId;
  String name;
  String businessName;
  String branchName;
  String email;
  String phoneNumber;
  String password;
  String country;
  DateTime createdAt;
  DateTime updatedAt;
  String kyc_status;
  String status;
  String accessToken;
  String securityPin;
  String balance;
  String role;
  String address;
  String state;
  String city;
  String currencyCountry;
  String kycReason;

  UserData({
    required this.id,
    required this.usersId,
    required this.name,
    required this.businessName,
    required this.branchName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.kyc_status,
    required this.status,
    required this.accessToken,
    required this.securityPin,
    required this.balance,
    required this.role,
    required this.address,
    required this.state,
    required this.city,
    required this.currencyCountry,
    required this.kycReason,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"] ?? "",
    usersId: json["users_id"] ?? "",
    name: json["name"] ?? "",
    businessName: json["business_name"] ?? "",
    branchName: json["branch_name"] ?? "",
    email: json["email"] ?? "",
    phoneNumber: json["phone_number"] ?? "",
    password: json["password"] ?? "",
    country: json["country"] ?? "",
    createdAt: DateTime.parse(json["created_at"]??"2023-09-21T06:55:26.000Z"),
    updatedAt: DateTime.parse(json["updated_at"]??"2023-09-21T06:55:26.000Z"),
    kyc_status: json["kyc_status"] ?? "",
    status: json["status"] ?? "",
    accessToken: json["access_token"] ?? "",
    securityPin: json["security_pin"] ?? "",
    balance: json["balance"] ?? "",
    role: json["role"] ?? "",
    address: json["address"] ?? "",
    state: json["state"] ?? "",
    city: json["city"] ?? "",
    currencyCountry: json["currency_country"] ?? "",
    kycReason: json["kyc_reason"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "users_id": usersId,
    "name": name,
    "business_name": businessName,
    "branch_name": branchName,
    "email": email,
    "phone_number": phoneNumber,
    "password": password,
    "country": country,
    "created_at": createdAt.toString(),
    "updated_at": updatedAt.toString(),
    "kyc_status": kyc_status,
    "status": status,
    "access_token": accessToken,
    "security_pin": securityPin,
    "balance": balance,
    "role": role,
    "address": address,
    "state": state,
    "city": city,
    "currency_country": currencyCountry,
    "kyc_reason": kycReason,
  };
}
