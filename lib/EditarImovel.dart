import 'dart:io';

import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/service/via_cep_service.dart';
import 'package:validadores/Validador.dart';

class EditarImovel extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  var document;
  EditarImovel(this.document, this.user, this.photo, this.emai, this.uid);
  @override
  _EditarImovelState createState() => _EditarImovelState();
}

class _EditarImovelState extends State<EditarImovel> {
  TextEditingController _controllerLogadouro = TextEditingController();
  TextEditingController _controllerComplemento = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerDetalhes = TextEditingController();
  var _localidadeController = TextEditingController();
  var _controllerSigla = TextEditingController();
  var _controller = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
  var controllerNumero = new MaskedTextController(mask: '000');
  var controllerCep = new MaskedTextController(mask: '00000-000');
  String estad;
  final _formKey = GlobalKey<FormState>();
  File _imagem, _imagem2, _imagem3, _imagem4, _imagem5;
  String _urlImagemRecuperada, _url2, _url3, _url4, _url5;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  bool _subindo2 = false;
  bool _subindo3 = false;
  bool _subindo4 = false;
  bool _subindo5 = false;
  String _idUsuario, _idImovel;
  String _nomeDaImagem,
      _nomeDaImagem2,
      _nomeDaImagem3,
      _nomeDaImagem4,
      _nomeDaImagem5;
  String _cpfUsuario = "";
  String _telefoneUsuario = "";
  String _mensagemErro = "";
  String _radioValue;
  String _id;
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Apartamento':
          choice = value;
          break;
        case 'Casa':
          choice = value;
          break;
        case 'Quitinete':
          choice = value;
          break;
      }
    });
  }

  Future<List<Imovel>> _recuperarImoveis() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection('imoveis').getDocuments();
    List<Imovel> listaImoveis = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados['idUsuario'] != widget.uid) continue;

      setState(() {});
    }
    return listaImoveis;
  }

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
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaImagem + ".jpg");

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

    setState(() {
      _urlImagemRecuperada = url;
    });
    _atualizarUrlImagemFirestore();
  }

  // Foto 2
  Future _recuperarImagem2(String origemImagem) async {
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
      _imagem2 = imagemSelecionada;
      if (_imagem2 != null) {
        _subindo2 = true;
        _uploadImagem2();
      }
    });
  }

  Future _uploadImagem2() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaImagem2 + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem2);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindo2 = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindo2 = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem2(snapshot);
    });
  }

  Future _recuperarUrlImagem2(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _url2 = url;
    });
    _atualizarUrlImagemFirestore();
  }

  // Foto3
  Future _recuperarImagem3(String origemImagem) async {
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
      _imagem3 = imagemSelecionada;
      if (_imagem3 != null) {
        _subindo3 = true;
        _uploadImagem3();
      }
    });
  }

  Future _uploadImagem3() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaImagem3 + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem3);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindo3 = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindo3 = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem3(snapshot);
    });
  }

  Future _recuperarUrlImagem3(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _url3 = url;
    });
    _atualizarUrlImagemFirestore();
  }

  // Foto4
  Future _recuperarImagem4(String origemImagem) async {
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
      _imagem4 = imagemSelecionada;
      if (_imagem4 != null) {
        _subindo4 = true;
        _uploadImagem4();
      }
    });
  }

  Future _uploadImagem4() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaImagem4 + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem4);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindo4 = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindo4 = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem4(snapshot);
    });
  }

  Future _recuperarUrlImagem4(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _url4 = url;
    });
    _atualizarUrlImagemFirestore();
  }

  // Foto5
  Future _recuperarImagem5(String origemImagem) async {
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
      _imagem5 = imagemSelecionada;
      if (_imagem5 != null) {
        _subindo5 = true;
        _uploadImagem5();
      }
    });
  }

  Future _uploadImagem5() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaImagem5 + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem5);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindo5 = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _subindo5 = false;
        });
      }
    });

    //Recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem5(snapshot);
    });
  }

  Future _recuperarUrlImagem5(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _url5 = url;
    });
    _atualizarUrlImagemFirestore();
  }

  _atualizarUrlImagemFirestore() {
    String log = _controllerLogadouro.text;
    String bairro = _controllerBairro.text;
    String comp = _controllerComplemento.text;
    String valor = _controller.text;
    String deta = _controllerDetalhes.text;
    String sgl = _controllerSigla.text;
    String tipoImovel = _radioValue;
    String numero = controllerNumero.text;
    String cep = controllerCep.text;
    String cidade = _localidadeController.text;

    if (_urlImagemRecuperada != null && _url2 != null && _url3 != null && _url4 != null && _url5 != null) {
      if (valor.isNotEmpty && valor.length >= 9) {
        if (tipoImovel.isNotEmpty) {
          Map<String, dynamic> dadosAtualizar = {
            "urlImagens": _urlImagemRecuperada,
            "url2": _url2,
            "url3": _url3,
            "url4": _url4,
            "url5": _url5,
            "cidade": cidade,
            "logadouro": log,
            "complemento": comp,
            "bairro": bairro,
            "detalhes": deta,
            "tipoImovel": tipoImovel,
            "valor": valor,
            "telefoneUsuario": _telefoneUsuario,
            "cpfUsuario": _cpfUsuario,
            "siglaEstado": sgl,
            "numero": numero,
            "cep": cep,
          };

          Imovel imovel = Imovel();
          imovel.logadouro = log;
          imovel.bairro = bairro;
          imovel.cidade = cidade;
          imovel.complemento = comp;
          imovel.tipoImovel = tipoImovel;
          imovel.valor = valor;
          imovel.detalhes = deta;
          imovel.urlImagens = _urlImagemRecuperada;
          imovel.url2 = _url2;
          imovel.url3 = _url3;
          imovel.url4 = _url4;
          imovel.url5 = _url5;
          imovel.telefoneUsuario = _telefoneUsuario;
          imovel.cpfUsuario = _cpfUsuario;
          imovel.siglaEstado = sgl;
          imovel.numero = numero;
          imovel.cep = cep;
          imovel.idUsuario = _idUsuario;
          imovel.nomeDaImagem = _nomeDaImagem;
          imovel.nomeDaImagem2 = _nomeDaImagem2;
          imovel.nomeDaImagem3 = _nomeDaImagem3;
          imovel.nomeDaImagem4 = _nomeDaImagem4;
          imovel.nomeDaImagem5 = _nomeDaImagem5;

          Firestore db = Firestore.instance;
          db.collection("imoveis").document(_idImovel).updateData(dadosAtualizar);
          db.collection("meus_imoveis").document(widget.uid).collection("imoveis").document(_idImovel).updateData(dadosAtualizar);
        } else {
          setState(() {
            _mensagemErro = "Digite um número";
          });
        }
      } else {
        setState(() {
          _mensagemErro = 'Selecione uma opção';
        });
      }
    } else{
      setState(() {
        _mensagemErro = "Selecione todas imagens";
      });
    }
  }

  _recuperarDadosUsuario() async {
    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      _cpfUsuario = dados['cpf'];
      _telefoneUsuario = dados['telefone'];

      _idImovel = widget.document['idImovel'];
      _idUsuario = widget.document['idUsuario'];
      _controllerLogadouro.text = widget.document['logadouro'];
      _controllerComplemento.text = widget.document['complemento'];
      _controllerBairro.text = widget.document['bairro'];
      _controllerDetalhes.text = widget.document['detalhes'];
      controllerNumero.text = widget.document['numero'];
      _controller.text = widget.document['valor'];
      _radioValue = widget.document['tipoImovel'];
      controllerCep.text = widget.document['cep'];
      _controllerSigla.text = widget.document['siglaEstado'];
      _localidadeController.text = widget.document['cidade'];
      _urlImagemRecuperada = widget.document['urlImagens'];
      _url2 = widget.document['url2'];
      _url3 = widget.document['url3'];
      _url4 = widget.document['url4'];
      _url5 = widget.document['url5'];
      _nomeDaImagem = widget.document['nomeDaImagem'];
      _nomeDaImagem2 = widget.document['nomeDaImagem2'];
      _nomeDaImagem3 = widget.document['nomeDaImagem3'];
      _nomeDaImagem4 = widget.document['nomeDaImagem3'];
      _nomeDaImagem5 = widget.document['nomeDaImagem5'];
    });
  }

  @override
  void initState() {
    super.initState();
    _recuperarImoveis();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Imóvel"),
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
                  _subindoImagem ? CircularProgressIndicator() : Container(),
                  _subindo2 ? CircularProgressIndicator() : Container(),
                  _subindo3 ? CircularProgressIndicator() : Container(),
                  _subindo4 ? CircularProgressIndicator() : Container(),
                  _subindo5 ? CircularProgressIndicator() : Container(),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: _urlImagemRecuperada != null
                              ? NetworkImage(
                                  _urlImagemRecuperada,
                                )
                              : null,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    _recuperarImagem("camera");
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  _recuperarImagem("galeria");
                                },
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: _url2 != null
                              ? NetworkImage(
                                  _url2,
                                )
                              : null,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    _recuperarImagem2("camera");
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  _recuperarImagem2("galeria");
                                },
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: _url3 != null
                              ? NetworkImage(
                                  _url3,
                                )
                              : null,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    _recuperarImagem3("camera");
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  _recuperarImagem3("galeria");
                                },
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: _url4 != null
                              ? NetworkImage(
                                  _url4,
                                )
                              : null,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    _recuperarImagem4("camera");
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  _recuperarImagem4("galeria");
                                },
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: _url5 != null
                              ? NetworkImage(
                                  _url5,
                                )
                              : null,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    _recuperarImagem5("camera");
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              Divider(),
                              GestureDetector(
                                onTap: () {
                                  _recuperarImagem5("galeria");
                                },
                                child: Icon(
                                  Icons.photo,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 8),
                    child: TextFormField(
                      controller: controllerCep,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .maxLength(9, msg: "CEP, possui 8 digitos")
                            .maxLength(9, msg: "CEP, possui 8 digitos")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Digite o CEP',
                        labelText: 'CEP',
                        filled: true,
                        enabled: _enableField,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchCep();
                          },
                          autofocus: true,
                          icon: Icon(Icons.search),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  _controllerSigla != null
                      ? Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      controller: _controllerSigla,
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Necessita digitar o CEP",
                        labelText: 'Estado',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      controller: _controllerSigla,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Necessita digitar o CEP",
                        labelText: 'Campo Estado é obrigatorio',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  _localidadeController != null
                      ? Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _localidadeController,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Necessita digitar o CEP",
                        labelText: 'Cidade',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _localidadeController,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO,
                            msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Necessita digitar o CEP",
                        labelText: 'Campo Cidade é obrigatorio',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _controllerLogadouro,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite seu endereço",
                        labelText: 'Logradouro',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _controllerBairro,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite o setor",
                        labelText: 'Bairro',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: controllerNumero,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: 'Número',
                        hintText: 'Ex: 000',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _controllerComplemento,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrogatório")
                            .valido(valor);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Digite um ponto de Referencia",
                          labelText: "Complemento",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 3),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Selecione o Tipo do Imóvel:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                value: 'Apartamento',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                'Apartamento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Radio(
                                value: 'Casa',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                'Casa',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Radio(
                                value: 'Quitinete',
                                groupValue: _radioValue,
                                onChanged: radioButtonChanges,
                              ),
                              Text(
                                'Quitinete',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true)
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Valor do aluguel",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _controllerDetalhes,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrogatório")
                            .maxLength(200, msg: "Máximo de 200 caracteres")
                            .valido(valor);
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Descrição",
                          hintText: 'Digite a descrição do imóvel',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Atualizar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          //_atualizarNomeFirestore();
                          _atualizarUrlImagemFirestore();
                          Navigator.pop(context);

                        }
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _loading = false;
  bool _enableField = true;
  String _result;

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Future _searchCep() async {
    _searching(true);

    final cep = controllerCep.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    controllerCep.text = resultCep.cep;
    _localidadeController.text = resultCep.localidade;
    _controllerSigla.text = resultCep.uf;
    _controllerLogadouro.text = resultCep.logradouro;
    _controllerBairro.text = resultCep.bairro;
    print(resultCep.localidade);
    print(resultCep.uf); // Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson();
    });

    _searching(false);
  }
}
