import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/model/PropostaDoLocador.dart';

import '../model/AluguarImovel.dart';
import '../model/DonoDoImovel.dart';
import '../model/Imovel.dart';

class PropostasDoLocador extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;
  PropostasDoLocador(this.user, this.photo, this.emai, this.uid);
  @override
  _PropostasDoLocadorState createState() => _PropostasDoLocadorState();
}

class _PropostasDoLocadorState extends State<PropostasDoLocador> {

  String _urlImagemRecuperada;
  File _imagem;
  bool _subindoImagem = false;

  Future<List<PropostaDoLocador>> _recuperarPropostas() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("propostasDoLocador").getDocuments();
    List<PropostaDoLocador> listaPropostas = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados['idLocador'] != widget.uid) continue;
      
      PropostaDoLocador propostaDoLocador = PropostaDoLocador();
      propostaDoLocador.idLocatario = dados['idLocatario'];
      propostaDoLocador.idLocador = dados['idLocador'];
      propostaDoLocador.nomeDaImagem = dados['nomeDaImagem'];
      propostaDoLocador.nomeDaImagem2 = dados['nomeDaImagem2'];
      propostaDoLocador.nomeDaImagem3 = dados['nomeDaImagem3'];
      propostaDoLocador.nomeDaImagem4 = dados['nomeDaImagem4'];
      propostaDoLocador.nomeDaImagem5 = dados['nomeDaImagem5'];
      propostaDoLocador.valor = dados['valor'];
      propostaDoLocador.bairro = dados['bairro'];
      propostaDoLocador.complemento = dados['complemento'];
      propostaDoLocador.logadouro = dados['logadouro'];
      propostaDoLocador.urlImagens = dados['urlImagens'];
      propostaDoLocador.url = dados['url'];
      propostaDoLocador.detalhes = dados['detalhes'];
      propostaDoLocador.cidade = dados['cidade'];
      propostaDoLocador.cep = dados['cep'];
      propostaDoLocador.numero = dados['numero'];
      propostaDoLocador.url2 = dados['url2'];
      propostaDoLocador.urlImagens4 = dados['urlImagens4'];
      propostaDoLocador.urlImagens3 = dados['urlImagens3'];
      propostaDoLocador.urlImagens2 = dados['urlImagens2'];
      propostaDoLocador.urlImagens5 = dados['urlImagens5'];
      propostaDoLocador.finalizado = dados['finalizado'];
      propostaDoLocador.idImovel = dados['idImovel'];
      propostaDoLocador.cpf = dados['cpf'];
      propostaDoLocador.telefone = dados['telefone'];
      propostaDoLocador.estado = dados['estado'];
      propostaDoLocador.tipo = dados['tipo'];
      print(propostaDoLocador.cpf);

      listaPropostas.add(propostaDoLocador);
    }
    return listaPropostas;
  }

  @override
  void initState() {
    _recuperarPropostas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proposta de Contrato'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            Expanded(
              child: FutureBuilder<List<PropostaDoLocador>>(
                future: _recuperarPropostas(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text("Carregando proposta"),
                            CircularProgressIndicator()
                          ],
                        ),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, indice) {
                            List<PropostaDoLocador> listaItens = snapshot.data;
                            PropostaDoLocador propostaDoLocador =
                                listaItens[indice];

                            _atualizarUrlImagemFirestore(String url) {
                              Map<String, dynamic> dadosAtualizar = {"url": url};

                              Firestore db = Firestore.instance;
                              db.collection("propostasDoLocador").document(widget.uid).updateData(dadosAtualizar);
                              db.collection("propostasDoLocatario").document(propostaDoLocador.idLocatario).updateData(dadosAtualizar);
                              Navigator.pop(context);
                            }

                            Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
                              String url = await snapshot.ref.getDownloadURL();
                              _atualizarUrlImagemFirestore(url);

                              setState(() {
                                _urlImagemRecuperada = url;
                              });
                            }

                            Future _uploadImagem() async {
                              String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
                              FirebaseStorage storage = FirebaseStorage.instance;
                              StorageReference pastaRaiz = storage.ref();
                              StorageReference arquivo = pastaRaiz
                                  .child("propostasDoLocador")
                                  .child(widget.uid)
                                  .child(nomeImagem + ".jpg");
                              //Upload da imagem
                              StorageUploadTask task = arquivo.putFile(_imagem);

                              //Controlar progresso do upload
                              task.events.listen((StorageTaskEvent storageEvent) {
                                if (storageEvent.type == StorageTaskEventType.progress) {
                                  setState(() {
                                    _subindoImagem = true;
                                  });
                                } else if (storageEvent.type == StorageTaskEventType.success) {
                                  setState(() {
                                    _subindoImagem = false;
                                  });
                                }
                              });

                              //Recuperar url da imagem
                              task.onComplete.then((StorageTaskSnapshot snapshot) {
                                _recuperarUrlImagem(snapshot);
                              });
                            }

                            Future _recuperarImagem(String origemImagem) async {
                              File imagemSelecionada;
                              switch (origemImagem) {
                                case "galeria":
                                  imagemSelecionada =
                                  await ImagePicker.pickImage(source: ImageSource.gallery);
                                  break;
                              }

                              setState(() {
                                _imagem = imagemSelecionada;
                                _uploadImagem();
                              });
                            }

                            _aceitarContrato() async {
                              DateTime _date = new DateTime.now();
                              String _dia = (_date.day + 5).toString();
                              String _mes = (_date.month).toString();
                              String _ano = (_date.year).toString();
                              String _dataFinal = _dia + '/' + _mes + '/' + _ano;
                              String _idImovel, _nomeDoDono, _photoDoDono, _emailDoDono, _cpfDono, _teleneDono;
                              String _idLocatario, _nomeDoLocatario, _emailDoLocatario, _cpfDoLocatario,_photoDoLocatario,_telefoneDoLocatario, _id;
                              Firestore db = Firestore.instance;
                              // minhas informações
                              // Dono do imóvel
                              DocumentSnapshot snapshot =
                              await db.collection("usuarios").document(widget.uid).get();
                              Map<String, dynamic> dados = snapshot.data;
                              _nomeDoDono = dados['nome'];
                              _photoDoDono = dados['photo'];
                              _emailDoDono = dados['email'];
                              _cpfDono = dados['cpf'];
                              _teleneDono = dados['telefone'];
                              print("Nome do Dono: " + _nomeDoDono);
                              print("Email do Dono: " + _emailDoDono);
                              print("Photo do Dono: " + _photoDoDono);
                              print("CPF do Dono: " + _cpfDono);
                              print("Telefone do Dono: " + _teleneDono);
                              print("\n");

                              //Informações do Locatário
                              // Informação do usuario Logado
                              DocumentSnapshot snapshot2 =
                              await db.collection("usuarios").document(propostaDoLocador.idLocatario).get();
                              Map<String, dynamic> dados2 = snapshot2.data;
                              _idLocatario = dados2['idUsuario'];
                              _nomeDoLocatario = dados2['nome'];
                              _photoDoLocatario = dados2['photo'];
                              _emailDoLocatario = dados2['email'];
                              _cpfDoLocatario = dados2['cpf'];
                              _telefoneDoLocatario = dados2['telefone'];
                              print("Nome do Locatario: " + _nomeDoLocatario);
                              print("Email do Locatario: " + _emailDoLocatario);
                              print("Photo do Locatario: " + _photoDoLocatario);
                              print("CPF do Locatario: " + _cpfDoLocatario);
                              print("Telefone do Locatario: " + _telefoneDoLocatario);

                              //Cartão Locatário
                              //Cartao
                              DocumentSnapshot snapshot3 =
                              await db.collection("cartao").document(propostaDoLocador.idLocatario).get();
                              Map<String, dynamic> dados3 = snapshot3.data;
                              setState(() {
                                _id = dados3['idUsuario'];
                                print("Aqui: " + _id);
                              });


                              _cadastrarDono(DonoDoImovel donoDoImovel) {
                                Firestore db = Firestore.instance;

                                db
                                    .collection("meuImovel")
                                    .document(propostaDoLocador.idImovel)
                                    .setData(donoDoImovel.toMap());
                              }

                              _cadastrarAluguel(AlugarImovel alugarImovel) {
                                //Salvar dados do Imovel
                                Firestore db = Firestore.instance;
                                //String nomeImovel = DateTime.now().millisecondsSinceEpoch.toString();
                                db
                                    .collection("imovelAlugado")
                                    .document(propostaDoLocador.idLocatario)
                                    .collection("Detalhes")
                                    .document(propostaDoLocador.idImovel)
                                    .setData(alugarImovel.toMap());
                              }

                              _validarCampos() {
                                // Para quem alugou
                                AlugarImovel alugarImovel = AlugarImovel();
                                Imovel imovel = Imovel();
                                alugarImovel.telefoneDoDono = _teleneDono;
                                alugarImovel.cpfDoDono = _cpfDono;
                                alugarImovel.cepImovelAlugado = propostaDoLocador.cep;
                                alugarImovel.cidadeImovelAlugado = propostaDoLocador.cidade;
                                alugarImovel.bairroImovelAlugado = propostaDoLocador.bairro;
                                alugarImovel.numeroImovelAlugado = propostaDoLocador.numero;
                                alugarImovel.nomeDaImagemImovelAlugado = propostaDoLocador.nomeDaImagem;
                                alugarImovel.nomeDaImagemImovelAlugado2 = propostaDoLocador.nomeDaImagem2;
                                alugarImovel.nomeDaImagemImovelAlugado3 = propostaDoLocador.nomeDaImagem3;
                                alugarImovel.nomeDaImagemImovelAlugado4 = propostaDoLocador.nomeDaImagem4;
                                alugarImovel.nomeDaImagemImovelAlugado5 = propostaDoLocador.nomeDaImagem5;
                                alugarImovel.dataFinal = _dataFinal;
                                alugarImovel.idImovel = propostaDoLocador.idImovel;
                                alugarImovel.estadoImovelAlugado = propostaDoLocador.estado;
                                alugarImovel.detalhesImovelAlugado = propostaDoLocador.detalhes;
                                alugarImovel.urlImagensImovelAlugado = propostaDoLocador.urlImagens;
                                alugarImovel.urlImagensImovelAlugado2 = propostaDoLocador.urlImagens2;
                                alugarImovel.urlImagensImovelAlugado3 = propostaDoLocador.urlImagens3;
                                alugarImovel.urlImagensImovelAlugado4 = propostaDoLocador.urlImagens4;
                                alugarImovel.urlImagensImovelAlugado5 = propostaDoLocador.urlImagens5;
                                alugarImovel.valorImovelAlugado = propostaDoLocador.valor;
                                alugarImovel.tipoImovelImovelAlugado = propostaDoLocador.tipo;
                                alugarImovel.complementoImovelAlugado = propostaDoLocador.complemento;
                                alugarImovel.logadouroImovelAlugado = propostaDoLocador.logadouro;
                                alugarImovel.nomeDoDono = _nomeDoDono;
                                alugarImovel.urlImagemDoDono = _photoDoDono;
                                alugarImovel.emailDoDono = _emailDoDono;
                                alugarImovel.idDono = propostaDoLocador.idLocador;
                                alugarImovel.urlDoContrato = propostaDoLocador.url2;
                                alugarImovel.idLocatario = propostaDoLocador.idLocatario;
                                alugarImovel.tipoDePagamento = "Cartão de Crédito";
                                alugarImovel.dataInicio =
                                    formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();

                                // Para o dono do imovel
                                DonoDoImovel donoDoImovel = DonoDoImovel();
                                donoDoImovel.telefoneUsuario = _telefoneDoLocatario;
                                donoDoImovel.cpfUsuario = _cpfDoLocatario;
                                donoDoImovel.cepDonoDoImovel = propostaDoLocador.cep;
                                donoDoImovel.urlDoContrato = propostaDoLocador.url2;
                                donoDoImovel.cidadeDonoDoImovel = propostaDoLocador.cidade;
                                donoDoImovel.bairroDonoDoImovel = propostaDoLocador.bairro;
                                donoDoImovel.numeroDonoDoImovel = propostaDoLocador.numero;
                                donoDoImovel.nomeDaImagemImovel = propostaDoLocador.nomeDaImagem;
                                donoDoImovel.nomeDaImagemImovel2 = propostaDoLocador.nomeDaImagem2;
                                donoDoImovel.nomeDaImagemImovel3 = propostaDoLocador.nomeDaImagem3;
                                donoDoImovel.nomeDaImagemImovel4 = propostaDoLocador.nomeDaImagem4;
                                donoDoImovel.nomeDaImagemImovel5 = propostaDoLocador.nomeDaImagem5;
                                donoDoImovel.dataFinal = _dataFinal;
                                donoDoImovel.idImovelAlugado = propostaDoLocador.idImovel;
                                donoDoImovel.estadoDoImovel = propostaDoLocador.estado;
                                donoDoImovel.detalhesDonoDoImovel = propostaDoLocador.detalhes;
                                donoDoImovel.urlImagensDonoDoImovel = propostaDoLocador.urlImagens;
                                donoDoImovel.urlImagensDonoDoImovel2 = propostaDoLocador.urlImagens2;
                                donoDoImovel.urlImagensDonoDoImovel3 = propostaDoLocador.urlImagens3;
                                donoDoImovel.urlImagensDonoDoImovel4 = propostaDoLocador.urlImagens4;
                                donoDoImovel.urlImagensDonoDoImovel5 = propostaDoLocador.urlImagens5;
                                donoDoImovel.valorDonoDoImovel = propostaDoLocador.valor;
                                donoDoImovel.tipoDonoDoImovel = propostaDoLocador.tipo;
                                donoDoImovel.complementoDonoDoImovel = propostaDoLocador.complemento;
                                donoDoImovel.logadouroDonoDoImovel = propostaDoLocador.logadouro;
                                donoDoImovel.nomeDoLocatario = _nomeDoLocatario;
                                donoDoImovel.urlImagemDoLocatario = _photoDoLocatario;
                                donoDoImovel.emailDoLocatario = _emailDoLocatario;
                                donoDoImovel.idDono = propostaDoLocador.idLocador;
                                donoDoImovel.idLocatario = propostaDoLocador.idLocatario;
                                donoDoImovel.tipoDeRecibo = "Cartão de Crédito";
                                donoDoImovel.dataInicio =
                                    formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();

                                Map<String, dynamic> dadosAtualizar = {"finalizado": widget.uid};

                                Firestore db = Firestore.instance;
                                db.collection("propostasDoLocador").document(widget.uid).updateData(dadosAtualizar);
                                db.collection("propostasDoLocatario").document(propostaDoLocador.idLocatario).updateData(dadosAtualizar);
                                _cadastrarDono(donoDoImovel);
                                _cadastrarAluguel(alugarImovel);

                              }



                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Aceitar Proposta',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Ao Aceitar a Proposta o imovel estára alugado para o locatário!'),
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
                                            child: Text('Aceitar'),
                                            onPressed: () {
                                              _validarCampos();
                                              Navigator.pop(context);
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

                            _CancelarContrato() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Recusar Proposta',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Você deseja recusa a proposta do Locatário!'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text('Não'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Sim'),
                                            onPressed: () {
                                              Firestore db = Firestore.instance;
                                              Imovel imovel = Imovel();
                                              imovel.logadouro = propostaDoLocador.logadouro;
                                              imovel.complemento = propostaDoLocador.complemento;
                                              imovel.valor = propostaDoLocador.valor;
                                              imovel.urlImagens = propostaDoLocador.urlImagens;
                                              imovel.url2 = propostaDoLocador.urlImagens2;
                                              imovel.url3 = propostaDoLocador.urlImagens3;
                                              imovel.url4 = propostaDoLocador.urlImagens4;
                                              imovel.url5 = propostaDoLocador.urlImagens5;
                                              imovel.detalhes = propostaDoLocador.detalhes;
                                              imovel.siglaEstado = propostaDoLocador.estado;
                                              imovel.cidade = propostaDoLocador.cidade;
                                              imovel.cep = propostaDoLocador.cep;
                                              imovel.bairro = propostaDoLocador.bairro;
                                              imovel.numero = propostaDoLocador.numero;
                                              imovel.tipoImovel = propostaDoLocador.tipo;
                                              imovel.idUsuario = widget.uid;
                                              imovel.nomeDaImagem = propostaDoLocador.nomeDaImagem;
                                              imovel.nomeDaImagem2 = propostaDoLocador.nomeDaImagem2;
                                              imovel.nomeDaImagem3 = propostaDoLocador.nomeDaImagem3;
                                              imovel.nomeDaImagem4 =propostaDoLocador.nomeDaImagem4;
                                              imovel.nomeDaImagem5 = propostaDoLocador.nomeDaImagem5;
                                              imovel.cpfUsuario = propostaDoLocador.cpf;
                                              imovel.telefoneUsuario = propostaDoLocador.telefone;
                                              db.collection("imoveis").document().setData(imovel.toMap());
                                              db
                                                  .collection("propostasDoLocatario")
                                                  .document(propostaDoLocador.idLocatario)
                                                  .delete();
                                              db
                                                  .collection("propostasDoLocador")
                                                  .document(widget.uid)
                                                  .delete();

                                              Navigator.pop(context);
                                              Navigator.pop(context);
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

                            List<String> itensMenu =  ["Aceitar Contrato", "Recusar Proposta"];
                            _escolhaMenuItem(String itemEscolhido) {
                              switch (itemEscolhido) {
                                case "Aceitar Contrato":
                                  _aceitarContrato();
                                  break;
                                case "Recusar Proposta":
                                  _CancelarContrato();
                                  break;
                              }
                            }

                            return Card(
                                child: ListTile(
                                 contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  leading: Icon(Icons.business_center),
                                  title: GestureDetector(
                                    onTap: () async {
                                      Firestore db = Firestore.instance;
                                      DocumentSnapshot snapshot =
                                      await db.collection("usuarios").document(propostaDoLocador.idLocatario).get();
                                      Map<String, dynamic> dados = snapshot.data;
                                      String _nome, _email, _photo;
                                      setState(() {
                                        _nome = dados['nome'];
                                        _email = dados['email'];
                                        _photo = dados['photo'];
                                      });
                                      String _numero, _nomeDoCartao, _cpfDoCartao;
                                      DocumentSnapshot snapshot2 =
                                      await db.collection("cartao").document(propostaDoLocador.idLocatario).get();
                                      Map<String, dynamic> dados2 = snapshot2.data;
                                      setState(() {
                                        _numero = dados2['numeroDoCartao'];
                                        _nomeDoCartao = dados2['nomeDoTitularDoCartao'];
                                        _cpfDoCartao = dados2['cpfDoTitularDoCartao'];
                                      });
                                      return showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              propostaDoLocador.finalizado != null
                                                  ? 'Contrato do Locatário'
                                                  : 'Proposta do Locatário',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 90,
                                                    backgroundImage: NetworkImage(_photo),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "Nome: " + _nome +
                                                        ' - Email: ' + _email +
                                                        '\nTelefone: ' + propostaDoLocador.telefone +
                                                        '\nCPF: ' + propostaDoLocador.cpf,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "Possui Cartão Cadastrado" +
                                                        "\nNumero: " + _numero +
                                                        "\nNome do Cartão: " + _nomeDoCartao +
                                                        "\nCPF do Cartão: " + _cpfDoCartao,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(),
                                                  propostaDoLocador.url != null && propostaDoLocador.url2 == null
                                                      ? Text("Imagem Anexada!", textAlign: TextAlign.center,)
                                                      : propostaDoLocador.url2 != null && propostaDoLocador.finalizado == null
                                                      ? Text('Contrato assinado pelo Locatário!', textAlign: TextAlign.center,)
                                                      : propostaDoLocador.finalizado != null
                                                      ? Text('Você possui um contrato ativo com o Locatário ' + _nome + '\nPara mais informações va na pagina Meu Imóvel')
                                                      : Text("Clique para anexar o contrato!", textAlign: TextAlign.center,),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  propostaDoLocador.url != null
                                                      ? Container()
                                                      : Center(
                                                      child:  RaisedButton(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Icon(Icons.photo, color: Colors.white,),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Text('Enviar Contrato', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                                                          ],
                                                        ),
                                                        color: Colors.blue,
                                                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(32)),
                                                        onPressed: () {
                                                          _recuperarImagem("galeria");
                                                        },
                                                      )
                                                  ),
                                                  Divider(),
                                                  _subindoImagem
                                                      ? CircularProgressIndicator()
                                                      : Container(),
                                                  propostaDoLocador.url != null && propostaDoLocador.url2 == null
                                                      ? Image.network(propostaDoLocador.url,)
                                                      : propostaDoLocador.url2 != null
                                                      ? Image.network(propostaDoLocador.url2)
                                                      : Text("Selecione Enviar  Contrato, e aguarde a assinatura do Locatário!", textAlign: TextAlign.center,),
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
                                    child: propostaDoLocador.url != null && propostaDoLocador.url2 == null
                                        ? Text('Aguardando Assinatura do contrato pelo Locátario', textAlign: TextAlign.center,)
                                        : propostaDoLocador.url2 != null && propostaDoLocador.finalizado == null
                                        ? Text('Contrato assinado pelo locatário!', textAlign: TextAlign.center,)
                                        : propostaDoLocador.finalizado != null
                                        ? Text('Imóvel Locado', textAlign: TextAlign.center,)
                                        : Text('Solicitação do Locatário', textAlign: TextAlign.center,
                                    ),
                                 ),
                                  trailing: propostaDoLocador.finalizado != null
                                      ? Icon(Icons.verified_user, color: Colors.blue,)
                                      : PopupMenuButton<String>(
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
                          });
                      break;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
