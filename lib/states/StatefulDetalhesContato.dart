import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/components/ModeloTransacao.dart';
import 'package:chard_flutter/models/Contato.dart';
import 'package:chard_flutter/models/Transacao.dart';
import 'package:chard_flutter/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StatefulDetalhesContato extends StatefulWidget{
  final Contato contato;

  const StatefulDetalhesContato({super.key, required this.contato});

  @override
  State<StatefulWidget> createState() => DetalhesContatoState();
}

class DetalhesContatoState extends State<StatefulDetalhesContato> {
  Widget builderTransacoes(QueryResult<Object?> result){
    if (result.isLoading) {
      return const CircularProgressIndicator();
    }

    if (result.data == null) {
      return const Text('deu merda');
    }

    return ListView.builder(
      itemCount: result.data!['transacoesComUsuario'].length + 1,
      itemBuilder: (context, index){
        if (index == 0){
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                const CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, color: Colors.grey, size:100.0),
                ),
                Text(
                  widget.contato.outroUsuario!.nome!,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8.0),
                Text(
                  widget.contato.outroUsuario!.email!,
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          );
        }

        var transacao = result.data!['transacoesComUsuario'][index - 1];
        return ModeloTransacao(
          transacao: Transacao.factory(transacao),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var query = r'''
      query Query($idUsuario : Int) {
        transacoesComUsuario(idUsuario: $idUsuario) {
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
      title: widget.contato.outroUsuario!.nome!,
      child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: { 'idUsuario' : widget.contato.outroUsuario!.id},
          fetchPolicy: FetchPolicy.noCache
        ),
        builder: (result, {fetchMore, refetch}){
          return builderTransacoes(result);
        }
      )
    );
  }
}