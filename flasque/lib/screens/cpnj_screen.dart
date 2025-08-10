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
    // Remove pontos, traços e espaços da formatação do CNPJ
    final cnpj = _controller.text.trim().replaceAll(RegExp(r'[.\-/\s]'), '');
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
      appBar: AppBar(
        title: const Text('Consultar CNPJ'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => consultarCnpj(),
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: "XX.XXX.XXX/0001-XX",
                    hintStyle: const TextStyle(color: Colors.white54),
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
                      borderSide: BorderSide(
                        color: Color(0xFFFF7A28),
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFFFF7A28)),
                      onPressed: _loading ? null : consultarCnpj,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 24),
                if (_loading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF7A28),
                    ),
                  ),
                if (_resultado.isNotEmpty && !_loading)
                  Builder(
                    builder: (context) {
                      final Map<String, dynamic> dados = json.decode(
                        _resultado,
                      );
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF100C0A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFF7A28),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REPÚBLICA FEDERATIVA DA PESSOA JURÍDICA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'COMPROVANTE DE INSCRIÇÃO E DE SITUAÇÃO CADASTRAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'NOME EMPRESARIAL',
                                  dados['nome'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'DATA DE ABERTURA',
                                  dados['abertura'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'NOME FANTASIA',
                                  dados['fantasia'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'PORTE',
                                  dados['porte'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'CNPJ',
                                  dados['cnpj'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'NATUREZA JURÍDICA',
                                  dados['natureza_juridica'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Text(
                              'ATIVIDADE PRINCIPAL:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            ...((dados['atividade_principal'] ?? []) as List)
                                .map<Widget>(
                                  (a) => Text(
                                    '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                            SizedBox(height: 8),
                            if ((dados['atividades_secundarias'] ?? [])
                                .isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ATIVIDADES SECUNDÁRIAS:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ...((dados['atividades_secundarias'] ?? [])
                                          as List)
                                      .map<Widget>(
                                        (a) => Text(
                                          '${a['code'] ?? ''} - ${a['text'] ?? ''}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            Divider(color: Colors.white24, height: 24),
                            Text(
                              'ENDEREÇO:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${dados['logradouro'] ?? ''}, ${dados['numero'] ?? ''} ${dados['complemento'] ?? ''}\n${dados['bairro'] ?? ''} - ${dados['municipio'] ?? ''}/${dados['uf'] ?? ''}\nCEP: ${dados['cep'] ?? ''}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Divider(color: Colors.white24, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'SITUAÇÃO CADASTRAL',
                                  dados['situacao'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'DATA DA SITUAÇÃO CADASTRAL',
                                  dados['data_situacao'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'CAPITAL SOCIAL',
                                  dados['capital_social'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'MOTIVO DE SITUAÇÃO CADASTRAL',
                                  dados['motivo_situacao'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _campo(
                                  'SITUAÇÃO ESPECIAL',
                                  dados['situacao_especial'] ?? '',
                                  color: Colors.white70,
                                ),
                                _campo(
                                  'DATA DA SITUAÇÃO ESPECIAL',
                                  dados['data_situacao_especial'] ?? '',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            Divider(color: Colors.white24, height: 24),
                            if ((dados['qsa'] ?? []).isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'QUADRO SOCIETÁRIO:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ...((dados['qsa'] ?? []) as List).map<Widget>(
                                    (s) => Text(
                                      '${s['qual'] ?? ''}: ${s['nome'] ?? ''}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função auxiliar para exibir campos com título e valor
  Widget _campo(String titulo, String valor, {Color color = Colors.black}) {
    if (valor.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: color, fontSize: 13),
          children: [
            TextSpan(
              text: '$titulo: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            TextSpan(text: valor, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
