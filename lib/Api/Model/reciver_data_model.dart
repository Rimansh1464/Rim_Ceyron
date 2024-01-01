class ReciverData {
  final int id;
  final String usersId;
  final String name;
  final String businessName;
  final String branchName;
  final String email;
  final String phoneNumber;
  final String password;
  final String country;
  final String createdAt;
  final String updatedAt;
  final String kyc;
  final String status;
  final String accessToken;
  final String securityPin;
  final String balance;
  final String role;

  ReciverData({
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
    required this.kyc,
    required this.status,
    required this.accessToken,
    required this.securityPin,
    required this.balance,
    required this.role,
  });

  factory ReciverData.fromJson(Map<String, dynamic> json) {
    return ReciverData(
      id: json['id'] ??"",
      usersId: json['users_id'] ??"",
      name: json['name'] ??"",
      businessName: json['business_name'] ??"",
      branchName: json['branch_name'] ??"",
      email: json['email'] ??"",
      phoneNumber: json['phone_number'] ??"",
      password: json['password'] ??"",
      country: json['country'] ??"",
      createdAt: json['created_at'] ??"",
      updatedAt: json['updated_at'] ??"",
      kyc: json['kyc'] ??"",
      status: json['status'] ??"",
      accessToken: json['access_token'] ??"",
      securityPin: json['security_pin'] ??"",
      balance: json['balance'] ??"",
      role: json['role'] ??"",
    );
  }
  ReciverData clean() {
    return ReciverData(
      id: 0,
      usersId: "",
      name: "",
      businessName: "",
      branchName: "",
      email:"",
      phoneNumber: "",
      password: "",
      country: "",
      createdAt: "",
      updatedAt: "",
      kyc: "",
      status: "",
      accessToken: "",
      securityPin: "",
      balance: "",
      role: "",
    );
  }

}
