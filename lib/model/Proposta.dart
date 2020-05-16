class Proposta {

  String _idPropostaUsuarioLogado;
  String _logadouro;
  String _complemento;
  String _tipo;
  String _valor;
  String _urlImagens;
  String _detalhes;
  String _estado;
  String _idImovel;
  String _nomeDaImagem;
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
  Proposta();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idPropostaUsuarioLogado" : this.idPropostaUsuarioLogado,
      "idCotra" : this.idCotra,
      "idProposta" : this.idProposta,
      "id" : this.id,
      "logadouro" : this.logadouro,
      "cpf" : this.cpf,
      "telefone" : this.telefone,
      "complemento" : this.complemento,
      "tipo" : this.tipo,
      "nomeDaImagem": this.nomeDaImagem,
      "valor" : this.valor,
      "urlImagens" : this.urlImagens,
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


}