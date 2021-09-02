import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/PropostaDoLocador.dart';
import 'package:industries/model/PropostaDoLocatario.dart';
import 'package:url_launcher/url_launcher.dart';



class Detalhes extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  var document;
  Detalhes(this.document, this.user, this.photo, this.emai, this.uid);
  @override
  _DetalhesState createState() => _DetalhesState();
}


class _DetalhesState extends State<Detalhes>  {
  String _idUsuarioLogado = "";
  String _id, _idMeu;
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
  String _locali, _cpfUser, _telefoneUser, _idAq;
  Firestore db = Firestore.instance;




  _mandarProposta() async {
    //Classe do Locatário
    PropostaDoLocatario propostaDoLocatario = PropostaDoLocatario();
    propostaDoLocatario.idLocador = _idImovel;
    propostaDoLocatario.idLocatario = widget.uid;
    propostaDoLocatario.idImovel = _idAq;
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
    propostaDoLocador.idImovel = _idAq;
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
    db.collection('imoveis').document(widget.document['idImovel']).delete();
    db.collection('meus_imoveis').document(widget.document['idUsuario']).collection("imoveis").document(widget.document['idImovel']).delete();
    Navigator.of(context).pop();
  }



  String _mensagem = '';

  _ligarTelefone(String telefone) async {

    // vai para o telefone
    if( await canLaunch("tel:$telefone") ){
      await launch("tel:$telefone");
    }else{
      print("não pode fazer a ligação");
    }
  }



  @override
  void initState() {
    super.initState();
    _recuperarDados();
  }
  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    setState(() {
      _idImovel = widget.document['idUsuario'];
    });
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
    _idAq = widget.document['idImovel'];
    print("Mostre: " + _idAq);
    //Cartao
    DocumentSnapshot snapshot3 =
    await db.collection("cartao").document(_idImovel).get();
    Map<String, dynamic> dados3 = snapshot3.data;
    setState(() {
      _id = dados3['idUsuario'];
      print("Aqui: " + _id);
    });
    DocumentSnapshot snapshot4 =
    await db.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> dados4 = snapshot4.data;
    setState(() {
      _idMeu = dados4['idUsuario'];
    });
    DocumentSnapshot snapshot =
    await db.collection("usuarios").document(widget.uid).get();

    Map<String, dynamic> dados = snapshot.data;
    print(dados['nome']);
    _nomeUsuario = dados['nome'];
    _cpfUser = dados['cpf'];
    _telefoneUser = dados['telefone'];





  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Imovel"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 250,

                child: Carousel(
                  images: [
                    NetworkImage(_url),
                    NetworkImage(_url2),
                    NetworkImage(_url3),
                    NetworkImage(_url4),
                    NetworkImage(_url5),

                  ],
                  boxFit: BoxFit.fitWidth,
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: false,
                  dotIncreasedColor: Colors.blue,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _valor,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 3),
                      child: Text(
                        "Localização: ${_locali} - ${_sig}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 3),
                      child: Text(
                        "Logradouro: ${_log}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 3),
                      child: Text(
                        "Bairro: ${_bairro} - Nº: ${_nume}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 3),
                      child: Text(
                        "Complemento: ${_comp}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_deta}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${widget.document['telefoneUsuario']}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Text(
                        "Ligar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                    onTap: () {
                      _ligarTelefone(widget.document['telefoneUsuario']);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      child: Text(
                        "Negociar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onTap: () {
                      if (_id != null && _idMeu != null) {
                        _mandarProposta();
                       } else {
                          setState(() {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Atenção',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Necessario Cadastrar o cartão de credito!',
                                          textAlign: TextAlign.center,),
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
        ],
      ),

    );
  }
}