import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:industries/model/Estado.dart' as prefix0;
import 'package:industries/model/Imovel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:industries/service/via_cep_service.dart';




class CadastroImoveis extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  CadastroImoveis(this.user, this.photo, this.emai, this.uid);

  @override
  _CadastroImoveisState createState() => _CadastroImoveisState();
}
/*
class Estado {
  int id;
  String nome;
  String sigla;

  Estado(this.id, this.nome, this.sigla);

  static List<Estado> getEstados() {
    return <Estado>[
      Estado(1, 'Acre', 'AC'),
      Estado(2, 'Alagoas', 'AL'),
      Estado(3, 'Amapá', 'AP'),
      Estado(4, 'Amazonas', 'AM'),
      Estado(5, 'Bahia', 'BA'),
      Estado(6, 'Ceará', 'CE'),
      Estado(7, 'Distrito Federal', 'DF'),
      Estado(8, 'Espírito Santo', 'ES'),
      Estado(9, 'Goiás', 'GO'),
      Estado(10, 'Maranhão', 'MA'),
      Estado(11, 'Mato Grosso', 'MT'),
      Estado(12, 'Mato Grosso do Sul', 'MS'),
      Estado(13, 'Minas Gerais', 'MG'),
      Estado(14, 'Pará', 'PA'),
      Estado(15, 'Paraíba', 'PB'),
      Estado(16, 'Paraná', 'PR'),
      Estado(17, 'Pernambuco', 'PE'),
      Estado(18, 'Piauí', 'PI'),
      Estado(19, 'Rio de Janeiro', 'RJ'),
      Estado(20, 'Rio Grande do Norte', 'RN'),
      Estado(21, 'Rio Grande do Sul', 'RS'),
      Estado(22, 'Rondônia', 'RO'),
      Estado(23, 'Roraima', 'RR'),
      Estado(24, 'Santa Catarina', 'SC'),
      Estado(25, 'São Paulo', 'SP'),
      Estado(26, 'Sergipe', 'SE'),
      Estado(27, 'Tocantins', 'TO'),
    ];
  }
}
*/
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
  String _urlImagemRecuperada;
  String _nomeDaFoto;
  bool _subindoImagem = false;
  File _imagem;
  int _id;
  String _nome;
  String _sigla;
  String _telefoneUsuario;
  String _cpfUsuario;

  String _cep;

  String _mensagemErro = "";


  Firestore db = Firestore.instance;

  CarouselSlider instance;
  //List<Estado> _estados = Estado.getEstados();
  //List<DropdownMenuItem<Estado>> _dropdownMenuItens;
  //Estado _selectedEstado;

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
    if (logadouro.isNotEmpty && logadouro.length >= 4) {
      if (bairro.isNotEmpty && bairro.length >= 4) {
        if (valor.isNotEmpty && valor.length >= 9) {
          if (sigl.isNotEmpty && sigl.length == 2) {
            if (tipoImovel.isNotEmpty) {
              if (numero.isNotEmpty) {
                  if (cidade.isNotEmpty ) {
                    Imovel imovel = Imovel();
                    imovel.logadouro = logadouro;
                    imovel.bairro = bairro;
                    imovel.cidade = cidade;
                    imovel.complemento = complemento;
                    imovel.tipoImovel = tipoImovel;
                    imovel.valor = valor;
                    imovel.detalhes = detalhes;
                    imovel.urlImagens = _urlImagemRecuperada;
                    imovel.telefoneUsuario = _telefoneUsuario;
                    imovel.cpfUsuario = _cpfUsuario;
                    imovel.siglaEstado = sigl;
                    imovel.numero = numero;
                    imovel.cep = _cep;
                    imovel.idUsuario = widget.uid;
                    imovel.nomeDaImagem = _nomeDaFoto;

                    _cadastrarImoveis(imovel);


                  } else {
                    setState(() {
                      _mensagemErro = "O Campo Cidade é obrigátorio!";
                    });
                  }
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
          } else {
            setState(() {
              _mensagemErro = "UF só possui 2 letras";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Digite um valor maior ou igual que R\$ 100";
          });
        }
      } else {
        setState(() {
          _mensagemErro = 'Bairro tem que ser maior que 4 letras';
        });
      }
    } else{
      setState(() {
        _mensagemErro = "Logradouro tem que ser maior que 4  letras";
      });
    }
  }

  _cadastrarImoveis(Imovel imovel) {
    Firestore db = Firestore.instance;
    db.collection("imoveis")
        .document()
        .setData(imovel.toMap());
    Navigator.pop(context);
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

  _atualizarUrlImagemFirestore(String url) {
    Map<String, dynamic> dadosAtualizar = {"urlImagens": url};


    //Usuario usuario = Usuario();
    //usuario.nome = widget.user;
    //usuario.email = widget.emai;
    //usuario.photo = widget.photo;
    //this.account = profile;
    Firestore db = Firestore.instance;
    db.collection("imoveis").document().updateData(dadosAtualizar);
  }

  _recuperarDadosUsuario() async {

    _idUsuario = widget.uid;

    DocumentSnapshot snapshot =
    await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpfUsuario = dados['cpf'];
    _telefoneUsuario = dados['telefone'];
    print(_cpfUsuario);


  }

  @override
  void initState() {
    //_dropdownMenuItens = buildDropdownMenuItens(_estados);
    //_selectedEstado = _dropdownMenuItens[8].value;
    super.initState();
    _recuperarDadosUsuario();
    //listaTela.add(_imagem);
  }

  @override
  void dispose() {
    super.dispose();
    controllerCep.clear();
    _localidadeController.clear();
    _controllerSigla.clear();
  }
/*
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
*/
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
                  Padding(
                    padding: const EdgeInsets.only(right: 80, left: 80),
                    child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        backgroundImage: _urlImagemRecuperada != null
                            ? NetworkImage(
                                _urlImagemRecuperada,
                              )
                            : null),

                    /*_imagem == null
                      ? Container()
                      :Image.file(_imagem),*/
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
                  /*
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 10),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Estado de: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        DropdownButton(
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.blue,
                          ),
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
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controllerCep,
                      onEditingComplete: () {
                        _searchCep();
                      },
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Digite seu CEP',
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerSigla,
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: 'Estado',
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
                      controller: _localidadeController,
                      //autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: 'Cidade',
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
                      //autofocus: true,
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
                        hintText: 'Ex: 000',
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
                          hintText: "Digite um ponto de Referencia",
                          labelText: "Complemento (opcional)",
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
                      controller: controller,
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
                  /*
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
                ),*/

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
                        if (_cpfUsuario != null) {
                          _validarCampos();

                        } else {
                          print("entrou aqui");
                          setState(() {
                            _mensagemErro = 'Cadastre o seu CPF para poder usufluir do aplicativo';
                          });
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
    print(resultCep.uf);// Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson();
      _cep = resultCep.cep;
      print(_result);
    });

    _searching(false);
  }
}
