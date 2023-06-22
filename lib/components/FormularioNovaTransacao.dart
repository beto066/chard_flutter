import 'package:chard_flutter/models/Transacao.dart';
import 'package:chard_flutter/models/Usuario.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FormularioNovaTransacao extends StatefulWidget {
  final Function setStateParent;

  const FormularioNovaTransacao({super.key, required this.setStateParent});

  @override
  State<StatefulWidget> createState() => FormularioNovaTransacaoState();
}

class FormularioNovaTransacaoState extends State<FormularioNovaTransacao> {
  final GlobalKey<FormState> _chaveAdd = GlobalKey<FormState>();

  List<Usuario> allUsers = [];

  List<Usuario> filteredUsers = [];

  Usuario? usuarioSelecionado;

  DateTime? data = DateTime.now();

  final TextEditingController pesquisaController = TextEditingController();

  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  String exception = '';

  Future<List<Usuario>?> getUsuarios() async {
    const String query = r'''
      query ProcurarContato($pesquisa: String) {
        procurarContato(pesquisa: $pesquisa) {
          id
          outroUsuario {
            nome
            id
          }
          confirmado
        }
      }
    ''';

    final client = ClientUtil.getGraphqlClient();

    var result = await client.value.query(
      QueryOptions(
        document: gql(query),
        variables: { 'pesquisa' : pesquisaController.text },
        fetchPolicy: FetchPolicy.noCache
      )
    );

    if (result.hasException) {
      print(result.exception);
      exception = "Erro ao encontrar usuarios";
      return null;
    }

    var ContatosMap = await result.data!['procurarContato'];

    if (ContatosMap == null) {
      exception = "Erro ao encontrar usuarios";
      return null;
    }

    List<Usuario> users = [];

    for (var contatoMap in ContatosMap) {
      users.add(Usuario.factory(contatoMap['outroUsuario']));
    }

    return users;
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredUsers = allUsers
            .where((user) =>
            user.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredUsers = allUsers;
      }
    });
  }

  Future<void> enviar() async {
    if (!_chaveAdd.currentState!.validate()){
      return;
    }

    const String mutationNovaTransacao = r'''
      mutation RealizarTransacao($data: TransacaoInput) {
        realizarTransacao(data: $data) {
          data
          confirmado
          descricao
          destinatario {
            nome
            id
          }
          id
          remetente {
            nome
            id
          }
          valor
        }
      }
    ''';

    var client = ClientUtil.getGraphqlClient();

    print(data.toString());

    var result = await client.value.mutate(
      MutationOptions(
        document: gql(mutationNovaTransacao),
          variables: {
            'data' : {
              'descricao' : _descricaoController.text,
              'idReceptor' : usuarioSelecionado!.id,
              'valor' : double.parse(_valorController.text) + 0.0,
              'data' : data.toString(),
            }
          },
        fetchPolicy: FetchPolicy.noCache
      )
    );

    if (result.hasException) {
      exception = 'Ocorreu um erro ao realizar a transação';
      print(result.exception);
      return;
    }

    var transacao = result.data!['realizarTransacao'];

    if (transacao == null) {
      exception = 'Ocorreu um erro ao realizar a transação';
      return;
    }

    await DefaultCacheManager().emptyCache();

    // Navigator.of(context).pop();
    widget.setStateParent();

    Navigator.of(context).pushNamed('DetalhesTransacao', arguments: {
      'transacao' : Transacao.factory(result.data!['realizarTransacao'])
    }).then((value) => widget.setStateParent());
  }

  @override
  void initState() {
    super.initState();

    getUsuarios().then((value){
      setState(() {
        if (value != null) {
          allUsers = value;
          filteredUsers = value;
          usuarioSelecionado = allUsers[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _chaveAdd,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            const Text(
              "Realizar Transação",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),

              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
                keyboardType: TextInputType.number,
                controller: _valorController,
                decoration: const InputDecoration(hintText: 'Valor da transação', labelText: 'Valor*'),
                validator: (String? value) {
                  if (_valorController.text.isEmpty || double.parse(_valorController.text) <= 0) {
                    return "Digite um valor positivo maior que 0";
                  }
                  return null;
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(hintText: 'Digite a descrição', labelText: 'Descricao'),
              ),
            ),
            const SizedBox(height: 10.0),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Data e Hora',
                  hintText: 'Digite Data da transação',
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  data = value;
                },
              ),
            ),

            const SizedBox(height: 15.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: pesquisaController,
                decoration: const InputDecoration(hintText: 'Nome do usuario', labelText: 'Pesquisar contato'),
                onEditingComplete: () {
                  getUsuarios().then((value){
                    if (value != null){
                      setState(() {
                        filteredUsers = value;
                        usuarioSelecionado = value[0];
                      });
                    }
                  });
                },
              ),
            ),

            const SizedBox(height: 16.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonFormField<Usuario>(
                value: usuarioSelecionado,
                onChanged: (Usuario? value) {
                  setState(() {
                    usuarioSelecionado = value;
                  });
                },

                items: filteredUsers.map((user) {
                  return DropdownMenuItem<Usuario>(
                    value: user,
                    child: Text(user.nome!),
                  );
                }).toList(),

                decoration: const InputDecoration(
                  labelText: 'Selecione um usuário',
                ),
                validator: (_){
                  if (usuarioSelecionado == null || usuarioSelecionado!.id == null || usuarioSelecionado!.id! <= 0){
                    return 'Este campo não pode ser vazio!';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(height: 15.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  if (_chaveAdd.currentState!.validate()){
                    enviar();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Enviar"),
              ),
            ),
          ],
        )
    );
  }
}