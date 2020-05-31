import 'dart:collection';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/IdEnviar.dart';
import 'package:industries/model/PagarImovel.dart';

import 'model/Imovel.dart';

class ImovelAlugado extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  ImovelAlugado(this.user, this.photo, this.emai, this.uid);

  @override
  _ImovelAlugadoState createState() => _ImovelAlugadoState();
}

class _ImovelAlugadoState extends State<ImovelAlugado> {
  String _idUsuarioLogado = "";
  String _idDono = "";
  String _nomeDoDono, _emailDoDono, _cpfDoDono, _telefoneDoDono, _photoDoDono;
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";
  String _telefone = '';
  String _cpf, _nome, _email, _photo;
  String _deta = "";
  String _estado, _cep, _numero, _bairro, _cidade;
  String _dataInicio,
      _idUsuarioDoCartao,
      _nomeUsuarioDoCartao,
      _cpfUsuarioDoCartao;
  String _idImovel, _idUsuario, _idReceber, _idPagar, _dados;
  List<String> itensMenu = [
    "Informações",
    "Pagar Aluguel",
    "Cancelar Contrato com Dono",
  ];
  DateTime _date = new DateTime.now();

  Firestore db = Firestore.instance;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    String _id;
    _cancelarContratoComDono() async {
      DocumentSnapshot snapshot3 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela1')
          .get();
      Map<String, dynamic> dados3 = snapshot3.data;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cancelar Contrato',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Você deseja cancelar o contrato se sim, você clicara em Cancelar se não clicara em Voltar!'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Voltar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  dados3 == null ||
                          dados3['idDoPagador'] == null ||
                          _idUsuarioDoCartao == null
                      ? FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Imovel imovel = Imovel();
                            imovel.logadouro =
                                document['logadouroImovelAlugado'];
                            imovel.idImovel = document['idImovel'];
                            imovel.complemento =
                                document['complementoImovelAlugado'];
                            imovel.detalhes = document['detalhesImovelAlugado'];
                            imovel.idUsuario = document['idDono'];
                            imovel.tipoImovel =
                                document['tipoImovelImovelAlugado'];
                            imovel.valor = document['valorImovelAlugado'];
                            imovel.urlImagens =
                                document['urlImagensImovelAlugado'];
                            imovel.url2 = document['urlImagensImovelAlugado2'];
                            imovel.url3 = document['urlImagensImovelAlugado3'];
                            imovel.url4 = document['urlImagensImovelAlugado4'];
                            imovel.url5 = document['urlImagensImovelAlugado5'];
                            imovel.siglaEstado =
                                document['estadoImovelAlugado'];
                            imovel.cep = document['cepImovelAlugado'];
                            imovel.cidade = document['cidadeImovelAlugado'];
                            imovel.bairro = document['bairroImovelAlugado'];
                            imovel.numero = document['numeroImovelAlugado'];
                            imovel.nomeDaImagem =
                                document['nomeDaImagemImovelAlugado'];
                            imovel.nomeDaImagem2 =
                                document['nomeDaImagemImovelAlugado2'];
                            imovel.nomeDaImagem3 =
                                document['nomeDaImagemImovelAlugado3'];
                            imovel.nomeDaImagem4 =
                                document['nomeDaImagemImovelAlugado4'];
                            imovel.nomeDaImagem5 =
                                document['nomeDaImagemImovelAlugado5'];
                            imovel.cpfUsuario = document['cpfDoDono'];
                            imovel.telefoneUsuario = document['telefoneDoDono'];
                            db
                                .collection("imoveis")
                                .document(document['idImovel'])
                                .setData(imovel.toMap());

                            db
                                .collection("propostasDoLocatario")
                                .document(widget.uid)
                                .delete();
                            db
                                .collection("propostasDoLocador")
                                .document(document['idDono'])
                                .delete();
                            db
                                .collection("imovelAlugado")
                                .document(document['idLocatario'])
                                .collection("Detalhes")
                                .document(document.documentID)
                                .delete();
                            db
                                .collection("meuImovel")
                                .document(document['idImovel'])
                                .delete();
                            Navigator.pop(context);
                          },
                        )
                      : Text('Fatura Paga este mês'),
                ],
              ),
            ],
          );
        },
      );
    }

    _pagarAluguel() async {
      _idDono = document['idDono'];
      _nomeDoDono = document['nomeDoDono'];
      _emailDoDono = document['emailDoDono'];
      _cpfDoDono = document['cpfDoDono'];
      _telefoneDoDono = document['telefoneDoDono'];
      _photoDoDono = document['urlImagemDoDono'];
      _dataInicio = document['dataInicio'];
      print(
          "O Dono de id: ${_idDono}, tem o nome: ${_nomeDoDono}, seu email é: ${_emailDoDono}, portador do CPF: ${_cpfDoDono} e seu número é: ${_telefoneDoDono}.");
      _valor = document['valorImovelAlugado'];
      _log = document['logadouroImovelAlugado'];
      _comp = document['complementoImovelAlugado'];
      String cpf = _cpf;
      String nome = _nome;
      String _tipo = document['tipoImovelImovelAlugado'];
      String _estado = document['estadoImovelAlugado'];
      String _detalhes = document['detalhesImovelAlugado'];
      String _tipoDoPagamento = document['tipoDePagamento'];
      _log = document['logadouroImovelAlugado'];
      _cidade = document['cidadeImovelAlugado'];
      _cep = document['cepImovelAlugado'];
      _bairro = document['bairroImovelAlugado'];
      _numero = document['numeroImovelAlugado'];

      DocumentSnapshot snapshot3 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela1')
          .get();
      Map<String, dynamic> dados3 = snapshot3.data;

      DocumentSnapshot snapshot4 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela2')
          .get();
      Map<String, dynamic> dados4 = snapshot4.data;
      print("Olá: " + dados3.toString());

      DocumentSnapshot snapshot5 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela3')
          .get();
      Map<String, dynamic> dados5 = snapshot5.data;

      DocumentSnapshot snapshot6 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela4')
          .get();
      Map<String, dynamic> dados6 = snapshot6.data;

      DocumentSnapshot snapshot7 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela5')
          .get();
      Map<String, dynamic> dados7 = snapshot7.data;

      DocumentSnapshot snapshot8 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela6')
          .get();
      Map<String, dynamic> dados8 = snapshot8.data;

      DocumentSnapshot snapshot9 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela7')
          .get();
      Map<String, dynamic> dados9 = snapshot9.data;

      DocumentSnapshot snapshot10 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela8')
          .get();
      Map<String, dynamic> dados10 = snapshot10.data;

      DocumentSnapshot snapshot11 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela9')
          .get();
      Map<String, dynamic> dados11 = snapshot11.data;

      DocumentSnapshot snapshot12 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela10')
          .get();
      Map<String, dynamic> dados12 = snapshot12.data;

      DocumentSnapshot snapshot13 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela11')
          .get();
      Map<String, dynamic> dados13 = snapshot13.data;

      DocumentSnapshot snapshot14 = await db
          .collection("pagarImoveis")
          .document(widget.uid)
          .collection(document['idImovel'])
          .document('parcela12')
          .get();
      Map<String, dynamic> dados14 = snapshot14.data;

      final todayDate = DateTime.now();
      print(todayDate.month + 1);
      String diaIni, diaFeve;
      String dia, dia2;
      String mes1,
          mes2,
          mes3,
          mes4,
          mes5,
          mes6,
          mes7,
          mes8,
          mes9,
          mes10,
          mes11,
          mes12;
      String ano, ano2;
      dia = document['dataFinal'].toString();
      diaIni = document['dataInicio'].toString();
      diaFeve = '28';
      dia2 = '5';
      mes1 = (todayDate.month + 1).toString();
      mes2 = (todayDate.month + 2).toString();
      mes3 = (todayDate.month + 3).toString();
      mes4 = (todayDate.month + 4).toString();
      mes5 = (todayDate.month + 5).toString();
      mes6 = (todayDate.month + 6).toString();
      mes7 = (todayDate.month + 7).toString();
      mes8 = (todayDate.month - 4).toString();
      mes9 = (todayDate.month - 3).toString();
      mes10 = (todayDate.month - 2).toString();
      mes11 = (todayDate.month - 1).toString();
      mes12 = (todayDate.month).toString();
      ano = todayDate.year.toString();
      ano2 = (todayDate.year + 1).toString();
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Parcelas do Aluguel',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  dados3 == null ||
                          dados3['idDoPagador'] == null ||
                          _idUsuarioDoCartao == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Confirmar Pagamento',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Informações da 1ª Parcela',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(),
                                        Text(
                                          'Locador: ' + document['nomeDoDono'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'CPF: ' + document['cpfDoDono'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Data Inicial: ' +
                                              document['dataInicio'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Data Limite: ' +
                                              document['dataFinal'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Localização: " +
                                              document['cidadeImovelAlugado'] +
                                              ' - ' +
                                              document['estadoImovelAlugado'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Endreço: ' +
                                              document[
                                                  'logadouroImovelAlugado'] +
                                              " " +
                                              document[
                                                  'complementoImovelAlugado'] +
                                              "\nBairro: " +
                                              document['bairroImovelAlugado'] +
                                              " - Número: " +
                                              document['numeroImovelAlugado'] +
                                              "\nCEP: " +
                                              document['cepImovelAlugado'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Valor do Aluguel: ' +
                                              document['valorImovelAlugado'],
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(),
                                        Text(
                                          'Clique em confirmar para efetuar o pagamento!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Confirmar'),
                                          onPressed: () {
                                            PagarImovel pagarImovel =
                                                PagarImovel();
                                            pagarImovel.idDoPagador =
                                                widget.uid;
                                            pagarImovel.idDoRecebedor = _idDono;
                                            pagarImovel.tipoDoPagamento =
                                                _tipoDoPagamento;
                                            pagarImovel.dataDoPagamento =
                                                formatDate(_date, [
                                              dd,
                                              '/',
                                              mm,
                                              '/',
                                              yyyy
                                            ]).toString();
                                            pagarImovel.valorDoPagamento =
                                                _valor;
                                            pagarImovel.juroDeAtraso = "0";
                                            pagarImovel.valorTotal = _valor;
                                            pagarImovel.idDoImovel =
                                                document['idImovel'];
                                            pagarImovel.logadouro = _log;
                                            pagarImovel.comp = _comp;
                                            pagarImovel.cidade = _cidade;
                                            pagarImovel.cep = _cep;
                                            pagarImovel.bairro = _bairro;
                                            pagarImovel.numero = _numero;
                                            pagarImovel.cpfDoDono = _cpfDoDono;
                                            pagarImovel.nomeDoDono =
                                                _nomeDoDono;
                                            pagarImovel.nome = nome;
                                            pagarImovel.cpf = cpf;
                                            pagarImovel.tipo = _tipo;
                                            pagarImovel.estado = _estado;
                                            pagarImovel.detalhes = _detalhes;
                                            pagarImovel.idUsuarioDoCartao =
                                                _idUsuarioDoCartao;
                                            pagarImovel.nomeUsuarioDoCartao =
                                                _nomeUsuarioDoCartao;
                                            pagarImovel.cpfUsuarioDoCartao =
                                                _cpfUsuarioDoCartao;
//                                      IdEnviar idEnviar = IdEnviar();
//                                      idEnviar.idUsuarioLogado = widget.uid;
//                                      idEnviar.idUsuarioDeslogado = _idDono;
//                                      idEnviar.idDoImovel = document['idImovel'];
//                                      db.collection("idEnvios").document(widget.uid).setData(idEnviar.toMap());
//                                      db.collection('idEnvios').document(_idDono).setData(idEnviar.toMap());
                                            //db.collection("idEnvios").document(_log).setData(idEnviar.toMap());
                                            PagarImovel pagarImovels =
                                                PagarImovel();
                                            pagarImovels.idDoPagador = _idDono;
                                            pagarImovels.idDoRecebedor =
                                                widget.uid;
                                            pagarImovels.tipoDoPagamento =
                                                _tipoDoPagamento;
                                            pagarImovels.dataDoPagamento =
                                                formatDate(_date, [
                                              dd,
                                              '/',
                                              mm,
                                              '/',
                                              yyyy
                                            ]).toString();
                                            pagarImovels.valorDoPagamento =
                                                _valor;
                                            pagarImovels.juroDeAtraso = "0";
                                            pagarImovels.valorTotal = _valor;
                                            pagarImovels.idDoImovel =
                                                document['idImovel'];
                                            pagarImovels.logadouro = _log;
                                            pagarImovels.comp = _comp;
                                            pagarImovels.cidade = _cidade;
                                            pagarImovels.cep = _cep;
                                            pagarImovels.bairro = _bairro;
                                            pagarImovels.numero = _numero;
                                            pagarImovels.cpfDoDono = _cpfDoDono;
                                            pagarImovels.nomeDoDono =
                                                _nomeDoDono;
                                            pagarImovels.nome = nome;
                                            pagarImovels.cpf = cpf;
                                            pagarImovels.tipo = _tipo;
                                            pagarImovels.estado = _estado;
                                            pagarImovels.detalhes = _detalhes;
                                            pagarImovels.idUsuarioDoCartao =
                                                _idUsuarioDoCartao;
                                            pagarImovels.nomeUsuarioDoCartao =
                                                _nomeUsuarioDoCartao;
                                            pagarImovels.cpfUsuarioDoCartao =
                                                _cpfUsuarioDoCartao;
                                            Map<String, dynamic>
                                                dadosAtualizar = {
                                              "idPg1": widget.uid,
                                              "idImovel": document['idImovel']
                                            };
                                            db
                                                .collection("usuarios")
                                                .document(_idDono)
                                                .updateData(dadosAtualizar);
                                            Map<String, dynamic>
                                                dadosAtualizar2 = {
                                              "idPg1": _idDono,
                                              "idImovel": document['idImovel']
                                            };
                                            db
                                                .collection("usuarios")
                                                .document(widget.uid)
                                                .updateData(dadosAtualizar2);
                                            db
                                                .collection("pagarImoveis")
                                                .document(widget.uid)
                                                .collection(
                                                    document['idImovel'])
                                                .document('parcela1')
                                                .setData(pagarImovel.toMap());
                                            db
                                                .collection("pagarImoveis")
                                                .document(_idDono)
                                                .collection(
                                                    document['idImovel'])
                                                .document('parcela1')
                                                .setData(pagarImovels.toMap());
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            print("Pago");
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                              : Text(
                                  "Parcela 1 " +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: ${document['dataFinal']}",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 1 " + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados4 == null ||
                          dados4['idDoPagador'] == null ||
                          _idUsuarioDoCartao == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 2',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1 para ter acesso ao pagamento 2!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 2',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 2ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes1 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes1 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 2!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg2": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg2": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela2')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela2')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 2 " +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes1 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 2 " + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados5 == null ||
                          dados5['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null || dados4 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 3',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1 e 2 para ter acesso ao pagamento 3!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 3',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 3ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes2 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes2 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 3!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg3": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg3": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela3')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela3')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 3" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes2 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 3" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados6 == null ||
                          dados6['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 4',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2 e 3 para ter acesso ao pagamento 4!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 4',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 4ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes3 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes3 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 4!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg3": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg3": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela4')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela4')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 4" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes3 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 4" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados7 == null ||
                          dados7['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 5',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3 e 4 para ter acesso ao pagamento 5!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 5',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 5ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes4 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes4 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 5!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg4": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg4": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela5')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela5')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 5" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes4 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 5" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados8 == null ||
                          dados8['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 6',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4 e 5 para ter acesso ao pagamento 6!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 6',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 6ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes5 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes5 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 6!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg5": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg5": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela6')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela6')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 6" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes5 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 6" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados9 == null ||
                          dados9['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 7',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5 e 6 para ter acesso ao pagamento 7!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 7',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 7ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes6 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes6 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 7!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg6": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg6": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela7')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela7')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 7" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes6 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 7" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados10 == null ||
                          dados10['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null ||
                                dados9 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 8',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5, 6 e 7 para ter acesso ao pagamento 8!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 8',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 8ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes7 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes7 +
                                                '/' +
                                                ano,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 8!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg7": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg7": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela8')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela8')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 8" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes7 +
                                      '/' +
                                      ano,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 8" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados11 == null ||
                          dados11['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null ||
                                dados9 == null ||
                                dados10 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 9',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5, 6, 7 e 8 para ter acesso ao pagamento 9!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 9',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 9ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes8 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes8 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 9!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg8": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg8": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela9')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela9')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 9" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes8 +
                                      '/' +
                                      ano2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 9" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados12 == null ||
                          dados12['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null ||
                                dados9 == null ||
                                dados10 == null ||
                                dados11 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 10',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5, 6, 7, 8 e 9 para ter acesso ao pagamento 10!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 10',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 10ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaFeve +
                                                '/' +
                                                mes9 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia2 +
                                                '/' +
                                                mes9 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 10!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg9": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg9": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela10')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela10')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 10" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia2 +
                                      '/' +
                                      mes9 +
                                      '/' +
                                      ano2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 10" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados13 == null ||
                          dados13['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null ||
                                dados9 == null ||
                                dados10 == null ||
                                dados11 == null ||
                                dados12 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 11',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5, 6, 7, 8, 9 e 10 para ter acesso ao pagamento 11!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 11',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 11ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes10 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes10 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 11!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg10": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg10": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela11')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela11')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 11" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes10 +
                                      '/' +
                                      ano2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 11" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  dados14 == null ||
                          dados14['idDoPagador'] == null ||
                          _idUsuarioLogado == null
                      ? InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            if (dados3 == null ||
                                dados4 == null ||
                                dados5 == null ||
                                dados6 == null ||
                                dados7 == null ||
                                dados8 == null ||
                                dados9 == null ||
                                dados10 == null ||
                                dados11 == null ||
                                dados12 == null ||
                                dados13 == null) {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Pagamento 12',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Efetue o pagamento 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 e 11 para ter acesso ao pagamento 12!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Confirmar Pagamento 12',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            'Informações da 12ª Parcela',
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Locador: ' +
                                                document['nomeDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'CPF: ' + document['cpfDoDono'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Inicial: ' +
                                                diaIni.substring(0, 2) +
                                                '/' +
                                                mes11 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Data Limite: ' +
                                                dia.substring(0, 2) +
                                                '/' +
                                                mes11 +
                                                '/' +
                                                ano2,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Localização: " +
                                                document[
                                                    'cidadeImovelAlugado'] +
                                                ' - ' +
                                                document['estadoImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Endreço: ' +
                                                document[
                                                    'logadouroImovelAlugado'] +
                                                " " +
                                                document[
                                                    'complementoImovelAlugado'] +
                                                "\nBairro: " +
                                                document[
                                                    'bairroImovelAlugado'] +
                                                " - Número: " +
                                                document[
                                                    'numeroImovelAlugado'] +
                                                "\nCEP: " +
                                                document['cepImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Valor do Aluguel: ' +
                                                document['valorImovelAlugado'],
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          Text(
                                            'Clique em confirmar para efetuar o pagamento 11!',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Voltar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              PagarImovel pagarImovel =
                                                  PagarImovel();
                                              pagarImovel.idDoPagador =
                                                  widget.uid;
                                              pagarImovel.idDoRecebedor =
                                                  _idDono;
                                              pagarImovel.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovel.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovel.valorDoPagamento =
                                                  _valor;
                                              pagarImovel.dataDoVencimento =
                                                  document['dataFinal'];
                                              pagarImovel.juroDeAtraso = "0";
                                              pagarImovel.valorTotal = _valor;
                                              pagarImovel.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovel.logadouro = _log;
                                              pagarImovel.comp = _comp;
                                              pagarImovel.cidade = _cidade;
                                              pagarImovel.cep = _cep;
                                              pagarImovel.bairro = _bairro;
                                              pagarImovel.numero = _numero;
                                              pagarImovel.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovel.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovel.nome = nome;
                                              pagarImovel.cpf = cpf;
                                              pagarImovel.tipo = _tipo;
                                              pagarImovel.estado = _estado;
                                              pagarImovel.detalhes = _detalhes;
                                              pagarImovel.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovel.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovel.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;

                                              PagarImovel pagarImovels =
                                                  PagarImovel();
                                              pagarImovels.idDoPagador =
                                                  _idDono;
                                              pagarImovels.idDoRecebedor =
                                                  widget.uid;
                                              pagarImovels.tipoDoPagamento =
                                                  _tipoDoPagamento;
                                              pagarImovels.dataDoPagamento =
                                                  formatDate(_date, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy
                                              ]).toString();
                                              pagarImovels.valorDoPagamento =
                                                  _valor;
                                              pagarImovels.juroDeAtraso = "0";
                                              pagarImovels.valorTotal = _valor;
                                              pagarImovels.idDoImovel =
                                                  document['idImovel'];
                                              pagarImovels.logadouro = _log;
                                              pagarImovels.comp = _comp;
                                              pagarImovels.cidade = _cidade;
                                              pagarImovels.cep = _cep;
                                              pagarImovels.bairro = _bairro;
                                              pagarImovels.numero = _numero;
                                              pagarImovels.cpfDoDono =
                                                  _cpfDoDono;
                                              pagarImovels.nomeDoDono =
                                                  _nomeDoDono;
                                              pagarImovels.nome = nome;
                                              pagarImovels.cpf = cpf;
                                              pagarImovels.tipo = _tipo;
                                              pagarImovels.estado = _estado;
                                              pagarImovels.detalhes = _detalhes;
                                              pagarImovels.idUsuarioDoCartao =
                                                  _idUsuarioDoCartao;
                                              pagarImovels.nomeUsuarioDoCartao =
                                                  _nomeUsuarioDoCartao;
                                              pagarImovels.cpfUsuarioDoCartao =
                                                  _cpfUsuarioDoCartao;
                                              Map<String, dynamic>
                                                  dadosAtualizar = {
                                                "idPg11": widget.uid,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(_idDono)
                                                  .updateData(dadosAtualizar);
                                              Map<String, dynamic>
                                                  dadosAtualizar2 = {
                                                "idPg11": _idDono,
                                                "idImovel": document['idImovel']
                                              };
                                              db
                                                  .collection("usuarios")
                                                  .document(widget.uid)
                                                  .updateData(dadosAtualizar2);
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(widget.uid)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela12')
                                                  .setData(pagarImovel.toMap());
                                              db
                                                  .collection("pagarImoveis")
                                                  .document(_idDono)
                                                  .collection(
                                                      document['idImovel'])
                                                  .document('parcela12')
                                                  .setData(
                                                      pagarImovels.toMap());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: _idUsuarioDoCartao == null
                              ? Text(
                                  "Cadastre seu cartão",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Parcela 12" +
                                      " - Valor: " +
                                      _valor +
                                      "\nData de Venc: " +
                                      dia.substring(0, 2) +
                                      '/' +
                                      mes11 +
                                      '/' +
                                      ano2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Informação',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Vá para a tela de recibos para ver seu Comprovante deste mês',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Voltar'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Parcela 12" + " - Paga",
                            style: TextStyle(color: Colors.green, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Voltar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    _informacaoImovel() {
      _idDono = document['idDono'];
      _nomeDoDono = document['nomeDoDono'];
      _emailDoDono = document['emailDoDono'];
      _cpfDoDono = document['cpfDoDono'];
      _telefoneDoDono = document['telefoneDoDono'];
      _photoDoDono = document['urlImagemDoDono'];
      _valor = document['valorImovelAlugado'];
      _log = document['logadouroImovelAlugado'];
      _cidade = document['cidadeImovelAlugado'];
      _cep = document['cepImovelAlugado'];
      _bairro = document['bairroImovelAlugado'];
      _numero = document['numeroImovelAlugado'];
      _comp = document['complementoImovelAlugado'];
      _url = document['urlImagensImovelAlugado'];
      _deta = document['detalhesImovelAlugado'];
      _tipo = document['tipoImovelImovelAlugado'];
      _estado = document['estadoImovelAlugado'];
      _dataInicio = document['dataInicio'];
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              'Informação do Imóvel',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Tipo do Imóvel: ' +
                        _tipo +
                        '\nLocalização: ' +
                        _cidade +
                        ' - ' +
                        _estado +
                        "\nValor Mensal: " +
                        _valor,
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  CircleAvatar(
                    radius: 110,
                    backgroundColor: Colors.transparent,
                    child: Carousel(
                      images: [
                        NetworkImage(document['urlImagensImovelAlugado']),
                        NetworkImage(document['urlImagensImovelAlugado2']),
                        NetworkImage(document['urlImagensImovelAlugado3']),
                        NetworkImage(document['urlImagensImovelAlugado4']),
                        NetworkImage(document['urlImagensImovelAlugado5']),
                      ],
                      dotSize: 8,
                      dotBgColor: Colors.transparent,
                      dotColor: Colors.white,
                      autoplay: false,
                      borderRadius: true,
                      dotIncreasedColor: Colors.blue,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Logadouro: " +
                        _log +
                        ' - ' +
                        _bairro +
                        "\nComplemento: ${_comp}" +
                        '\nDetalhes: ' +
                        _deta +
                        '\nCEP: ${_cep}' +
                        ' N°: ${_numero}'
                            '\nData Inicial do contrato: ' +
                        _dataInicio,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Voltar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Informações":
          _informacaoImovel();
          break;
        case "Pagar Aluguel":
          _pagarAluguel();
          break;
        case "Cancelar Contrato com Dono":
          _cancelarContratoComDono();
          break;
      }
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            document['urlImagensImovelAlugado']
          ),
        ),
        title: Text(
          document['logadouroImovelAlugado'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          document['valorImovelAlugado'],
          textAlign: TextAlign.center,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: _escolhaMenuItem,
          itemBuilder: (context) {
            return itensMenu.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpf = dados['cpf'];
    _telefone = dados['telefone'];
    _nome = dados['nome'];
    _email = dados['email'];
    _photo = dados['photo'];
    print(
        "Locatário de id: ${widget.uid}, tem o nome de ${_nome}, seu email é ${_email}, portador do CPF: ${_cpf} e tem o telefone: ${_telefone}");
    print(_photo);
    //print(_idUsuarioLogado);

    DocumentSnapshot _snapshot =
        await db.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> _dados = _snapshot.data;

    _idUsuarioDoCartao = _dados['idUsuario'];
    _nomeUsuarioDoCartao = _dados['nomeDoTitularDoCartao'];
    _cpfUsuarioDoCartao = _dados['cpfDoTitularDoCartao'];
    print("idCartao: " + _idUsuarioDoCartao);
    print("Número Do Cartao: " + _nomeUsuarioDoCartao);
    print("CPF do Cartão: " + _cpfUsuarioDoCartao);
  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando imóveis alugado"),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Imóvel Alugado"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('imovelAlugado')
                  .document(widget.uid)
                  .collection("Detalhes")
                  .snapshots(),
              //print an integer every 2secs, 10 times
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    var docs = snapshot.data.documents;

                    if (docs.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhum imóvel alugado! :( ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return _buildList(
                              context, snapshot.data.documents[index]);
                        },
                      ),
                    );
                    break;
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
