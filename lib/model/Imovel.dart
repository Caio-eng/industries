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
  String _url2;
  String _url3;
  String _url4;
  String _url5;
  String _valor;
  String _nomeDaImagem;
  String _nomeDaImagem2;
  String _nomeDaImagem3;
  String _nomeDaImagem4;
  String _nomeDaImagem5;
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
      "url2" : this.url2,
      "url3" : this.url3,
      "url4" : this.url4,
      "url5" : this.url5,
      "nomeDaImagem2" : this.nomeDaImagem2,
      "nomeDaImagem3" : this.nomeDaImagem3,
      "nomeDaImagem4" : this.nomeDaImagem4,
      "nomeDaImagem5" : this.nomeDaImagem5,
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


  String get nomeDaImagem2 => _nomeDaImagem2;

  set nomeDaImagem2(String value) {
    _nomeDaImagem2 = value;
  }

  String get url2 => _url2;

  set url2(String value) {
    _url2 = value;
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

  String get url3 => _url3;

  set url3(String value) {
    _url3 = value;
  }

  String get url4 => _url4;

  set url4(String value) {
    _url4 = value;
  }

  String get url5 => _url5;

  set url5(String value) {
    _url5 = value;
  }

  String get nomeDaImagem3 => _nomeDaImagem3;

  set nomeDaImagem3(String value) {
    _nomeDaImagem3 = value;
  }

  String get nomeDaImagem4 => _nomeDaImagem4;

  set nomeDaImagem4(String value) {
    _nomeDaImagem4 = value;
  }

  String get nomeDaImagem5 => _nomeDaImagem5;

  set nomeDaImagem5(String value) {
    _nomeDaImagem5 = value;
  }


}