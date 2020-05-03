class DonoDoImovel {

  String _cpfUsuario;
  String _idLocatario;
  String _idDono;
  String _logadouroDonoDoImovel;
  String _complementoDonoDoImovel;
  String _tipoDonoDoImovel;
  String _valorDonoDoImovel;
  String _urlImagensDonoDoImovel;
  String _detalhesDonoDoImovel;
  String _dataInicio;
  String _dataFinal;
  String _nomeDoLocatario;
  String _emailDoLocatario;
  String _estadoDoImovel;
  String _urlImagemDoLocatario;
  String _idImovelAlugado;
  int _idEstadoImovel;
  String _nomeDaImagemImovel;
  String _telefoneUsuario;

  DonoDoImovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cpfUsuario" : this.cpfUsuario,
      "telefoneUsuario" : this.telefoneUsuario,
      "nomeDoLocatario" : this.nomeDoLocatario,
      "emailDoLocatario": this.emailDoLocatario,
      "urlImagemDoLocatario": this.urlImagemDoLocatario,
      "idLocatario" : this.idLocatario,
      "detalhesDonoDoImovel" :this.detalhesDonoDoImovel,
      "idDono" : this.idDono,
      "logadouroDonoDoImovel" : this.logadouroDonoDoImovel,
      "complementoDonoDoImovel" : this.complementoDonoDoImovel,
      "tipoDonoDoImovel" : this.tipoDonoDoImovel,
      "valorDonoDoImovel" : this.valorDonoDoImovel,
      "estadoDoImovel" : this.estadoDoImovel,
      "urlImagensDonoDoImovel" : this.urlImagensDonoDoImovel,
      "idImovelAlugado" : this.idImovelAlugado,
      "dataInicio" : this.dataInicio,
      "dataFinal" : this.dataFinal,
      "idEstadoImovel" : this.idEstadoImovel,
      "nomeDaImagemImovel" : this.nomeDaImagemImovel,
    };

    return map;

  }


  String get telefoneUsuario => _telefoneUsuario;

  set telefoneUsuario(String value) {
    _telefoneUsuario = value;
  }

  int get idEstadoImovel => _idEstadoImovel;

  set idEstadoImovel(int value) {
    _idEstadoImovel = value;
  }

  String get idImovelAlugado => _idImovelAlugado;

  set idImovelAlugado(String value) {
    _idImovelAlugado = value;
  }

  String get estadoDoImovel => _estadoDoImovel;

  set estadoDoImovel(String value) {
    _estadoDoImovel = value;
  }

  String get nomeDoLocatario => _nomeDoLocatario;

  set nomeDoLocatario(String value) {
    _nomeDoLocatario = value;
  }

  String get dataFinal => _dataFinal;

  set dataFinal(String value) {
    _dataFinal = value;
  }

  String get dataInicio => _dataInicio;

  set dataInicio(String value) {
    _dataInicio = value;
  }

  String get detalhesDonoDoImovel => _detalhesDonoDoImovel;

  set detalhesDonoDoImovel(String value) {
    _detalhesDonoDoImovel = value;
  }

  String get urlImagensDonoDoImovel => _urlImagensDonoDoImovel;

  set urlImagensDonoDoImovel(String value) {
    _urlImagensDonoDoImovel = value;
  }

  String get valorDonoDoImovel => _valorDonoDoImovel;

  set valorDonoDoImovel(String value) {
    _valorDonoDoImovel = value;
  }

  String get tipoDonoDoImovel => _tipoDonoDoImovel;

  set tipoDonoDoImovel(String value) {
    _tipoDonoDoImovel = value;
  }

  String get complementoDonoDoImovel => _complementoDonoDoImovel;

  set complementoDonoDoImovel(String value) {
    _complementoDonoDoImovel = value;
  }

  String get logadouroDonoDoImovel => _logadouroDonoDoImovel;

  set logadouroDonoDoImovel(String value) {
    _logadouroDonoDoImovel = value;
  }

  String get idDono => _idDono;

  set idDono(String value) {
    _idDono = value;
  }

  String get idLocatario => _idLocatario;

  set idLocatario(String value) {
    _idLocatario = value;
  }

  String get cpfUsuario => _cpfUsuario;

  set cpfUsuario(String value) {
    _cpfUsuario = value;
  }

  String get emailDoLocatario => _emailDoLocatario;

  set emailDoLocatario(String value) {
    _emailDoLocatario = value;
  }

  String get urlImagemDoLocatario => _urlImagemDoLocatario;

  set urlImagemDoLocatario(String value) {
    _urlImagemDoLocatario = value;
  }

  String get nomeDaImagemImovel => _nomeDaImagemImovel;

  set nomeDaImagemImovel(String value) {
    _nomeDaImagemImovel = value;
  }


}