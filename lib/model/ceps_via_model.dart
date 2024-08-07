class CepViaModel {
  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String localidade;
  String uf;
  String ibge;
  String gia;
  String ddd;
  String siafi;

  CepViaModel(
      {required this.cep,
      required this.logradouro,
      required this.bairro,
      required this.localidade,
      required this.uf,
      required this.complemento,
      required this.ddd,
      required this.gia,
      required this.ibge,

      required this.siafi});

  factory CepViaModel.fromJson(Map<String, dynamic> json) {
    return CepViaModel(
      cep: json['cep'],
      logradouro: json['logradouro'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
      complemento: json['complemento'],
      ddd: json['ddd'],
      siafi: json['siafi'],
      ibge: json['ibge'],
      gia: json['gia'],
      
    );
  }
}
