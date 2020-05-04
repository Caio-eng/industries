import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:industries/Home.dart';

class ImovelAlugado extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  ImovelAlugado(this.user, this.photo, this.emai, this.uid);

  @override
  _ImovelAlugadoState createState() => _ImovelAlugadoState();
}

class _ImovelAlugadoState extends State<ImovelAlugado> {
  String _idUsuarioLogado = "";
  String _idDono = "";
  String _nomeDoDono, _emailDoDono, _cpfDoDono, _telefoneDoDono, _photoDoDono;
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";
  String _telefone = '';
  String _cpf, _nome, _email, _photo;
  String _deta = "";
  String _estado = "";
  String _dataInicio = "";
  List<String> itensMenu = [
    "Informações", "Pagar Aluguel", "Cancelar Contrato com Dono",
  ];

  Firestore db = Firestore.instance;


  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    _pagarAluguel() async {
      _idDono = document['idDono'];
      _nomeDoDono = document['nomeDoDono'];
      _emailDoDono = document['emailDoDono'];
      _cpfDoDono = document['cpfDoDono'];
      _telefoneDoDono = document['telefoneDoDono'];
      _photoDoDono = document['urlImagemDoDono'];
      _dataInicio = document['dataInicio'];
      print("O Dono de id: ${_idDono}, tem o nome: ${_nomeDoDono}, seu email é: ${_emailDoDono}, portador do CPF: ${_cpfDoDono} e seu número é: ${_telefoneDoDono}.");
      _valor = document['valorImovelAlugado'];
      _log = document['logadouroImovelAlugado'];

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Parcelas do Aluguel', textAlign: TextAlign.center, style: TextStyle(fontSize: 25),),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.blue,
                    onTap: () {},
                    child: Text("Parcela 1 " + " - Valor: " + _valor, style: TextStyle(color: Colors.blue, fontSize: 18),),
                  ),
                  Text('Parcela 2'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 3'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 4'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 5'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 6'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 7'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 8'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 9'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 10'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 11'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                  Text('Parcela 12'+ " - Valor: " + _valor, style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Voltar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );

    }

    _informacaoImovel() {
      _idDono = document['idDono'];
      _nomeDoDono = document['nomeDoDono'];
      _emailDoDono = document['emailDoDono'];
      _cpfDoDono = document['cpfDoDono'];
      _telefoneDoDono = document['telefoneDoDono'];
      _photoDoDono = document['urlImagemDoDono'];
      _valor = document['valorImovelAlugado'];
      _log = document['logadouroImovelAlugado'];
      _comp = document['complementoImovelAlugado'];
      _url = document['urlImagensImovelAlugado'];
      _deta = document['detalhesImovelAlugado'];
      _tipo = document['tipoImovelImovelAlugado'];
      _estado = document['estadoImovelAlugado'];
      _dataInicio = document['dataInicio'];
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text('Informação ', textAlign: TextAlign.center,),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Tipo do Imóvel: ' + _tipo + '\nEstado de: ' + _estado + "\nValor Mensal: " + _valor, textAlign: TextAlign.center,),
                  CircleAvatar(backgroundImage: NetworkImage(_url), radius: 30,),
                  Text("Logadouro: " + _log  + "\nComplemento: ${_comp}"  +  '\nDetalhes: ' + _deta + '\nData Inicial: ' + _dataInicio, textAlign: TextAlign.center,),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Informação sobre o Dono", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Nome: ' + _nomeDoDono + " Email: " +_emailDoDono + "\nCPF: " + _cpfDoDono + "\nTelefone: " + _telefoneDoDono, textAlign: TextAlign.center,),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Voltar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
    _escolhaMenuItem(String itemEscolhido) {

      switch ( itemEscolhido ){
        case "Informações":
          _informacaoImovel();
          break;
        case "Pagar Aluguel":
          _pagarAluguel();
          break;
        case "Cancelar Contrato com Dono":
          print("Cancelar Contrato com Dono");
          break;
      }

    }
      return Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              document['logadouroImovelAlugado'],
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              document['complementoImovelAlugado'],
              textAlign: TextAlign.center,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(document['urlImagensImovelAlugado']),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          )
      );


  }


  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =   await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpf = dados['cpf'];
    _telefone = dados['telefone'];
    _nome = dados['nome'];
    _email = dados['email'];
    _photo = dados['photo'];
    print("Locatário de id: ${widget.uid}, tem o nome de ${_nome}, seu email é ${_email}, portador do CPF: ${_cpf} e tem o telefone: ${_telefone}");
    print(_photo);
    //print(_idUsuarioLogado);
  }



  @override
  void initState() {
    _recuperarDados();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Imóvel Alugado"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,

          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('imovelAlugado').document(widget.uid).collection("Detalhes").snapshots(),
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
