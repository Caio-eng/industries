import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:industries/model/Estado.dart' as prefix0;
import 'package:industries/model/Imovel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:industries/service/via_cep_service.dart';
import 'package:validadores/Validador.dart';

class CadastroImoveis extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  CadastroImoveis(this.user, this.photo, this.emai, this.uid);

  @override
  _CadastroImoveisState createState() => _CadastroImoveisState();
}

class _CadastroImoveisState extends State<CadastroImoveis> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerLogadouro = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerComplemento = TextEditingController();
  var _localidadeController = TextEditingController();
  var _controllerSigla = TextEditingController();

  TextEditingController _controllerDetalhes = TextEditingController();
  var controllerTelefone = new MaskedTextController(mask: '(00) 00000 - 0000');
  var controllerNumero = new MaskedTextController(mask: '000');
  var controller = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
  var controllerCPF = new MaskedTextController(mask: '000.000.000-00');
  var controllerCep = new MaskedTextController(mask: '00000-000');
  String _idUsuario;
  String _urlImagemRecuperada, _url2, _url3, _url4, _url5;
  String _nomeDaFoto, _nomeDaFoto2, _nomeDaFoto3, _nomeDaFoto4, _nomeDaFoto5;
  bool _subindoImagem = false;
  bool _subindo2 = false;
  bool _subindo3 = false;
  bool _subindo4 = false;
  bool _subindo5 = false;
  File _imagem;
  String  _idCar;
  String _sigla, _idImovel;
  String _telefoneUsuario;
  String _cpfUsuario;

  String _cep;

  String _mensagemErro = "";

  Firestore db = Firestore.instance;

  String _radioValue;
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

  _validarCampos() {
    String logadouro = _controllerLogadouro.text;
    String complemento = _controllerComplemento.text;
    String tipoImovel = choice;
    String valor = controller.text;
    String detalhes = _controllerDetalhes.text;
    String sigl = _controllerSigla.text;
    String bairro = _controllerBairro.text;
    String numero = controllerNumero.text;
    String cidade = _localidadeController.text;
    if (_urlImagemRecuperada != null && _url2 != null && _url3 != null && _url4 != null && _url5 !=null) {
      if(valor.isNotEmpty && valor.length >= 9) {
       if(tipoImovel.isNotEmpty) {
         String _id = DateTime
             .now()
             .millisecondsSinceEpoch
             .toString();
         setState(() {
           _idImovel = _id;
         });
         Imovel imovel = Imovel();
         imovel.logadouro = logadouro;
         imovel.bairro = bairro;
         imovel.idImovel = _idImovel;
         imovel.cidade = cidade;
         imovel.complemento = complemento;
         imovel.tipoImovel = tipoImovel;
         imovel.valor = valor;
         imovel.detalhes = detalhes;
         imovel.urlImagens = _urlImagemRecuperada;
         imovel.url2 = _url2;
         imovel.url3 = _url3;
         imovel.url4 = _url4;
         imovel.url5 = _url5;
         imovel.telefoneUsuario = _telefoneUsuario;
         imovel.cpfUsuario = _cpfUsuario;
         imovel.siglaEstado = sigl;
         imovel.numero = numero;
         imovel.cep = _cep;
         imovel.idUsuario = widget.uid;
         imovel.nomeDaImagem = _nomeDaFoto;
         imovel.nomeDaImagem2 = _nomeDaFoto2;
         imovel.nomeDaImagem3 = _nomeDaFoto3;
         imovel.nomeDaImagem4 = _nomeDaFoto4;
         imovel.nomeDaImagem5 = _nomeDaFoto5;
         _cadastrarImoveis(imovel);
       }else{
         setState(() {
           _mensagemErro = "Selecione o tipo de imóvel";
         });
       }
      } else {
        setState(() {
          _mensagemErro = "Digite um valor maior ou igual que R\$ 100";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Selecione todas imagens";
      });
    }
  }

  _cadastrarImoveis(Imovel imovel) {
    Firestore db = Firestore.instance;
    db.collection("imoveis").document(_idImovel)
        .setData(imovel.toMap()).then((_){
          db.collection("meus_imoveis")
              .document(widget.uid)
              .collection("imoveis")
              .document(_idImovel)
              .setData(imovel.toMap());

          Navigator.pop(context);

    });


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
      _uploadImagem();
    });
  }

  Future _uploadImagem() async {
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _nomeDaFoto = nomeImagem;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaFoto + ".jpg");
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
      _imagem = imagemSelecionada;
      _uploadImagem2();
    });
  }

  Future _uploadImagem2() async {
    String nomeImagem2 = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _nomeDaFoto2 = nomeImagem2;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaFoto2 + ".jpg");
    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _url2 = url;
    });
  }

  // Foto 3
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
      _imagem = imagemSelecionada;
      _uploadImagem3();
    });
  }

  Future _uploadImagem3() async {
    String nomeImagem3 = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _nomeDaFoto3 = nomeImagem3;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaFoto3 + ".jpg");
    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _url3 = url;
    });
  }

  // Foto 4
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
      _imagem = imagemSelecionada;
      _uploadImagem4();
    });
  }

  Future _uploadImagem4() async {
    String nomeImagem4 = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _nomeDaFoto4 = nomeImagem4;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaFoto4 + ".jpg");
    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _url4 = url;
    });
  }

  //Foto5
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
      _imagem = imagemSelecionada;
      _uploadImagem5();
    });
  }

  Future _uploadImagem5() async {
    String nomeImagem5 = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _nomeDaFoto5 = nomeImagem5;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("imoveis")
        .child(widget.uid)
        .child(_nomeDaFoto5 + ".jpg");
    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _url5 = url;
    });
  }

  _atualizarUrlImagemFirestore(String url) {
    Map<String, dynamic> dadosAtualizar = {"urlImagens": url};
    Firestore db = Firestore.instance;
    db.collection("imoveis").document().updateData(dadosAtualizar);
  }

  _recuperarDadosUsuario() async {
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpfUsuario = dados['cpf'];
    _telefoneUsuario = dados['telefone'];
    _idUsuario = dados['idUsuario'];
    print(_cpfUsuario);
  }

  _recuperarDadosCartao() async {
    Firestore db2 = Firestore.instance;

    DocumentSnapshot snapshot2 =
        await db2.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> dados2 = snapshot2.data;

    setState(() {
      _idCar = dados2['idUsuario'];
    });
    print("Aqui: " + _idCar);
  }

  @override
  void initState() {
    _recuperarDadosCartao();
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  void dispose() {
    super.dispose();
    controllerCep.clear();
    _localidadeController.clear();
    _controllerSigla.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastre seu Imóvel"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      //autofocus: true,
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
                  _result != null
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
                            //autofocus: true,
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
                  _result != null
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
                            //autofocus: true,
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
                            //autofocus: true,
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
                      //autofocus: true,
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
                      //autofocus: true,
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
                      controller: controller,
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
                          if (_formKey.currentState.validate()) {
                            print("entrou aqui");
                            _validarCampos();
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
      _cep = resultCep.cep;
      print(_result);
    });

    _searching(false);
  }
}
