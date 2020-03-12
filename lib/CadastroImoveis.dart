

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:industries/Home.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/model/Mensagem.dart';
import 'package:industries/model/Usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroImoveis extends StatefulWidget {
  final String uid;
  CadastroImoveis(this.uid);

  @override
  _CadastroImoveisState createState() => _CadastroImoveisState();
}

class _CadastroImoveisState extends State<CadastroImoveis> {
  TextEditingController _controllerLogadouro = TextEditingController();

  TextEditingController _controllerComplemento = TextEditingController();

  TextEditingController _controllerTipoImovel = TextEditingController();
  String _idUsuario;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  File _imagem;

  String _mensagemErro = "";

  Firestore db = Firestore.instance;

  CarouselSlider instance;

  _validarCampos() {
    String logadouro = _controllerLogadouro.text;
    String complemento = _controllerComplemento.text;
    String tipoImovel = _controllerTipoImovel.text;


    if (logadouro.isNotEmpty && logadouro.length > 6) {
      if (complemento.isNotEmpty) {
        if (tipoImovel.isNotEmpty) {
          Imovel imovel = Imovel();
          imovel.logadouro = logadouro;
          imovel.complemento = complemento;
          imovel.tipoImovel = tipoImovel;
          imovel.idUser = widget.uid;



          _cadastrarImovel (imovel);
        }else {
          _mensagemErro = "O Tipo do Imóvel é obrigatorio";
        }
      }else {
        _mensagemErro = "O complemento é obrigatorio";
      }
    }else {
      _mensagemErro = "Logaroudo tem que ter mais de 6 letras";
    }
  }

  _cadastrarImovel (Imovel imovel) {

    FirebaseAuth auth = FirebaseAuth.instance;
    var _user = auth.currentUser;
    print(_user);
    //Salvar dados do Imovel
    Firestore db = Firestore.instance;

    db.collection("Imovel")
        .document()
        .setData(imovel.toMap());

  }

  Future _recuperarImagem(String origemImagem) async {

    File imagemSelecionada;
    switch( origemImagem ) {
      case "camera" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  _recuperarDadosUsuario() async {
    _idUsuario = widget.uid;

  }

  Future _uploadImagem() {

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
      .child("fotos")
      .child( _idUsuario + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar processo do upload
    task.events.listen((StorageTaskEvent storageEvent){

      if( storageEvent.type == StorageTaskEventType.progress ){
        setState(() {
          _subindoImagem = true;
        });
      }else if( storageEvent.type == StorageTaskEventType.success ){
        setState(() {
          _subindoImagem = false;
        });
      }

    });

    //Recupera url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperaUrlImagem(snapshot);
    });
  }



  Future _recuperaUrlImagem(StorageTaskSnapshot snapshot) async {

    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
    });
  }


  List<File> listaTela = new List();

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    //listaTela.add(_imagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text (
        "Cadastre seu Imóvel"
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,

          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerLogadouro,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Logradouro",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerComplemento,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Complemento",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerTipoImovel,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Tipo do Imóvel",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Galeria",
                              style: TextStyle(color: Colors.white),
                            ),
                            //Icon(Icons.file_upload, color: Colors.white, size: 30,),
                          ],
                        ),
                        onPressed: () {
                          _recuperarImagem("galeria");
                        },
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Camera",
                                style: TextStyle(color: Colors.white),
                              ),
                              //Icon(Icons.file_upload, color: Colors.white, size: 30,),
                            ],
                          ),
                          onPressed: () {
                            _recuperarImagem("camera");
                          },
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                    ],
                  ),
                ),
                _subindoImagem
                  ? CircularProgressIndicator()
                  :Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _imagem == null
                    ? Container()
                      :Image.file(_imagem),
                  /*CarouselSlider(
                    height: 150.0,
                    items: listaTela.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue
                              ),
                              child: Image.file(_imagem),

                              //child: _imagem,
                          );
                        },
                      );
                    }).toList(),
                  ),*/

                ),

                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _validarCampos();
                      _uploadImagem();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
