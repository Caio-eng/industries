import 'dart:convert';

class Imovel {

  String _logadouro;
  String _numero;
  String _complemento;
  String _tipoImovel;
  String _cidade;
  String _estado;
  String _cep;
  String _bairro;
  String _detalhes;
  String _idUsuario;
  String _urlImagens;
  String _valor;
  String _nomeDaImagem;
  int _idEstado;
  String _ibge;
  String _gia;
  String _siglaEstado;
  String _telefoneUsuario;
  String _cpfUsuario;

  Imovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cep" : this.cep,
      "cidade" : this.cidade,
      "siglaEstado" : this.siglaEstado,
      "logadouro" : this.logadouro,
      "bairro" : this.bairro,
      "numero" : this.numero,
      "complemento" : this.complemento,
      "tipoImovel" : this.tipoImovel,
      "valor" : this.valor,
      "idUsuario" : this._idUsuario,
      "urlImagens" : this.urlImagens,
      'detalhes' : this.detalhes,
      "nomeDaImagem" : this.nomeDaImagem,
      "telefoneUsuario" : this.telefoneUsuario,
      "cpfUsuario" : this.cpfUsuario,
    };

    return map;

  }


  String get ibge => _ibge;

  set ibge(String value) {
    _ibge = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get siglaEstado => _siglaEstado;

  set siglaEstado(String value) {
    _siglaEstado = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get telefoneUsuario => _telefoneUsuario;

  set telefoneUsuario(String value) {
    _telefoneUsuario = value;
  }

  int get idEstado => _idEstado;

  set idEstado(int value) {
    _idEstado = value;
  }

  String get nomeDaImagem => _nomeDaImagem;

  set nomeDaImagem(String value) {
    _nomeDaImagem = value;
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

  String get cpfUsuario => _cpfUsuario;

  set cpfUsuario(String value) {
    _cpfUsuario = value;
  }

  String get gia => _gia;

  set gia(String value) {
    _gia = value;
  }


}