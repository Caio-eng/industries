class PagarImovel {

  String _idPagamento;
  String _valorDoPagamento;
  String _valorTotal;
  String _juroDeAtraso;
  String _tipoDoPagamento;
  String _dataDoPagamento;
  String _dataDoVencimento;
  String _idDoPagador;
  String _idDoRecebedor;
  String _idDoImovel;
  String _logadouro;
  String _comp;
  String _cpfDoDono;
  String _nomeDoDono;
  String _nome;
  String _cpf;
  String _tipo;
  String _estado;
  String _detalhes;
  String _cidade;
  String _cep;
  String _bairro;
  String _numero;

  PagarImovel();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idPagamento" : this.idPagamento,
      "valorDoPagamento" : this.valorDoPagamento,
      "juroDeAtraso" : this.juroDeAtraso,
      "valorTotal" : this.valorTotal,
      "tipoDoPagamento" : this.tipoDoPagamento,
      "dataDoPagamento" : this.dataDoPagamento,
      "dataDoVencimento" : this.dataDoVencimento,
      "idDoPagador" : this.idDoPagador,
      "idDoRecebedor" : this.idDoRecebedor,
      "idDoImovel" : this.idDoImovel,
      "logadouro" : this.logadouro,
      "comp" : this.comp,
      "cpfDoDono" : this.cpfDoDono,
      "nomeDoDono" : this.nomeDoDono,
      "nome" : this.nome,
      "cpf" : this.cpf,
      "tipo" : this.tipo,
      "estado" : this.estado,
      "cidade" : this.cidade,
      "cep" : this.cep,
      "bairro" : this.bairro,
      "numero" : this.numero,
      "detalhes" : this.detalhes,
    };

    return map;

  }


  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get logadouro => _logadouro;

  set logadouro(String value) {
    _logadouro = value;
  }

  String get idDoImovel => _idDoImovel;

  set idDoImovel(String value) {
    _idDoImovel = value;
  }

  String get valorTotal => _valorTotal;

  set valorTotal(String value) {
    _valorTotal = value;
  }

  String get idPagamento => _idPagamento;

  set idPagamento(String value) {
    _idPagamento = value;
  }

  String get valorDoPagamento => _valorDoPagamento;

  String get idDoRecebedor => _idDoRecebedor;

  set idDoRecebedor(String value) {
    _idDoRecebedor = value;
  }

  String get idDoPagador => _idDoPagador;

  set idDoPagador(String value) {
    _idDoPagador = value;
  }

  String get dataDoVencimento => _dataDoVencimento;

  set dataDoVencimento(String value) {
    _dataDoVencimento = value;
  }

  String get dataDoPagamento => _dataDoPagamento;

  set dataDoPagamento(String value) {
    _dataDoPagamento = value;
  }

  String get tipoDoPagamento => _tipoDoPagamento;

  set tipoDoPagamento(String value) {
    _tipoDoPagamento = value;
  }

  String get juroDeAtraso => _juroDeAtraso;

  set juroDeAtraso(String value) {
    _juroDeAtraso = value;
  }

  set valorDoPagamento(String value) {
    _valorDoPagamento = value;
  }

  String get comp => _comp;

  set comp(String value) {
    _comp = value;
  }

  String get cpfDoDono => _cpfDoDono;

  set cpfDoDono(String value) {
    _cpfDoDono = value;
  }

  String get nomeDoDono => _nomeDoDono;

  set nomeDoDono(String value) {
    _nomeDoDono = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get detalhes => _detalhes;

  set detalhes(String value) {
    _detalhes = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }


}