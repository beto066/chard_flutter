class Usuario {
  late final int? _id;
  late final String? _nome;
  late final String? _email;
  late final String? _perfil;

  Usuario(this._id, this._nome, this._email, this._perfil);

  Usuario.factory(Map<String, dynamic> user){
    _id = user['id'];
    _nome = user['nome'];
    _email = user['email'];
    _perfil = user['perfil'];
  }

  @override
  String toString() {
    return 'Usuario{_id: $_id, _nome: $_nome, _email: $_email, _perfil: $_perfil}';
  }

  String? get perfil => _perfil;

  set perfil(String? value) {
    _perfil = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get nome => _nome;

  set nome(String? value) {
    _nome = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }
}