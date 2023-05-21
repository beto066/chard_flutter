import 'package:chard_flutter/components/FormularioPesquisaTransacao.dart';
import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/components/ModeloTransacao.dart';
import 'package:chard_flutter/models/Transacao.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StatefulTransacoes extends StatefulWidget {
  const StatefulTransacoes({super.key});

  @override
  State<StatefulWidget> createState() => TransacoesState();
}

class TransacoesState extends State {
  final GlobalKey<FormState> _chaveAdd = GlobalKey<FormState>();

  final TextEditingController _quantController = TextEditingController();
  final TextEditingController _pesquisaController = TextEditingController();

  Widget builderTransacoes(QueryResult<Object?> result){
    if (result.isLoading) {
      return const CircularProgressIndicator();
    }

    if (result.hasException){
      print(result.exception);
      return const Text('deu merda');
    }

    if (result.data == null) {
      return const Text('deu merda');
    }

    return ListView.builder(
        itemCount: result.data!['transacoesUsuario'].length,
        itemBuilder: (context, index){
          var transacao = result.data!['transacoesUsuario'][index];
          return ModeloTransacao(
            transacao: Transacao.factory(transacao),
          );
        }
    );
  }

  Widget modalPesquisa(BuildContext context) {
    return FormularioPesquisaTransacao(
      quantController: quantController,
      pesquisaController: _pesquisaController,
      pesquisar: (){
        setState(() {

        });
      }
    );
  }

  Widget modalAdd(BuildContext context) {
    return Text('Modal Add');
  }

  @override
  Widget build(BuildContext context) {
    var query = r'''
      query Query($quant : Int!, $pesquisa : String) {
        transacoesUsuario(quant: $quant, pesquisa : $pesquisa) {
          confirmado
          data
          descricao
          id
          valor
          remetente {
            id
            nome
          }
          destinatario {
            id
            nome
          }
        }
      }
    ''';

    return Modelo(
      setStateParent: (){
        setState(() {

        });
      },
      title: 'Transações',
      footerButtons: [
        IconButton(
          onPressed: (){ showModalBottomSheet(context: context, builder: modalPesquisa); },
          icon: const Icon(Icons.search),
          tooltip: 'Pesquisar'
        ),
        IconButton(
          onPressed: (){ showModalBottomSheet(context: context, builder: modalAdd); },
          icon: const Icon(Icons.add),
          tooltip: 'Adcionar Transação'
        )
      ],
      child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: { 'quant' : int.parse(quantController.text), 'pesquisa' : _pesquisaController.text },
          fetchPolicy: FetchPolicy.noCache
        ),
        builder: (result, {fetchMore, refetch}){
          return builderTransacoes(result);
        }
      )
    );
  }

  TextEditingController get quantController {
    if(_quantController.text.isEmpty){
      _quantController.text = '10';
    }

    return _quantController;
  }
}