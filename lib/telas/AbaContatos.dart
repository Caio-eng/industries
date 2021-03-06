import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/Conversa.dart';
import 'package:industries/model/Usuario.dart';
import 'package:industries/telas/Mensagens.dart';

class AbaContatos extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  AbaContatos(this.user, this.photo, this.emai, this.uid);
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  String _idUsuarioLogado;
  String _emailUsuarioLogado;
  String _nomeUsuarioLogado;

  Future<List<Usuario>> _recuperarContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();
    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados['email'] == widget.emai) continue;

      Usuario usuario = Usuario();
      usuario.idUsuario = item.documentID;
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.photo = dados['photo'];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);
    }
    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    setState(() {
      _idUsuarioLogado = widget.uid;
    });
    _emailUsuarioLogado = widget.emai;
    _nomeUsuarioLogado = widget.user;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            FutureBuilder<List<Usuario>>(
              future: _recuperarContatos(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text("Carregando contatos"),
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, indice) {
                            List<Usuario> listaItens = snapshot.data;
                            Usuario usuario = listaItens[indice];

                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Mensagens(
                                            usuario,
                                            widget.user,
                                            widget.photo,
                                            widget.emai,
                                            widget.uid)));
                              },
                              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              leading: CircleAvatar(
                                  maxRadius: 30,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: usuario.urlImagem != null
                                      ? NetworkImage(usuario.urlImagem)
                                      : NetworkImage(usuario.photo)),
                              title: Text(
                                usuario.nome,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            );
                          }),
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
