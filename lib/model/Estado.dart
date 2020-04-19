class Estado {

  int _id;
  String _nome;
  String _sigla;

  Estado();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id" : this.id,
      "nome" : this.nome,
      "sigla" : this.sigla,
    };

    return map;

  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get nome => _nome;

  String get sigla => _sigla;

  set sigla(String value) {
    _sigla = value;
  }

  set nome(String value) {
    _nome = value;
  }


}