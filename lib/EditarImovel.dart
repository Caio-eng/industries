import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/model/Imovel.dart';
import 'package:validadores/Validador.dart';

import 'CadastroImoveis.dart';

class EditarImovel extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  final DocumentSnapshot document;
  EditarImovel(this.document, this.user, this.photo, this.emai, this.uid);
  @override
  _EditarImovelState createState() => _EditarImovelState();
}

class _EditarImovelState extends State<EditarImovel> {
  TextEditingController _controllerLogadouro = TextEditingController();
  TextEditingController _controllerComplemento = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerDetalhes = TextEditingController();
  var _controller = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
  var controllerNumero = new MaskedTextController(mask: '000');
  var controllerCep = new MaskedTextController(mask: '00000-000');
  String estad;

  List<Estado> _estados = Estado.getEstados();
  List<DropdownMenuItem<Estado>> _dropdownMenuItens;
  Estado _selectedEstado;
  File _imagem;
  String _urlImagemRecuperada;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _cpfUsuario = "";
  String _telefoneUsuario = "";
  String _mensagemErro = "";
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
        case 'KitNet':
          choice = value;
          break;
      }
    });
  }


  Future _recuperarImagem(String origemImagem) async {

    File imagemSelecionada;
    switch ( origemImagem ) {
      case "camera" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if( _imagem != null ) {
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
        .child( widget.document['nomeDaImagem'] + ".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent) {

      if( storageEvent.type == StorageTaskEventType.progress ) {
        setState(() {
          _subindoImagem = true;
        });
      } else if( storageEvent.type == StorageTaskEventType.success ) {
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
    _atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });

  }

  _atualizarUrlImagemFirestore(String url){

    String log = _controllerLogadouro.text;
    String bairro = _controllerBairro.text;
    String comp = _controllerComplemento.text;
    String valor = _controller.text;
    String deta = _controllerDetalhes.text;
    String estado = _selectedEstado.nome;
    int i = _selectedEstado.id;
    String sgl = _selectedEstado.sigla;
    String tipoImovel = _radioValue;
    String numero = controllerNumero.text;
    String cep = controllerCep.text;

    Map<String, dynamic> dadosAtualizar = {
      "urlImagens" : url,
      "logadouro" : log,
      "estado" : estado,
      "complemento" : comp,
      "bairro" : bairro,
      "detalhes" : deta,
      "tipoImovel" : tipoImovel,
      "valor" : valor,
      "idEstado" : i - 1,
      "telefoneUsuario" : _telefoneUsuario,
      "cpfUsuario" : _cpfUsuario,
      "siglaEstado" : sgl,
      "numero" : numero,
      "cep" : cep,
    };

    Imovel imovel = Imovel();
    imovel.estado = estado;
    imovel.logadouro = log;
    imovel.bairro = bairro;
    imovel.complemento = comp;
    imovel.tipoImovel = tipoImovel;
    imovel.valor = valor;
    imovel.idEstado = i - 1;
    imovel.detalhes = deta;
    imovel.urlImagens = url;
    imovel.telefoneUsuario = _telefoneUsuario;
    imovel.cpfUsuario = _cpfUsuario;
    imovel.siglaEstado = sgl;
    imovel.numero = numero;
    imovel.cep = cep;
    imovel.idUsuario = widget.document['idUsuario'];
    imovel.nomeDaImagem = widget.document['nomeDaImagem'];

    Firestore db = Firestore.instance;
    db.collection("imoveis")
        .document(widget.document.documentID)
        .updateData(dadosAtualizar);

  }

  _recuperarDadosUsuario() async {

    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
    await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpfUsuario = dados['cpf'];
    _telefoneUsuario = dados['telefone'];

    _controllerLogadouro.text = widget.document['logadouro'];
    _controllerComplemento.text = widget.document['complemento'];
    _controllerBairro.text = widget.document['bairro'];
    _controllerDetalhes.text = widget.document['detalhes'];
    controllerNumero.text = widget.document['numero'];
    _controller.text = widget.document['valor'];
    _radioValue = widget.document['tipoImovel'];
    controllerCep.text = widget.document['cep'];


    setState(() {
      _urlImagemRecuperada = widget.document["urlImagens"];
    });
  }

  List<DropdownMenuItem<Estado>> buildDropdownMenuItens(List estados) {
    List<DropdownMenuItem<Estado>> items = List();
    for (Estado estado in estados) {
      items.add(
        DropdownMenuItem(
          value: estado,
          child: Text(estado.nome),
        ),
      );
    }
    return items;
  }

  onCgangeDropdownItem(Estado selectedEstado) {
    setState(() {
      _selectedEstado = selectedEstado;
    });
  }

  @override
  void initState() {
    _dropdownMenuItens = buildDropdownMenuItens(_estados);
    _selectedEstado = _dropdownMenuItens[widget.document['idEstado']].value;
    super.initState();
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
                    /*child: Row(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(Icons.camera_alt),
                          onPressed: () {
                            _recuperarImagem("camera");
                          },
                        ),
                        FlatButton(
                          child: Icon(Icons.photo),
                          onPressed: () {
                            _recuperarImagem("galeria");
                          },
                        ),
                      ],
                    ),*/
                    backgroundImage:
                    _urlImagemRecuperada != null
                        ? NetworkImage(_urlImagemRecuperada, )
                        : null
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recuperarImagem("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recuperarImagem("galeria");
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 10),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Estado de: ', style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold), ),
                      SizedBox(width: 30,),
                      DropdownButton(
                        icon: Icon(Icons.arrow_downward, color: Colors.blue,),
                        value: _selectedEstado,
                        items: _dropdownMenuItens,
                        onChanged: onCgangeDropdownItem,
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                      ),
                      /*
                      SizedBox(height: 20,),
                      Text('Selecione: ${_selectedEstado.nome}'),
                        */
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: controllerCep,
                    //autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: 'Digite o seu CEP',
                      labelText: 'CEP',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerLogadouro,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    /*
                    onChanged: (texto) {
                      _atualizarUrlImagemFirestore(_urlImagemRecuperada, texto);
                    },*/
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Logadouro",
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
                  child: TextField(
                    controller: _controllerBairro,
                    //autofocus: true,
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
                  child: TextField(
                    controller: controllerNumero,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      labelText: 'Número',
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
                        hintText: "Digite um poto de Referencia",
                        labelText: "Complemento (Opcional)",
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                fontSize: 16,
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
                                fontSize: 16,
                              ),
                            ),
                            Radio(
                              value: 'KitNet',
                              groupValue: _radioValue,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              'KitNet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
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
                  child: TextField(
                    controller: _controllerDetalhes,
                    keyboardType: TextInputType.text,
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
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                         //_atualizarNomeFirestore();
                         _atualizarUrlImagemFirestore(_urlImagemRecuperada);
                         Navigator.pop(context);
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
