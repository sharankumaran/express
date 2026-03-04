// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceApi {
  static const String baseUrl = "https://express-abvc.onrender.com";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  // CREATE INVOICE (WITH PDF)
  static Future<void> createInvoice({
    required String amount,
    required String status,
    required String clientId,
    required String pdfPath,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("Login expired. Please login again.");
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/invoices"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields["amount"] = amount;
    request.fields["status"] = status;
    request.fields["client"] = clientId;

    request.files.add(await http.MultipartFile.fromPath("pdf", pdfPath));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("Status: ${response.statusCode}");
    print("Body: $responseBody");

    if (response.statusCode != 201) {
      throw Exception(responseBody);
    }
  }

  // GET INVOICES
  static Future<List<dynamic>> getInvoices() async {
    final token = await _getToken();

    print("TOKEN: $token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/invoices"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Status: ${response.statusCode}");
    }
  }
}
