class Imovel {

  String _logadouro;
  String _complemento;
  String _tipoImovel;
  String _cidade;
  String _estado;
  String _bairro;
  String _detalhes;
  String _idUsuario;
  String _urlImagens;
  String _valor;

  Imovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "estado" : this.estado,
      "logadouro" : this.logadouro,
      "complemento" : this.complemento,
      "tipoImovel" : this.tipoImovel,
      "valor" : this.valor,
      "idUsuario" : this._idUsuario,
      "urlImagens" : this.urlImagens,
      'detalhes' : this.detalhes,
    };

    return map;

  }


  String get detalhes => _detalhes;

  set detalhes(String value) {
    _detalhes = value;
  }

  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get urlImagens => _urlImagens;

  set urlImagens(String value) {
    _urlImagens = value;
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


}