class AlugarImovel {

  String _cpfDoDono;
  String _telefoneDoDono;
  String _idLocatario;
  String _idDono;
  String _logadouroImovelAlugado;
  String _complementoImovelAlugado;
  String _tipoImovelImovelAlugado;
  String _valorImovelAlugado;
  String _urlImagensImovelAlugado, _urlImagensImovelAlugado2, _urlImagensImovelAlugado3, _urlImagensImovelAlugado4, _urlImagensImovelAlugado5;
  String _detalhesImovelAlugado;
  String _dataInicio;
  String _dataFinal;
  String _estadoImovelAlugado;
  int _idEstadoImovelAlugado;
  String _nomeDaImagemImovelAlugado, _nomeDaImagemImovelAlugado2, _nomeDaImagemImovelAlugado3, _nomeDaImagemImovelAlugado4, _nomeDaImagemImovelAlugado5;
  String _urlImagemDoDono;
  String _idImovel;
  String _nomeDoDono;
  String _emailDoDono;
  String _tipoDePagamento;
  String _cidadeImovelAlugado;
  String _cepImovelAlugado;
  String _bairroImovelAlugado;
  String _numeroImovelAlugado;
  String _urlDoContrato;

  AlugarImovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
     "cpfDoDono" : this.cpfDoDono,
      "urlDoContrato" : this.urlDoContrato,
      "telefoneDoDono" : this.telefoneDoDono,
      "idLocatario" : this.idLocatario,
      "idDono" : this.idDono,
      "cidadeImovelAlugado" : this.cidadeImovelAlugado,
      "cepImovelAlugado" : this.cepImovelAlugado,
      "bairroImovelAlugado" : this.bairroImovelAlugado,
      "numeroImovelAlugado" : this.numeroImovelAlugado,
      "logadouroImovelAlugado" : this.logadouroImovelAlugado,
      "complementoImovelAlugado" : this.complementoImovelAlugado,
      "tipoImovelImovelAlugado" : this.tipoImovelImovelAlugado,
      "detalhesImovelAlugado" : this.detalhesImovelAlugado,
      "valorImovelAlugado" : this.valorImovelAlugado,
      "urlImagensImovelAlugado" : this.urlImagensImovelAlugado,
      "urlImagensImovelAlugado2" : this.urlImagensImovelAlugado2,
      "urlImagensImovelAlugado3" : this.urlImagensImovelAlugado3,
      "urlImagensImovelAlugado4" : this.urlImagensImovelAlugado4,
      "urlImagensImovelAlugado5" : this.urlImagensImovelAlugado5,
      "estadoImovelAlugado": this.estadoImovelAlugado,
      "dataInicio" : this.dataInicio,
      "dataFinal" : this.dataFinal,
      "nomeDaImagemImovelAlugado" : this.nomeDaImagemImovelAlugado,
      "nomeDaImagemImovelAlugado2" : this.nomeDaImagemImovelAlugado2,
      "nomeDaImagemImovelAlugado3" : this.nomeDaImagemImovelAlugado3,
      "nomeDaImagemImovelAlugado4" : this.nomeDaImagemImovelAlugado4,
      "nomeDaImagemImovelAlugado5" : this.nomeDaImagemImovelAlugado5,
      "urlImagemDoDono" : this.urlImagemDoDono,
      "idImovel" : this.idImovel,
      "nomeDoDono" : this.nomeDoDono,
      "emailDoDono" :this.emailDoDono,
      "tipoDePagamento" : this.tipoDePagamento,

    };

    return map;

  }


  get urlImagensImovelAlugado2 => _urlImagensImovelAlugado2;

  set urlImagensImovelAlugado2(value) {
    _urlImagensImovelAlugado2 = value;
  }

  String get urlDoContrato => _urlDoContrato;

  set urlDoContrato(String value) {
    _urlDoContrato = value;
  }

  String get numeroImovelAlugado => _numeroImovelAlugado;

  set numeroImovelAlugado(String value) {
    _numeroImovelAlugado = value;
  }

  String get bairroImovelAlugado => _bairroImovelAlugado;

  set bairroImovelAlugado(String value) {
    _bairroImovelAlugado = value;
  }

  String get cepImovelAlugado => _cepImovelAlugado;

  set cepImovelAlugado(String value) {
    _cepImovelAlugado = value;
  }

  String get cidadeImovelAlugado => _cidadeImovelAlugado;

  set cidadeImovelAlugado(String value) {
    _cidadeImovelAlugado = value;
  }

  String get tipoDePagamento => _tipoDePagamento;

  set tipoDePagamento(String value) {
    _tipoDePagamento = value;
  }

  String get telefoneDoDono => _telefoneDoDono;

  set telefoneDoDono(String value) {
    _telefoneDoDono = value;
  }

  String get urlImagemDoDono => _urlImagemDoDono;

  set urlImagemDoDono(String value) {
    _urlImagemDoDono = value;
  }

  int get idEstadoImovelAlugado => _idEstadoImovelAlugado;

  set idEstadoImovelAlugado(int value) {
    _idEstadoImovelAlugado = value;
  }

  String get estadoImovelAlugado => _estadoImovelAlugado;

  set estadoImovelAlugado(String value) {
    _estadoImovelAlugado = value;
  }

  String get dataInicio => _dataInicio;

  set dataInicio(String value) {
    _dataInicio = value;
  }

  String get detalhesImovelAlugado => _detalhesImovelAlugado;

  set detalhesImovelAlugado(String value) {
    _detalhesImovelAlugado = value;
  }

  String get complementoImovelAlugado => _complementoImovelAlugado;

  set complementoImovelAlugado(String value) {
    _complementoImovelAlugado = value;
  }

  String get logadouroImovelAlugado => _logadouroImovelAlugado;

  set logadouroImovelAlugado(String value) {
    _logadouroImovelAlugado = value;
  }

  String get idDono => _idDono;

  set idDono(String value) {
    _idDono = value;
  }

  String get idLocatario => _idLocatario;

  set idLocatario(String value) {
    _idLocatario = value;
  }

  String get cpfDoDono => _cpfDoDono;

  set cpfDoDono(String value) {
    _cpfDoDono = value;
  }

  String get tipoImovelImovelAlugado => _tipoImovelImovelAlugado;

  set tipoImovelImovelAlugado(String value) {
    _tipoImovelImovelAlugado = value;
  }

  String get valorImovelAlugado => _valorImovelAlugado;

  set valorImovelAlugado(String value) {
    _valorImovelAlugado = value;
  }

  String get urlImagensImovelAlugado => _urlImagensImovelAlugado;

  set urlImagensImovelAlugado(String value) {
    _urlImagensImovelAlugado = value;
  }

  String get dataFinal => _dataFinal;

  set dataFinal(String value) {
    _dataFinal = value;
  }

  String get nomeDaImagemImovelAlugado => _nomeDaImagemImovelAlugado;

  set nomeDaImagemImovelAlugado(String value) {
    _nomeDaImagemImovelAlugado = value;
  }

  String get idImovel => _idImovel;

  set idImovel(String value) {
    _idImovel = value;
  }

  String get nomeDoDono => _nomeDoDono;

  set nomeDoDono(String value) {
    _nomeDoDono = value;
  }

  String get emailDoDono => _emailDoDono;

  set emailDoDono(String value) {
    _emailDoDono = value;
  }

  get urlImagensImovelAlugado3 => _urlImagensImovelAlugado3;

  set urlImagensImovelAlugado3(value) {
    _urlImagensImovelAlugado3 = value;
  }

  get urlImagensImovelAlugado4 => _urlImagensImovelAlugado4;

  set urlImagensImovelAlugado4(value) {
    _urlImagensImovelAlugado4 = value;
  }

  get urlImagensImovelAlugado5 => _urlImagensImovelAlugado5;

  set urlImagensImovelAlugado5(value) {
    _urlImagensImovelAlugado5 = value;
  }

  get nomeDaImagemImovelAlugado2 => _nomeDaImagemImovelAlugado2;

  set nomeDaImagemImovelAlugado2(value) {
    _nomeDaImagemImovelAlugado2 = value;
  }

  get nomeDaImagemImovelAlugado3 => _nomeDaImagemImovelAlugado3;

  set nomeDaImagemImovelAlugado3(value) {
    _nomeDaImagemImovelAlugado3 = value;
  }

  get nomeDaImagemImovelAlugado4 => _nomeDaImagemImovelAlugado4;

  set nomeDaImagemImovelAlugado4(value) {
    _nomeDaImagemImovelAlugado4 = value;
  }

  get nomeDaImagemImovelAlugado5 => _nomeDaImagemImovelAlugado5;

  set nomeDaImagemImovelAlugado5(value) {
    _nomeDaImagemImovelAlugado5 = value;
  }


}