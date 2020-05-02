import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/AluguarImovel.dart';
import 'package:industries/model/Imovel.dart';

class MeuImovel extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  MeuImovel(this.user, this.photo, this.emai, this.uid);
  @override
  _MeuImovelState createState() => _MeuImovelState();
}

class _MeuImovelState extends State<MeuImovel> {
  String _idUsuarioLogado = "";
  String _idDono = "";
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";
  String _locado = "";
  List<String> itensMenu = ["Informações", "Cancelar Contrato"];

  Firestore db = Firestore.instance;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {

    _cancelarContrato() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancelar Contrato', textAlign: TextAlign.center,),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Você deseja cancelar o contrato se sim, você clicara em Cancelar se não clicara em Voltar!'),

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
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Imovel imovel = Imovel();
                      imovel.logadouro = document['logadouroDonoDoImovel'];
                      imovel.complemento = document['complementoDonoDoImovel'];
                      imovel.detalhes = document['detalhesDonoDoImovel'];
                      imovel.idUsuario = document['idDono'];
                      imovel.tipoImovel = document['tipoDonoDoImovel'];
                      imovel.valor = document['valorDonoDoImovel'];
                      imovel.urlImagens = document['urlImagensDonoDoImovel'];
                      imovel.estado = document['estadoDoImovel'];
                      imovel.idEstado = document['idEstadoImovel'];
                      imovel.nomeDaImagem = document['nomeDaImagemImovel'];
                      db.collection("imoveis")
                          .document()
                          .setData(imovel.toMap());
                      db.collection("meuImovel").document(document.documentID).delete();

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

    _deletar(AlugarImovel alugarImovel) {
      db.collection("imovelAlugado").document(document['idLocatario']).collection("Detalhes").document(document['idImovelAlugado']).delete();
    }
    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Informações":
          print("Informações");
          break;
        case "Cancelar Contrato":
          AlugarImovel alugarImovel = AlugarImovel();
          _deletar(alugarImovel);
          _cancelarContrato();

          break;
      }
    }
    if (document['idDono'] == _idUsuarioLogado) {
      return Padding(
          padding: const EdgeInsets.all(0),
          child: ListTile(
            title: Text(
              document['logadouroDonoDoImovel'],
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              document['complementoDonoDoImovel'],
              textAlign: TextAlign.center,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(document['urlImagensDonoDoImovel']),
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
    } else {
      return Text('________________________________________________________', style: TextStyle(color: Colors.grey),);
    }



  }


  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    //print(_idUsuarioLogado);
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
        title: Text('Meu Imóveis'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('meuImovel').snapshots(),
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
