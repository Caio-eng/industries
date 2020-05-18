class DonoDoImovel {

  String _cpfUsuario;
  String _idLocatario;
  String _idDono;
  String _logadouroDonoDoImovel;
  String _complementoDonoDoImovel;
  String _tipoDonoDoImovel;
  String _valorDonoDoImovel;
  String _urlImagensDonoDoImovel, _urlImagensDonoDoImovel2, _urlImagensDonoDoImovel3, _urlImagensDonoDoImovel4, _urlImagensDonoDoImovel5;
  String _detalhesDonoDoImovel;
  String _dataInicio;
  String _dataFinal;
  String _nomeDoLocatario;
  String _emailDoLocatario;
  String _estadoDoImovel;
  String _urlImagemDoLocatario;
  String _idImovelAlugado;
  int _idEstadoImovel;
  String _nomeDaImagemImovel, _nomeDaImagemImovel2, _nomeDaImagemImovel3, _nomeDaImagemImovel4, _nomeDaImagemImovel5;
  String _telefoneUsuario;
  String _tipoDeRecibo;
  String _cidadeDonoDoImovel;
  String _cepDonoDoImovel;
  String _bairroDonoDoImovel;
  String _numeroDonoDoImovel;
  String _urlDoContrato;

  DonoDoImovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cidadeDonoDoImovel" : this.cidadeDonoDoImovel,
      "urlDoContrato" : this.urlDoContrato,
      "cepDonoDoImovel" : this.cepDonoDoImovel,
      "bairroDonoDoImovel" : this.bairroDonoDoImovel,
      "numeroDono" : this.numeroDonoDoImovel,
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
      "urlImagensDonoDoImovel2" : this.urlImagensDonoDoImovel2,
      "urlImagensDonoDoImovel3" : this.urlImagensDonoDoImovel3,
      "urlImagensDonoDoImovel4" : this.urlImagensDonoDoImovel4,
      "urlImagensDonoDoImovel5" : this.urlImagensDonoDoImovel5,
      "idImovelAlugado" : this.idImovelAlugado,
      "dataInicio" : this.dataInicio,
      "dataFinal" : this.dataFinal,
      "nomeDaImagemImovel" : this.nomeDaImagemImovel,
      "nomeDaImagemImovel2" : this.nomeDaImagemImovel2,
      "nomeDaImagemImovel3" : this.nomeDaImagemImovel3,
      "nomeDaImagemImovel4" : this.nomeDaImagemImovel4,
      "nomeDaImagemImovel5" : this.nomeDaImagemImovel5,
      "tipoDeRecibo" : this.tipoDeRecibo,
    };

    return map;

  }


  get urlImagensDonoDoImovel2 => _urlImagensDonoDoImovel2;

  set urlImagensDonoDoImovel2(value) {
    _urlImagensDonoDoImovel2 = value;
  }

  String get urlDoContrato => _urlDoContrato;

  set urlDoContrato(String value) {
    _urlDoContrato = value;
  }

  String get cidadeDonoDoImovel => _cidadeDonoDoImovel;

  set cidadeDonoDoImovel(String value) {
    _cidadeDonoDoImovel = value;
  }

  String get tipoDeRecibo => _tipoDeRecibo;

  set tipoDeRecibo(String value) {
    _tipoDeRecibo = value;
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

  String get cepDonoDoImovel => _cepDonoDoImovel;

  set cepDonoDoImovel(String value) {
    _cepDonoDoImovel = value;
  }

  String get bairroDonoDoImovel => _bairroDonoDoImovel;

  set bairroDonoDoImovel(String value) {
    _bairroDonoDoImovel = value;
  }

  String get numeroDonoDoImovel => _numeroDonoDoImovel;

  set numeroDonoDoImovel(String value) {
    _numeroDonoDoImovel = value;
  }

  get urlImagensDonoDoImovel3 => _urlImagensDonoDoImovel3;

  set urlImagensDonoDoImovel3(value) {
    _urlImagensDonoDoImovel3 = value;
  }

  get urlImagensDonoDoImovel4 => _urlImagensDonoDoImovel4;

  set urlImagensDonoDoImovel4(value) {
    _urlImagensDonoDoImovel4 = value;
  }

  get urlImagensDonoDoImovel5 => _urlImagensDonoDoImovel5;

  set urlImagensDonoDoImovel5(value) {
    _urlImagensDonoDoImovel5 = value;
  }

  get nomeDaImagemImovel2 => _nomeDaImagemImovel2;

  set nomeDaImagemImovel2(value) {
    _nomeDaImagemImovel2 = value;
  }

  get nomeDaImagemImovel3 => _nomeDaImagemImovel3;

  set nomeDaImagemImovel3(value) {
    _nomeDaImagemImovel3 = value;
  }

  get nomeDaImagemImovel4 => _nomeDaImagemImovel4;

  set nomeDaImagemImovel4(value) {
    _nomeDaImagemImovel4 = value;
  }

  get nomeDaImagemImovel5 => _nomeDaImagemImovel5;

  set nomeDaImagemImovel5(value) {
    _nomeDaImagemImovel5 = value;
  }


}