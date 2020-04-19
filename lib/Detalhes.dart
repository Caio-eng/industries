import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/AluguelImovel.dart';

import 'Home.dart';

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
  String _idImovel = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _nomeUsuario = "";
  String _valor = "";
  String _deta = "";
  String _estado = "";
  Firestore db = Firestore.instance;


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

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idImovel).get();

    Map<String, dynamic> dados = snapshot.data;
    print(dados['nome']);
    _nomeUsuario = dados['nome'];
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
              padding: const EdgeInsets.all(50),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 110,
                    backgroundImage: NetworkImage(_url),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    _log + " - " + _comp,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 8,
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
                      "Detalhes: " + _deta + " localizada em ${_estado}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, ),
                  ),

                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10,  right: 10, left: 30),
                  child: RaisedButton(
                    child: Text(
                      "Alugar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AluguelImovel(widget.document, widget.user, widget.photo, widget.emai, widget.uid))
                      );
                    },
                  ),

                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 40),
                  child: RaisedButton(
                    child: Text(
                      "Contato",

                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      print(_idImovel);
                      print(_nomeUsuario);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
