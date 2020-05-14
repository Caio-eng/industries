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
  String _nome;
  String _photo;
  Firestore db = Firestore.instance;

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

    List<String> itensMenu = ["Editar", "Deletar"];
    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Editar":
          print("Editar");
          Navigator.push(
              context,
              MaterialPageRoute(
                 builder: (context) => EditarCartaoDeCredito(widget.user,
                      widget.photo, widget.emai, widget.uid)));
          break;
        case "Deletar":
          print("Deletar");
          _deletarCartao();
          break;
      }
    }
    return Card(
      child: ListTile(
        title: Text(
          document['nomeDoTitularDoCartao'] + '\nCPF: ${document['cpfDoTitularDoCartao']}',
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          "Cartão: " + document['numeroDoCartao'],
          textAlign: TextAlign.center,
        ),
        leading: Icon(Icons.credit_card),
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
    setState(() {
      _id = dados['idUsuario'];
      _nome = dados['nome'];
      _photo = dados['urlImagem'];

      print("_id: " + _id);
    });
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
        title: Text("Cartão de Crédito"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastrarCartaoDeCredito(widget.user,
                        widget.photo, widget.emai, widget.uid)
                  ));
            },
            child: Icon(Icons.credit_card),
          ),
          Padding(
            padding: EdgeInsets.only(right: 18),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            Expanded (
             child :StreamBuilder(
                stream: Firestore.instance.collection('cartao').where('idUsuario', isEqualTo: _idUsuarioLogado).snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }

                  return ListView.builder(
                    itemExtent: 80.0,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) {
                      return _buildList(
                          context, snapshot.data.documents[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
