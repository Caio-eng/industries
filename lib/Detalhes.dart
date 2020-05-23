import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/AluguelImovel.dart';
import 'package:industries/model/Conversa.dart';
import 'package:industries/model/Proposta.dart';
import 'package:industries/model/PropostaDoLocador.dart';
import 'package:industries/model/PropostaDoLocatario.dart';
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
  String _url, _url2, _url3, _url4, _url5;
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
    //Classe do Locatário
    PropostaDoLocatario propostaDoLocatario = PropostaDoLocatario();
    propostaDoLocatario.idLocador = _idImovel;
    propostaDoLocatario.idLocatario = widget.uid;
    propostaDoLocatario.idImovel = widget.document.documentID;
    propostaDoLocatario.numero = _nume;
    propostaDoLocatario.bairro = _bairro;
    propostaDoLocatario.cep = _cep;
    propostaDoLocatario.cidade = _locali;
    propostaDoLocatario.estado = _sig;
    propostaDoLocatario.detalhes = _deta;
    propostaDoLocatario.urlImagens = _url;
    propostaDoLocatario.urlImagens2 = _url2;
    propostaDoLocatario.urlImagens3 = _url3;
    propostaDoLocatario.urlImagens4 = _url4;
    propostaDoLocatario.urlImagens5 = _url5;
    propostaDoLocatario.valor = _valor;
    propostaDoLocatario.tipo = _tipo;
    propostaDoLocatario.complemento = _comp;
    propostaDoLocatario.logadouro = _log;
    propostaDoLocatario.nomeDaImagem = widget.document['nomeDaImagem'];
    propostaDoLocatario.nomeDaImagem2 = widget.document['nomeDaImagem2'];
    propostaDoLocatario.nomeDaImagem3 = widget.document['nomeDaImagem3'];
    propostaDoLocatario.nomeDaImagem4 = widget.document['nomeDaImagem4'];
    propostaDoLocatario.nomeDaImagem5 = widget.document['nomeDaImagem5'];
    propostaDoLocatario.telefone = widget.document['telefoneUsuario'];
    propostaDoLocatario.cpf = widget.document['cpfUsuario'];
    db.collection("propostasDoLocatario").document(widget.uid).setData(propostaDoLocatario.toMap());

    PropostaDoLocador propostaDoLocador = PropostaDoLocador();
    propostaDoLocador.idLocador = _idImovel;
    propostaDoLocador.idLocatario = widget.uid;
    propostaDoLocador.idImovel = widget.document.documentID;
    propostaDoLocador.numero = _nume;
    propostaDoLocador.bairro = _bairro;
    propostaDoLocador.cep = _cep;
    propostaDoLocador.cidade = _locali;
    propostaDoLocador.estado = _sig;
    propostaDoLocador.detalhes = _deta;
    propostaDoLocador.urlImagens = _url;
    propostaDoLocador.urlImagens2 = _url2;
    propostaDoLocador.urlImagens3 = _url3;
    propostaDoLocador.urlImagens4 = _url4;
    propostaDoLocador.urlImagens5 = _url5;
    propostaDoLocador.valor = _valor;
    propostaDoLocador.tipo = _tipo;
    propostaDoLocador.complemento = _comp;
    propostaDoLocador.logadouro = _log;
    propostaDoLocador.nomeDaImagem = widget.document['nomeDaImagem'];
    propostaDoLocador.nomeDaImagem2 = widget.document['nomeDaImagem2'];
    propostaDoLocador.nomeDaImagem3 = widget.document['nomeDaImagem3'];
    propostaDoLocador.nomeDaImagem4 = widget.document['nomeDaImagem4'];
    propostaDoLocador.nomeDaImagem5 = widget.document['nomeDaImagem5'];
    propostaDoLocador.telefone = _telefoneUser;
    propostaDoLocador.cpf = _cpfUser;
    db.collection("propostasDoLocador").document(_idImovel).setData(propostaDoLocador.toMap());
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
    _url2 = widget.document['url2'];
    _url3 = widget.document['url3'];
    _url4 = widget.document['url4'];
    _url5 = widget.document['url5'];
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
        await db.collection("usuarios").document(widget.uid).get();

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
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 110,
                    child: Carousel(
                      images: [
                        _url != null
                        ? NetworkImage(_url)
                        : NetworkImage(''),
                        _url2 != null
                        ? NetworkImage(_url2)
                        : NetworkImage(''),
                        _url3 != null
                        ? NetworkImage(_url3)
                        : NetworkImage(''),
                        _url4 != null
                        ? NetworkImage(_url4)
                        : NetworkImage(''),
                        _url5 != null
                        ? NetworkImage(_url5)
                        : NetworkImage(''),
                      ],
                      dotSize: 4,
                      dotSpacing: 15,
                      dotBgColor: Colors.blue.withOpacity(0.5),
                      indicatorBgPadding: 4,
                      borderRadius: true,
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Informações Extras',
                              textAlign: TextAlign.center,
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('4 Quartos, Sala, Cozinha', textAlign: TextAlign.center,),
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
                    child: Card(
                      color: Colors.white.withOpacity(0.8),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Localização: ${_locali} - " + _sig,
                            style: TextStyle(fontSize: 17),
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
                            height: 3,
                          ),
                          Text(
                            _deta,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, ),
                          ),
                        ],
                      ),
                    ),
                  )


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
                    setState(() {
                      _mensagem = 'Para mandar a proposta neste imovel é necessario ter cadastrado o cartão';
                    });
                  }
                },
              ),

            ),
            Center(
              child: Text(
                _mensagem,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
