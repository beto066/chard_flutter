import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';

class StatefulHome extends StatefulWidget {
  const StatefulHome({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<StatefulHome> {
  Future<void> verificaLogado() async {
    var statusLogado = await Persist.hasToken();

    print(statusLogado);

    if (!statusLogado){
      Navigator.of(context).popUntil(ModalRoute.withName('Login'));
    }
  }

  @override
  void initState() {
    super.initState();
    verificaLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Modelo(
      child: const Center(child: Text('Você está logado')),
      setStateParent: () {
        setState(() {
        });
      },
    );
  }
}