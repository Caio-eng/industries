import 'package:flutter/material.dart';
import 'package:industries/telas/AbaContatos.dart';
import 'package:industries/telas/AbaConversas.dart';

class MensagemUsuario extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;


  MensagemUsuario(this.user, this.photo, this.emai, this.uid);

  @override
  _MensagemUsuarioState createState() => _MensagemUsuarioState();
}

class _MensagemUsuarioState extends State<MensagemUsuario> with SingleTickerProviderStateMixin {

  TabController _tabController;


  String _emailUsuario= "";

  Future _recuperarDadosUsuario() async {


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
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AbaConversas(widget.user, widget.photo, widget.emai, widget.uid),
          AbaContatos(widget.user, widget.photo, widget.emai, widget.uid),
        ],
      ),
    );
  }
}
