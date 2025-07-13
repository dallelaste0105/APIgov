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
  const ConsultaCnpjPage({super.key});

  @override
  _ConsultaCnpjPageState createState() => _ConsultaCnpjPageState();
}

class _ConsultaCnpjPageState extends State<ConsultaCnpjPage> {
  final TextEditingController _controllerCnpj = TextEditingController();
  final TextEditingController _controllerCep = TextEditingController();
  final TextEditingController _controllerCodSiorg = TextEditingController();

  String _resultadoCnpj = "";
  String _resultadoCep = "";
  String _resultadoCodSiorg = "";

  Future<void> consultarCnpj(String cnpj) async {
    final url = Uri.parse('http://10.0.2.2:5000/cnpj/$cnpj');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dados = json.decode(response.body);
      setState(() {
        _resultadoCnpj = dados['nome'] ?? "Nome não encontrado";
      });
    } else {
      setState(() {
        _resultadoCnpj = "Erro na consulta.";
      });
    }
  }

  Future<void> consultarCep(String cep) async {
    final url = Uri.parse('http://10.0.2.2:5000/cep/$cep');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dados = json.decode(response.body);
      setState(() {
        _resultadoCep = dados['logradouro'] ?? "Logradouro não encontrado";
      });
    } else {
      setState(() {
        _resultadoCep = "Erro na consulta.";
      });
    }
  }

  Future<void> consultarCodSiorg(String codSiorg) async {
    final url = Uri.parse('http://10.0.2.2:5000/servicos/$codSiorg');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dados = json.decode(response.body);
      setState(() {
        _resultadoCodSiorg = dados['nome'] ?? "Nome não encontrado";
      });
    } else {
      setState(() {
        _resultadoCodSiorg = "Erro na consulta.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consultas GOV")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Seção CNPJ
              TextField(
                controller: _controllerCnpj,
                decoration: InputDecoration(labelText: "Digite o CNPJ"),
              ),
              ElevatedButton(
                onPressed: () => consultarCnpj(_controllerCnpj.text),
                child: Text("Consultar CNPJ"),
              ),
              Text(_resultadoCnpj),
              Divider(),

              // Seção CEP
              TextField(
                controller: _controllerCep,
                decoration: InputDecoration(labelText: "Digite o CEP"),
              ),
              ElevatedButton(
                onPressed: () => consultarCep(_controllerCep.text),
                child: Text("Consultar CEP"),
              ),
              Text(_resultadoCep),
              Divider(),

              // Seção codSiorg
              TextField(
                controller: _controllerCodSiorg,
                decoration: InputDecoration(labelText: "Digite o codSiorg"),
              ),
              ElevatedButton(
                onPressed: () => consultarCodSiorg(_controllerCodSiorg.text),
                child: Text("Consultar codSiorg"),
              ),
              Text(_resultadoCodSiorg),
            ],
          ),
        ),
      ),
    );
  }
}