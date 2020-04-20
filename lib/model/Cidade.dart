import 'package:industries/model/Estado.dart';

class Cidade {

  String _nome;

  Estado _estado = Estado();

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  Estado get estado => _estado;

  set estado(Estado value) {
    _estado = value;
  }


}