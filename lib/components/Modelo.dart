import 'package:chard_flutter/components/ModalNotificacoes.dart';
import 'package:chard_flutter/models/Usuario.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';
import 'package:chard_flutter/models/Notificacao.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Modelo extends StatefulWidget {
  final String title;
  final Widget child;
  final Function setStateParent;
  Widget? floatingActionButton;
  List<Widget>? footerButtons;

  Modelo({super.key, this.title = "CHARD", required this.child, required this.setStateParent, this.floatingActionButton, this.footerButtons});

  @override
  State<StatefulWidget> createState() => ModeloState();
}

class ModeloState extends State<Modelo> {
  List<Notficacao> notificacoes = [];
  List<Notficacao> novasNotificacoes = [];
  bool haveExceptionNotificacao = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget drawerBuilder(BuildContext context, AsyncSnapshot<Usuario?> snapshot){
    if (snapshot.connectionState == ConnectionState.waiting){
      return const CircularProgressIndicator();
    }

    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData){
        return ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(snapshot.data!.nome!, textAlign: TextAlign.center),
              accountEmail: Text(snapshot.data!.email!, textAlign: TextAlign.center),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.grey),
              ),
            ),

            ListTile(
              title: const Text('Principal'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil('HomePage', (Route<dynamic> route) => route.isFirst).then((value) => widget.setStateParent());
              },
            ),

            ListTile(
              title: const Text('Contatos'),
              leading: const Icon(Icons.contacts),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil('Contatos', (Route<dynamic> route) => route.isFirst).then((value) => widget.setStateParent());
              },
            ),
            
            ListTile(
              title: const Text('Ultimas transações'),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil('UltimasTransacoes', (Route<dynamic> route) => route.isFirst).then((value) => widget.setStateParent());
              },
            ),

            ListTile(
              title: const Text('Notificacoes'),
              leading: const Icon(Icons.notifications),
              onTap: (){
                scaffoldKey.currentState?.closeDrawer();
                showModalNotificacao();
              },
            ),

            ListTile(
              title: const Text('Desconectar'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Persist.removeUsuarioLogado();
                Navigator.of(context).pushNamedAndRemoveUntil('Login', (Route<dynamic> route) => false);
              },
            )
          ],
        );
      }

      if (snapshot.hasError) {
        return const Text("Erro ao carregar o usuario");
      }
      return const Text("data");
    }
    return const Text("data");
  }  
  
  Future<void> verificaLogado() async {
    var statusLogado = await Persist.hasToken();
    if (!statusLogado){
      Navigator.of(context).pushNamed('Login');
    }
  }

  Future<List<Notficacao>> getNotificacoes() async {
    var query = r'''
      query Query {
        notificacoesUsuario {
          contato {
            id
          }
          data
          descricao
          emissor {
            nome
            id
          }
          id
          titulo
          transacao {
            id
          }
          visualizado
        }
      }
    ''';

    final client = ClientUtil.getGraphqlClient();
    var result = await client.value.query(QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache
    ));

    List<Notficacao> list = [];

    if (result.hasException){
      print(result.exception);
      haveExceptionNotificacao = true;
      setState(() {

      });
      return list;
    }

    if (result.data == null) {
      haveExceptionNotificacao = true;
      setState(() {

      });
      return list;
    }

    // print(result.data!['notificacoesUsuario']);

    for (Map<String, dynamic> notificacaoMap in result.data!['notificacoesUsuario']){
      var notificacao = Notficacao.factory(notificacaoMap);
      list.add(notificacao);
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    verificaLogado().then((value){
      getNotificacoes().then((value){
        setState(() {
          notificacoes = value;
        });
      });
    });
  }

  void showModalNotificacao() async {
    setState(() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          return ModalNotificacoes(notificacoes: notificacoes, setStateParent: () => setState(() {}),);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Persist.getUsuarioLogado();

    scaffoldKey.currentState?.closeDrawer();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){
              showModalNotificacao();
            },
            icon: const Icon(Icons.notifications)
          )
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: FutureBuilder<Usuario?>(
          future: user,
          builder: drawerBuilder
        ),
      ),

      body: Center(
        child: widget.child
      ),
      floatingActionButton: widget.floatingActionButton,
      persistentFooterButtons: widget.footerButtons,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}