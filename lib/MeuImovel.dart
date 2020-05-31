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
  String _idEnvioLogado,
      _idEnvioDeslo,
      _idEnvioImovel,
      _idPagador,
      _idReceptor,
      _idPagador1,
      _idReceptor1;
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
                    ' Tipo do Imóvel: ' +
                        document['tipoDonoDoImovel'] +
                        '\nLocalização: ' +
                        document['cidadeDonoDoImovel'] +
                        ' - ' +
                        document['estadoDoImovel'] +
                        "\nValor Alugado: " +
                        document['valorDonoDoImovel'],
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  CircleAvatar(
                    radius: 110,
                    backgroundColor: Colors.transparent,
                    child: Carousel(
                      images: [
                        NetworkImage(document['urlImagensDonoDoImovel']),
                        NetworkImage(document['urlImagensDonoDoImovel2']),
                        NetworkImage(document['urlImagensDonoDoImovel3']),
                        NetworkImage(document['urlImagensDonoDoImovel4']),
                        NetworkImage(document['urlImagensDonoDoImovel5']),
                      ],
                      dotSize: 8,
                      dotBgColor: Colors.transparent,
                      dotColor: Colors.white,
                      autoplay: false,
                      borderRadius: true,
                      dotIncreasedColor: Colors.blue,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Logadouro: " +
                        document['logadouroDonoDoImovel'] +
                        " - " +
                        document['bairroDonoDoImovel'] +
                        "\nComplemento: " +
                        document['complementoDonoDoImovel'] +
                        '\nDetalhes: ' +
                        document['detalhesDonoDoImovel'] +
                        "\nCEP: " +
                        document['cepDonoDoImovel'] +
                        " N°: " +
                        document['numeroDono'] +
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

      DocumentSnapshot snapshot5 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela3')
          .get();
      Map<String, dynamic> dados5 = snapshot5.data;

      DocumentSnapshot snapshot6 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela4')
          .get();
      Map<String, dynamic> dados6 = snapshot6.data;

      DocumentSnapshot snapshot7 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela5')
          .get();
      Map<String, dynamic> dados7 = snapshot7.data;

      DocumentSnapshot snapshot8 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela6')
          .get();
      Map<String, dynamic> dados8 = snapshot8.data;

      DocumentSnapshot snapshot9 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela7')
          .get();
      Map<String, dynamic> dados9 = snapshot9.data;

      DocumentSnapshot snapshot10 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela8')
          .get();
      Map<String, dynamic> dados10 = snapshot10.data;

      DocumentSnapshot snapshot11 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela9')
          .get();
      Map<String, dynamic> dados11 = snapshot11.data;

      DocumentSnapshot snapshot12 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela10')
          .get();
      Map<String, dynamic> dados12 = snapshot12.data;

      DocumentSnapshot snapshot13 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela11')
          .get();
      Map<String, dynamic> dados13 = snapshot13.data;

      DocumentSnapshot snapshot14 = await db
          .collection("pagarImoveis")
          .document(_idDoLocatario)
          .collection(document['idImovelAlugado'])
          .document('parcela12')
          .get();
      Map<String, dynamic> dados14 = snapshot14.data;

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
                              barrierDismissible:
                                  false, // user must tap button!
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
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 2: OK\nData do Rec: ${dados4['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados5 == null || dados5['idDoPagador'] == null
                      ? Text(
                          ' Recibo 3',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 3: OK\nData do Rec: ${dados5['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados6 == null || dados6['idDoPagador'] == null
                      ? Text(
                          ' Recibo 4',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 4: OK\nData do Rec: ${dados6['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados7 == null || dados7['idDoPagador'] == null
                      ? Text(
                          ' Recibo 5',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 5: OK\nData do Rec: ${dados7['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados8 == null || dados8['idDoPagador'] == null
                      ? Text(
                          ' Recibo 6',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 6: OK\nData do Rec: ${dados8['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados9 == null || dados9['idDoPagador'] == null
                      ? Text(
                          ' Recibo 7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 7: OK\nData do Rec: ${dados9['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados10 == null || dados10['idDoPagador'] == null
                      ? Text(
                          ' Recibo 8',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 8: OK\nData do Rec: ${dados10['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados11 == null || dados11['idDoPagador'] == null
                      ? Text(
                          ' Recibo 9',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 9: OK\nData do Rec: ${dados11['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados12 == null || dados12['idDoPagador'] == null
                      ? Text(
                          ' Recibo 10',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 10: OK\nData do Rec: ${dados12['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados13 == null || dados13['idDoPagador'] == null
                      ? Text(
                          ' Recibo 11',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 11: OK\nData do Rec: ${dados13['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  dados14 == null || dados14['idDoPagador'] == null
                      ? Text(
                          ' Recibo 12',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : GestureDetector(
                          onTap: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                            'Recibo 12: OK\nData do Rec: ${dados14['dataDoPagamento']} ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green),
                          ),
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
                  _idPagador == widget.uid
                      ? Text('Fatura Paga este mês')
                      : FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Imovel imovel = Imovel();
                            imovel.logadouro =
                                document['logadouroDonoDoImovel'];
                            imovel.complemento =
                                document['complementoDonoDoImovel'];
                            imovel.idImovel = document['idImovelAlugado'];
                            imovel.detalhes = document['detalhesDonoDoImovel'];
                            imovel.idUsuario = document['idDono'];
                            imovel.tipoImovel = document['tipoDonoDoImovel'];
                            imovel.valor = document['valorDonoDoImovel'];
                            imovel.urlImagens =
                                document['urlImagensDonoDoImovel'];
                            imovel.url2 = document['urlImagensDonoDoImovel2'];
                            imovel.url3 = document['urlImagensDonoDoImovel3'];
                            imovel.url4 = document['urlImagensDonoDoImovel4'];
                            imovel.url5 = document['urlImagensDonoDoImovel5'];
                            imovel.siglaEstado = document['estadoDoImovel'];
                            imovel.cidade = document['cidadeDonoDoImovel'];
                            imovel.cep = document['cepDonoDoImovel'];
                            imovel.bairro = document['bairroDonoDoImovel'];
                            imovel.numero = document['numeroDono'];
                            imovel.nomeDaImagem =
                                document['nomeDaImagemImovel'];
                            imovel.nomeDaImagem2 =
                                document['nomeDaImagemImovel2'];
                            imovel.nomeDaImagem3 =
                                document['nomeDaImagemImovel3'];
                            imovel.nomeDaImagem4 =
                                document['nomeDaImagemImovel4'];
                            imovel.nomeDaImagem5 =
                                document['nomeDaImagemImovel5'];
                            imovel.cpfUsuario = _cpf;
                            imovel.telefoneUsuario = _telefone;
                            db
                                .collection("imoveis")
                                .document(document['idImovelAlugado'])
                                .setData(imovel.toMap());
                            db
                              .collection("meus_imoveis")
                              .document(document['idDono'])
                              .collection("imoveis")
                              .document(document['idImovelAlugado'])
                              .setData(imovel.toMap());
                            db
                                .collection("meuImovel")
                                .document(document.documentID)
                                .delete();

                            db
                                .collection("propostasDoLocador")
                                .document(widget.uid)
                                .delete();
                            db
                                .collection("propostasDoLocatario")
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

    if (_idPagador == widget.uid) {
      return Card(
          child: ListTile(
        title: Text(
          document['logadouroDonoDoImovel'] +
              ' - ' +
              document['bairroDonoDoImovel'],
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
              document['logadouroDonoDoImovel'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              document['valorDonoDoImovel'],
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
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados2 = snapshot2.data;

    setState(() {
      _idEnvioLogado = widget.uid;
      _idEnvioDeslo = dados2['idPg1'];
      _idEnvioImovel = dados2['idImovel'];
    });
    DocumentSnapshot snapshot3 = await db
        .collection("pagarImoveis")
        .document(widget.uid)
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

    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando imóveis alugado"),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meu Imóveis'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            StreamBuilder(
              stream: Firestore.instance
                  .collection('meuImovel')
                  .where("idDono", isEqualTo: widget.uid)
                  .snapshots(),
              //print an integer every 2secs, 10 times
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:

                  var docs = snapshot.data.documents;
                  if (docs.length == 0) {
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Nenhum imóvel locado! :( ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemExtent: 80.0,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return _buildList(context, snapshot.data.documents[index]);
                      },
                    ),
                  );
                    break;
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
