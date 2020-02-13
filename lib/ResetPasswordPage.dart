import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.deepPurple,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 100,
              child: Image.asset("imagens/cadeado.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Esqueceu sua Senha?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Por favor, informe o E-mail associado a sua conta que enviaremos um link para o mesmo com as informações para restauraçãode sua senha.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(
                  fontSize: 20,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 10),
              child: RaisedButton(
                child: Text(
                  "Enviar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                onPressed: () {

                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
