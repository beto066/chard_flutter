import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/components/ModeloContato.dart';
import 'package:chard_flutter/models/Contato.dart';
import 'package:chard_flutter/models/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StatefulContatos extends StatefulWidget {
  const StatefulContatos({super.key});

  @override
  State<StatefulWidget> createState() => ContatoState();
}

class ContatoState extends State<StatefulContatos> {
  Widget builderContatos(QueryResult<Object?> result){
    if (result.isLoading) {
      return const CircularProgressIndicator();
    }
    if (result.data == null) {
      return const Text('deu merda');
    }
    
    return ListView.builder(
      itemCount: result.data!['contatosUsuario'].length,
      itemBuilder: (context, index){
        var contato = result.data!['contatosUsuario'][index];
        return ModeloContato(
          setStateParent: (){
            setState(() {

            });
          },
          contato: Contato(
            contato['id'],
            Usuario(
              contato['outroUsuario']['id'],
              contato['outroUsuario']['nome'],
              contato['outroUsuario']['email'],
              null
            ),
            contato['saldoComUsuario'] + 0.0
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var query = '''
      query ContatosUsuario {
        contatosUsuario {
          id
          outroUsuario {
            id
            nome
            email
          }
          saldoComUsuario
        }
      }
    ''';

    return Modelo(
      child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: const <String, dynamic>{},
          fetchPolicy: FetchPolicy.noCache
        ),
        builder: (result, {fetchMore, refetch}) {
          return builderContatos(result);
        }
      ),
      setStateParent: (){
        setState(() {

        });
      }
    );
  }
}