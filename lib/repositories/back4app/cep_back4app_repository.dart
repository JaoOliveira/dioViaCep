import 'package:cep_dio/model/ceps_back4app_model.dart';
import 'package:dio/dio.dart';

class CepBack4appRepository {
  var _dio = Dio();

  CepBack4appRepository() {
    _dio.options.headers["X-Parse-Application-Id"] =
        "rDL1n3Jj5oph6s6enttyes9Z7im95GzZNtKvvhI9";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "o92oYnza4WSb9xBkKaaTHOLFbLmbWPiN7uT9Plqa";
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }

 Future<void> criarCep(CepBack4appModel cep) async {
  try {
    final data = {
      "uf": cep.uf ?? '',
      "cep": cep.cep ?? '',
      "ddd": cep.ddd ?? '',
      "gia": cep.gia ?? '',
      "ibge": cep.ibge ?? '',
      "siafi": cep.siafi ?? '',
      "bairro": cep.bairro ?? '',
      "localidade": cep.localidade ?? '',
      "logradouro": cep.logradouro ?? '',
      "complemento": cep.complemento ?? '',
    };

    print('Enviando dados: $data'); // Log dos dados enviados para depuração

    final response = await _dio.post(
      '/ceps',
      data: data,
    );

    print('Resposta da API: ${response.statusCode} - ${response.data}'); // Log da resposta da API

    if (response.statusCode == 201) {
      print('CEP criado com sucesso');
    } else {
      print('Erro ao criar o CEP: ${response.statusCode} - ${response.data}');
    }
  } on DioError catch (e) {
    print('Erro ao criar o CEP: ${e.response?.statusCode} - ${e.message}');
    if (e.response != null) {
      print('Resposta: ${e.response?.data}');
    }
  } catch (e) {
    print('Erro desconhecido ao criar o CEP: $e');
  }
}

Future<List<CepBack4appModel>> returnCep() async {
  try {
    final response = await _dio.get('/ceps');
    final data = response.data['results'] as List;
    return data.map((json) => CepBack4appModel.fromJson(json)).toList();
  } catch (e) {
    print('Erro ao obter a lista de CEPs: $e');
    return [];
  }
}


  Future<void> atualizarCep(
      String objectId, String cep, String uf, String logradouro) async {
    var url = '/ceps/$objectId';
    var data = {
      'cep': cep,
      'uf': uf,
      'logradouro': logradouro,
    };
    var result = await _dio.put(url, data: data);
    if (result.statusCode != 200) {
      throw Exception('Erro ao atualizar o CEP: ${result.data}');
    }
  }

  Future<void> deletarCep(String objectId) async {
    var url = '/ceps/$objectId';
    var result = await _dio.delete(url);
    if (result.statusCode != 200) {
      throw Exception('Erro ao deletar o CEP: ${result.data}');
    }
  }
}
