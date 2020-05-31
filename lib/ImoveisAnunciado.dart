import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'CadastroImoveis.dart';
import 'EditarImovel.dart';

class ImoveisAnunciado extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  ImoveisAnunciado(this.user, this.photo, this.emai, this.uid);
  @override
  _ImoveisAnunciadoState createState() => _ImoveisAnunciadoState();
}

class _ImoveisAnunciadoState extends State<ImoveisAnunciado> {
  Firestore db = Firestore.instance;

  final _controller = StreamController<QuerySnapshot>.broadcast();


  Widget _buildList(BuildContext context, var document) {
    _deletarImovel() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Deletar Imóvel',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Você deseja deletar este imóvel se sim, você clicara em Excluir se não clicara em cancelar!'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);

                    },
                  ),
                  FlatButton(
                    child: Text('Excluir'),
                    onPressed: () {
                      db
                          .collection("imoveis")
                          .document(document['idImovel'])
                          .delete();
                      db.collection("meus_imoveis")
                        .document(widget.uid)
                        .collection("imoveis")
                        .document(document['idImovel']).delete();

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

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                document['urlImagens'],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      document['logadouro'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(document['valor']),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.blue,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarImovel(document, widget.user,
                                  widget.photo, widget.emai, widget.uid)));
                    },
                    child: Icon(Icons.edit, color: Colors.white,),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    onPressed: () {
                      _deletarImovel();
                    },
                    child: Icon(Icons.delete, color: Colors.white,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }


  Future<Stream<QuerySnapshot>> _adicionarListenerImoveis() async {

    Stream<QuerySnapshot> stram = db
        .collection("meus_imoveis").document(widget.uid)
        .collection("imoveis")
        .snapshots();

    stram.listen((dados){
      _controller.add(dados);
    });

  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerImoveis();
  }


  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando meus imóveis.."),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Meus Imóveis"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CadastroImoveis(
                      widget.user, widget.photo, widget.emai, widget.uid)));
        },
        label: Text("Cadastrar", style: TextStyle(fontSize: 18),),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:

                    var docs = snapshot.data.documents;

                    if( docs.length == 0 ){
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: Text("Nenhum imóvel Cadastado! :( ",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, indice){
                          return _buildList(
                              context, docs[indice]
                          );
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
