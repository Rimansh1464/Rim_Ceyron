import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://3.96.147.37/agents/login';

  Future<Map<String, dynamic>> login(
      String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      body: {'agents_id': email, 'phone_number': phone, 'password': password},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("api Data==${responseData}");
      return responseData;
    } else {
      throw Exception('Login failed');
    }
  }
}
