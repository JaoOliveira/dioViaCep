import 'package:flutter/material.dart';
import 'package:cep_dio/components/listcep.dart';
import 'package:cep_dio/model/ceps_back4app_model.dart';
import 'package:cep_dio/repositories/back4app/cep_back4app_repository.dart';
import 'package:cep_dio/repositories/viaCep/cep_via_repositories.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CepBack4appRepository back4appRepository = CepBack4appRepository();
  CepViaRepository viaRepository = CepViaRepository();
  final TextEditingController cepController = TextEditingController();
  List<CepBack4appModel> _ceps = [];

  @override
  void initState() {
    super.initState();
    obterListaCep();
  }

  Future<void> obterListaCep() async {
    try {
      var ceps = await back4appRepository.returnCep();
      setState(() {
        _ceps = ceps;
      });
    } catch (e) {
      print('Erro ao obter a lista de CEPs: $e');
    }
  }

  Future<void> buscarEAdicionarCep(String cep) async {
    try {
      print('Buscando CEP: $cep');
      var cepVia = await viaRepository.returnViaCep(cep);

      bool cepExiste =
          _ceps.any((cepBack4appModel) => cepBack4appModel.cep == cep);

      if (!cepExiste) {
        var novoCepBack4appModel = CepBack4appModel(
          cep: cepVia.cep ?? '',
          logradouro: cepVia.logradouro ?? '',
          complemento: cepVia.complemento ?? '',
          bairro: cepVia.bairro ?? '',
          localidade: cepVia.localidade ?? '',
          uf: cepVia.uf ?? '',
          ibge: cepVia.ibge ?? '',
          gia: cepVia.gia ?? '',
          ddd: cepVia.ddd ?? '',
          siafi: cepVia.siafi ?? '',
          objectId: '',
        );

        // Verificar se todos os campos obrigatórios não estão vazios
        if (novoCepBack4appModel.cep.isNotEmpty &&
            novoCepBack4appModel.logradouro.isNotEmpty &&
            novoCepBack4appModel.bairro.isNotEmpty &&
            novoCepBack4appModel.localidade.isNotEmpty &&
            novoCepBack4appModel.uf.isNotEmpty) {
          await back4appRepository.criarCep(novoCepBack4appModel);
          await obterListaCep();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CEP adicionado com sucesso')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: alguns campos obrigatórios estão vazios.')),
          );
        }
      }
    } catch (e) {
      print('Erro ao buscar ou adicionar CEP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar ou adicionar CEP: $e')),
      );
    }
  }

  Future<void> onUpdate() async {
    await obterListaCep();
    setState(() {});
  }

  Future<void> onDelete() async {
    await obterListaCep();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 8,
                      onChanged: (String value) async {
                        var cep = value.trim().replaceAll('-', '');
                        if (cep.length == 8) {
                          await buscarEAdicionarCep(cep);
                          setState(() {});
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: cepController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Informe seu CEP",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _ceps.length,
                  itemBuilder: (context, i) {
                    final cepItem = _ceps[i];
                    return CepListItem(
                      cepItem: cepItem,
                      onUpdate: onUpdate,
                      onDelete: onDelete,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
