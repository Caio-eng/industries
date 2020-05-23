import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:industries/CadastroImoveis.dart';
import 'package:industries/model/Usuario.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'Home.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;


GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
);

void main() => runApp(
    Industries(),

);

class Industries extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'SIMOB',
      home: Main(title: 'SIMOB',),
      //SideBarLayout(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.blue,
        accentColor: Colors.blue,
        textTheme: TextTheme(
        )
      ),
    );
  }

}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MainState createState() => _MainState();

}





class _MainState extends State<Main>  {
  String user;
  String detalhes;
  String emai;
  String photo;
  String uid;
  GoogleSignInAccount account;
  bool _isLoggedIn = false;
  Map userProfile;
  //final facebookLogin = FacebookLogin();


  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        this.account = account;
      });
      //_onLoginStatusChange(true);
      if (this.account != null) {
        setState(() {
          this.user = this.account.displayName;
          this.emai = this.account.email;
          this.photo = this.account.photoUrl;
          this.uid = this.account.id;
        });
      }



    });

    _googleSignIn.signInSilently();
  }
  Future<void> googleSignIn() async {
    try {

      await _googleSignIn.signIn();
    } catch(error) {
      print(error);
    }
  }

  Future<void> googleSignOut() => _googleSignIn.disconnect();

  void signOut() {
    setState(() {
      user = null;
      emai = null;
      photo = null;
      uid = null;
    });
  }

  void signIn() {
    setState(() {
      user = 'user';
      emai = 'email';
      photo = 'photoUrl';
      uid = 'id';
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoggedIn || account != null
    ? new Home(googleSignOut, user, photo, emai, uid)
    : new Login(googleSignIn);
  }

}


