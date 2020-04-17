import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:industries/ImovelAlugado.dart';
import 'package:industries/model/AluguarImovel.dart';
import 'package:industries/model/Imovel.dart';

class AluguelImovel extends StatefulWidget {
  Function signOut;
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
  var controller = new MaskedTextController(mask: '000.000.000-00');
  String _idUsuarioLogado = "";
  String _idDono = "";
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";

  Firestore db = Firestore.instance;

  _validarCampos() {

    String _cpfUsuario = controller.text;

    if (_cpfUsuario.isNotEmpty && _cpfUsuario.length == 14) {
      AlugarImovel alugarImovel = AlugarImovel();
      Imovel imovel= Imovel();
      alugarImovel.ididLocatario = _idUsuarioLogado;
      alugarImovel.cpfUsuario = _cpfUsuario;
      alugarImovel.idDono = _idDono;
      alugarImovel.logadouroImovelAlugado = _log;
      alugarImovel.complementoImovelAlugado = _comp;
      alugarImovel.tipoImovelImovelAlugado = _tipo;
      alugarImovel.valorImovelAlugado = _valor;
      alugarImovel.urlImagensImovelAlugado = _url;
      _cadastrarAluguel( alugarImovel );
      _excluirImovel( imovel );
    }else {
      _mensagemErro = "cpf não pode conter menos que 14 números ";
    }

  }

  _cadastrarAluguel( AlugarImovel alugarImovel ) {

    //Salvar dados do Imovel
    Firestore db = Firestore.instance;
    //String nomeImovel = DateTime.now().millisecondsSinceEpoch.toString();
    db.collection("imovelAlugado")
        .document(widget.uid)
        .collection("Detalhes")
        .document()
        .setData(alugarImovel.toMap());

    Navigator.push(context, MaterialPageRoute(builder: (context) => ImovelAlugado(widget.user, widget.photo, widget.emai, widget.uid)));
  }

  _excluirImovel(Imovel imovel) {
    Firestore db = Firestore.instance;

    db.collection("imoveis")
        .document(widget.document.documentID)
        .delete();

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
    print("Id do dono: " + widget.document['idUsuario']);
    print(widget.uid);

    DocumentSnapshot snapshot =
    await db.collection("imoveis").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    //_idImovel = dados['idUsuario'];
    _url = dados['urlImagens'];
    _log = dados['logadouro'];
    _comp = dados['complemento'];
    _tipo = dados['tipoImovel'];
    _valor= dados['valor'];
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
      body: Container(
        //decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Digite o seu CPF",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                  ),
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
    );
  }
}
