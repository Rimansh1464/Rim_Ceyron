import 'package:ceyron_app/Agent/auth/create_pin.dart';
import 'package:ceyron_app/Api/Api_Helper/api.dart';
import 'package:ceyron_app/User/auth/u_login.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Agent/Home/home_page.dart';
import '../../Agent/auth/Login.dart';
import '../../Agent/auth/otp_screen.dart';
import '../../Agent/auth/otp_screen_password.dart';
import '../../Agent/auth/reset_password.dart';
import '../../User/Screen/BottomBar/bottom_bar.dart';
import '../../User/auth/u_login.dart';
import '../../User/auth/u_login.dart';
import '../../User/auth/u_login.dart';
import '../../User/auth/user_create_pin.dart';
import '../../utils/widgets.dart';
import '../Model/user_model.dart';
import 'getx_controller.dart';

class AuthProvider extends ChangeNotifier {

  // double? currency;
  // String currencyType.value = "INR";
  GetController getController = Get.put(GetController());


  UserData? userData;
  UserData? AgentData;

  bool isSignedIn = false;
  bool get isSignIn => isSignedIn;
  bool _hasError = false;
  String? person;
  String? get Person => person;
  bool get hasError => _hasError;
  String? _errorCode;
  String? get errorCode => _errorCode;
  String? _provider;
  String? get provider => _provider;


  AuthProvider() {
    checkSignInUser();
  }
  // upgradeCurrency(){
  //   currency = 81.92;
  //   notifyListeners();
  // }
  Future checkSignInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getBool("signed_in") ?? false;
    person = prefs.getString("person");

    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("signed_in", true);
    isSignedIn = true;
    notifyListeners();
  }

  Future signOut(context) async {
    isSignedIn = false;
    notifyListeners();
    // showSnackbarMessage(context,"sucees");
    adsLoader.show(context);
    clearStoredData();
    await Future.delayed(Duration(seconds: 2));
    // clear all Info from Shared Preferences
    clearStoredData();
    notifyListeners();
  }

  Future clearStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.clear();
    notifyListeners();
  }


  Future getList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = await getUserData();
    prefs.clear();
  }


  Future<void> saveUserData(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setBool('isLoggedIn', true);
    prefs.setString('userData', json.encode(user.toJson())).then((value) async => await getUserData());
    notifyListeners();// Remove .toString()
  }

  Future<UserData?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final Map<String, dynamic> userDataJson = json.decode(userDataString);
      userData = UserData.fromJson(userDataJson);
      notifyListeners();
      return userData;
    }
    print("No Data Found for SharedPreferences");
    notifyListeners();// Remove .toString()
    return null;
  }



  Future<void> updateData(BuildContext context) async  {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.get(
        Uri.parse("${ApiUrl.updateData}/${userData!.usersId}"),
        headers: headers
    );
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data user==$responseData");

        if (responseData["success"] == true) {
          List<dynamic> userDataList = responseData['data'];
          if (userDataList.isNotEmpty) {
            UserData user = UserData.fromJson(userDataList[0]);
            await saveUserData(user);
            await Future.delayed(Duration(seconds: 2));

            getController.upgradeCurrency(user.currencyCountry,context);
            notifyListeners();

          } else {
            showSnackbarError(context, 'No user data found.');
          }
          notifyListeners();
        } else {
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {showSnackbarError(context, "Update failed");
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Eroor eree  = $e');
      notifyListeners();
    }
  }

  Future<void> agentLogin(
      String email,String password, BuildContext context) async {
    clearStoredData();
    if (email.isEmpty ||  password.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.agentLogin),
      body: {'email': email, 'password': password},
    );
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
           if(responseData['data']['role']=="Agent"){
             person = "agent";
             Map<String, dynamic> responsedata = json.decode(response.body);
             UserData user = UserData.fromJson(responsedata['data']);
             await saveUserData(user);
             getController.upgradeCurrency(user.currencyCountry, context);
             notifyListeners();
             adsLoader.close();
             await Future.delayed(Duration(seconds: 0));
             //nextScreen(context, CreatePin(result: 'Login',));
             if(user.securityPin.isEmpty){
               nextScreen(context, CreatePin(result: 'Singup',));
             }else{
               Navigator.pushNamed(context, 'MyBottomBarApp');}
             setSignIn();
             showSnackbarSuccess(context, responseData["message"]);
           }
           else {
             adsLoader.close();
             showSnackbarError(context, "No Found Data");
           }

        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Login failed");
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Eroor = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> agentSignup(
      String Name,
      String BusinessName,
      String BranchName,
      String email,
      String phone,
      String password,
      String confirmPassword,
      String countryy,
      BuildContext context) async {
    if (Name.isEmpty ||
        BusinessName.isEmpty ||
        BranchName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        countryy.isEmpty) {
      // Show a SnackBar with validation error message
      showSnackbarError(context, "Please fill in all fields");

      return;
    }
    adsLoader.show(context);
    clearStoredData();
    final response = await http.post(
      Uri.parse(ApiUrl.agentRegister),
      body: {
        'name': Name,
        'business_name': BusinessName,
        'branch_name': BranchName,
        'email': email,
        'phone_number': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'country': countryy,
        'role': 'Agent',

      },
    );
    final responseData = json.decode(response.body);
    print("api Data==$responseData");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        UserData user = UserData.fromJson(responseData['data']);
        await saveUserData(user);
        notifyListeners();
        adsLoader.close();
        adsLoader.close();
        getController.upgradeCurrency(user.currencyCountry, context);

        // Navigator.pushNamed(context, 'MyBottomBarApp');
        await Future.delayed(Duration(seconds: 2));
        //nextScreen(context, CreatePin(result: 'Singup',));
        agentSendOTP(email: user.email,context:context);
        setSignIn();
         // Navigator.pushNamed(context, "CreatePin");
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> agentUpdate(
      int Id,
      String Name,
      String BusinessName,
      String BranchName,
      String Email,
      String phone,
      String countryy,
      BuildContext context) async {
    if (Id.toString().isEmpty ||
        Name.isEmpty ||
        BusinessName.isEmpty ||
        BranchName.isEmpty ||
        Email.isEmpty ||
        phone.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');

      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    adsLoader.show(context);
    final response = await http.put(
      Uri.parse("${ApiUrl.agentUpdate}/$Id"),
      headers: headers,
      body: {
        // 'id': Id.toString(),
        // 'agents_id': agents_id.toString(),
        'name': Name,
        'business_name': BusinessName,
        'branch_name': BranchName,
        'email': Email,
        'phone_number': phone,
        'country': countryy,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarMessage(context, responseData["message"]);
          UserData user = UserData.fromJson(responseData['data']);
          getController.upgradeCurrency(user.currencyCountry, context);
          await saveUserData(user);
          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        } else {
          adsLoader.close();
          showSnackbarMessage(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarMessage(context, 'Update failed');

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }


  Future<void> agentSendOTP({
    required String email,
    required BuildContext context,
  }) async {

    final response = await http.post(
      Uri.parse(ApiUrl.agentSendOtp),
      body: {
        "email":email,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        //UserData user = UserData.fromJson(responseData['data']);
        //await saveUserData(user);
        nextScreen(context, OtpPage(email: email,));
        showSnackbarSuccess(context, responseData["message"]);
        notifyListeners();
        adsLoader.close();
        // await Future.delayed(Duration(seconds: 2));
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> agentSendOTP1({
    required String email,
    required BuildContext context,
  }) async {
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.agentSendOtp),
      body: {
        "email":email,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        //UserData user = UserData.fromJson(responseData['data']);
        //await saveUserData(user);
        showSnackbarSuccess(context, responseData["message"]);
        adsLoader.close();
        notifyListeners();
        adsLoader.close();
        // await Future.delayed(Duration(seconds: 2));
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> agentCheckOTP(
      String OTP,
      // String email,
      BuildContext context) async {
    if (OTP.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.agentCheckOtp),
      body: {
        "email":userData?.email,
        'otp':OTP
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        adsLoader.close();
        await Future.delayed(Duration(seconds: 2));

        nextScreen(context, CreatePin(result: 'Singup',));

        notifyListeners();
        adsLoader.close();
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Invalid OTP');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Invalid OTP');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }


  Future<void> agentChangePassword(
      String Id,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      BuildContext context) async {
    if (Id.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.agentChangePassword),
      headers: headers,
      body: {
        'id': Id,
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);

          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }



  Future<void> agentChangePin(
      String Id,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      BuildContext context) async {
    if (Id.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }
    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.agentChangePin),
      headers: headers,
      body: {
        'id': Id,
        'old_security_pin': oldPassword,
        'security_pin': newPassword,
        'confirm_security_pin': confirmPassword,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);

          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> agentCreatePin(
      String id,
      String SecurityPin,
      String CsecurityPin,
      BuildContext context) async {
    if (id.isEmpty ||
        SecurityPin.isEmpty ||
        CsecurityPin.isEmpty)  {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.agentCreatePin),
      headers: headers,
      body: {
        'id': id,
        'security_pin': SecurityPin,
        'confirm_security_pin': CsecurityPin,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);
         // securityPin = responseData["data"]['security_pin'];
          UserData user = UserData.fromJson(responseData['data']);
          await saveUserData(user);
          adsLoader.close();

          notifyListeners();
          // await Future.delayed(Duration(seconds: 2));
          Navigator.pushNamed(context, 'MyBottomBarApp');

          // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> agentCheckPin(
      String SecurityPin,
      String CsecurityPin,
      BuildContext context) async {
    if (SecurityPin.isEmpty ||
        CsecurityPin.isEmpty)  {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }
    notifyListeners();

    adsLoader.show(context);
    try {
      if(SecurityPin == CsecurityPin){
        if ( userData?.securityPin== SecurityPin && userData?.securityPin == CsecurityPin) {

          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 1));
          Navigator.pushNamed(context, 'MyBottomBarApp');

          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, "Wronged Pin");

          throw Exception('Update failed');
        }
      }
      else{
        adsLoader.close();
        showSnackbarError(context, "Both Pin are not same!");

      }

    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

//////////////////////////////////////////////// User Auth ///////////////////////////////////////////////////////////////

  Future<void> userLogin(
      String email, String password, BuildContext context) async  {
    clearStoredData();

    if (email.isEmpty || password.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.userLogin),
      body: {'email': email, 'password': password},
    );
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          if(responseData['data']['role']=="User"){
            showSnackbarSuccess(context, responseData["message"]);

            UserData user = UserData.fromJson(responseData['data']);
            await saveUserData(user);
            getController.upgradeCurrency(user.currencyCountry, context);

            notifyListeners();
            adsLoader.close();
            await Future.delayed(Duration(seconds: 2));
            //nextScreen(context, UserCreatePin(result: 'Login',));
            if(user.securityPin.isEmpty){
              nextScreen(context, UserCreatePin(result: 'Singup',));
            }else{
              Navigator.pushNamed(context, 'userBottomBarApp');
            }
            setSignIn();
          }
          else {
            adsLoader.close();
            showSnackbarError(context, "No Found Data");
          }

        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Login failed");
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Eroor = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> userSignup(
      String Name,
      String email,
      String phone,
      String password,
      String confirmPassword,
      String countryy,

      BuildContext context) async {
    clearStoredData();

    if (Name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        countryy.isEmpty) {
      // Show a SnackBar with validation error message

      showSnackbarError(context, "Please fill in all fields");

      return;
    }
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.userRegister),
      body: {
        'name': Name,
        'email': email,
        'phone_number': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'country': countryy,
        'role': 'User',
      },
    );
    final responseData = json.decode(response.body);
    print("api Data==$responseData");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        UserData user = UserData.fromJson(responseData['data']);
        getController.upgradeCurrency(user.currencyCountry, context);
        await saveUserData(user);
        notifyListeners();
        adsLoader.close();
        await Future.delayed(Duration(seconds: 2));
        userSendOTP(email: user.email,context:context);

        //nextScreen(context, UserCreatePin(result: 'Singup',));
        setSignIn();
        // Navigator.pushNamed(context, 'userBottomBarApp');
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> userUpdate(
      String Id,
      String Name,
      String Email,
      String phone,
      String countryy,
      BuildContext context) async {
    if (countryy.isEmpty ||Id.isEmpty||
        Name.isEmpty ||
        Email.isEmpty ||
        phone.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');

      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    adsLoader.show(context);
    final response = await http.put(
      Uri.parse("${ApiUrl.userUpdate}/$Id"),
      headers: headers,
      body: {
        'name': Name,
        'email': Email,
        'phone_number': phone,
        'country': countryy,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarMessage(context, responseData["message"]);
          // person = "user";
          // userId = responseData['data']["user_id"] ?? "";
          // name = responseData['data']["name"] ?? "";
          // emaill = responseData['data']["email"] ?? "";
          // phoneNumber = responseData['data']["phone_number"] ?? "";
          // country = responseData['data']["country"] ?? "";
          UserData user = UserData.fromJson(responseData['data']);
          await saveUserData(user);
          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        } else {
          adsLoader.close();
          showSnackbarMessage(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarMessage(context, 'Update failed');

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> userSendOTP({
    required String email,
    required BuildContext context,
  }) async {

    final response = await http.post(
      Uri.parse(ApiUrl.agentSendOtp),
      body: {
        "email":email,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        //UserData user = UserData.fromJson(responseData['data']);
        //await saveUserData(user);
        nextScreen(context, OtpPage(email: email,));
        showSnackbarSuccess(context, responseData["message"]);
        notifyListeners();
        adsLoader.close();
        // await Future.delayed(Duration(seconds: 2));
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> userCheckOTP(
      String OTP,
      // String email,
      BuildContext context) async {
    if (OTP.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.agentCheckOtp),
      body: {
        "email":userData?.email,
        'otp':OTP
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        adsLoader.close();
        await Future.delayed(Duration(seconds: 2));

        nextScreen(context, UserCreatePin(result: 'Singup',));

        notifyListeners();
        adsLoader.close();
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Invalid OTP');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Invalid OTP');
      adsLoader.close();

      //throw Exception('Invalid OTP');
    }
  }


  Future<void> userSendOTPPassword({
    required String email,
    required String role,
    required BuildContext context,
  }) async {
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.agentSendOtp),
      body: {
        "email":email,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        //UserData user = UserData.fromJson(responseData['data']);
        //await saveUserData(user);
        adsLoader.close();
        showSnackbarSuccess(context, responseData["message"]);
        nextScreen(context, OtpPagePassword(email: email,role: role,));
        notifyListeners();
        adsLoader.close();
        // await Future.delayed(Duration(seconds: 2));
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Signup failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Signup failed');
      adsLoader.close();

      throw Exception('Signup failed');
    }
  }

  Future<void> userCheckOTPPassword(
      String OTP,
       String email,
       String role,
      BuildContext context) async {
    if (OTP.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.agentCheckOtp),
      body: {
        "email":email,
        'otp':OTP
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        adsLoader.close();
        await Future.delayed(Duration(seconds: 2));

        nextScreen(context, ResetPassword(email:email, role: role,));

        notifyListeners();
        adsLoader.close();
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Invalid OTP');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Invalid OTP');
      adsLoader.close();

      //throw Exception('Invalid OTP');
    }
  }
  Future<void> resetPassword(
      String email,
      String password,
      String confirmPassword,
      String role,
      BuildContext context) async {
    if (email.isEmpty) {
      showSnackbarError(context, "Please fill in all fields");
      return;
    }
    adsLoader.show(context);

    final response = await http.post(
      Uri.parse(ApiUrl.agentResetPassword),
      body: {
        "email":email,
        "new_password":password,
        "confirm_password":confirmPassword,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==$responseData");

      if (responseData["success"] == true) {
        showSnackbarSuccess(context, responseData["message"]);
        adsLoader.close();
        await Future.delayed(Duration(seconds: 2));
        if(role == 'Agent'){
          nextScreen(context,Login());
        }else{
          nextScreen(context,UserLogin());
        }


        notifyListeners();
        adsLoader.close();
      } else {
        showSnackbarError(context, responseData["message"]);
        adsLoader.close();

        throw Exception('Failed');
      }

      notifyListeners();
    } else {
      // Show a SnackBar with signup failed message
      showSnackbarError(context, 'Failed');
      adsLoader.close();

      //throw Exception('Invalid OTP');
    }
  }


  Future<void> userChangePassword(
      String id,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      BuildContext context) async {
    if (id.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.userChangePassword),
      headers: headers,
      body: {
        'id': id,
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);

          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> userChangePin(
      String Id,
      String oldPassword,
      String newPassword,
      String confirmPassword,
      BuildContext context) async {
    if (Id.isEmpty ||
        oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }
    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.usersChangePin),
      headers: headers,
      body: {
        'id': Id,
        'old_security_pin': oldPassword,
        'security_pin': newPassword,
        'confirm_security_pin': confirmPassword,
      },
    );
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);

          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop(); // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> userCreatePin(
      String id,
      String SecurityPin,
      String CsecurityPin,
      BuildContext context) async {
    if (id.isEmpty ||
        SecurityPin.isEmpty ||
        CsecurityPin.isEmpty)  {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }

    notifyListeners();
    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };
    adsLoader.show(context);
    final response = await http.post(
      Uri.parse(ApiUrl.userCreatePin),
      headers: headers,
      body: {
        'id': id,
        'security_pin': SecurityPin,
        'confirm_security_pin': CsecurityPin,
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, responseData["message"]);
          // securityPin = responseData["data"]['security_pin'];
          UserData user = UserData.fromJson(responseData['data']);
          await saveUserData(user);
          adsLoader.close();

          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          nextScreen(context, userBottomBarApp(visit: 0,));
          setSignIn();
          // Close the page, or navigate as needed
        }
        else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }
        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "Failed");

        throw Exception('Update failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> UserChackPin(
      String SecurityPin,
      String CsecurityPin,
      BuildContext context) async {
    if (SecurityPin.isEmpty ||
        CsecurityPin.isEmpty)  {
      showSnackbarError(context, 'Please fill in all fields');
      return;
    }
    notifyListeners();

    adsLoader.show(context);
    try {
      if(SecurityPin == CsecurityPin){
        if (userData?.securityPin == SecurityPin && userData?.securityPin == CsecurityPin) {
          notifyListeners();
          await Future.delayed(Duration(seconds: 2));
          adsLoader.close();
          Navigator.pushNamed(context, 'userBottomBarApp');
          setSignIn();
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, "Wronged Pin");

          throw Exception('Update failed');
        }
      }
      else{
        adsLoader.close();
        showSnackbarError(context, "Both Pin are not same!");

      }

    } catch (e) {
      adsLoader.close();
      print('Error = $e');
      _hasError = true;
      notifyListeners();
    }
  }
}
