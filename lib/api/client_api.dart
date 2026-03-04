import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClientApi {
  static const String baseUrl = "https://express-abvc.onrender.com";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  static Future<List<dynamic>> getClients() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/api/clients"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load clients");
    }
  }

  static Future<void> createClient(
    String name,
    String email,
    String phone,
  ) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/api/clients"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": name, "email": email, "phone": phone}),
    );

    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
  }
}
