import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/models/Transacao.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class StatefulTransacao extends StatefulWidget {
  final Transacao transacao;

  const StatefulTransacao({super.key, required this.transacao});

  @override
  State<StatefulWidget> createState() => TransacaoState();
}

class TransacaoState extends State<StatefulTransacao> {
  Widget builderTransacao(QueryResult result){
    if (result.isLoading) {
      return const CircularProgressIndicator();
    }

    if (result.data == null) {
      return const Text('deu merda');
    }

    var transacao = Transacao.factory(result.data!['findTransacao']);

    return ListView(
      children: [
        const SizedBox(height: 20.0),
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 100.0,
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "${transacao.remetente!.nome} enviou R\$ ${transacao.valor!.toStringAsFixed(2)} para ${transacao.destinatario!.nome}",
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 14.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Row(
            children: [
              Text(
                'Remetente: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
              ),
              Icon(
                Icons.person,
                size: 17.0,
              )
            ],
          ),
        ),

        const SizedBox(height: 6.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(transacao.remetente!.nome!)
        ),

        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Row(
            children: [
              Text(
                'Destinatário: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
              ),
              Icon(
                Icons.person_3,
                size: 17.0,
              )
            ],
          ),
        ),

        const SizedBox(height: 6.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(transacao.destinatario!.nome!)
        ),

        const SizedBox(height: 8.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Row(
            children: [
              Text(
                'Valor da transação: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.attach_money,
                size: 17.0,
              )
            ],
          ),
        ),
        const SizedBox(height: 7.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            'R\$ ${transacao.valor!.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Row(
            children: [
              Text(
                'Data da transação: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.calendar_month,
                size: 17.0,
              )
            ],
          ),
        ),
        const SizedBox(height: 7.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            children: [
              Text(
                  DateFormat('dd/MM/yyyy').format(widget.transacao.data!),
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                " ás ${transacao.data!.hour.toString().padLeft(2, '0')}:${transacao.data!.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: const Row(
            children: [
              Text(
                'Descrição da transação: ',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.description,
                size: 17.0,
              )
            ],
          ),
        ),
        const SizedBox(height: 7.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            transacao.descricao!,
            style: const TextStyle(fontSize: 14.0),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var query = r'''
      query Query($idTransacao: Int) {
        findTransacao(idTransacao: $idTransacao) {
          confirmado
          data
          descricao
          destinatario {
            nome
            id
          }
          id
          remetente {
            id
            nome
          }
          valor
        }
      }
    ''';

    return Modelo(
      title: 'Transação',
      setStateParent: (){
        setState(() {

        });
      },
      child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: { 'idTransacao' : widget.transacao.id },
          fetchPolicy: FetchPolicy.noCache
        ),
        builder: (result, {fetchMore, refetch}){
          return builderTransacao(result);
        },
      )
    );
  }
}