import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/Imovel.dart';


class Propostas extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  Propostas(this.user, this.photo, this.emai, this.uid);

  @override
  _PropostasState createState() => _PropostasState();
}

class _PropostasState extends State<Propostas> {

  Firestore db = Firestore.instance;
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    if (document['idProposta'] == widget.uid)  {
      _aceitarContrato() async {

      }

      _CancelarContrato() async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Cancelar Contrato',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Você deseja cancelar o contrato com Locatário!'),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Não'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Sim'),
                      onPressed: () {
                        Imovel imovel = Imovel();
                        imovel.logadouro = document['logadouro'];
                        imovel.complemento = document['complemento'];
                        imovel.valor = document['valor'];
                        imovel.urlImagens = document['urlImagens'];
                        imovel.detalhes = document['detalhes'];
                        imovel.siglaEstado = document['estado'];
                        imovel.cidade = document['cidade'];
                        imovel.cep = document['cep'];
                        imovel.bairro = document['bairro'];
                        imovel.numero = document['numero'];
                        imovel.tipoImovel = document['tipo'];
                        imovel.idUsuario = widget.uid;
                        imovel.nomeDaImagem = document['nomeDaImagem'];
                        imovel.cpfUsuario = document['cpf'];
                        imovel.telefoneUsuario = document['telefone'];
                        db.collection("imoveis").document().setData(imovel.toMap());
                        db
                            .collection("propostas")
                            .document(document['idCotra'])
                            .delete();
                        db
                            .collection("propostas")
                            .document(document.documentID)
                            .delete();

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

      List<String> itensMenu = ["Aceitar Contrato", "Cancelar Contrato"];
      _escolhaMenuItem(String itemEscolhido) {
        switch (itemEscolhido) {
          case "Aceitar Contrato":
            _aceitarContrato();
            break;
          case "Cancelar Contrato":
            _CancelarContrato();
            break;
        }
      }



      return Card(
        child:  ListTile(
          title: GestureDetector(
            onTap: () async {
              Firestore db = Firestore.instance;
              DocumentSnapshot snapshot =
              await db.collection("usuarios").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados = snapshot.data;
              String _nome, _email, _photo;
              setState(() {
                _nome = dados['nome'];
                _email = dados['email'];
                _photo = dados['photo'];
              });
              String _numero, _nomeDoCartao, _cpfDoCartao;
              DocumentSnapshot snapshot2 =
              await db.collection("cartao").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados2 = snapshot2.data;
              setState(() {
                _numero = dados2['numeroDoCartao'];
                _nomeDoCartao = dados2['nomeDoTitularDoCartao'];
                _cpfDoCartao = dados2['cpfDoTitularDoCartao'];
              });
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Informações do Locatário',
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(_photo),
                          ),
                          Divider(),
                          Text(
                            "Nome: " + _nome +
                                ' - Email: ' + _email +
                                '\nTelefone: ' + document['telefone'] +
                                '\nCPF: ' + document['cpf'],
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Text(
                            "Possui Cartão Cadastrado" +
                                "\nNumero: " + _numero +
                                "\nNome do Cartão: " + _nomeDoCartao +
                                "\nCPF do Cartão: " + _cpfDoCartao,
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Text("Clique para anexar o contrato!", textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: RaisedButton(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.photo, color: Colors.white,),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Galeria', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
                                ],
                              ),
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              onPressed: () {

                              },
                            ),
                          ),
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
                            child: Text('Enviar Contrato'),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              document['proposta'],
              textAlign: TextAlign.center,

            ),
          ),
          leading: Icon(Icons.business_center),
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
    } else {
      _aceitarContrato() async {

      }
      _CancelarContrato() async {

      }
      List<String> itensMenu = ["Informações Do Locador ", "Cancelar Contrato"];
      _escolhaMenuItem(String itemEscolhido) {
        switch (itemEscolhido) {
          case "Informações Do Locador ":
            _aceitarContrato();
            break;
          case "Cancelar Contrato":
            _CancelarContrato();
            break;
        }
      }
      return Card(
        child:  ListTile(
          title: GestureDetector(
            onTap: () async {
              Firestore db = Firestore.instance;
              DocumentSnapshot snapshot =
              await db.collection("usuarios").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados = snapshot.data;
              String _nome, _email, _photo;
              setState(() {
                _nome = dados['nome'];
                _email = dados['email'];
                _photo = dados['photo'];
              });
              String _numero, _nomeDoCartao, _cpfDoCartao;
              DocumentSnapshot snapshot2 =
              await db.collection("cartao").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados2 = snapshot2.data;
              setState(() {
                _numero = dados2['numeroDoCartao'];
                _nomeDoCartao = dados2['nomeDoTitularDoCartao'];
                _cpfDoCartao = dados2['cpfDoTitularDoCartao'];
              });
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Proposta do Locatário',
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(_photo),
                          ),
                          Divider(),
                          Text(
                            "Nome: " + _nome +
                                ' - Email: ' + _email +
                                '\nTelefone: ' + document['telefone'] +
                                '\nCPF: ' + document['cpf'],
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Text(
                            "Possui Cartão Cadastrado" +
                                "\nNumero: " + _numero +
                                "\nNome do Cartão: " + _nomeDoCartao +
                                "\nCPF do Cartão: " + _cpfDoCartao,
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Text("Clique para anexar o contrato!", textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: RaisedButton(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.photo, color: Colors.white,),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Galeria', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
                                ],
                              ),
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              onPressed: () {

                              },
                            ),
                          ),
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
                            child: Text('Enviar Contrato Assinado'),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              document['proposta'],
              textAlign: TextAlign.center,

            ),
          ),
          leading: Icon(Icons.business_center),
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


  }



  @override
  void initState() {

    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Propostas"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),

            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('propostas').where('id', isEqualTo: widget.uid).snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  var docs = snapshot.data.documents;


                  return ListView.builder(
                    itemExtent: 80.0,
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      return _buildList(
                          context, docs[index]);
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
