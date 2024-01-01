import 'dart:io';

class ApiUrl {
  static const String _baseUrl = "https://api.ceyronpartners.com";

       ////////////// Agent Auth /////////////////////

  static const String updateData = "$_baseUrl/users/id";

  static const String agentLogin = "$_baseUrl/agents/login";
  static const String agentRegister = "$_baseUrl/agents/register";
  static const String agentUpdate = "$_baseUrl/agents";
  static const String agentChangePassword = "$_baseUrl/agents/change-password";
  static const String agentChangePin = "$_baseUrl/agents/change-pin";
  static const String agentCreatePin = "$_baseUrl/agents/set-pin";
  static const String agentSendOtp = "$_baseUrl/auth/verify-email";
  static const String agentCheckOtp = "$_baseUrl/auth/check-otp";
  static const String agentResetPassword = "$_baseUrl/auth/set-password";


       ////////////// User Auth /////////////////////
  static const String userLogin = "$_baseUrl/users/login";
  static const String userRegister = "$_baseUrl/users/register";
  static const String userUpdate = "$_baseUrl/users";
  static const String userChangePassword = "$_baseUrl/users/change-password";
  static const String usersChangePin = "$_baseUrl/users/change-pin";
  static const String userCreatePin = "$_baseUrl/users/set-pin";


       ////////////// Transactions /////////////////////
  static const String transactions = "$_baseUrl/transactions";
  static const String transferCoin = "$_baseUrl/transfer";


  static const String receiverData = "$_baseUrl/users/id";
  static const String globalSetting = "$_baseUrl/global/setting";
  static const String globalSetting1 = "$_baseUrl/global/charge";

  static const String pinVerify = "$_baseUrl/verify-pin";
  static const String giveCurrency = "$_baseUrl/auth/currency-conversion";
  static const String changeCurrency = "$_baseUrl/auth/change-country";
  static const String getAllCountry = "$_baseUrl/auth/getCountry";
  static const String searchAgent = "$_baseUrl/agents/search";

  ////////////// Kyc /////////////////////
  static const String kyc = "$_baseUrl/kyc";

}
