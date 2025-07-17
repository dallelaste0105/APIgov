import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsultaCnpjPage extends StatefulWidget {
  @override
  _ConsultaCnpjPageState createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  TextEditingController _controller = TextEditingController();
  String _resultado = "";
  bool _loading = false;

  Future<void> consultarCnpj() async {
    setState(() {
      _loading = true;
      _resultado = "";
    });
    final cnpj = _controller.text.trim();
    final url = Uri.parse('http://localhost:5000/cnpj/$cnpj');
    final response = await http.get(url);
    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final dados = json.decode(response.body);
        _resultado = const JsonEncoder.withIndent('  ').convert(dados);
      } else {
        _resultado = "Erro na consulta.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consulta CNPJ")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Digite o CNPJ",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : consultarCnpj,
                        icon: Icon(Icons.search),
                        label: Text("Consultar"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    if (_loading) CircularProgressIndicator(),
                    if (_resultado.isNotEmpty && !_loading)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _resultado,
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
