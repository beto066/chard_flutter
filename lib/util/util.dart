import 'package:chard_flutter/models/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Persist{
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("tokenUsuario");
  }

  static Future<Map<String, dynamic>?> getUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenUsuario');

    if (token != null){
      return JwtDecoder.decode(token);
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

    if (token == null){
      return false;
    }

    Map<String, dynamic> user = JwtDecoder.decode(token);

    if (user.isEmpty){
      return false;
    }

    return true;
  }
}

class ClientUtil {
  static ValueNotifier<GraphQLClient>? _client;

  static ValueNotifier<GraphQLClient> getGraphqlClient(){
    if (_client == null) {
      final HttpLink httpLink = HttpLink('http://192.168.63.105:4000/');

      _client = ValueNotifier(
        GraphQLClient(
          link: httpLink,
          cache: GraphQLCache(),
        ),
      );
    }

    return _client!;
  }
}



