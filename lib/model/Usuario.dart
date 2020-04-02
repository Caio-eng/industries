
class Usuario {

  String _nome;
  String _cpf;
  String _rg;
  DateTime _dataEmissao;
  DateTime _dataNasc;
  int _telefone;
  String _email;
  String _senha;
  bool _estadoCivil;
  bool _contaCartao;
  String _photo;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "photo" : this.photo,
    };

    return map;

  }

  bool get contaCartao => _contaCartao;

  set contaCartao(bool value) {
    _contaCartao = value;
  }

  bool get estadoCivil => _estadoCivil;

  set estadoCivil(bool value) {
    _estadoCivil = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  int get telefone => _telefone;

  set telefone(int value) {
    _telefone = value;
  }

  DateTime get dataNasc => _dataNasc;

  set dataNasc(DateTime value) {
    _dataNasc = value;
  }

  DateTime get dataEmissao => _dataEmissao;

  set dataEmissao(DateTime value) {
    _dataEmissao = value;
  }

  String get rg => _rg;

  set rg(String value) {
    _rg = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }


}