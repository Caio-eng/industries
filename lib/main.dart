
import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:industries/CadastroImoveis.dart';
import 'package:industries/sidebar/sidebar_layout.dart';
import 'Home.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;

/*
void main() {


  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    ),
    debugShowCheckedModeBanner: false,
  ));
}*/
GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
);
void main() => runApp(Industries());

class Industries extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IndustriesKC',
      home: Main(title: 'IndustriesKC',),
      //SideBarLayout(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.blue,
        accentColor: Colors.blue,
        textTheme: TextTheme(
          /*
          headline: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.blue),
          body1: TextStyle(fontSize: 14),
          */
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
  final facebookLogin = FacebookLogin();


  @override
  void initState() {
    super.initState();

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

  Future<void> logarPorFacebbok () async {
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
        _onLoginStatusChange(true);
        break;
    }
  }

  _onLoginStatusChange(bool isLoggedIn) {
    setState(() {
      this._isLoggedIn=isLoggedIn;
    });
  }

  _getUserInfo(FacebookLoginResult result) async {
    var token = result.accessToken.token;
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
    var profile = json.decode(graphResponse.body);

    //this.account = profile;

    setState(() {
      this.user = profile['name'];
      this.emai = profile['email'];
      this.photo = profile['picture']['data']['url'];
      this.uid = profile['id'];
    });
    print('Nome: $user');
    print('Email: $emai');
    print('ID: $uid');
    print('Photo: $photo');
    print(profile.toString());
  }


    Future<void> logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
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

  void signOutFB() {
    setState(() {
      user = null;
      emai = null;
      photo = null;
      uid = null;
    });
  }

  void signInFB() {
    setState(() {
      user = 'name';
      emai = 'email';
      photo = 'picture';
      uid = 'id';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn || account != null
    ? new Home(googleSignOut, logout, user, emai, photo, uid)
    : new Login(googleSignIn, logarPorFacebbok);
  }

}


