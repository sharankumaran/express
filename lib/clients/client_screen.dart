import 'package:backend/api/client_api.dart';
import 'package:flutter/material.dart';

class CreateClientScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Client")),
      body: Column(
        children: [
          TextField(controller: nameController),
          TextField(controller: emailController),
          TextField(controller: phoneController),

          ElevatedButton(
            onPressed: () async {
              await ClientApi.createClient(
                nameController.text,
                emailController.text,
                phoneController.text,
              );

              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }
}