import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/AluguelImovel.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/model/Proposta.dart';


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
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  File _imagem;
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    if (document['idProposta'] == widget.uid)  {
      _aceitarContrato() async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AluguelImovel(document, widget.user, widget.photo, widget.emai, widget.uid)));
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






      _atualizarUrlImagemFirestore(String url) {
        Map<String, dynamic> dadosAtualizar = {"url": url};

        Firestore db = Firestore.instance;
        db.collection("propostas").document(document.documentID).updateData(dadosAtualizar);
        db.collection("propostas").document(document['idCotra']).updateData(dadosAtualizar);
        Navigator.pop(context);
      }

      Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
        String url = await snapshot.ref.getDownloadURL();
        _atualizarUrlImagemFirestore(url);

        setState(() {
          _urlImagemRecuperada = url;
        });
      }

      Future _uploadImagem() async {
        String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseStorage storage = FirebaseStorage.instance;
        StorageReference pastaRaiz = storage.ref();
        StorageReference arquivo = pastaRaiz
            .child("propostas")
            .child(widget.uid)
            .child(nomeImagem + ".jpg");
        //Upload da imagem
        StorageUploadTask task = arquivo.putFile(_imagem);

        //Controlar progresso do upload
        task.events.listen((StorageTaskEvent storageEvent) {
          if (storageEvent.type == StorageTaskEventType.progress) {
            setState(() {
              _subindoImagem = true;
            });
          } else if (storageEvent.type == StorageTaskEventType.success) {
            setState(() {
              _subindoImagem = false;
            });
          }
        });

        //Recuperar url da imagem
        task.onComplete.then((StorageTaskSnapshot snapshot) {
          _recuperarUrlImagem(snapshot);
        });
      }

      Future _recuperarImagem(String origemImagem) async {
        File imagemSelecionada;
        switch (origemImagem) {
          case "galeria":
            imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
            break;
        }

        setState(() {
          _imagem = imagemSelecionada;
          _uploadImagem();
        });
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
                          document['url'] != null && document['url2'] == null
                          ? Text("Imagem Anexada!", textAlign: TextAlign.center,)
                          : document['url2'] != null
                          ? Text('Contrato assinado pelo Locatário!', textAlign: TextAlign.center,)
                          : Text("Clique para anexar o contrato!", textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          document['url'] != null
                          ? Container()
                          : Center(
                            child:  RaisedButton(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.photo, color: Colors.white,),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('Enviar Contrato', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                                ],
                              ),
                              color: Colors.blue,
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              onPressed: () {
                                _recuperarImagem("galeria");
                              },
                            )
                          ),
                          Divider(),
                          _subindoImagem
                              ? CircularProgressIndicator()
                              : Container(),
                        document['url'] != null && document['url2'] == null
                          ? Image.network(document['url'],)
                          : document['url2'] != null
                          ? Image.network(document['url2'])
                          : Text("Selecione Enviar  Contrato, e aguarde a assinatura do Dono!", textAlign: TextAlign.center,),
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
//                          document['url'] != null && document['url2'] == null
//                          ? Container()
//                          : FlatButton(
//                            child: Text('Enviar Contrato'),
//                            onPressed: () {
//                              _atualizarUrlImagemFirestore(_urlImagemRecuperada);
//                            },
//                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: document['url'] != null && document['url2'] == null
            ? Text('Aguardando Assinatura do contrato pelo Locátario', textAlign: TextAlign.center,)
            : document['url2'] != null
            ? Text('Contrato assinado pelo locatário!', textAlign: TextAlign.center,)
            : Text(document['proposta'], textAlign: TextAlign.center,),
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
      _CancelarContrato() async {

      }
      List<String> itensMenu = ["Cancelar Contrato"];
      _escolhaMenuItem(String itemEscolhido) {
        switch (itemEscolhido) {
          case "Cancelar Contrato":
            _CancelarContrato();
            break;
        }
      }

      _atualizarUrlImagemFirestore(String url) {
        Map<String, dynamic> dadosAtualizar = {"url2": url};

        Firestore db = Firestore.instance;
        db.collection("propostas").document(document.documentID).updateData(dadosAtualizar);
        db.collection("propostas").document(document['idProposta']).updateData(dadosAtualizar);
        Navigator.pop(context);
      }

      Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
        String url = await snapshot.ref.getDownloadURL();
        _atualizarUrlImagemFirestore(url);

        setState(() {
          _urlImagemRecuperada = url;
        });
      }

      Future _uploadImagem() async {
        String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseStorage storage = FirebaseStorage.instance;
        StorageReference pastaRaiz = storage.ref();
        StorageReference arquivo = pastaRaiz
            .child("propostas")
            .child(widget.uid)
            .child(nomeImagem + ".jpg");
        //Upload da imagem
        StorageUploadTask task = arquivo.putFile(_imagem);

        //Controlar progresso do upload
        task.events.listen((StorageTaskEvent storageEvent) {
          if (storageEvent.type == StorageTaskEventType.progress) {
            setState(() {
              _subindoImagem = true;
            });
          } else if (storageEvent.type == StorageTaskEventType.success) {
            setState(() {
              _subindoImagem = false;
            });
          }
        });

        //Recuperar url da imagem
        task.onComplete.then((StorageTaskSnapshot snapshot) {
          _recuperarUrlImagem(snapshot);
        });
      }

      Future _recuperarImagem(String origemImagem) async {
        File imagemSelecionada;
        switch (origemImagem) {
          case "galeria":
            imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
            break;
        }

        setState(() {
          _imagem = imagemSelecionada;
          _uploadImagem();
        });
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
                      'Proposta do Proprietário',
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
                          document['url'] != null && document['url2'] == null
                          ? Text('Contrato do Locador disponivel abaixo!', textAlign: TextAlign.center,)
                          : document['url2'] != null
                          ? Container()
                          : Text('O Contrato estará disponivel aqui, aguardando a resposta!', textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),
                          _subindoImagem
                              ? CircularProgressIndicator()
                              : Container(),

                          document['url'] != null && document['url2'] == null
                              ? Image.network(
                            document['url'],)
                              : document['url2'] != null
                              ? Image.network(document['url2'])
                              : Container(),

                          Divider(),

                        document['url'] != null && document['url2'] == null
                          ? Center(
                        child: RaisedButton(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.white,),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Enviar Contrato', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                            ],
                          ),
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          onPressed: () {
                            _recuperarImagem("galeria");
                          },
                        ),
                      )
                          :Container(),
                          Divider(),
                          document['url'] != null && document['url2'] == null
                          ? Text('Clique em Enviar Contrato e anexe o contrato assinado, ao selecionar o contrato será enviado automáticamente ao Locatário!', textAlign: TextAlign.center,)
                          : document['url2'] != null
                          ? Text('Contrato Anexado!', textAlign: TextAlign.center,)
                          : Container(),
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
//                          document['url'] != null && document['url2'] == null
//                          ? FlatButton(
//                            child: Text('Enviar Contrato Assinado'),
//                            onPressed: () {
//
//                              _atualizarUrlImagemFirestore(_urlImagemRecuperada);
//                            },
//                          )
//                          : Container(),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: document['url'] != null && document['url2'] == null
            ? Text('Contrato disp. para assinar')
            : document['url2'] != null
            ? Text('Aguardando o Proprietario aceitar o contrato!')
            :Text(document['proposta'],
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
