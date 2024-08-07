import 'package:cep_dio/model/ceps_back4app_model.dart';
import 'package:cep_dio/repositories/back4app/cep_back4app_repository.dart';
import 'package:flutter/material.dart';

class CepListItem extends StatefulWidget {
  const CepListItem({
    Key? key,
    required this.cepItem,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  final CepBack4appModel cepItem;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  _CepListItemState createState() => _CepListItemState();
}

class _CepListItemState extends State<CepListItem> {
  late TextEditingController cepController;
  late TextEditingController ufController;
  late TextEditingController logradouroController;

  @override
  void initState() {
    super.initState();
    cepController = TextEditingController(text: widget.cepItem.cep);
    ufController = TextEditingController(text: widget.cepItem.uf);
    logradouroController = TextEditingController(text: widget.cepItem.logradouro);
  }

  @override
  void dispose() {
    cepController.dispose();
    ufController.dispose();
    logradouroController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(widget.cepItem.uf)),
      title: Text(widget.cepItem.localidade),
      subtitle: Text(widget.cepItem.cep),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Editar Cep"),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: cepController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "CEP",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o CEP';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: ufController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "UF",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira a UF';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: logradouroController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              hintText: "Logradouro",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o logradouro';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Voltar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await editItem(widget.cepItem.objectId, cepController.text, ufController.text, logradouroController.text);
                          widget.onUpdate();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Atualizar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Deletar Cep"),
                  content: const Text('Tem certeza que deseja deletar?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Não'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await deleteItem(widget.cepItem.objectId);
                        widget.onDelete();
                        Navigator.pop(context);
                      },
                      child: const Text('Sim'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> deleteItem(String objectId) async {
    CepBack4appRepository repository = CepBack4appRepository();
    await repository.deletarCep(objectId);
  }

  Future<void> editItem(String objectId, String cep, String uf, String logradouro) async {
    CepBack4appRepository repository = CepBack4appRepository();
    await repository.atualizarCep(objectId, cep, uf, logradouro);
  }
}
