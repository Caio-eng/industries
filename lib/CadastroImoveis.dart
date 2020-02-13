

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:industries/Home.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/model/Usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastroImoveis extends StatelessWidget {
  final String uid;
  CadastroImoveis(this.uid);
  //Controladores
  TextEditingController _controllerLogadouro = TextEditingController();
  TextEditingController _controllerComplemento = TextEditingController();
  TextEditingController _controllerTipoImovel = TextEditingController();
  File _imagem;
  String _mensagemErro = "";

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
          imovel.idUser = uid;

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
    _imagem = imagemSelecionada;
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

                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    CircleAvatar(

                    ),
                    CircleAvatar(

                    ),
                  ],
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
