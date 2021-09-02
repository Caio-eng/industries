import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:validadores/Validador.dart';

import 'model/CartaoDeCredito.dart';

class EditarCartaoDeCredito extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  EditarCartaoDeCredito(this.user, this.photo, this.emai, this.uid);
  @override
  _EditarCartaoDeCreditoState createState() => _EditarCartaoDeCreditoState();
}

class _EditarCartaoDeCreditoState extends State<EditarCartaoDeCredito> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerNome = TextEditingController();
  var controllerDataDeVencimento = new MaskedTextController(mask: '00/00');
  var controllerCvv = new MaskedTextController(mask: '000');
  var controllerCPF = new MaskedTextController(mask: '000.000.000-00');
  var controllerNumeroDoCartao = new MaskedTextController(mask: '0000 0000 0000 0000');
  DateTime _date = new DateTime.now();
  String _idUsuario, _cpfUsuario, _telefoneUsuario, _idEnvioLogado, _idEnvioDeslo, _idEnvioImovel, _idCartao;
  String _mensagemErro = "";
  String _id;

  Firestore db = Firestore.instance;

  _atualizarCartao() async {
    String nome = _controllerNome.text;
    String numero = controllerNumeroDoCartao.text;
    String cvv = controllerCvv.text;
    String cpf = controllerCPF.text;
    String data = controllerDataDeVencimento.text;
    String mesDeHoje = _date.month.toString();
    String anoDeHoje = _date.year.toString();
    String junte = mesDeHoje + '/' + anoDeHoje;

    if (nome.isNotEmpty && nome.length > 4) {
      if (numero.isNotEmpty && numero.length == 19) {
        if (cvv.isNotEmpty && cvv.length == 3) {
          if (data.isNotEmpty && data.length == 5 ) {
            Map<String, dynamic> dadosAtualizar = {
              "numeroDoCartao" : numero,
              "nomeDoTitularDoCartao" : nome,
              "dataDeValidadeDoCartao" : data,
              "cpfDoTitularDoCartao" : cpf,
              "cvv" : cvv,
            };

            CartaoDeCredito cartaoDeCredito = CartaoDeCredito();
            cartaoDeCredito.nomeDoTitularDoCartao = nome;
            cartaoDeCredito.cpfDoTitularDoCartao = cpf;
            cartaoDeCredito.numeroDoCartao = numero;
            cartaoDeCredito.cvv = cvv;
            cartaoDeCredito.dataDeValdadeDoCartao = data;
            cartaoDeCredito.idUsuario = widget.uid;

            Firestore db = Firestore.instance;
            db.collection("cartao")
                .document(widget.uid)
                .updateData(dadosAtualizar);
            Navigator.pop(context);

          } else {
            setState(() {
              _mensagemErro = "Data invalida";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "O CVV é 3 números";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Número do cartão é 16 números";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Nome do Cartão tem que ter mais que 4 letras";
      });
    }
  }

  _recuperarDadosUsuario() async {
    _idUsuario = widget.uid;
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot4 = await db.collection("cartao").document(_idUsuario).get();
    Map<String, dynamic> dados4 = snapshot4.data;
    setState(() {
      _controllerNome.text = dados4['nomeDoTitularDoCartao'];
      controllerNumeroDoCartao.text = dados4['numeroDoCartao'];
      controllerCvv.text = dados4['cvv'];
      controllerCPF.text = dados4['cpfDoTitularDoCartao'];
      controllerDataDeVencimento.text = dados4['dataDeValidadeDoCartao'];
    });


    QuerySnapshot querySnapshot = await db.collection("idEnvios").where(
        'idUsuarioLogado', isEqualTo: _idEnvioLogado).getDocuments();

    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      setState(() {
        _idEnvioLogado = dados['idUsuarioLogado'];
        _idEnvioDeslo = dados['idUsuarioDeslogado'];
        _idEnvioImovel = dados['idDoImovel'];

        print("1: " + _idEnvioLogado);
        print("2: " + _idEnvioDeslo);
      });

      DocumentSnapshot snapshot3 = await db.collection("pagarImoveis").document(_idEnvioLogado).collection(_idEnvioImovel).document('parcela1').get();
      Map<String, dynamic> dados3 = snapshot3.data;
      _idCartao = dados3['idUsuarioDoCartao'];
      print('Logadouro: ' + dados3['idUsuarioDoCartao']);


    }
  }

  @override
  void initState() {
    //_dropdownMenuItens = buildDropdownMenuItens(_estados);
    //_selectedEstado = _dropdownMenuItens[8].value;
    super.initState();

    _recuperarDadosUsuario();
    //listaTela.add(_imagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edição do Cartão'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "imagens/cartao.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNome,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Digite o seu nome do cartão",
                        labelText: 'Nome',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            return Validador()
                                .add(Validar.CPF, msg: 'CPF Inválido')
                                .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                                .minLength(11)
                                .maxLength(11)
                                .valido(value, clearNoNumber: true);
                          },
                          controller: controllerCPF,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            labelText: 'CPF',
                            hintText: 'Digite o seu CPF',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controllerNumeroDoCartao,
                      //autofocus: true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "0000 0000 0000 0000",
                        labelText: 'Número do cartão',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controllerDataDeVencimento,
                      //autofocus: true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "00/00",
                        labelText: 'Data de Vencimento',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: controllerCvv,
                      //autofocus: true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "000",
                        labelText: 'CVV',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                      child: Text(
                        "Atualizar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _atualizarCartao();
                        }
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
      ),
    );
  }
}
