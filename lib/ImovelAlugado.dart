import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:industries/Home.dart';
import 'package:industries/model/IdEnviar.dart';
import 'package:industries/model/PagarImovel.dart';

import 'model/Imovel.dart';

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
  String _estado, _cep, _numero, _bairro, _cidade;
  String _dataInicio, _idUsuarioDoCartao, _nomeUsuarioDoCartao, _cpfUsuarioDoCartao;
  String _idImovel, _idUsuario, _idReceber, _idPagar, _dados;
  List<String> itensMenu = [
    "Informações",
    "Pagar Aluguel",
    "Cancelar Contrato com Dono",
  ];
  DateTime _date = new DateTime.now();

  Firestore db = Firestore.instance;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    String _id;
    _cancelarContratoComDono() async{
      DocumentSnapshot snapshot3 = await db.collection("pagarImoveis").document(widget.uid).collection(document['idImovel']).document('parcela1').get();
      Map<String, dynamic> dados3 = snapshot3.data;
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
                  dados3 == null || dados3['idDoPagador'] == null || _idUsuarioDoCartao == null
                  ? FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Imovel imovel = Imovel();
                      imovel.logadouro = document['logadouroImovelAlugado'];
                      imovel.complemento = document['complementoImovelAlugado'];
                      imovel.detalhes = document['detalhesImovelAlugado'];
                      imovel.idUsuario = document['idDono'];
                      imovel.tipoImovel = document['tipoImovelImovelAlugado'];
                      imovel.valor = document['valorImovelAlugado'];
                      imovel.urlImagens = document['urlImagensImovelAlugado'];
                      imovel.siglaEstado = document['estadoImovelAlugado'];
                      imovel.cep = document['cepImovelAlugado'];
                      imovel.cidade = document['cidadeImovelAlugado'];
                      imovel.bairro = document['bairroImovelAlugado'];
                      imovel.numero = document['numeroImovelAlugado'];
                      imovel.nomeDaImagem =
                          document['nomeDaImagemImovelAlugado'];
                      imovel.cpfUsuario = document['cpfDoDono'];
                      imovel.telefoneUsuario = document['telefoneDoDono'];
                      db
                          .collection("imoveis")
                          .document()
                          .setData(imovel.toMap());
                      db
                          .collection("imovelAlugado")
                          .document(document['idLocatario'])
                          .collection("Detalhes")
                          .document(document.documentID)
                          .delete();
                      db
                          .collection("meuImovel")
                          .document(document['idImovel'])
                          .delete();
                      Navigator.pop(context);
                    },
                  )
                  : Text(
                    'Fatura Paga este mês'
                  ),
                ],
              ),
            ],
          );
        },
      );
    }



    _pagarAluguel() async {
      _idDono = document['idDono'];
      _nomeDoDono = document['nomeDoDono'];
      _emailDoDono = document['emailDoDono'];
      _cpfDoDono = document['cpfDoDono'];
      _telefoneDoDono = document['telefoneDoDono'];
      _photoDoDono = document['urlImagemDoDono'];
      _dataInicio = document['dataInicio'];
      print(
          "O Dono de id: ${_idDono}, tem o nome: ${_nomeDoDono}, seu email é: ${_emailDoDono}, portador do CPF: ${_cpfDoDono} e seu número é: ${_telefoneDoDono}.");
      _valor = document['valorImovelAlugado'];
      _log = document['logadouroImovelAlugado'];
      _comp = document['complementoImovelAlugado'];
      String cpf = _cpf;
      String nome = _nome;
      String _tipo = document['tipoImovelImovelAlugado'];
      String _estado = document['estadoImovelAlugado'];
      String _detalhes = document['detalhesImovelAlugado'];
      String _tipoDoPagamento = document['tipoDePagamento'];
      _log = document['logadouroImovelAlugado'];
      _cidade = document['cidadeImovelAlugado'];
      _cep = document['cepImovelAlugado'];
      _bairro = document['bairroImovelAlugado'];
      _numero = document['numeroImovelAlugado'];

      DocumentSnapshot snapshot3 = await db.collection("pagarImoveis").document(widget.uid).collection(document['idImovel']).document('parcela1').get();
      Map<String, dynamic> dados3 = snapshot3.data;

      DocumentSnapshot snapshot4 = await db.collection("pagarImoveis").document(widget.uid).collection(document['idImovel']).document('parcela2').get();
      Map<String, dynamic> dados4 = snapshot4.data;
      print("Olá: " + dados3.toString());

      final todayDate = DateTime.now();
      print(todayDate.month + 1);
      String dia;
      String mes1;
      String ano;
      dia = document['dataInicio'].toString();
      mes1 = (todayDate.month + 1).toString();
      ano = todayDate.year.toString();
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Parcelas do Aluguel\nATENÇÃO: AO CLICAR SERA EFETUADO O PAGAMENTO AUTOMATICAMENTE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  dados3 == null || dados3['idDoPagador'] == null || _idUsuarioDoCartao == null
                  ? InkWell(
                    splashColor: Colors.blue,
                    onTap: () {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Confirmar Pagamento',
                              textAlign: TextAlign.center,
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      'Clique em confirmar para efetuar o pagamento!'),
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
                                  FlatButton(
                                    child: Text('Confirmar'),
                                    onPressed: () {
                                      PagarImovel pagarImovel = PagarImovel();
                                      pagarImovel.idDoPagador = widget.uid;
                                      pagarImovel.idDoRecebedor = _idDono;
                                      pagarImovel.tipoDoPagamento = _tipoDoPagamento;
                                      pagarImovel.dataDoPagamento = formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();
                                      pagarImovel.valorDoPagamento = _valor;
                                      pagarImovel.juroDeAtraso = "0";
                                      pagarImovel.valorTotal = _valor;
                                      pagarImovel.idDoImovel = document['idImovel'];
                                      pagarImovel.logadouro = _log;
                                      pagarImovel.comp = _comp;
                                      pagarImovel.cidade = _cidade;
                                      pagarImovel.cep = _cep;
                                      pagarImovel.bairro = _bairro;
                                      pagarImovel.numero = _numero;
                                      pagarImovel.cpfDoDono = _cpfDoDono;
                                      pagarImovel.nomeDoDono = _nomeDoDono;
                                      pagarImovel.nome = nome;
                                      pagarImovel.cpf = cpf;
                                      pagarImovel.tipo = _tipo;
                                      pagarImovel.estado = _estado;
                                      pagarImovel.detalhes = _detalhes;
                                      pagarImovel.idUsuarioDoCartao = _idUsuarioDoCartao;
                                      pagarImovel.nomeUsuarioDoCartao = _nomeUsuarioDoCartao;
                                      pagarImovel.cpfUsuarioDoCartao = _cpfUsuarioDoCartao;
                                      IdEnviar idEnviar = IdEnviar();
                                      idEnviar.idUsuarioLogado = widget.uid;
                                      idEnviar.idUsuarioDeslogado = _idDono;
                                      idEnviar.idDoImovel = document['idImovel'];
                                      db.collection("idEnvios").document(widget.uid).setData(idEnviar.toMap());
                                      db.collection('idEnvios').document(_idDono).setData(idEnviar.toMap());
                                      //db.collection("idEnvios").document(_log).setData(idEnviar.toMap());
                                      db.collection("pagarImoveis").document(widget.uid).collection(document['idImovel']).document('parcela1').setData(pagarImovel.toMap());
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      print("Pago");
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: _idUsuarioDoCartao == null
                   ? Text("Cadastre seu cartão", style: TextStyle(color: Colors.red, fontSize: 20),)
                    : Text(
                      "Parcela 1 " + " - Valor: " + _valor + "\nData de Venc: ${formatDate(_date, [dd, '/', mm, '/', yyyy]).toString()}",
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  )
                  : Text(
                    "Parcela 1 " + " - Paga",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  dados4 == null || dados4['idDoPagador'] == null || _idUsuarioDoCartao == null
                      ? InkWell(
                    splashColor: Colors.blue,
                    onTap: () {
                      if (dados3 == null ) {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Pagamento 2',
                                textAlign: TextAlign.center,
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Efetue o pagamento 1 para ter acesso ao pagamento 2!'),
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
                      } else {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Confirmar Pagamento 2',
                                textAlign: TextAlign.center,
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Clique em confirmar para efetuar o pagamento 2!'),
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
                                    FlatButton(
                                      child: Text('Confirmar'),
                                      onPressed: () {
                                        PagarImovel pagarImovel = PagarImovel();
                                        pagarImovel.idDoPagador = widget.uid;
                                        pagarImovel.idDoRecebedor = _idDono;
                                        pagarImovel.tipoDoPagamento = _tipoDoPagamento;
                                        pagarImovel.dataDoPagamento = formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();
                                        pagarImovel.valorDoPagamento = _valor;
                                        pagarImovel.juroDeAtraso = "0";
                                        pagarImovel.valorTotal = _valor;
                                        pagarImovel.idDoImovel = document['idImovel'];
                                        pagarImovel.logadouro = _log;
                                        pagarImovel.comp = _comp;
                                        pagarImovel.cidade = _cidade;
                                        pagarImovel.cep = _cep;
                                        pagarImovel.bairro = _bairro;
                                        pagarImovel.numero = _numero;
                                        pagarImovel.cpfDoDono = _cpfDoDono;
                                        pagarImovel.nomeDoDono = _nomeDoDono;
                                        pagarImovel.nome = nome;
                                        pagarImovel.cpf = cpf;
                                        pagarImovel.tipo = _tipo;
                                        pagarImovel.estado = _estado;
                                        pagarImovel.detalhes = _detalhes;
                                        pagarImovel.idUsuarioDoCartao = _idUsuarioDoCartao;
                                        pagarImovel.nomeUsuarioDoCartao = _nomeUsuarioDoCartao;
                                        pagarImovel.cpfUsuarioDoCartao = _cpfUsuarioDoCartao;
                                        IdEnviar idEnviar = IdEnviar();
                                        idEnviar.idUsuarioLogado = widget.uid;
                                        idEnviar.idUsuarioDeslogado = _idDono;
                                        idEnviar.idDoImovel = document['idImovel'];
                                        db.collection("idEnvios").document(widget.uid).setData(idEnviar.toMap());
                                        db.collection('idEnvios').document(_idDono).setData(idEnviar.toMap());
                                        //db.collection("idEnvios").document(_log).setData(idEnviar.toMap());
                                        db.collection("pagarImoveis").document(widget.uid).collection(document['idImovel']).document('parcela2').setData(pagarImovel.toMap());
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        print("Pago");
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }

                    },
                    child: _idUsuarioDoCartao == null
                      ? Text("Cadastre seu cartão", style: TextStyle(color: Colors.red, fontSize: 20),)
                      : Text(
                      "Parcela 2 " + " - Valor: " + _valor + "\nData de Venc: " + dia.substring(0, 2) + '/' + mes1 + '/' + ano,
                      style: TextStyle(color: Colors.orange, fontSize: 18),
                    ),
                  )
                      : Text(
                    "Parcela 2 " + " - Paga",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  Text('Parcela 3' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 4' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 5' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 6' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 7' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 8' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 9' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 10' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 11' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
                  Text('Parcela 12' + " - Valor: " + _valor,
                      style: TextStyle(color: Colors.orange)),
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
      _cidade = document['cidadeImovelAlugado'];
      _cep = document['cepImovelAlugado'];
      _bairro = document['bairroImovelAlugado'];
      _numero = document['numeroImovelAlugado'];
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
            title: Text(
              'Informação ',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Tipo do Imóvel: ' +
                        _tipo +
                        '\nLocalização: ' + _cidade + ' - ' +
                        _estado +
                        "\nValor Mensal: " +
                        _valor,
                    textAlign: TextAlign.center,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_url),
                    radius: 30,
                  ),
                  Text(
                    "Logadouro: " +
                        _log + ' - ' + _bairro +
                        "\nComplemento: ${_comp}" +
                        '\nDetalhes: ' +
                        _deta + '\nCEP: ${_cep}' + ' N°: ${_numero}'
                        '\nData Inicial: ' +
                        _dataInicio,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Informação sobre o Dono",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Nome: ' +
                        _nomeDoDono +
                        " Email: " +
                        _emailDoDono +
                        "\nCPF: " +
                        _cpfDoDono +
                        "\nTelefone: " +
                        _telefoneDoDono,
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
    }

    _escolhaMenuItem(String itemEscolhido) {
      switch (itemEscolhido) {
        case "Informações":
          _informacaoImovel();
          break;
        case "Pagar Aluguel":
          _pagarAluguel();
          break;
        case "Cancelar Contrato com Dono":
          _cancelarContratoComDono();
          break;
      }
    }

    return Card(
        child: ListTile(
          title: Text(
            document['logadouroImovelAlugado'] + ' - ' + document['bairroImovelAlugado'],
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

  _recuperarDados() async {
    _idUsuarioLogado = widget.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;
    _cpf = dados['cpf'];
    _telefone = dados['telefone'];
    _nome = dados['nome'];
    _email = dados['email'];
    _photo = dados['photo'];
    print(
        "Locatário de id: ${widget.uid}, tem o nome de ${_nome}, seu email é ${_email}, portador do CPF: ${_cpf} e tem o telefone: ${_telefone}");
    print(_photo);
    //print(_idUsuarioLogado);

    DocumentSnapshot _snapshot =
    await db.collection("cartao").document(widget.uid).get();
    Map<String, dynamic> _dados = _snapshot.data;

    _idUsuarioDoCartao = _dados['idUsuario'];
    _nomeUsuarioDoCartao = _dados['nomeDoTitularDoCartao'];
    _cpfUsuarioDoCartao = _dados['cpfDoTitularDoCartao'];
    print("idCartao: " + _idUsuarioDoCartao);
    print("Número Do Cartao: " + _nomeUsuarioDoCartao);
    print("CPF do Cartão: " + _cpfUsuarioDoCartao);
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
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('imovelAlugado')
                    .document(widget.uid)
                    .collection("Detalhes")
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
