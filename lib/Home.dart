

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:industries/Detalhes.dart';
import 'package:industries/model/Imovel.dart';
import 'CadastroImoveis.dart';
import 'CadastroImoveis.dart';
import 'Login.dart';
/*
class Home extends StatefulWidget {
  final Function signOut;

  Home(this.signOut);



  @override
  _HomeState createState() => _HomeState();
}
*/
class Home extends StatelessWidget {
  final Function signOut;
  final Function signOutFB;
  final String user;
  final String emai;
  final String photo;
  final String uid;

  Home(this.signOut, this.signOutFB, this.user, this.emai, this.photo, this.uid);
  Firestore db = Firestore.instance;
  bool isLoggedIn = false;

  var profile;


/*
  Future _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();


    setState(() {
      _emailUsuario = usuarioLogado.email;
      _nomeUsuario = usuarioLogado.displayName;
    });

  }*/


/*
  _deslogarUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    var login = FacebookLogin();
    login.logOut();


  }*/

/*

  List<String> itensMenu = [
    "Outros","Duvidas", "Sobre"
  ];

  _escolhaMenuItem( String escolha ) {

    switch( escolha ) {
      case "Outros" :
        break;
      case "Perfil" :
      setState(() {
        print('Ola');
      });
        break;
      case "Duvidas" :
        break;
    }

  }*/

/*
  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();

  }*/

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListTile(
        /*
        trailing: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            print(document['tipoImovel']);
          },
          child: Icon(Icons.keyboard_arrow_right),
        ),*/
        onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => Detalhes())),
        title: Text(document['logadouro'], textAlign: TextAlign.center,),
        subtitle: Text(document['complemento'], textAlign: TextAlign.center,),
        leading: Icon(Icons.home),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(
          child:  Text(
          "IndustriesKC",
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroImoveis(uid)));
             /* showDialog(
                  context: context,
                //barrierDismissible: false,
                builder: (BuildContext ctx) {

                    final input = TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Logadouro',
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10 ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                        )
                      ),
                    );

                    return AlertDialog(
                      title: Text('Cadastrar Imoveis', style: TextStyle(color: Colors.black),),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                           // Text('Logadouro'),
                            input
                          ],
                        ),
                      ),
                      actions: <Widget>[
                         RaisedButton(
                          color: Colors.red,
                          child: Text('Cancelar', style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text('Salvar', style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            print(input.controller.value);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    );
                }
              );*/
            },
            child: Icon(Icons.add),
          ),
          Padding(padding: EdgeInsets.only(right: 20),),
          /*PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {

              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )*/
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('$user'),
              accountEmail: Text("$emai"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('$photo'),
              ),
            ),
            CustomListTitle(Icons.person, 'Perfil', () => {}),
            CustomListTitle(Icons.notifications, 'Notificações', () => {}),
            CustomListTitle(Icons.send, 'Mensagens', () => {}/*_cadastrarImoveis()*/),
            CustomListTitle(Icons.settings, 'Configurações', () => {}),
            CustomListTitle(Icons.exit_to_app, 'Sair', () => {signOut(), signOutFB()} ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Imovel').snapshots(),
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
