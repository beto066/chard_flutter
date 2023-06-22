import 'package:chard_flutter/models/Usuario.dart';

class Contato {
  int? _id;
  Usuario? _outroUsuario;
  double? _saldo;

  Contato(this._id, this._outroUsuario, this._saldo);

  Contato.factory(Map<String, dynamic> contato){
    _id = contato['id'];
    if (contato['outroUsuario'] != null) {
      _outroUsuario = Usuario.factory(contato['outroUsuario']);
    }
    if (contato['saldoComUsuario'] != null) {
      _saldo = 0.0 + contato['saldoComUsuario'];
    }
  }

  @override
  String toString() {
    return 'Contato{_id: $_id, _outroUsuario: $_outroUsuario, _saldo: $_saldo}';
  }

  double? get saldo => _saldo;

  set saldo(double? value) {
    _saldo = value;
  }

  Usuario? get outroUsuario => _outroUsuario;

  set outroUsuario(Usuario? value) {
    _outroUsuario = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }
}