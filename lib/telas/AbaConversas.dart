import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/Conversa.dart';
import 'package:industries/model/Usuario.dart';
import 'package:industries/telas/Mensagens.dart';

class AbaConversas extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  AbaConversas(this.user, this.photo, this.emai, this.uid);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _listaConversas = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;


  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

    Conversa conversa = Conversa();
    conversa.nome = "Scream";
    conversa.mensagem = "Top mano";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/industries-6e1c0.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=e14c2bef-1a5c-4781-9793-732dd45a7031";

    _listaConversas.add(conversa);

  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {

    final stream = db.collection("conversas")
        .document( _idUsuarioLogado )
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add( dados );
    });

  }

  _recuperarDadosUsuario() async {
    _idUsuarioLogado = widget.uid;

    _adicionarListenerConversas();

  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if( snapshot.hasError ) {
              return Text("Erro ao carregar os dados!");
            }else {

              QuerySnapshot querySnapshot = snapshot.data;

              if( querySnapshot.documents.length == 0 ) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :( ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: _listaConversas.length,
                  itemBuilder: (context, indice) {

                    List<DocumentSnapshot> conversas = querySnapshot.documents.toList();
                    DocumentSnapshot item = conversas[indice];

                    String urlImagem = item["caminhoFoto"];
                    String tipo = item["tipoMensagem"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];
                    String idDestinatario = item["idDestinatario"];

                    Usuario usuario = Usuario();
                    usuario.nome = nome;
                    usuario.urlImagem = urlImagem;
                    usuario.idUsuario = idDestinatario;

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Mensagens(usuario, widget.user, widget.photo, widget.emai, widget.uid)));
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: urlImagem != null
                          ? NetworkImage( urlImagem )
                          : null,
                      ),
                      title: Text(
                        nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                        tipo=="texto"
                            ? mensagem
                            : "Imagem...",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14
                        ),
                      ),
                    );
                  }
              );

            }
        }
      },
    );

  }
}
