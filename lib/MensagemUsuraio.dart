import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:industries/Configuracoes.dart';
import 'package:industries/telas/AbaContatos.dart';
import 'package:industries/telas/AbaConversas.dart';

class MensagemUsuario extends StatefulWidget {
  final String emai;
  MensagemUsuario(this.emai);

  @override
  _MensagemUsuarioState createState() => _MensagemUsuarioState();
}

class _MensagemUsuarioState extends State<MensagemUsuario> with SingleTickerProviderStateMixin {

  TabController _tabController;
  List<String> itensMenu = [
    "Perfil", "Configurações"
  ];

  String _emailUsuario= "";

  Future _recuperarDadosUsuario() async {

    //FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = widget.emai;
    });

  }

  @override
  void initState() {
    super.initState();

    _recuperarDadosUsuario();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  _escolhaMenuItem(String itemEscolhido) {

    switch ( itemEscolhido ){
      case "Perfil":
       print("perfil");
       break;
      case "Configurações":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Configuracoes(widget.emai)
            )
        );
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("in-app message", textAlign: TextAlign.center,),
        centerTitle: true,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AbaConversas(),
          AbaContatos(),
        ],
      ),
    );
  }
}
