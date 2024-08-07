import 'package:cep_dio/model/ceps_via_model.dart';
import 'package:dio/dio.dart';

class CepViaRepository {
  final Dio _dio = Dio();

  CepViaRepository() {
    _dio.options.baseUrl = 'https://viacep.com.br/ws/';
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.validateStatus = (status) {
      return status! < 500; // Aceita status 2xx e 4xx, mas não 5xx
    };
  }

  Future<CepViaModel> returnViaCep(String cep) async {
    var url = '$cep/json/';
    try {
      final result = await _dio.get(url);
      if (result.statusCode == 200) {
        return CepViaModel.fromJson(result.data);
      } else {
        throw Exception('Erro ao buscar o CEP: ${result.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar o CEP: ${e.message}');
    }
  }
}
