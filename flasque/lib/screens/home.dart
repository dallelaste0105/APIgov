import 'package:flutter/material.dart';
import 'cpnj_screen.dart';
import 'deputado_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 12, 10),
      appBar: AppBar(leading: Icon(Icons.import_contacts, color: const Color.fromARGB(255, 255, 122, 40)),
        title: Text('Olá Mignnor', style: TextStyle(color: Colors.white),), backgroundColor: const Color.fromARGB(255, 16, 12, 10)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.business, color: const Color.fromARGB(255, 255, 255, 255)),
                label: Text('Consulta CNPJ', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Color.fromARGB(255, 255, 122, 40)
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
                icon: Icon(Icons.people, color: const Color.fromARGB(255, 255, 255, 255)),
                label: Text('Buscar Deputados', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Color.fromARGB(255, 255, 122, 40)
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
