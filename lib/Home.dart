import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'CadastroImoveis.dart';

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
  var imoveis;
  var imoveisList;


  Widget _buildList(BuildContext context, var document) {
    _deletarImovel() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Deletar Imóvel',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Você deseja deletar este imóvel se sim, você clicara em Excluir se não clicara em cancelar!'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Excluir'),
                    onPressed: () {
                      db
                          .collection("imoveis")
                          .document(document['idImovel'])
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

    List<String> itensMenu = ["Editar", "Deletar"];
    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Editar":
          print("Editar");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarImovel(document, widget.user,
                      widget.photo, widget.emai, widget.uid)));
          break;
        case "Deletar":
          print("Deletar");
          _deletarImovel();
          break;
      }
    }



    return Card(
      child: document['idUsuario'] != _idUsuarioLogado
          ? ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detalhes(document, widget.user,
                    widget.photo, widget.emai, widget.uid))),
        title: Text(
          document['logadouro'] + '\n' + document['bairro'],
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          'Valor: ${document['valor']}',
          textAlign: TextAlign.center,
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: document['urlImagens'] != null
            ? NetworkImage(document['urlImagens'])
            : NetworkImage(''),
        ),
      )
          : ListTile(
        title: Text(
          document['logadouro'] + '\n' + document['bairro'],
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          'Valor: ${document['valor']}' ,
          textAlign: TextAlign.center,
        ),
        leading: Icon(Icons.home),
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

  _pesquisar() async {
    _pes = editingController.text;
    QuerySnapshot querySnapshot = await db.collection("imoveis")
        .where("logadouro" , isGreaterThanOrEqualTo: _pes)
        .where("logadouro" , isLessThanOrEqualTo: _pes + "\uf8ff"  )
        .getDocuments();

    setState(() {
      _pes = querySnapshot.documents;
    });

    for( DocumentSnapshot item in querySnapshot.documents ) {
      var dados = item.data;
      setState(() {
        _pes = dados['logadouro'];
      });

      print(_pes);
    }
    return _pes;
  }

  _recuperarDados() async {
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
      print("Aqui" + _idLocatario);
    });
  }

  @override
  void initState() {
    super.initState();
    _pesquisar();
    _pes = [];
    Firestore.instance.collection('imoveis').snapshots().listen((QuerySnapshot snapshot) {
      print('entrou');
      print(snapshot.documents.first.data.keys.toString());
      var docs = [];
      for (var i = 0; i < snapshot.documents.length; i++) {
        docs.add(snapshot.documents[i].data);
      }
      setState(() {
        imoveis = docs;
        imoveisList = docs;
      });


    });
    _recuperarDados();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("SIMOB"),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Configuracoes(widget.user,
                              widget.photo, widget.emai, widget.uid)));
                },
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroImoveis(
                              widget.user, widget.photo, widget.emai, widget.uid)));
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 18),
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
                                'Meu Imóvel',
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
            Divider(),
            Padding(
              padding: EdgeInsets.all(7),
              child: TextField(
                controller: editingController,
                onChanged: (texto) {

                  if (texto.length > 3 ) {
                    var new_imovies = [];
                    print('texto pesquisa' + texto);
                    for (var i = 0; i < imoveis.length; i++) {
                      if (imoveis[i]['logadouro'].toLowerCase().contains(texto.toLowerCase())) {
                        new_imovies.add(imoveis[i]);
                      }

                    }

                    setState(() {
                      imoveis = new_imovies;
                    });
                  } else {
                    setState(() {
                      imoveis = imoveisList;
                    });
                  }
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Pesquisar Imóveis",
                  hintText: "Informe o endereço",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32))
                  ),
                ),


              ),
            ),
            Divider(),
            this.imoveis == null ? Text("Loading..") :

            Expanded(
                child:

                ListView.builder(
                  itemExtent: 80,
                  itemCount: imoveis.length,
                  itemBuilder: (_, index) {
                    return _buildList(
                        context, imoveis[index]);
                  },
                )


            )
            ,
          ],
        ),
      ),
    );
  }
}
