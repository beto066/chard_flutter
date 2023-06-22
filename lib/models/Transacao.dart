import 'package:chard_flutter/models/Usuario.dart';

class Transacao {
  late int? _id;
  late String? _descricao;
  late double? _valor;
  late DateTime? _data;
  Usuario? _remetente;
  Usuario? _destinatario;
  bool? _confirmado;

  Transacao(this._id, this._descricao, this._valor, this._data, this._confirmado, this._remetente, this._destinatario);

  Transacao.factory(Map<String, dynamic> transacao){
    id = transacao['id'];
    descricao = transacao['descricao'];
    confirmado = transacao['confirmado'];

    if (transacao['data'] != null) {
      data = DateTime.parse(((transacao['data']) as String).replaceFirst('T', ' '));
    }

    if (transacao['valor'] != null) {
      valor = 0.0 + transacao['valor'];
    }

    if (transacao['remetente'] != null){
      remetente = Usuario.factory(transacao['remetente']);
    }

    if (transacao['destinatario'] != null){
      destinatario = Usuario.factory(transacao['destinatario']);
    }
  }

  @override
  String toString() {
    return 'Transacao{_id: $_id, _descricao: $_descricao, _valor: $_valor, _data: $_data, _emissor: $_remetente, _receptor: $_destinatario, _confirmado: $_confirmado}';
  }

  Usuario? get remetente => _remetente;

  set remetente(Usuario? value) {
    _remetente = value;
  }

  bool? get confirmado => _confirmado;

  set confirmado(bool? value) {
    _confirmado = value;
  }

  DateTime? get data => _data;

  set data(DateTime? value) {
    _data = value;
  }

  double? get valor => _valor;

  set valor(double? value) {
    _valor = value;
  }

  String? get descricao => _descricao;

  set descricao(String? value) {
    _descricao = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  Usuario? get destinatario => _destinatario;

  set destinatario(Usuario? value) {
    _destinatario = value;
  }
}