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
      title: 'Consulta CNPJ e Deputados',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultas')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.business),
                label: Text('Consulta CNPJ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultaCnpjPage()),
                  );
                },
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.people),
                label: Text('Buscar Deputados'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeputadosPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
