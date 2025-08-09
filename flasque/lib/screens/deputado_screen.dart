import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/deputado_model.dart';
import '../components/deputado_card.dart';

class DeputadosPage extends StatefulWidget {
  @override
  _DeputadosPageState createState() => _DeputadosPageState();
}

class _DeputadosPageState extends State<DeputadosPage> {
  TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<Deputado> _deputados = [];

  Future<void> buscarDeputados() async {
    setState(() {
      _loading = true;
      _deputados = [];
    });

    final nome = _controller.text.trim();
    final url = Uri.parse('http://localhost:5000/deputados?nome=$nome');
    final response = await http.get(url);

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        _deputados = jsonList.map((e) => Deputado.fromJson(e)).toList();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro na consulta.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Deputados'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => buscarDeputados(),
              decoration: InputDecoration(
                labelText: 'Nome do deputado',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color(0xFFFF7A28)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color(0xFFFF7A28)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Color(0xFFFF7A28), width: 2),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFFFF7A28)),
                  onPressed: buscarDeputados,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7A28)),
                )
                : _deputados.isEmpty
                ? const Text(
                  'Nenhum resultado encontrado.',
                  style: TextStyle(color: Colors.white),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _deputados.length,
                    itemBuilder: (context, index) {
                      return DeputadoCard(deputado: _deputados[index]);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
