import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeputadosPage extends StatefulWidget {
  @override
  _DeputadosPageState createState() => _DeputadosPageState();
}

class _DeputadosPageState extends State<DeputadosPage> {
  TextEditingController _controller = TextEditingController();
  String _resultado = "";
  bool _loading = false;

  Future<void> buscarDeputados() async {
    setState(() {
      _loading = true;
      _resultado = "";
    });
    final nome = _controller.text.trim();
    final url = Uri.parse('http://localhost:5000/deputados?nome=$nome');
    final response = await http.get(url);
    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        _resultado = const JsonEncoder.withIndent(
          '  ',
        ).convert(json.decode(response.body));
      } else {
        _resultado = "Erro na consulta.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Deputados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome do deputado',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: buscarDeputados, child: Text('Buscar')),
            SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(_resultado),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
