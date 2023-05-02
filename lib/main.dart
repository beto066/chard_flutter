import 'package:chard_flutter/states/StatefulHome.dart';
import 'package:chard_flutter/states/StatefulLogin.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  static bool estaLogado = false;

  @override
  void initState() {
    super.initState();
    verificaLogado();
  }

  Future<void> verificaLogado() async {
    var statusLogado = await Persist.hasToken();
    setState(() {
      estaLogado = statusLogado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ClientUtil.getGraphqlClient(),
      child: MaterialApp(
        title: 'Chard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: ((estaLogado)? 'HomePage' : 'Login'),
        routes: {
          'HomePage' : (_) => const StatefulHome(),
          'Login' : (_) => StatefulLogin()
        },
      ),
    );
  }
}