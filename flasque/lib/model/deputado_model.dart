class Deputado {
  final String nome;
  final String email;
  final int id;
  final String siglaPartido;
  final String siglaUf;
  final String urlFoto;
  final String? telefone;
  final String? endereco;
  final String? dataNascimento;
  final String? naturalidade;

  Deputado({
    required this.nome,
    required this.email,
    required this.id,
    required this.siglaPartido,
    required this.siglaUf,
    required this.urlFoto,
    this.telefone,
    this.endereco,
    this.dataNascimento,
    this.naturalidade,
  });

  factory Deputado.fromJson(Map<String, dynamic> json) {
    return Deputado(
      nome: json['nome'],
      email: json['email'],
      id: json['id'],
      siglaPartido: json['siglaPartido'],
      siglaUf: json['siglaUf'],
      urlFoto: json['urlFoto'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      dataNascimento: json['dataNascimento'],
      naturalidade: json['naturalidade'],
    );
  }
}
