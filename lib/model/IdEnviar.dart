class IdEnviar {

  String _idUsuarioLogado;
  String _idUsuarioDeslogado;
  String _idDoImovel;

  IdEnviar();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuarioLogado" : this.idUsuarioLogado,
      "idUsuarioDeslogado" : this.idUsuarioDeslogado,
      "idDoImovel" : this.idDoImovel,
    };

    return map;

  }

  String get idUsuarioLogado => _idUsuarioLogado;

  set idUsuarioLogado(String value) {
    _idUsuarioLogado = value;
  }

  String get idUsuarioDeslogado => _idUsuarioDeslogado;

  String get idDoImovel => _idDoImovel;

  set idDoImovel(String value) {
    _idDoImovel = value;
  }

  set idUsuarioDeslogado(String value) {
    _idUsuarioDeslogado = value;
  }


}