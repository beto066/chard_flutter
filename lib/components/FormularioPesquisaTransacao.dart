import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormularioPesquisaTransacao extends StatefulWidget {
  final TextEditingController pesquisaController;
  final TextEditingController quantController;
  final Function pesquisar;

  const FormularioPesquisaTransacao({super.key, required this.quantController, required this.pesquisaController, required this.pesquisar});

  @override
  State<StatefulWidget> createState() => PesquisaTransacaoState();
}

class PesquisaTransacaoState extends State<FormularioPesquisaTransacao> {
  final GlobalKey<FormState> _chavePesquisa = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _chavePesquisa,
      child: ListView(
        children: [
          const SizedBox(height: 20.0),
          const Text(
            "Pesquisar Transação",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: widget.pesquisaController,
              decoration: const InputDecoration(hintText: 'Pesquisar por nome ou descrição', labelText: 'Pesquisa'),
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ],
              keyboardType: TextInputType.number,
              controller: widget.quantController,
              decoration: const InputDecoration(hintText: 'Transações retornadas', labelText: 'Quantidade de itens'),
              validator: (String? value) {
                if (int.parse(widget.quantController.text) <= 0) {
                  return "Digite um valor positivo maior que 0";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40),
            child: ElevatedButton(
              onPressed: () {
                if (_chavePesquisa.currentState!.validate()){
                  widget.pesquisar();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Pesquisar"),
            ),
          ),
        ],
      )
    );
  }
}