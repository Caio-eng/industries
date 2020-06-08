import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/CadastrarCartaoDeCredito.dart';
import 'package:industries/EditarCartaoDeCredito.dart';

class MeuCartao extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  MeuCartao(this.user, this.photo, this.emai, this.uid);
  @override
  _MeuCartaoState createState() => _MeuCartaoState();
}

class _MeuCartaoState extends State<MeuCartao> {
  String _idUsuarioLogado = "";
  String _id = "";
  String _nome, _idCar, _cpfUsuario;
  String _photo;
  Firestore db = Firestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    _deletarCartao() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          if (_id == null) {
            return AlertDialog(
              title: Text(
                'Deletar Cartao',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Você deseja deletar este cartão se sim, você clicara em Excluir se não clicara em cancelar!'),
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
                            .collection("cartao")
                            .document(document.documentID)
                            .delete();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                'Deletar Cartao',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Você cadastrou seu CPF, delete seu usuario para deletar o cartão!'),
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
          }
        },
      );
    }

    return GestureDetector(
      onTap: () {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Informação do Cartão',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Divider(),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "imagens/cartao.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Divider(),
                    Text(
                        "Nome: ${document['nomeDoTitularDoCartao']}", textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("CPF: ${document['cpfDoTitularDoCartao']}", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    Divider(),
                    Text("Número: ${document['numeroDoCartao']}", textAlign: TextAlign.center,),
                    Text("Data de Vencimento: ${document['dataDeValidadeDoCartao']}", textAlign: TextAlign.center,)
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
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  "imagens/cartao.png",
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
                        document['nomeDoTitularDoCartao'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "CPF: ${document['cpfDoTitularDoCartao']}",
                        textAlign: TextAlign.center,
                      ),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarCartaoDeCredito(
                                    widget.user,
                                    widget.photo,
                                    widget.emai,
                                    widget.uid)));
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.red,
                      onPressed: () {
                        _deletarCartao();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
    setState(() {
      _id = dados['idUsuario'];
      _nome = dados['nome'];
      _photo = dados['urlImagem'];
      _cpfUsuario = dados['cpf'];

      print("_id: " + _id);
    });
  }

  _recuperarDadosCartao() async {
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot2 =
        await db.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> dados2 = snapshot2.data;

    setState(() {
      _idCar = dados2['idUsuario'];
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerCartao() async {
    Stream<QuerySnapshot> stram = db
        .collection('cartao')
        .where('idUsuario', isEqualTo: widget.uid)
        .snapshots();

    stram.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerCartao();
    _recuperarDados();
    _recuperarDadosCartao();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando meu cartão.."),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cartão de Crédito"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        icon: Icon(Icons.credit_card),
        onPressed: () {
          if (_idCar == widget.uid) {
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
                          'Existe um cadastro, se quiser edite o mesmo!',
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
          } else if (_cpfUsuario == null) {
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
                          'Cadastre o CPF do usuário, para cadastrar o cartão!',
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
          }else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CadastrarCartaoDeCredito(
                            widget.user, widget.photo, widget.emai,
                            widget.uid)));
          }
          return Container();
        },
        label: Text(
          "Cadastrar Cartão",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            StreamBuilder(
              stream: _controller.stream,
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
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "Nenhum cartão Cadastado! :( ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, index) {
                          return _buildList(
                              context, docs[index]);
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
