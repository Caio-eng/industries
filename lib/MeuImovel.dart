import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/AluguarImovel.dart';
import 'package:industries/model/Imovel.dart';

class MeuImovel extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  MeuImovel(this.user, this.photo, this.emai, this.uid);
  @override
  _MeuImovelState createState() => _MeuImovelState();
}

class _MeuImovelState extends State<MeuImovel> {
  String _idUsuarioLogado = "";
  String _idDono = "";
  String _mensagemErro = "";
  String _url = "";
  String _log = "";
  String _comp = "";
  String _tipo = "";
  String _valor = "";
  String _locado = "";
  String _cpf, _deta, _estado, _dataInicio, _cidade, _bairro, _cep, _numero;
  String _telefone = "";
  String _idDoLocatario,
      _nomeDoLocatario,
      _emailDoLocatario,
      _cpfDoLocatario,
      _telefoneDoLocatario,
      _photoDoLocatario;
  String _idEnvioLogado, _idEnvioDeslo, _idEnvioImovel, _idPagador, _idReceptor, _idPagador1, _idReceptor1;
  List<String> itensMenu = [
    "Informações",
    "Recibo do Aluguel",
    "Cancelar Contrato"
  ];

  Firestore db = Firestore.instance;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {

    _informacaoImovel() {
      _idDoLocatario = document['idLocatario'];
      _photoDoLocatario = document['urlImagemDoLocatario'];

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              'Informação do Imóvel',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                 Text(
                  ' Tipo do Imóvel: ' + document['tipoDonoDoImovel'] +
                    '\nLocalização: ' + document['cidadeDonoDoImovel'] + ' - ' +
                      document['estadoDoImovel'] +
                      "\nValor Alugado: " + document['valorDonoDoImovel'],
                      textAlign: TextAlign.center,
                  ),
                  Divider(),
                  CircleAvatar(
                    radius: 110,
                    child: Carousel(
                      images: [
                        NetworkImage(document['urlImagensDonoDoImovel']),
                        NetworkImage(document['urlImagensDonoDoImovel2']),
                        NetworkImage(document['urlImagensDonoDoImovel3']),
                        NetworkImage(document['urlImagensDonoDoImovel4']),
                        NetworkImage(document['urlImagensDonoDoImovel5']),
                      ],
                      dotSize: 4,
                      dotSpacing: 15,
                      dotBgColor: Colors.blue.withOpacity(0.5),
                      indicatorBgPadding: 4,
                      borderRadius: true,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Logadouro: " +
                        document['logadouroDonoDoImovel'] + " - " + document['bairroDonoDoImovel']+
                        "\nComplemento: " + document['complementoDonoDoImovel'] +
                        '\nDetalhes: ' + document['detalhesDonoDoImovel'] +
                        "\nCEP: " + document['cepDonoDoImovel'] + " N°: " + document['numeroDono'] +
                        '\nData Inicial do contrato: ' +
                        document['dataInicio'],
                   textAlign: TextAlign.center,
                  ),
//                  Divider(),
//                  Text(
//                    "Informação sobre o Locatário",
//                    style: TextStyle(fontSize: 18),
//                    textAlign: TextAlign.center,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    'Nome: ' +
//                        document['nomeDoLocatario'] +
//                        " Email: " +
//                        document['emailDoLocatario'] +
//                        "\nCPF: " +
//                        document['cpfUsuario'] +
//                        "\nTelefone: " +
//                        document['telefoneUsuario'],
//                    textAlign: TextAlign.center,
//                  ),
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

    _reciboDoAluguel() async {
      _idDoLocatario = document['idLocatario'];
      _nomeDoLocatario = document['nomeDoLocatario'];
      _emailDoLocatario = document['emailDoLocatario'];
      _cpfDoLocatario = document['cpfUsuario'];
      _telefoneDoLocatario = document['telefoneUsuario'];
      _photoDoLocatario = document['urlImagemDoLocatario'];
      _valor = document['valorDonoDoImovel'];
      _log = document['logadouroDonoDoImovel'];
      _comp = document['complementoDonoDoImovel'];
      _url = document['urlImagensDonoDoImovel'];
      _deta = document['detalhesDonoDoImovel'];
      _tipo = document['tipoDonoDoImovel'];
      _estado = document['estadoDoImovel'];
      _dataInicio = document['dataInicio'];
      _cidade = document['cidadeDonoDoImovel'];
      _cep = document['cepDonoDoImovel'];
      _bairro = document['bairroDonoDoImovel'];
      _numero = document['numeroDono'];

      String _tipoDoPagamento = document['tipoDePagamento'];
      DocumentSnapshot snapshot3 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela1')
          .get();
      Map<String, dynamic> dados3 = snapshot3.data;

      DocumentSnapshot snapshot4 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela2')
          .get();
      Map<String, dynamic> dados4 = snapshot4.data;



      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              'Informação do Recibo',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  dados3 == null || dados3['idDoPagador'] == null
                      ? Text(
                          ' Pagamento em Falta ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        )
                      : GestureDetector(
                        onTap: () {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(10),
                                title: Text(
                                  'Informação do Imóvel',
                                  textAlign: TextAlign.center,
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        "Para informações do Recibo vá na tela de recibos",
                                        textAlign: TextAlign.center,
                                      ),
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
                        },
                        child: Text(
                          'Recibo 1: OK\nData do Rec: ${dados3['dataDoPagamento']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  dados4 == null || dados4['idDoPagador'] == null
                      ? Text(
                    ' Recibo 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  )
                      : GestureDetector(
                        onTap: () {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(10),
                                title: Text(
                                  'Informação do Imóvel',
                                  textAlign: TextAlign.center,
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        "Para informações do Recibo vá na tela de recibos",
                                        textAlign: TextAlign.center,
                                      ),
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
                        },
                        child: Text(
                          'Recibo 2: OK\nData do Rec: ${dados3['dataDoPagamento']} ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                  ),
                  Text(
                    'Recibo 3',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 4',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 5',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 6',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 7',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 8',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 9',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 10',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 11',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                  Text(
                    'Recibo 12',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
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

    _cancelarContrato() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cancelar Contrato',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Você deseja cancelar o contrato se sim, você clicara em Cancelar se não clicara em Voltar!'),
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
                  _idReceptor == widget.uid
                      ? Text('Fatura Paga este mês')
                      : FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Imovel imovel = Imovel();
                            imovel.logadouro =
                                document['logadouroDonoDoImovel'];
                            imovel.complemento =
                                document['complementoDonoDoImovel'];
                            imovel.detalhes = document['detalhesDonoDoImovel'];
                            imovel.idUsuario = document['idDono'];
                            imovel.tipoImovel = document['tipoDonoDoImovel'];
                            imovel.valor = document['valorDonoDoImovel'];
                            imovel.urlImagens = document['urlImagensDonoDoImovel'];
                            imovel.url2 = document['urlImagensDonoDoImovel2'];
                            imovel.url3 = document['urlImagensDonoDoImovel3'];
                            imovel.url4 = document['urlImagensDonoDoImovel4'];
                            imovel.url5 = document['urlImagensDonoDoImovel5'];
                            imovel.siglaEstado = document['estadoDoImovel'];
                            imovel.cidade = document['cidadeDonoDoImovel'];
                            imovel.cep = document['cepDonoDoImovel'];
                            imovel.bairro = document['bairroDonoDoImovel'];
                            imovel.numero = document['numeroDono'];
                            imovel.nomeDaImagem = document['nomeDaImagemImovel'];
                            imovel.nomeDaImagem2 = document['nomeDaImagemImovel2'];
                            imovel.nomeDaImagem3 = document['nomeDaImagemImovel3'];
                            imovel.nomeDaImagem4 = document['nomeDaImagemImovel4'];
                            imovel.nomeDaImagem5 = document['nomeDaImagemImovel5'];
                            imovel.cpfUsuario = _cpf;
                            imovel.telefoneUsuario = _telefone;
                            db
                                .collection("imoveis")
                                .document()
                                .setData(imovel.toMap());
                            db
                                .collection("meuImovel")
                                .document(document.documentID)
                                .delete();

                            db.collection("propostas")
                                .document(widget.uid)
                                .delete();
                            db.collection("propostas")
                                .document(document['idLocatario'])
                                .delete();

                            db
                                .collection("imovelAlugado")
                                .document(document['idLocatario'])
                                .collection("Detalhes")
                                .document(document['idImovelAlugado'])
                                .delete();
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
      switch (itemEscolhido) {
        case "Informações":
          _informacaoImovel();
          break;
        case "Recibo do Aluguel":
          _reciboDoAluguel();
          break;
        case "Cancelar Contrato":
          _cancelarContrato();
          break;
      }
    }

    if (_idReceptor == widget.uid) {
      return Card(
          child: ListTile(
        title: Text(
          document['logadouroDonoDoImovel'] + ' - ' + document['bairroDonoDoImovel'],
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          document['complementoDonoDoImovel'],
          textAlign: TextAlign.center,
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(document['urlImagensDonoDoImovel']),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: _escolhaMenuItem,
          itemBuilder: (context) {
            return itensMenu.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        ),
      ));
    } else {
      return Card(
          color: Colors.red,
          child: ListTile(
            title: Text(
              document['logadouroDonoDoImovel'] + ' - ' + document['bairroDonoDoImovel'],
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              document['complementoDonoDoImovel'],
              textAlign: TextAlign.center,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(document['urlImagensDonoDoImovel']),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            ),
          ));
    }
  }

  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;

    _cpf = dados['cpf'];
    _telefone = dados['telefone'];

    DocumentSnapshot snapshot2 =
        await db.collection("idEnvios").document(widget.uid).get();
    Map<String, dynamic> dados2 = snapshot2.data;

    setState(() {
      _idEnvioLogado = dados2['idUsuarioLogado'];
      _idEnvioDeslo = dados2['idUsuarioDeslogado'];
      _idEnvioImovel = dados2['idDoImovel'];
    });
    DocumentSnapshot snapshot3 = await db
        .collection("pagarImoveis")
        .document(_idEnvioLogado)
        .collection(_idEnvioImovel)
        .document('parcela1')
        .get();
    Map<String, dynamic> dados3 = snapshot3.data;
    setState(() {
      _idPagador = dados3['idDoPagador'];
      _idReceptor = dados3['idDoRecebedor'];
    });

    print('Ola: ' + dados3['idDoPagador']);
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
        title: Text('Meu Imóveis'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('meuImovel')
                    .where("idDono", isEqualTo: widget.uid)
                    .snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  return ListView.builder(
                    itemExtent: 80.0,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return _buildList(
                          context, snapshot.data.documents[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
