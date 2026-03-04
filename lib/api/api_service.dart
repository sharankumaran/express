import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  // Replace with your deployed backend URL
  static const String baseUrl = "https://express-abvc.onrender.com";

  // REGISTER
  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? "Registration failed",
      );
    }
  }

  // LOGIN
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? "Login failed");
    }

    final data = jsonDecode(response.body);
    final token = data['token'];

    // Save token locally for future requests
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    return token;
  }
}
