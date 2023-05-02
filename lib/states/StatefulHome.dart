import 'package:chard_flutter/components/Modelo.dart';
import 'package:flutter/material.dart';

class StatefulHome extends StatefulWidget {
  const StatefulHome({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<StatefulHome> {
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