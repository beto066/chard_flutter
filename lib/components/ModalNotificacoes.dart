import 'package:chard_flutter/models/Contato.dart';
import 'package:chard_flutter/models/Notificacao.dart';
import 'package:chard_flutter/models/Transacao.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class ModalNotificacoes extends StatefulWidget {
  List<Notficacao> notificacoes;
  Function setStateParent;
  ModalNotificacoes({super.key, required this.notificacoes, required this.setStateParent});

  @override
  State<StatefulWidget> createState() => ModalNotificacoesState();
}

class ModalNotificacoesState extends State<ModalNotificacoes> {
  var exception = '';
  void confirmNotificacao(Notficacao notficacao) async {
    String confirmMutation = r'''
      mutation Mutation($idContato: Int) {
        confirmarContato( idContato : $idContato ) {
          id
        }
      }
    ''';
    if (notficacao.transacao != null){
      confirmMutation = r'''
        mutation Mutation($idTransacao: Int) {
          confirmarTransacao( idTransacao : $idTransacao ) {
            id
          }
        }
      ''';
    }

    final client = ClientUtil.getGraphqlClient();

    var result = await client.value.mutate(
      MutationOptions(
        document: gql(confirmMutation),
        variables: { 'idContato' : notficacao.contato?.id, 'idTransacao' : notficacao.transacao?.id },
        fetchPolicy: FetchPolicy.noCache
      )
    );

    if (result.hasException) {
      exception = 'Ocorreu um erro ao confirmar';
      return;
    }

    if (
      result.data == null ||
      (result.data!['id'] != notficacao.contato?.id ||
      result.data!['id'] != notficacao.transacao?.id)
    ) {
      exception = 'Ocorreu um erro ao confirmar';
      return;
    }
  }

  void visualizar(Notficacao notficacao) async {
    const visualizaQuery = r'''
      query Query($id: Int) {
        visualizarNotificacao( id : $id ) {
          transacao {
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
          contato {
            id
            outroUsuario {
              id
              nome
              email
            }
            saldoComUsuario
          }
        }
      }
    ''';

    final client = ClientUtil.getGraphqlClient();

    var result = await client.value.query(
      QueryOptions(
        document: gql(visualizaQuery),
        variables: { 'id' : notficacao.id },
        fetchPolicy: FetchPolicy.noCache
      )
    );

    if (result.hasException) {
      print(result.exception);
      exception = 'Ocorreu um erro ao confirmar';
      return;
    }

    if (result.data == null) {
      exception = 'Ocorreu um erro ao confirmar';
      return;
    }

    print(result.data);

    if (result.data!['visualizarNotificacao']['transacao'] != null && result.data!['visualizarNotificacao']['transacao']['id'] != null){
      Navigator.of(context).pushNamed('DetalhesTransacao', arguments: {
        'transacao' : Transacao.factory(result.data!['visualizarNotificacao']['transacao'])
      }).then((value) => widget.setStateParent());
    }

    if (result.data!['visualizarNotificacao']['contato'] != null && result.data!['visualizarNotificacao']['contato']['id']  != null){
      Navigator.of(context).pushNamed('DetalhesContato', arguments: {
        'contato': Contato.factory(result.data!['visualizarNotificacao']['contato'])
      }).then((value) => widget.setStateParent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.lightBackgroundGray,
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemCount: widget.notificacoes.length + 1,
        itemBuilder: (context, index){
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: const Text(
                'Notificações',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              ),
            );
          }

          var notificacao = widget.notificacoes[index - 1];

          return GestureDetector(
            onTap: () {
              visualizar(notificacao);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: ListTile(
                  title: Text(notificacao.titulo, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  subtitle: SizedBox(
                    height: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(notificacao.data)),
                        Text(notificacao.descricao ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],
                    )
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => confirmNotificacao(notificacao),
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}