import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/MeuCartao.dart';
import 'package:industries/Configuracoes.dart';
import 'package:industries/Detalhes.dart';
import 'package:industries/Chat.dart';
import 'package:industries/EditarImovel.dart';
import 'package:industries/ImovelAlugado.dart';
import 'package:industries/MeuImovel.dart';
import 'package:industries/ReciboImovel.dart';
import 'package:industries/telas/PropostasDoLocador.dart';
import 'package:industries/telas/PropostasDoLocatario.dart';
import 'package:industries/telas/splash.dart';
import 'package:industries/utils/Config.dart';
import 'CadastroImoveis.dart';
import 'ImoveisAnunciado.dart';

class Home extends StatefulWidget {
  final Function signOut;
  final String user;
  final String photo;
  final String emai;
  final String uid;

  Home(this.signOut, this.user, this.photo, this.emai, this.uid);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  Firestore db = Firestore.instance;


  TextEditingController controller = TextEditingController();


  TextEditingController editingController = TextEditingController();

  bool isLoggedIn = false;
  String _idUsuarioLogado = "";
  String _id = "";
  String _nome, _idLocatario, _idLocador;
  String _photo;
  String _cpf;
  var _pes;
  String filter;

  var profile;
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropTipos;
  List<DropdownMenuItem<String>> _listaItensDropEstados;
  List<DropdownMenuItem<String>> _listaMeusImoveis;
  List<String> escolha = ['Perfil', 'Meus Imóveis'];

  var imoveis;
  var imoveisList;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  String _itemSelecionadoEstado;
  String _itemLogradouro;
  String _itemSelecionadoTipos;
  String _itemSelecionadoMeus;


  Widget _buildList(BuildContext context, var document) {
    _informacao() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Informação',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Este é seu imóvel, vá em meus imoveis para ter acesso!',
                    textAlign: TextAlign.center,),
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
    }

    if (document['idUsuario'] != _idUsuarioLogado) {
      return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detalhes(document, widget.user,
                    widget.photo, widget.emai, widget.uid))),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(document['urlImagens'], fit: BoxFit.cover,),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(document['logadouro'], style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(
                          height: 5,
                        ),
                        Text(document['valor']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: (){
          _informacao();
        },
        child:  Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    document['urlImagens'],
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          document['logadouro'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(document['valor']),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  }



  _carregarItensDropdown() {
    //Estados
    _listaItensDropEstados = Config.getEstados();

    //Tipos
    _listaItensDropTipos = Config.getTipos();


  }

  Future<Stream<QuerySnapshot>> _adicionarListenerImoveis() async {

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("imoveis")
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
    });

  }

  Future<Stream<QuerySnapshot>> _filtrarImoveis() async {
    Firestore db = Firestore.instance;
    Query query = db.collection("imoveis");

    if (_itemSelecionadoEstado != null) {
      query = query.where("siglaEstado", isEqualTo: _itemSelecionadoEstado);
    }

    if (_itemSelecionadoTipos != null) {
      query = query.where("tipoImovel", isEqualTo: _itemSelecionadoTipos);
    }
    
    if (_itemSelecionadoMeus != null) {
      query = query.where('idUsuario', isEqualTo: widget.uid);
    }


    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ) {
      case "Perfil":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Configuracoes(widget.user,
                    widget.photo, widget.emai, widget.uid)));
        break;
      case "Meus Imóveis":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImoveisAnunciado(widget.user,
                  widget.photo, widget.emai, widget.uid)
            ));
        break;
    }

  }


    _pesquisar() async {
      Firestore db = Firestore.instance;
      Query query = db.collection("imoveis");

       if (_pes != null) {
         query = query .where("logadouro" , isGreaterThanOrEqualTo: editingController.text)
             .where("logadouro" , isLessThanOrEqualTo: editingController.text + "\uf8ff"  );
       }

       Stream<QuerySnapshot> stream = query.snapshots();

       stream.listen((dados){
         _controller.add(dados);
       });
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  _recuperarDados() async {
    FirebaseUser usuarioLogado = await _auth.currentUser();
    print("id: " + usuarioLogado.uid);
    _idUsuarioLogado = widget.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
    await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    setState(() {
      /* _id = dados['idUsuario'];
      _nome = dados['nome'];
      _photo = dados['urlImagem'];
      _cpf = dados['cpf'];
      print("_id: " + _id); */
    });

    DocumentSnapshot snapshot2 = await db.collection('propostasDoLocatario').document(widget.uid).get();
    Map<String, dynamic> dados2 = snapshot2.data;
    setState(() {
      _idLocatario = dados2['idLocatario'];
      _idLocador = dados2['idLocador'];
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerImoveis();
    _carregarItensDropdown();
    _recuperarDados();
    _pesquisar();
  }

  @override
  Widget build(BuildContext context) {


    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando imóveis"),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("SIMOB"),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return escolha.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            _idUsuarioLogado == _id
                ? UserAccountsDrawerHeader(
              accountName: Text('${_nome}'),
              accountEmail: Text("${widget.emai}"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: _photo != null
                      ? NetworkImage('${_photo}')
                      : NetworkImage('${widget.photo}')),
            )
                : UserAccountsDrawerHeader(
              accountName: Text('${widget.user}'),
              accountEmail: Text("${widget.emai}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _photo != null
                    ? NetworkImage('${_photo}')
                    : NetworkImage('${widget.photo}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImovelAlugado(widget.user,
                                widget.photo, widget.emai, widget.uid)))
                  },
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Imóvel Alugado',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MeuImovel(widget.user,
                                widget.photo, widget.emai, widget.uid)))
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.business,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Meus Imóveis Locado',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MensagemUsuario(widget.user,
                                widget.photo, widget.emai, widget.uid))),
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Mensagens',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReciboImovel(widget.uid))
                    )
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.receipt,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Recibos',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    if (_idLocatario != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropostasDoLocatario(widget.user,
                                  widget.photo, widget.emai, widget.uid)
                          ))
                    } else  {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropostasDoLocador(widget.user,
                                  widget.photo, widget.emai, widget.uid)
                          ))
                    }
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.business_center,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'propostas',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MeuCartao(widget.user,
                        widget.photo, widget.emai, widget.uid)))
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.payment,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cartão',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () => {},
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.help,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sobre',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                child: InkWell(
                  splashColor: Colors.red,
                  onTap: () => {widget.signOut(), Navigator.pop(context)},
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sair',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Colors.blue,
                        value: _itemSelecionadoEstado,
                        items: _listaItensDropEstados,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black
                        ),
                        onChanged: (estado){
                          setState(() {
                            _itemSelecionadoEstado = estado;
                            _filtrarImoveis();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 1,
                  height: 50,
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Colors.blue,
                        value: _itemSelecionadoTipos,
                        items: _listaItensDropTipos,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black
                        ),
                        onChanged: (tipos){
                          setState(() {
                            _itemSelecionadoTipos = tipos;
                            _filtrarImoveis();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),

            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: editingController,
                onChanged: (valor) {
                  _pes = valor;
                  _pesquisar();
                },
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Digite seu endereço",
                  labelText: 'Pesquisar',
                  filled: true,
                  suffixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)),
                ),

              ),
            ),
            Divider(),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch(snapshot.connectionState){
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
                      child: Text("Nenhum imóvel! :( ",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    );
                  }


                  return Expanded(
                    child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, indice){
                          return _buildList(
                            context, docs[indice]
                          );
                        },
                    ),
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
