import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:industries/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/sidebar/sidebar_layout.dart';

class MyOrdersPage extends StatefulWidget with NavigationStates {
  @override
  _MyOrdersPageState createState()=> _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> with NavigationStates {

  TextEditingController _controllerComplemento = TextEditingController();
  TextEditingController _controllerTipoImovel = TextEditingController();
  TextEditingController _controllerLogadouro = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String logadouro = _controllerLogadouro.text;
    String complemento = _controllerComplemento.text;
    String tipoImovel = _controllerTipoImovel.text;

    if (logadouro.isNotEmpty && logadouro.length > 6) {
      if (complemento.isNotEmpty) {
        if (tipoImovel.isNotEmpty) {
          Imovel imovel = Imovel();
          imovel.logadouro = logadouro;
          imovel.complemento = complemento;
          imovel.tipoImovel = tipoImovel;

          _cadastrarImovel (imovel);
        }else {
          _mensagemErro = "O Tipo do Imóvel é obrigatorio";
        }
      }else {
        _mensagemErro = "O complemento é obrigatorio";
      }
    }else {
      _mensagemErro = "Logaroudo tem que ter mais de 6 letras";
    }
  }

  _cadastrarImovel (Imovel imovel) {

    FirebaseAuth auth = FirebaseAuth.instance;
    var _user = auth.currentUser;
    print(_user);
    //Salvar dados do Imovel
    Firestore db = Firestore.instance;

    db.collection("Imovel")
        .document()
        .setData(imovel.toMap());
    // colocar outra rota
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SideBarLayout()
        ));

  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(

        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[

            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.deepPurple),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerLogadouro,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Logradouro",
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
                          hintText: "Complemento",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerTipoImovel,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Tipo do Imóvel",
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
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validarCampos();
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}
