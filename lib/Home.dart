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
import 'package:industries/Propostas.dart';
import 'package:industries/ReciboImovel.dart';
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
  String _nome;
  String _photo;
  String _cpf;
  var _pes;
  String filter;
  var profile;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
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
                          .document(document.documentID)
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
                document['logadouro'],
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                document['complemento'],
                textAlign: TextAlign.center,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(document['urlImagens']),
              ),
            )
          : ListTile(
              title: Text(
                document['logadouro'],
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                document['complemento'],
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
    /*
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        document['idUsuario'] != _idUsuarioLogado
            ? ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detalhes(document, widget.user,
                            widget.photo, widget.emai, widget.uid))),
                title: Text(
                  document['logadouro'],
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  document['complemento'],
                  textAlign: TextAlign.center,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(document['urlImagens']),
                ),
              )
            : ListTile(
                title: Text(
                  document['logadouro'],
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  document['complemento'],
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
                /*
                leading:CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(document['urlImagens']),
                ),*/
              ),
      ],
    );*/
  }
/*
  Future<List<Imovel>> _recuperarImoveis() async {
    QuerySnapshot querySnapshot = await db.collection("imoveis").getDocuments();
    List<Imovel> listaImoveis = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      Imovel imovel = Imovel();
      imovel.estado = dados['estado'];
      imovel.logadouro = dados['logadouro'];
      imovel.complemento = dados['complemento'];
      imovel.tipoImovel = dados['tipoImovel'];
      imovel.valor = dados['valor'];
      imovel.idUsuario = dados['idUsuario'];
      imovel.urlImagens = dados['urlImagens'];
      imovel.detalhes = dados['detalhes'];
      imovel.idEstado = dados['idEstado'];
      imovel.nomeDaImagem = dados['nomeDaImagem'];
      imovel.telefoneUsuario = dados['telefoneUsuario'];
      imovel.cpfUsuario = dados['cpfUsuario'];
      print(dados['estado']);

      listaImoveis.add(imovel);
    }
    return listaImoveis;
  }

 */
  _pesquisar() async {
    String pesquisa = editingController.text;
    QuerySnapshot querySnapshot = await db.collection("imoveis")
        .where("logadouro" , isGreaterThanOrEqualTo: pesquisa)
        .where("logadouro" , isLessThanOrEqualTo: pesquisa + "\uf8ff"  )
        .getDocuments();

    setState(() {
      _pes = querySnapshot.documents;
    });

    for( DocumentSnapshot item in querySnapshot.documents ) {
      var dados = item.data;
      setState(() {
        pesquisa = dados['logadouro'];
      });

      print(pesquisa);
    }
    return pesquisa;
  }

  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      _id = dados['idUsuario'];
      _nome = dados['nome'];
      _photo = dados['urlImagem'];
      _cpf = dados['cpf'];
      print("_id: " + _id);
    });
  }

  @override
  void initState() {
    _pesquisar();
    _pes = [];

    _recuperarDados();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
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
          child: Text("IndustriesKC"),
//          child: TextField(
//            style: TextStyle(color: Colors.white),
//            textAlign: TextAlign.center,
//            decoration: InputDecoration(
//              labelText: "Pesquisar Imóvel",
//
//              fillColor: Colors.white,
//              focusColor: Colors.white,
//              suffixIcon: Icon(Icons.search, color: Colors.white,),
//              labelStyle:TextStyle(color: Colors.white,),
//              hintStyle: TextStyle(color: Colors.blue),
//
//            ),
//            controller: controller,
//          ),
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
                  /*
                    onDetailsPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Configuracoes(widget.user,
                                  widget.photo, widget.emai, widget.uid)));
                    },*/
                    accountName: Text('${_nome}'),
                    accountEmail: Text("${widget.emai}"),
                    currentAccountPicture: CircleAvatar(
                        backgroundImage: _photo != null
                            ? NetworkImage('${_photo}')
                            : NetworkImage('${widget.photo}')),
                  )
                : UserAccountsDrawerHeader(
              /*
                    onDetailsPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Configuracoes(widget.user,
                                  widget.photo, widget.emai, widget.uid)));
                    },*/
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Propostas(widget.user,
                            widget.photo, widget.emai, widget.uid))
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
            //CustomListTitle(Icons.person, 'Perfil', () => {}),
            //CustomListTitle(Icons.notifications, 'Notificações', () => {}),
            //CustomListTitle(Icons.send, 'Mensagens', () => {}/*_cadastrarImoveis()*/),
            //Divider(),
            // CustomListTitle(Icons.settings, 'Configurações', () => {}),
            //CustomListTitle(Icons.help, 'Sobre', ()=>{}),
            //CustomListTitle(Icons.exit_to_app,  'Sair', () => {signOut(), signOutFB()} ),
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
                  texto = _pesquisar();
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

            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('imoveis').snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  var docs = snapshot.data.documents;
                  var docs2 = [
                  ];
                  //print(this._pesquisar());
                  for (var d in docs) {
                    //print(d);
                    docs2.add(d);
                  }
                  docs = docs2;
                  //print("Quantidade: " + _pes.snapshot.data.lengh.toString());

                  return ListView.builder(
                    itemExtent: 80.0,
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      return _buildList(
                          context, docs[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
class CustomListTitle extends StatelessWidget {

  IconData icon;
  String text;
  Function onTap;


  CustomListTitle(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
          splashColor: Colors.blue,
          onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                        fontSize: 16.0,
                      ),),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
