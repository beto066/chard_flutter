import 'package:chard_flutter/states/StatefulContatos.dart';
import 'package:chard_flutter/states/StatefulDetalhesContato.dart';
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

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ClientUtil.getGraphqlClient(),
      child: MaterialApp(
        title: 'Chard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'Login',
        routes: {
          'HomePage' : (_) => const StatefulHome(),
          'Login' : (_) => const StatefulLogin(),
          'Contatos' : (_) => const StatefulContatos(),

          'DetalhesContato' : (context) {
            var parametry = ModalRoute.of(context)!.settings.arguments as Map;
            return StatefulDetalhesContato(contato : parametry['contato']);
          }
        },
      ),
    );
  }
}