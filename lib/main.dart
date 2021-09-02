import 'dart:convert' as JSON;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if(account == null)
        return false;
      AuthResult res = await _auth.signInWithCredential(
          (GoogleAuthProvider.getCredential(
              idToken: (await account.authentication).idToken,
              accessToken: (await account.authentication).accessToken,
          ))
      );
      if(res.user == null)
        return false;
      return true;
    } catch(error) {
      print(error);
      return false;
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


