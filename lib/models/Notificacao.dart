import 'package:chard_flutter/models/Contato.dart';
import 'package:chard_flutter/models/Transacao.dart';
import 'package:chard_flutter/models/Usuario.dart';

class Notficacao {
  late int _id;
  late String _titulo;
  late bool _visualizado;
  late DateTime _data;
  String? _descricao;
  Usuario? _emissor;
  Transacao? _transacao;
  Contato? _contato;

  Notficacao(this._id, this._titulo, this._visualizado, this._data,
      this._descricao, this._emissor, this._transacao, this._contato);
  
  Notficacao.factory(Map<String, dynamic> notificacao){
    id = notificacao['id'];
    titulo = notificacao['titulo'];
    visualizado = notificacao['visualizado'];
    data = DateTime.parse(((notificacao['data']) as String).replaceFirst('T', ' '));
    descricao = notificacao['descricao'];
    
    if (notificacao['emissor'] != null){
      emissor = Usuario.factory(notificacao['emissor']);
    }

    if (notificacao['transacao'] != null) {
      transacao = Transacao.factory(notificacao['transacao']);

    } else if (notificacao['contato'] != null){
      contato = Contato.factory(notificacao['contato']);
    }
  }

  Contato? get contato => _contato;

  set contato(Contato? value) {
    _contato = value;
  }

  Transacao? get transacao => _transacao;

  set transacao(Transacao? value) {
    _transacao = value;
  }

  Usuario? get emissor => _emissor;

  set emissor(Usuario? value) {
    _emissor = value;
  }

  String? get descricao => _descricao;

  set descricao(String? value) {
    _descricao = value;
  }

  DateTime get data => _data;

  set data(DateTime value) {
    _data = value;
  }

  bool get visualizado => _visualizado;

  set visualizado(bool value) {
    _visualizado = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}