import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/AluguelImovel.dart';
import 'package:industries/model/Conversa.dart';
import 'package:industries/model/Proposta.dart';
import 'package:industries/telas/Mensagens.dart';

import 'Home.dart';
import 'model/Usuario.dart';

class Detalhes extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  final DocumentSnapshot document;
  Detalhes(this.document, this.user, this.photo, this.emai, this.uid);
  @override
  _DetalhesState createState() => _DetalhesState();
}


class _DetalhesState extends State<Detalhes>  {
  String _idUsuarioLogado = "";
  String _id;
  String _idImovel = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _nomeUsuario = "";
  String _valor = "";
  String _deta = "";
  String _estado = "";
  String _nume = "";
  String _cep = "";
  String _bairro = "";
  String _sig;
  String _locali, _cpfUser, _telefoneUser;
  Firestore db = Firestore.instance;


  _mandarProposta() async {
    //Proposta para o Dono
    Proposta propostaD = Proposta();
    propostaD.idProposta = _idImovel;
    propostaD.idCotra = widget.uid;
    propostaD.idImovel = widget.document.documentID;
    propostaD.idPropostaUsuarioLogado = widget.uid;
    propostaD.id = _idImovel;
    propostaD.numero = _nume;
    propostaD.bairro = _bairro;
    propostaD.cep = _cep;
    propostaD.cidade = _locali;
    propostaD.estado = _sig;
    propostaD.detalhes = _deta;
    propostaD.urlImagens = _url;
    propostaD.valor = _valor;
    propostaD.tipo = _tipo;
    propostaD.complemento = _comp;
    propostaD.logadouro = _log;
    propostaD.nomeDaImagem = widget.document['nomeDaImagem'];
    propostaD.telefone = widget.document['telefoneUsuario'];
    propostaD.cpf = widget.document['cpfUsuario'];
    propostaD.proposta = 'Prop. enviada pelo locatário';
    db.collection("propostas").document(_idImovel).setData(propostaD.toMap());

    Proposta proposta = Proposta();
    proposta.idImovel = widget.document.documentID;
    proposta.idProposta = _idImovel;
    proposta.idCotra = widget.uid;
    proposta.idPropostaUsuarioLogado = _idImovel;
    proposta.id = widget.uid;
    proposta.numero = _nume;
    proposta.bairro = _bairro;
    proposta.cep = _cep;
    proposta.cidade = _locali;
    proposta.estado = _sig;
    proposta.detalhes = _deta;
    proposta.urlImagens = _url;
    proposta.valor = _valor;
    proposta.tipo = _tipo;
    proposta.complemento = _comp;
    proposta.logadouro = _log;
    proposta.nomeDaImagem = widget.document['nomeDaImagem'];
    proposta.telefone = _telefoneUser;
    proposta.cpf = _cpfUser;
    proposta.proposta = 'Aguardando Envio do Contrato';
    db.collection("propostas").document(widget.uid).setData(proposta.toMap());
    db.collection('imoveis').document(widget.document.documentID).delete();
    Navigator.pop(context);
  }



  String _mensagem = '';



  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }
  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    _idImovel = widget.document['idUsuario'];
    _url = widget.document['urlImagens'];
    _log = widget.document['logadouro'];
    _comp = widget.document['complemento'];
    _tipo = widget.document['tipoImovel'];
    _valor = widget.document['valor'];
    _deta = widget.document['detalhes'];
    _estado = widget.document['estado'];
    _nume = widget.document['numero'];
    _cep = widget.document['cep'];
    _bairro = widget.document['bairro'];
    _sig = widget.document['siglaEstado'];
    _locali = widget.document['cidade'];
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idImovel).get();

    Map<String, dynamic> dados = snapshot.data;
    print(dados['nome']);
    _nomeUsuario = dados['nome'];
    _cpfUser = dados['cpf'];
    _telefoneUser = dados['telefone'];

    //Cartao
    DocumentSnapshot snapshot3 =
    await db.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> dados3 = snapshot3.data;
    setState(() {
      _id = dados3['idUsuario'];
      print("Aqui: " + _id);
    });

    ;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Imovel"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: <Widget>[
                  Text(
                      "Localização: ${_locali} - " + _sig,
                      style: TextStyle(fontSize: 16),
                    ),
                  SizedBox(
                    height: 3,
                  ),
                  CircleAvatar(
                    radius: 110,
                    backgroundImage: NetworkImage(_url),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    _log + " - " + _bairro + " " +  _comp + " Nº ${_nume}" + "\nCEP: ${_cep}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Valor do Imóvel: " + _valor,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      _deta,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10,  right: 10, left: 30),
              child: RaisedButton(
                child: Text(
                  "Enviar Proposta de Aluguel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => AluguelImovel(widget.document, widget.user, widget.photo, widget.emai, widget.uid))
//                      );
                  if (_id == widget.uid) {
                    _mandarProposta();
                  } else {
                    _mensagem = 'Para mandar a proposta neste imovel é necessario ter cadastrado o cartão';
                  }
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
