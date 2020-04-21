import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industries/Detalhes.dart';
import 'package:industries/Chat.dart';
import 'package:industries/ImovelAlugado.dart';
import 'package:industries/model/AluguarImovel.dart';
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

  bool isLoggedIn = false;
  String _idUsuarioLogado = "";
  String _id = "";
  String _url;
  var profile;




  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: document['idUsuario'] != _idUsuarioLogado
        ? ListTile(
          onTap: () =>
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => Detalhes(document, widget.user, widget.photo, widget.emai, widget.uid))),
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
            /*
            leading:CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(document['urlImagens']),
            ),*/
      ),
    );
  }

  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("imoveis").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      _id = dados['idUsuario'];
      print("_id: " + _id);
      _url = dados['urlImagens'];
    });

  }

  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "IndustriesKC",
          ),
        ),
        actions: <Widget>[
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
          Padding(
            padding: EdgeInsets.only(right: 18),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${widget.user}'),
              accountEmail: Text("${widget.emai}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('${widget.photo}'),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImovelAlugado(widget.user, widget.photo, widget.emai, widget.uid)))
                  },
                  child: Container(
                    height: 50,
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
                  onTap: () => {},
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Notificações',
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
                                widget.emai, widget.photo, widget.uid))),
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
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Configurações',
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
                  onTap: () => {widget.signOut()},
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
      body: StreamBuilder(
        stream: Firestore.instance.collection('imoveis').snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {

              return _buildList(context, snapshot.data.documents[index]);
            },
          );
        },
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
