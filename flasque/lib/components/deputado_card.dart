import 'package:flutter/material.dart';
import '../model/deputado_model.dart';

class DeputadoCard extends StatelessWidget {
  final Deputado deputado;

  const DeputadoCard({super.key, required this.deputado});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFF7A28), width: 2),
      ),
      color: const Color(0xFF100C0A),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    deputado.urlFoto,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 50),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nome Civil:', deputado.nome.toUpperCase()),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Partido:',
                        '${deputado.siglaPartido} - ${deputado.siglaUf}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('E-mail:', deputado.email),
                      const SizedBox(height: 8),
                      if (deputado.telefone != null)
                        _buildInfoRow('Telefone:', deputado.telefone!),
                      if (deputado.telefone != null) const SizedBox(height: 8),
                      if (deputado.endereco != null)
                        _buildInfoRow('Endereço:', deputado.endereco!),
                      if (deputado.endereco != null) const SizedBox(height: 8),
                      if (deputado.dataNascimento != null)
                        _buildInfoRow(
                          'Data de Nascimento:',
                          deputado.dataNascimento!,
                        ),
                      if (deputado.dataNascimento != null)
                        const SizedBox(height: 8),
                      if (deputado.naturalidade != null)
                        _buildInfoRow('Naturalidade:', deputado.naturalidade!),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' $value'),
        ],
      ),
    );
  }
}
