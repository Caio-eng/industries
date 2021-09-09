import 'package:brasil_fields/modelos/estados.dart';
import 'package:flutter/material.dart';

class Config {

  static List<DropdownMenuItem<String>> getEstados() {

    List<DropdownMenuItem<String>> _listaItensDropEstados = [];

    _listaItensDropEstados.add(
        DropdownMenuItem(child: Text(
          'Região', style: TextStyle(
          color: Colors.blue,
        ),
        ), value: null,
        ));

    for (var estado in Estados.listaEstadosAbrv) {
      _listaItensDropEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }


    return _listaItensDropEstados;

  }

  static List<String> getLogradouro() {

    List<String> _listaItensLogradouro = [];

    return _listaItensLogradouro;

  }

  static List<DropdownMenuItem<String>> getTipos() {

    List<DropdownMenuItem<String>> itensDropTipos = [];

    itensDropTipos.add(
        DropdownMenuItem(child: Text(
          'Tipo do Imóvel', style: TextStyle(
          color: Colors.blue,
        ),
        ), value: null,
        ));

    itensDropTipos.add(DropdownMenuItem(
      child: Text('Casa'),
      value: 'Casa',
    ));
    itensDropTipos.add(DropdownMenuItem(
      child: Text('Apartamento'),
      value: 'Apartamento',
    ));
    itensDropTipos.add(DropdownMenuItem(
      child: Text('Quitinete'),
      value: 'Quitinete',
    ));

    return itensDropTipos;

  }

  static List<DropdownMenuItem<String>> getMeusImoveis() {

    List<DropdownMenuItem<String>> itensDropMeus = [];

    itensDropMeus.add(
        DropdownMenuItem(child: Text(
          'Selecione', style: TextStyle(
          color: Colors.blue,
        ),
        ), value: null,
        ));

    itensDropMeus.add(DropdownMenuItem(
      child: Text('Meus Imóveis'),
      value: 'Meus Imóveis',
    ));

    return itensDropMeus;

  }

}