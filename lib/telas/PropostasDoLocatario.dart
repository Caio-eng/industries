import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/model/PropostaDoLocatario.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/Imovel.dart';


class PropostasDoLocatario extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  PropostasDoLocatario(this.user, this.photo, this.emai, this.uid);
  @override
  _PropostasDoLocatarioState createState() => _PropostasDoLocatarioState();
}

class _PropostasDoLocatarioState extends State<PropostasDoLocatario> {
  String _urlImagemRecuperada;
  File _imagem;
  bool _subindoImagem = false;
  Firestore db = Firestore.instance;
  String _id;
  BuildContext _dialogContext;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Widget _buildList(BuildContext context, var document) {

    _abrirDialog(BuildContext context){

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20,),
                  Text("Carregando...")
                ],
              ),
            );
          }
      );

    }

    _atualizarUrlImagemFirestore(String url) {
      Map<String, dynamic> dadosAtualizar = {"url2": url};

      Firestore db = Firestore.instance;
      db.collection("propostasDoLocatario").document(widget.uid).updateData(dadosAtualizar);
      db.collection("propostasDoLocador").document(document['idLocador']).updateData(dadosAtualizar);
      Navigator.pop(_dialogContext);
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
      _abrirDialog(_dialogContext);
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference pastaRaiz = storage.ref();
      StorageReference arquivo = pastaRaiz
          .child("propostasDoLocatario")
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

    _CancelarContrato() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Recusar Proposta',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Você deseja recusa a proposta do Locador!'),
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
                      Firestore db = Firestore.instance;
                      Imovel imovel = Imovel();
                      imovel.logadouro = document['logadouro'];
                      imovel.complemento = document['complemento'];
                      imovel.valor = document['valor'];
                      imovel.idImovel = document['idImovel'];
                      imovel.urlImagens = document['urlImagens'];
                      imovel.url2 = document['urlImagens2'];
                      imovel.url3 = document['urlImagens3'];
                      imovel.url4 = document['urlImagens4'];
                      imovel.url5 = document['urlImagens5'];
                      imovel.detalhes = document['detalhes'];
                      imovel.siglaEstado = document['estado'];
                      imovel.cidade = document['cidade'];
                      imovel.cep = document['cep'];
                      imovel.bairro = document['bairro'];
                      imovel.numero = document['numero'];
                      imovel.tipoImovel = document['tipo'];
                      imovel.idUsuario = document['idLocador'];
                      imovel.nomeDaImagem = document['nomeDaImagem'];
                      imovel.nomeDaImagem2 = document['nomeDaImagem2'];
                      imovel.nomeDaImagem3 = document['nomeDaImagem3'];
                      imovel.nomeDaImagem4 = document['nomeDaImagem4'];
                      imovel.nomeDaImagem5 = document['nomeDaImagem5'];
                      imovel.cpfUsuario = document['cpf'];
                      imovel.telefoneUsuario = document['telefone'];
                      db.collection("imoveis").document(document['idImovel']).setData(imovel.toMap());
                      db.collection("meus_imoveis").document(document['idLocador']).collection("imoveis").document(document['idImovel']).setData(imovel.toMap());
                      db
                          .collection("propostasDoLocatario")
                          .document(widget.uid)
                          .delete();
                      db
                          .collection("propostasDoLocador")
                          .document(document['idLocador'])
                          .delete();

                      Navigator.pop(context);
                      Navigator.pop(context);
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
    List<String> itensMenu = ["Recusar Proposta"];
    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Recusar Proposta":
          _CancelarContrato();
          break;
      }
    }

    return Card(
      child: ListTile(

        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        leading: Icon(Icons.business_center),
        title: GestureDetector(
          onTap: () async {
            Firestore db = Firestore.instance;
            DocumentSnapshot snapshot =
            await db.collection("usuarios").document(document['idLocador']).get();
            Map<String, dynamic> dados = snapshot.data;
            String _nome, _email, _photo;
            setState(() {
              _nome = dados['nome'];
              _email = dados['email'];
              _photo = dados['photo'];
            });
            String _numero, _nomeDoCartao, _cpfDoCartao;
            DocumentSnapshot snapshot2 =
            await db.collection("cartao").document(document['idLocador']).get();
            Map<String, dynamic> dados2 = snapshot2.data;
            setState(() {
              _numero = dados2['numeroDoCartao'];
              _nomeDoCartao = dados2['nomeDoTitularDoCartao'];
              _cpfDoCartao = dados2['cpfDoTitularDoCartao'];
            });
            verContrato(String link) async {
              //telefone = _imovel.fotos[0];

              //Abre link passado
              if( await canLaunch(link) ){
                await launch(link);
              }else{
                print("não pode fazer a ligação");
              }

            }


            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    document['finalizado'] != null
                        ? 'Informações do Locador'
                        : 'Proposta do Locador',
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
                            ? GestureDetector(
                          onTap: (){
                            verContrato(document['url']);
                          },
                          child: Text('Clique aqui para acessar o Contrato abaixo', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
                        )
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
                              //Configura dialog context
                              _dialogContext = context;
                              _recuperarImagem("galeria");
                            },
                          ),
                        )
                            :Container(),
                        Divider(),
                        document['url'] != null && document['url2'] == null
                            ? Text('Clique em Enviar Contrato e anexe o contrato assinado, ao selecionar o contrato será enviado automáticamente ao Locatário!', textAlign: TextAlign.center,)
                            : document['url2'] != null && document['finalizado'] == null
                            ? GestureDetector(
                          onTap: (){
                            verContrato(document['url2']);
                          },
                          child: Text('Contrato Anexado!, Clique para acessa-lo', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
                        )
                            : document['finalizado'] != null
                            ? GestureDetector(
                          onTap: (){
                            verContrato(document['url2']);
                          },
                          child: Text(
                            'Você possui um contrato ativo com o Locador ' + _nome + "\nClique aqui para acessa-lo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
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
                      ],
                    ),
                  ],
                );
              },
            );
          },
          child: document['url'] != null && document['url2'] == null
              ? Text(
            'Contrato disp. para assinar',
            textAlign: TextAlign.center,
          )
              : document['url2'] != null && document['finalizado'] == null
              ? Text(
            'Aguardando o Locador aceitar o contrato!',
            textAlign: TextAlign.center,
          )
              : document['finalizado'] != null
              ? Text('Imóvel Alugado', textAlign: TextAlign.center,)
              : Text('Solicitação enviada para o Locador', textAlign: TextAlign.center,),
        ),
        trailing: document['finalizado'] != null
            ? Icon(Icons.verified_user, color: Colors.blue,)
            : PopupMenuButton<String>(
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


  Future<List<PropostaDoLocatario>> _recuperarPropostas() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
    await db.collection("propostasDoLocatario").getDocuments();
    List<PropostaDoLocatario> listaPropostas = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados['idLocatario'] != widget.uid) continue;
      PropostaDoLocatario propostaDoLocatario = PropostaDoLocatario();
      propostaDoLocatario.idLocatario = dados['idLocatario'];
      propostaDoLocatario.idLocador = dados['idLocador'];
      propostaDoLocatario.nomeDaImagem = dados['nomeDaImagem'];
      propostaDoLocatario.nomeDaImagem2 = dados['nomeDaImagem2'];
      propostaDoLocatario.nomeDaImagem3 = dados['nomeDaImagem3'];
      propostaDoLocatario.nomeDaImagem4 = dados['nomeDaImagem4'];
      propostaDoLocatario.nomeDaImagem5 = dados['nomeDaImagem5'];
      propostaDoLocatario.valor = dados['valor'];
      propostaDoLocatario.bairro = dados['bairro'];
      propostaDoLocatario.complemento = dados['complemento'];
      propostaDoLocatario.logadouro = dados['logadouro'];
      propostaDoLocatario.urlImagens = dados['urlImagens'];
      propostaDoLocatario.url = dados['url'];
      propostaDoLocatario.detalhes = dados['detalhes'];
      propostaDoLocatario.cidade = dados['cidade'];
      propostaDoLocatario.cep = dados['cep'];
      propostaDoLocatario.numero = dados['numero'];
      propostaDoLocatario.url2 = dados['url2'];
      propostaDoLocatario.urlImagens4 = dados['urlImagens4'];
      propostaDoLocatario.urlImagens3 = dados['urlImagens3'];
      propostaDoLocatario.urlImagens2 = dados['urlImagens2'];
      propostaDoLocatario.urlImagens5 = dados['urlImagens5'];
      propostaDoLocatario.finalizado = dados['finalizado'];
      propostaDoLocatario.idImovel = dados['idImovel'];
      propostaDoLocatario.cpf = dados['cpf'];
      propostaDoLocatario.telefone = dados['telefone'];
      propostaDoLocatario.estado = dados['estado'];
      propostaDoLocatario.tipo = dados['tipo'];
      print(propostaDoLocatario.cpf);

      listaPropostas.add(propostaDoLocatario);
    }
    return listaPropostas;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerPropostas() async {

    Stream<QuerySnapshot> stream = db
        .collection("propostasDoLocatario")
        .where('idLocatario', isEqualTo: widget.uid)
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });

  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerPropostas();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando Propostas.."),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proposta de Contrato'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
           StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return carregandoDados;
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:

                    var docs = snapshot.data.documents;

                    if( docs.length == 0 ){
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text("Nenhuma proposta! :( ",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                      );
                    }

                    return Expanded(
                        child: ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (_, indice) {
                              return _buildList(
                                context, docs[indice]
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
