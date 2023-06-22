import 'package:chard_flutter/models/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Persist {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("tokenUsuario");
  }

  static Future<Usuario?> getUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenUsuario');

    if (token != null){
      var userMap = JwtDecoder.decode(token);

      if(userMap.isNotEmpty){
        return Usuario.factory(userMap);
      }
    }

    return null;
  }

  static void setUsuarioLogado(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("tokenUsuario", token);
  }

  static void removeUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenUsuario');
  }

  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("tokenUsuario");

    if (token == null || token == ''){
      return false;
    }

    Map<String, dynamic> user = JwtDecoder.decode(token);

    if (user.isEmpty){
      return false;
    }

    return true;
  }
}

abstract class ClientUtil {
  static ValueNotifier<GraphQLClient>? _client;

  static ValueNotifier<GraphQLClient> getGraphqlClient() {
    if (_client == null) {
      // final HttpLink httpLink = HttpLink('http://192.168.63.106:4000/graphql'); // Casa 5G
      // final HttpLink httpLink = HttpLink('http://192.168.63.105:4000/graphql'); // Casa
      final HttpLink httpLink = HttpLink('http://172.16.106.45:4000/graphql'); // Facul
      // final HttpLink httpLink = HttpLink('http://192.168.10.119:4000/graphql'); // Trabalho

      // const wsLink = 'ws://192.168.63.106:4000/graphql'; // Casa 5G
      // const wsLink = 'ws://192.168.63.105:4000/graphql'; // Casa
      const wsLink = 'ws://172.16.106.45:4000/graphql'; // Facul
      // const wsLink = 'ws://192.168.10.119:4000/graphql'; // Trabalho

      WebSocketLink websocketLink = WebSocketLink(
        wsLink,
        config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: const Duration(hours: 1),
          delayBetweenReconnectionAttempts: const Duration(seconds: 1),
          initialPayload: () async {
            var token = await Persist.getToken();
            return {
              'Authorization': 'Bearer $token'
            };
          },
        ),
      );

      final AuthLink authLink = AuthLink(
        getToken:  () async {
          var token = await Persist.getToken();
          return 'Bearer $token';
        }
      );

      final Link link = Link.split(
        (request) => request.isSubscription,
        websocketLink,
        httpLink,
      );

      final Link linkWithAuth = authLink.concat(link);

      _client = ValueNotifier(
        GraphQLClient(
          link: linkWithAuth,
          cache: GraphQLCache(),
        ),
      );
    }

    return _client!;
  }
}



