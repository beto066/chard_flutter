import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StatefulLogin extends StatefulWidget {
  const StatefulLogin({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<StatefulLogin> {
  final GlobalKey<FormState> _chave = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String? exception;

  void logar() async {
    const String loginMutation = r'''
      mutation Mutation($userName: String, $senha: String) {
        logar( userName : $userName, senha : $senha )
      }
    ''';

    final client = ClientUtil.getGraphqlClient();

    var result = await client.value.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: { 'userName' : _email.text, 'senha' : _senha.text }
      )
    );

    if (result.hasException) {
      exception = 'Ocorreu um erro ao realizar o login';
      return;
    }

    var token = await result.data!['logar'];

    if (token == null) {
      exception = 'Usuario/Senha incorreto';
      return;
    }

    Persist.setUsuarioLogado(token);

    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    Navigator.of(context).popAndPushNamed('HomePage');
  }

  Future<void> verificaLogado() async {
    var statusLogado = await Persist.hasToken();

    if (statusLogado){
      Navigator.of(context).pushNamedAndRemoveUntil('HomePage', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    verificaLogado();
    // Navigator.of(context)
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _chave,
          child : Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40.0),
                const CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, color: Colors.grey, size:100.0),
                ),

                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      hintText: 'Entre com o seu node de usuário'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nome de usuário não pode ser vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _senha,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Entre com a sua senha'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Digita ai na moral";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10.0),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cadastrar',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.blueAccent,
                      ),
                    ),
                    Text(
                      ' ou ',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'recuperar senha',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    onPressed: logar,
                    child: const Text("Logar"),
                  ),
                ),
                const SizedBox(height: 100.0),
              ]
            )
          ),
        ),
      ),
    );
  }

}