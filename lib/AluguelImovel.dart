import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:industries/ImovelAlugado.dart';
import 'package:industries/model/AluguarImovel.dart';
import 'package:industries/model/DonoDoImovel.dart';
import 'package:industries/model/Imovel.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:validadores/Validador.dart';

class AluguelImovel extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  final DocumentSnapshot document;

  AluguelImovel(this.document, this.user, this.photo, this.emai, this.uid);

  @override
  _AluguelImovelState createState() => _AluguelImovelState();
}

class _AluguelImovelState extends State<AluguelImovel> {
  DateTime _date = new DateTime.now();

  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date,
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date) {
      print(formatDate(_date, [dd, '-', mm, '-', yyyy]));
      setState(() {
        _date = picked;
      });
    }
  }

  String _idUsuarioLogado = "";
  String _idDono = "";
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";
  String _detalhes = "";
  String _estado = "";
  String _nomeDoDono = "";
  String _emailDoDono = "";
  String _photoDoDono = "";
  String _nomeDaFoto = "";
  int _idDoEstado;
  String _cpfDono = "";
  String _cpf = "";
  String _teleneDono = '';
  String _telefone = '';

  Firestore db = Firestore.instance;

  _validarCampos() {
      // Para quem alugou
      AlugarImovel alugarImovel = AlugarImovel();
      Imovel imovel = Imovel();
      alugarImovel.idLocatario = _idUsuarioLogado;
      alugarImovel.cpfUsuario = _cpfDono;
      alugarImovel.idDono = _idDono;
      alugarImovel.nomeDoDono = _nomeDoDono;
      alugarImovel.emailDoDono = _emailDoDono;
      alugarImovel.urlImagemDoDono = _photoDoDono;
      alugarImovel.idImovel = widget.document.documentID;
      alugarImovel.logadouroImovelAlugado = _log;
      alugarImovel.complementoImovelAlugado = _comp;
      alugarImovel.tipoImovelImovelAlugado = _tipo;
      alugarImovel.valorImovelAlugado = _valor;
      alugarImovel.detalhesImovelAlugado = _detalhes;
      alugarImovel.estadoImovelAlugado = _estado;
      alugarImovel.nomeDaImagemImovelAlugado = _nomeDaFoto;
      alugarImovel.idEstadoImovelAlugado = _idDoEstado;
      alugarImovel.urlImagensImovelAlugado = _url;

      alugarImovel.dataInicio =
          formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();

      // Para o dono do imovel
      DonoDoImovel donoDoImovel = DonoDoImovel();
      donoDoImovel.idLocatario = _idUsuarioLogado;
      donoDoImovel.cpfUsuario = _cpf;
      donoDoImovel.nomeDoLocatario = widget.user;
      donoDoImovel.emailDoLocatario = widget.emai;
      donoDoImovel.detalhesDonoDoImovel = _detalhes;
      donoDoImovel.urlImagemDoLocatario = widget.photo;
      donoDoImovel.idDono = _idDono;
      donoDoImovel.logadouroDonoDoImovel = _log;
      donoDoImovel.complementoDonoDoImovel = _comp;
      donoDoImovel.tipoDonoDoImovel = _tipo;
      donoDoImovel.estadoDoImovel = _estado;
      donoDoImovel.valorDonoDoImovel = _valor;
      donoDoImovel.idImovelAlugado = widget.document.documentID;
      donoDoImovel.urlImagensDonoDoImovel = _url;
      donoDoImovel.nomeDaImagemImovel = _nomeDaFoto;
      donoDoImovel.idEstadoImovel = _idDoEstado;
      donoDoImovel.dataInicio =
          formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();
      _cadastrarDono(donoDoImovel);
      _cadastrarAluguel(alugarImovel);
      _excluirImovel(imovel);

  }

  _cadastrarAluguel(AlugarImovel alugarImovel) {
    //Salvar dados do Imovel
    Firestore db = Firestore.instance;
    //String nomeImovel = DateTime.now().millisecondsSinceEpoch.toString();
    db
        .collection("imovelAlugado")
        .document(widget.uid)
        .collection("Detalhes")
        .document(widget.document.documentID)
        .setData(alugarImovel.toMap());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImovelAlugado(
                widget.user, widget.photo, widget.emai, widget.uid)));
  }

  _cadastrarDono(DonoDoImovel donoDoImovel) {
    Firestore db = Firestore.instance;

    db
        .collection("meuImovel")
        .document(widget.document.documentID)
        .setData(donoDoImovel.toMap());
  }

  _excluirImovel(Imovel imovel) {
    Firestore db = Firestore.instance;

    db.collection("imoveis").document(widget.document.documentID).delete();

    print('Imovel excluido');
  }

  _recuperarDados() async {
    _idDono = widget.document['idUsuario'];
    _idUsuarioLogado = widget.uid;
    _url = widget.document['urlImagens'];
    _log = widget.document['logadouro'];
    _comp = widget.document['complemento'];
    _tipo = widget.document['tipoImovel'];
    _valor = widget.document['valor'];
    _detalhes = widget.document['detalhes'];
    _estado = widget.document['estado'];
    _nomeDaFoto = widget.document['nomeDaImagem'];
    _idDoEstado = widget.document['idEstado'];
    _cpf = widget.document['cpfUsuario'];

    print("CPF do Dono: " + _cpfDono);

    print("Id do dono: " + widget.document['idUsuario']);
    print(widget.uid);

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idDono).get();
    Map<String, dynamic> dados = snapshot.data;
    _nomeDoDono = dados['nome'];
    _emailDoDono = dados['email'];
    _photoDoDono = dados['photo'];
    _cpfDono = dados['cpf'];
    print("Nome do Dono: " + _nomeDoDono);
    print("Email do Dono: " + _emailDoDono);
    print("Photo do Dono: " + _photoDoDono);


//    //_idImovel = dados['idUsuario'];
//    _url = dados['urlImagens'];
//    _log = dados['logadouro'];
//    _comp = dados['complemento'];
//    _tipo = dados['tipoImovel'];
//    _valor= dados['valor'];
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
        title: Text("Dados do Alugel"),
      ),
      body: Form(
        child: Container(
          //decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 10),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Data Inicial: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      InkWell(

                        onTap: () {
                          _selectedDate(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${formatDate(_date, [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy
                                ])}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                            ),
                          ],
                        ),
                        splashColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Alugar o Imóvel",
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
                    style: TextStyle(color: Colors.red, fontSize: 20),
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
