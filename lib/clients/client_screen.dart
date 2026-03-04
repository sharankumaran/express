import 'package:flutter/material.dart';
import '../api/client_api.dart';

class CreateClientScreen extends StatefulWidget {
  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = false;

  Future<void> saveClient() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("All fields required")));
      return;
    }

    setState(() => loading = true);

    try {
      await ClientApi.createClient(
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Client Created Successfully")));

      Navigator.pop(context, true); // return success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Client")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Client Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveClient,
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save Client"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
