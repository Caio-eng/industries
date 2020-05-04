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
    };

    return map;

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


}