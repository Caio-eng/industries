class AlugarImovel {

  String _cpfUsuario;
  String _idLocatario;
  String _idDono;
  String _logadouroImovelAlugado;
  String _complementoImovelAlugado;
  String _tipoImovelImovelAlugado;
  String _valorImovelAlugado;
  String _urlImagensImovelAlugado;
  String _detalhesImovelAlugado;
  String _dataInicio;
  String _dataFinal;
  String _estadoImovelAlugado;
  AlugarImovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
     "cpfUsuario" : this.cpfUsuario,
      "idLocatario" : this.idLocatario,
      "idDono" : this.idDono,
      "logadouroImovelAlugado" : this.logadouroImovelAlugado,
      "complementoImovelAlugado" : this.complementoImovelAlugado,
      "tipoImovelImovelAlugado" : this.tipoImovelImovelAlugado,
      "detalhesImovelAlugado" : this.detalhesImovelAlugado,
      "valorImovelAlugado" : this.valorImovelAlugado,
      "urlImagensImovelAlugado" : this.urlImagensImovelAlugado,
      "estadoImovelAlugado": this.estadoImovelAlugado,
      "dataInicio" : this.dataInicio,
      "dataFinal" : this.dataFinal,
    };

    return map;

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

  String get cpfUsuario => _cpfUsuario;

  set cpfUsuario(String value) {
    _cpfUsuario = value;
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


}