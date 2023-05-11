import 'package:chard_flutter/models/Transacao.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModeloTransacao extends StatefulWidget {
  final Transacao transacao;

  const ModeloTransacao({super.key, required this.transacao});

  @override
  State<StatefulWidget> createState() => ModeloTransacaoState();
}

class ModeloTransacaoState extends State<ModeloTransacao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: 120,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(widget.transacao.data),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(
                      "${widget.transacao.data.hour.toString().padLeft(2, '0')}:${widget.transacao.data.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey
                      )
                  ),
                ],
              ),

              Row(
                children: [
                  const Text('Remetente : ', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.transacao.remetente!.nome!)
                ],
              ),

              Row(
                children: [
                  const Text('Destinatario : ', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.transacao.destinatario!.nome!)
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(
                    builder: (context) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.59,
                        margin: const EdgeInsets.only(right: 4),
                        child: Text(
                          widget.transacao.descricao,
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      );
                    }
                  ),
                  const SizedBox(width: 0.5),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.253,
                    alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (context) {
                        String message = '';

                        if (widget.transacao.valor < 1000){
                          message = 'R\$${widget.transacao.valor.toStringAsFixed(2)}';
                        } else if (widget.transacao.valor < 10000){
                          message = 'R\$${widget.transacao.valor.toStringAsFixed(0)}';
                        } else {
                          message = 'R\$${(widget.transacao.valor / 1000).toStringAsFixed(0)}K';
                        }

                        return Text(
                          message,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.right,
                        );
                      }
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}