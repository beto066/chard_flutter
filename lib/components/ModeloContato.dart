import 'package:chard_flutter/models/Contato.dart';
import 'package:flutter/material.dart';

class ModeloContato extends StatefulWidget {
  final Contato contato;
  final Function setStateParent;

  ModeloContato({super.key, required this.contato, required this.setStateParent});

  @override
  State<StatefulWidget> createState() => ModeloContatoState();
}

class ModeloContatoState extends State<ModeloContato> {
  void carregaContato(){
    Navigator.of(context).pushNamed('DetalhesContato', arguments: {
      'contato': widget.contato
    }).then((value) => widget.setStateParent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: carregaContato,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                image: DecorationImage(
                  image: NetworkImage('https://www.kindpng.com/picc/m/207-2074624_white-gray-circle-avatar-png-transparent-png.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.contato.outroUsuario!.nome!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (
                          (widget.contato.saldo! < 0.0)? const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.red,
                          ):
                          const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.green,
                          )
                        ),

                        Text(
                          'R\$${widget.contato.saldo!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: (widget.contato.saldo! < 0.0)?Colors.red : Colors.green,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}