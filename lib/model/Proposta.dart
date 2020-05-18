class Proposta {

  String _idPropostaUsuarioLogado;
  String _logadouro;
  String _complemento;
  String _tipo;
  String _valor;
  String _urlImagens, _urlImagens2, _urlImagens3, _urlImagens4, _urlImagens5;
  String _detalhes;
  String _estado;
  String _idImovel;
  String _nomeDaImagem, _nomeDaImagem2, _nomeDaImagem3, _nomeDaImagem4, _nomeDaImagem5;
  String _cidade;
  String _cep;
  String _bairro;
  String _numero;
  String _cpf;
  String _telefone;
  String _proposta;
  String _id;
  String _idProposta;
  String _idCotra;
  String _url;
  String _url2;
  String _finalizado;
  Proposta();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idPropostaUsuarioLogado" : this.idPropostaUsuarioLogado,
      "idCotra" : this.idCotra,
      "finalizado" : this.finalizado,
      "idProposta" : this.idProposta,
      "id" : this.id,
      "logadouro" : this.logadouro,
      "cpf" : this.cpf,
      "telefone" : this.telefone,
      "complemento" : this.complemento,
      "tipo" : this.tipo,
      "nomeDaImagem": this.nomeDaImagem,
      "nomeDaImagem2" : this.nomeDaImagem2,
      "nomeDaImagem3" : this.nomeDaImagem3,
      "nomeDaImagem4" : this.nomeDaImagem5,
      "nomeDaImagem5" : this.nomeDaImagem5,
      "valor" : this.valor,
      "urlImagens" : this.urlImagens,
      "urlImagens2" : this.urlImagens2,
      "urlImagens3" : this.urlImagens3,
      "urlImagens4" : this.urlImagens4,
      "urlImagens5" : this.urlImagens5,
      "detalhes" : this.detalhes,
      "estado" : this.estado,
      "idImovel" : this.idImovel,
      "cidade" : this.cidade,
      "cep" : this.cep,
      "bairro" : this.bairro,
      "numero" : this.numero,
      "proposta" : this.proposta,
    };

    return map;

  }


  get nomeDaImagem2 => _nomeDaImagem2;

  set nomeDaImagem2(value) {
    _nomeDaImagem2 = value;
  }

  get urlImagens2 => _urlImagens2;

  set urlImagens2(value) {
    _urlImagens2 = value;
  }

  String get finalizado => _finalizado;

  set finalizado(String value) {
    _finalizado = value;
  }

  String get url2 => _url2;

  set url2(String value) {
    _url2 = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get idCotra => _idCotra;

  set idCotra(String value) {
    _idCotra = value;
  }

  String get idProposta => _idProposta;

  set idProposta(String value) {
    _idProposta = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get proposta => _proposta;

  set proposta(String value) {
    _proposta = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get nomeDaImagem => _nomeDaImagem;

  set nomeDaImagem(String value) {
    _nomeDaImagem = value;
  }

  String get idImovel => _idImovel;

  set idImovel(String value) {
    _idImovel = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get detalhes => _detalhes;

  set detalhes(String value) {
    _detalhes = value;
  }

  String get urlImagens => _urlImagens;

  set urlImagens(String value) {
    _urlImagens = value;
  }

  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get complemento => _complemento;

  set complemento(String value) {
    _complemento = value;
  }

  String get logadouro => _logadouro;

  set logadouro(String value) {
    _logadouro = value;
  }

  String get idPropostaUsuarioLogado => _idPropostaUsuarioLogado;

  set idPropostaUsuarioLogado(String value) {
    _idPropostaUsuarioLogado = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  get urlImagens3 => _urlImagens3;

  set urlImagens3(value) {
    _urlImagens3 = value;
  }

  get urlImagens4 => _urlImagens4;

  set urlImagens4(value) {
    _urlImagens4 = value;
  }

  get urlImagens5 => _urlImagens5;

  set urlImagens5(value) {
    _urlImagens5 = value;
  }

  get nomeDaImagem3 => _nomeDaImagem3;

  set nomeDaImagem3(value) {
    _nomeDaImagem3 = value;
  }

  get nomeDaImagem4 => _nomeDaImagem4;

  set nomeDaImagem4(value) {
    _nomeDaImagem4 = value;
  }

  get nomeDaImagem5 => _nomeDaImagem5;

  set nomeDaImagem5(value) {
    _nomeDaImagem5 = value;
  }


}