import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConsultaCnpjPage(),
    );
  }
}

class ConsultaCnpjPage extends StatefulWidget {
  @override
  _ConsultaCnpjPageState createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  TextEditingController _controller = TextEditingController();
  String _resultado = "";

  Future<void> consultarCnpj(String cnpj) async {
    final url = Uri.parse('http://localhost:5000/cnpj/$cnpj'); //manos, aqui tem q mudar se for mobile pra 10.0.2.2
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dados = json.decode(response.body);
      setState(() {
        _resultado = dados['nome'] ?? "Nome não encontrado";
      });
    } else {
      setState(() {
        _resultado = "Erro na consulta.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consulta CNPJ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Digite o CNPJ"),
            ),
            ElevatedButton(
              onPressed: () => consultarCnpj(_controller.text),
              child: Text("Consultar"),
            ),
            SizedBox(height: 20),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}