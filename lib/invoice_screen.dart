// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../api/client_api.dart';
import '../api/invoice_api.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List clients = [];
  List invoices = [];

  String? selectedClientId;
  String status = "pending";
  String? pdfPath;

  final amountController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final clientData = await ClientApi.getClients();
      final invoiceData = await InvoiceApi.getInvoices();

      setState(() {
        clients = clientData;
        invoices = invoiceData;
        loading = false;
      });
    } catch (e) {
      print("Load Error: $e");

      setState(() {
        loading = false; // 🔥 VERY IMPORTANT
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading data")));
    }
  }

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        pdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> createInvoice() async {
    if (amountController.text.isEmpty ||
        selectedClientId == null ||
        pdfPath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fill all fields")));
      return;
    }

    try {
      await InvoiceApi.createInvoice(
        amount: amountController.text,
        status: status,
        clientId: selectedClientId!,
        pdfPath: pdfPath!,
      );

      amountController.clear();
      selectedClientId = null;
      pdfPath = null;

      await loadData();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invoice Created")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Invoices")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Invoices")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Create Invoice",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedClientId,
              hint: Text("Select Client"),
              items: clients.map<DropdownMenuItem<String>>((client) {
                return DropdownMenuItem(
                  value: client['_id'],
                  child: Text(client['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClientId = value;
                });
              },
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: status,
              items: [
                "pending",
                "paid",
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickPDF,
              child: Text(pdfPath == null ? "Select PDF" : "PDF Selected"),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: createInvoice,
              child: Text("Create Invoice"),
            ),

            Divider(height: 40),

            Text(
              "Invoice List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];

                return Card(
                  child: ListTile(
                    title: Text("₹ ${invoice['amount']}"),
                    subtitle: Text("Client: ${invoice['client']['name']}"),
                    trailing: Text(invoice['status']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
