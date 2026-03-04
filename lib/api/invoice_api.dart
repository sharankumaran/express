import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceApi {
  static const String baseUrl = "https://express-abvc.onrender.com";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  // CREATE INVOICE WITH PDF
  static Future<void> createInvoice({
    required String amount,
    required String status,
    required String clientId,
    required String pdfPath,
  }) async {
    final token = await _getToken();

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

    if (response.statusCode != 201) {
      throw Exception("Invoice creation failed");
    }
  }

  // GET INVOICES WITH FILTER + PAGINATION
  static Future<List<dynamic>> getInvoices({
    String? status,
    int page = 1,
  }) async {
    final token = await _getToken();

    final uri = Uri.parse("$baseUrl/api/invoices?status=$status&page=$page");

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch invoices");
    }
  }
}
