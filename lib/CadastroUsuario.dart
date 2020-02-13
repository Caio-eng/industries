import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:industries/Home.dart';
import 'package:industries/model/Usuario.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  bool _locatario = false;
  bool _locador = false;

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //Recuperar os dados do campo
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //Validação
    if (nome.isNotEmpty && nome.length >= 3) {
      if (email.isNotEmpty && email.contains("@")) {
          if (senha.isNotEmpty && senha.length > 6) {
            setState(() {
              _mensagemErro = "";
            });
            Usuario usuario = Usuario();
            usuario.nome = nome;
            usuario.email = email;
            usuario.senha = senha;

            _cadastrarUsuario( usuario );

          } else {
            _mensagemErro = "Preencha a senha! digite mais de 6 caracteres";
          }

      } else {
        _mensagemErro = "Preencha o E-mail utilizando @";
      }
    } else {
      setState(() {
        _mensagemErro = "O nome precisa ter mais de 3 caracteres";
      });
    }
  }

  _cadastrarUsuario( Usuario usuario ) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      //Salvar dados do usuário
      Firestore db = Firestore.instance;
      
      db.collection("usuarios")
      .document( firebaseUser.uid )
      .setData( usuario.toMap() );

      Navigator.pop(context);
    }).catchError((error){
      print("erro app: " + error.toString() );
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),

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
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                /*
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                          title: Text(
                              "Locatário",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                          //activeColor: Colors.red,
                          //selected: true,
                          //secondary: Icon(Icons.add_box),
                          value: _locatario,
                          onChanged: (bool valor){
                            setState(() {
                              _locatario = valor;
                            });
                          }

                      ),
                      CheckboxListTile(
                          title: Text(
                              "Locador",
                          textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white),
                          ),
                          //activeColor: Colors.red,
                          //selected: true,
                          //secondary: Icon(Icons.add_box),
                          value: _locador,
                          onChanged: (bool valor){
                            setState(() {
                              _locador = valor;
                            });
                          }
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
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
                /*
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
