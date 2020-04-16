import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";

  List<String> itensMenu = [
    "Informações", "Cancelar Contrato"
  ];

  Firestore db = Firestore.instance;


  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    if ( document['idLocatario'] == widget.uid ) {
      return Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              document['logadouroImovelAlugado'],
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              document['complementoImovelAlugado'],
              textAlign: TextAlign.center,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(document['urlImagensImovelAlugado']),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          )
      );
    }

    else {
      return Center(
        child: Text("Tratar dado"),
      );
    }

  }

  _recuperarDados() async {
/*
    _idDono = widget.document['idLocatario'];
    _idUsuarioLogado = widget.uid;
    _url = widget.document['urlImagens'];
    _log = widget.document['logadouroImovelAlugado'];
    _comp = widget.document['complemento'];
    _tipo = widget.document['tipoImovel'];
    _valor = widget.document['valor'];
    print("Id do dono: " + widget.document['idUsuario']);
    print(widget.uid);
*/
    DocumentSnapshot snapshot =
    await db.collection("imovelAlugado").document().get();

    Map<String, dynamic> dados = snapshot.data;
    //_idImovel = dados['idUsuario'];
    _url = dados['urlImagens'];
    _log = dados['logadouroImovelAlugado'];
    _comp = dados['complemento'];
    _tipo = dados['tipoImovel'];
    _valor= dados['valor'];
  }

  _escolhaMenuItem(String itemEscolhido) {

    switch ( itemEscolhido ){
      case "Informações":
        print("Informações");
        break;
      case "Cancelar Contrato":
        print("Cancelar Contrato");
        break;
    }

  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Imóvel Alugado"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('imovelAlugado').snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {

              return _buildList(context, snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }
}
