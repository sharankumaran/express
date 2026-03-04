// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static const String baseUrl = "https://express-abvc.onrender.com";

  // REGISTER
  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/auth/register"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 60));

      print("Register Status: ${response.statusCode}");
      print("Register Body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception("Register Error: $e");
    }
  }

  // LOGIN
  static Future<String> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/auth/login"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 60));

      print("Login Status: ${response.statusCode}");
      print("Login Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message']);
      }

      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", token);

      return token;
    } catch (e) {
      throw Exception("Login Error: $e");
    }
  }
}
