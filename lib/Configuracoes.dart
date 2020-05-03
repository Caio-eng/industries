import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:validadores/Validador.dart';
import 'dart:io';

import 'model/Usuario.dart';

class Configuracoes extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  Configuracoes(this.user, this.photo, this.emai, this.uid);
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String _urlImagemRecuperada;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  var controllerTelefone = new MaskedTextController(mask: '(00) 00000 - 0000');
  var controllerCPF = new MaskedTextController(mask: '000.000.000-00');
  String _mensagemErro = "";

  Future _recuperarImagem(String origemImagem) async {
    File imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("perfil").child(widget.uid + ".jpg");
    print("Usuario: " + widget.user);
    print("id: " + widget.uid);

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

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url) {
    String nome = _controllerNome.text;
    String _telefoneUsuario = controllerTelefone.text;
    String _cpfUsuario = controllerCPF.text;
    if (_telefoneUsuario.isNotEmpty && _telefoneUsuario.length == 17) {
        Map<String, dynamic> dadosAtualizar = {
          "urlImagem": url,
          "nome": nome,
          "photo": widget.photo,
          "email": widget.emai,
          "cpf": _cpfUsuario,
          "telefone": _telefoneUsuario,
          "idUsuario" : _idUsuarioLogado,
        };


        Usuario usuario = Usuario();
        Firestore db = Firestore.instance;
        db.collection("usuarios").document(widget.uid).setData(usuario.toMap());
        db.collection("usuarios").document(widget.uid).updateData(dadosAtualizar);
        Navigator.pop(context);
    }  else {
      _mensagemErro = "O número deve conter 10 digitos";
    }
  }

/*
  _atualizarNomeFirestore(){

    String nome = _controllerNome.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };
    Usuario usuario = Usuario();
    usuario.nome = nome;
    db.collection("usuarios")
        .document(widget.uid)
        .updateData( dadosAtualizar );


  }
*/
  _recuperarDadosUsuario() async {
    _idUsuarioLogado = widget.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    _controllerNome.text = dados['nome'];
    controllerCPF.text = dados['cpf'];
    controllerTelefone.text = dados['telefone'];
    print(dados['urlImagem']);
    setState(() {
      _urlImagemRecuperada = dados["urlImagem"];
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informações do Usuário"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: _subindoImagem
                        ? CircularProgressIndicator()
                        : Container(),
                  ),
                  CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada)
                          : NetworkImage(widget.photo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Câmera"),
                        onPressed: () {
                          _recuperarImagem("camera");
                        },
                      ),
                      FlatButton(
                        child: Text("Galeria"),
                        onPressed: () {
                          _recuperarImagem("galeria");
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNome,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      /*
                    onChanged: (texto) {
                      _atualizarUrlImagemFirestore(_urlImagemRecuperada, texto);
                    },*/
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            return Validador()
                                .add(Validar.CPF, msg: 'CPF Inválido')
                                .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                                .minLength(11)
                                .maxLength(11)
                                .valido(value, clearNoNumber: true);
                          },
                          controller: controllerCPF,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: 'Digite o seu CPF',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controllerTelefone,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite o seu Telefone",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
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
                        if (_formKey.currentState.validate()) {
                          //_atualizarNomeFirestore();
                          _atualizarUrlImagemFirestore(_urlImagemRecuperada);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
