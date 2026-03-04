import 'package:backend/api/client_api.dart';
import 'package:backend/clients/client_screen.dart';
import 'package:flutter/material.dart';

class ClientListScreen extends StatefulWidget {
  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List clients = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  void fetchClients() async {
    final data = await ClientApi.getClients();
    setState(() {
      clients = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return CircularProgressIndicator();

    return Scaffold(
      appBar: AppBar(title: Text("Clients")),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];

          return ListTile(
            title: Text(client['name']),
            subtitle: Text(client['email']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateClientScreen()),
          );
          fetchClients(); // refresh after adding
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
