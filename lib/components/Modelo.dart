import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';

class Modelo extends StatefulWidget {
  final String title;
  final Widget child;
  final Function setStateParent;
  Widget? floatingActionButton;

  Modelo({super.key, this.title = "CHARD", required this.child, required this.setStateParent, this.floatingActionButton});

  @override
  State<StatefulWidget> createState() => ModeloState();
}

class ModeloState extends State<Modelo> {
  Widget drawerBuilder(BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot){
    if (snapshot.connectionState == ConnectionState.waiting){
      return const CircularProgressIndicator();
    }

    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData){
        return ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(snapshot.data!['nome'], textAlign: TextAlign.center),
              accountEmail: Text(snapshot.data!["email"], textAlign: TextAlign.center),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.grey),
              ),
            ),

            ListTile(
              title: const Text('Principal'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pushNamed('HomePage').then((value) => widget.setStateParent());
              },
            ),

            ListTile(
              title: const Text('Contatos'),
              leading: const Icon(Icons.contacts),
              onTap: () {
                Navigator.of(context).pushNamed('Contatos').then((value) => widget.setStateParent());
              },
            ),
            
            ListTile(
              title: const Text('Ultimas transações'),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.of(context).pushNamed('UltimasTransacoes').then((value) => widget.setStateParent());
              },
            ),

            ListTile(
              title: const Text('Notificacoes'),
              leading: const Icon(Icons.notifications),
              onTap: (){
                // Adcionar dps
              },
            ),

            ListTile(
              title: const Text('Desconectar'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Persist.removeUsuarioLogado();
                Navigator.of(context).pushNamed('Login').then((value) => widget.setStateParent());
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

  @override
  Widget build(BuildContext context) {
    var user = Persist.getUsuarioLogado();

    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    scaffoldKey.currentState?.closeDrawer();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: user,
          builder: drawerBuilder
        ),
      ),
      body: Center(
        child: widget.child
      ),
      floatingActionButton: widget.floatingActionButton
    );
  }
}