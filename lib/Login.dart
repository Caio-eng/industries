import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:industries/CadastroUsuario.dart';
import 'package:http/http.dart' as http;
import 'package:industries/pages/homepage.dart';
import 'package:industries/sidebar/sidebar_layout.dart';

import 'Home.dart';
import 'model/Usuario.dart';
import 'ResetPasswordPage.dart';
/*
class Login extends StatefulWidget {
  final Function signIn;

  Login(this.signIn);

  @override
  _LoginState createState() => _LoginState();
}
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);*/
class Login extends StatelessWidget {

  //TextEditingController _controllerEmail = TextEditingController();
 // TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
 // bool isLoggedIn = false;
  //bool _lembreme = false;
 // String user;
  final Function signIn;
  final Function signInFB;

  Login(this.signIn, this.signInFB);
 // var profile;
  /*
  _validarCampos() {
    //Recuperar os dados do campo
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //Validação
    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        //_logarUsuario( usuario );

      } else {
        _mensagemErro = "Preencha a senha!";
      }

    } else {
      _mensagemErro = "Preencha o E-mail utilizando @";
    }
  }*/

 /* _logarUsuario( Usuario usuario ) {

    FirebaseAuth auth = FirebaseAuth.instance;


    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {

      Navigator.pushReplacement(
          context,
         MaterialPageRoute(
           builder: (context) => Home()
         )
      );

    }).catchError((error) {

      setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
      });

    });
  }*/
/*
  _logarPorFacebbok () async {
    var login = FacebookLogin();
    var result = await login.logInWithReadPermissions(['email']);

    switch(result.status) {
      case FacebookLoginStatus.error:
        print("Surgiu um erro");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelado pelo usuário");
        break;
      case FacebookLoginStatus.loggedIn:
        _getUserInfo(result);
        profile.toString();
        _onLoginStatusChange(true, profileData: profile);


        break;
    }
  }

  _onLoginStatusChange(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn=isLoggedIn;
    });
  }*/
/*
  _getUserInfo(FacebookLoginResult result) async {
    var token = result.accessToken.token;
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    var profile = json.decode(graphResponse.body);

    setState(() {
      this.profile = profile;
    });

    print('O Profile é ' + this.profile);

    print(profile.toString());

  }*/
/*
  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if( usuarioLogado != null ) {
      String logado = usuarioLogado as String;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home()
          )
      );
    }
  }*/


/*
  @override
  void initState() {
    //_verificaUsuarioLogado();
    super.initState();
  }
*/


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Industries KC Imoveis",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                /*
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
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
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),*/
                /*
                Container(
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text(
                      "Esqueceu a Senha?",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(),
                          )
                      );
                    },
                  ),
                  padding: EdgeInsets.only(right: 0.0),

                ),*/
                /*
                Container(
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: _lembreme,
                          checkColor: Colors.blue,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _lembreme = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Lembre-me",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(32),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Logar com Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                child: Image.asset("imagens/google.png"),
                                height: 28,
                                width: 28,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      signIn();
                     // googleSignIn();
                    },
                  ),
                ),
              ),
            ),
             Center(
               child: Column(
                 children: <Widget>[
                   Text("OU", style: TextStyle(color: Colors.black, fontSize: 16),),
                 ],
               ),
             ) ,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Logar com Facebook",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              child: SizedBox(
                                child: Image.asset("imagens/fb-icon.png"),
                                height: 28,
                                width: 28,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          signInFB();
                         // _logarPorFacebbok();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                /*
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Cadastre-se aqui!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroUsuario()
                          )
                      );
                    },
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),
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
