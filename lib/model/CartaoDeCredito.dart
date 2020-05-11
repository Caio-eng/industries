class CartaoDeCredito {

  String _numeroDoCartao;
  String _nomeDoTitularDoCartao;
  String _dataDeValdadeDoCartao;
  String _cpfDoTitularDoCartao;
  String _cvv;
  String _idUsuario;

  CartaoDeCredito();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "numeroDoCartao" : this.numeroDoCartao,
      "nomeDoTitularDoCartao" : this.nomeDoTitularDoCartao,
      "dataDeValidadeDoCartao" : this.dataDeValdadeDoCartao,
      "cpfDoTitularDoCartao" : this.cpfDoTitularDoCartao,
      "cvv" : this.cvv,
      "idUsuario" : this.idUsuario,
    };

    return map;

  }


  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get numeroDoCartao => _numeroDoCartao;

  set numeroDoCartao(String value) {
    _numeroDoCartao = value;
  }

  String get nomeDoTitularDoCartao => _nomeDoTitularDoCartao;

  String get cvv => _cvv;

  set cvv(String value) {
    _cvv = value;
  }

  String get cpfDoTitularDoCartao => _cpfDoTitularDoCartao;

  set cpfDoTitularDoCartao(String value) {
    _cpfDoTitularDoCartao = value;
  }

  String get dataDeValdadeDoCartao => _dataDeValdadeDoCartao;

  set dataDeValdadeDoCartao(String value) {
    _dataDeValdadeDoCartao = value;
  }

  set nomeDoTitularDoCartao(String value) {
    _nomeDoTitularDoCartao = value;
  }


}