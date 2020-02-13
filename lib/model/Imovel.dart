class Imovel {

  String _logadouro;
  String _complemento;
  String _tipoImovel;
  String _cidade;
  String _estado;
  String _bairro;
  String _idUser;

  Imovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "logadouro" : this.logadouro,
      "complemento" : this.complemento,
      "tipoImovel" : this.tipoImovel,
      "idUser" : this.idUser
    };

    return map;

  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get tipoImovel => _tipoImovel;

  set tipoImovel(String value) {
    _tipoImovel = value;
  }

  String get complemento => _complemento;

  set complemento(String value) {
    _complemento = value;
  }

  String get logadouro => _logadouro;

  set logadouro(String value) {
    _logadouro = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }


}