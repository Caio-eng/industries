import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:industries/AluguelImovel.dart';
import 'package:industries/model/Imovel.dart';
import 'package:industries/model/Proposta.dart';

import 'model/AluguarImovel.dart';
import 'model/DonoDoImovel.dart';


class Propostas extends StatefulWidget {
  final String user;
  final String photo;
  final String emai;
  final String uid;

  Propostas(this.user, this.photo, this.emai, this.uid);

  @override
  _PropostasState createState() => _PropostasState();
}

class _PropostasState extends State<Propostas> {

  Firestore db = Firestore.instance;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  File _imagem;
  Widget _buildList(BuildContext context, DocumentSnapshot document) {

    String _idLocatario = "";
    String _idDono = "";
    String _mensagemErro = "";
    String _url, _id;
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
    String _cpfDoLocatario = "";
    String _teleneDono = '';
    String _telefoneDoLocatario = '';
    String _nomeDoLocatario = "";
    String _emailDoLocatario = "";
    String _photoDoLocatario = "";
    String _cidade = "";
    String _bairro = "";
    String _cep = "";
    String _numero, _idU;
    DateTime _date = new DateTime.now();
    String _dia = (_date.day + 5).toString();
    String _mes = (_date.month).toString();
    String _ano = (_date.year).toString();
    String _dataFinal = _dia + '/' + _mes + '/' + _ano;
    String _idImovel;


    if (document['idProposta'] == widget.uid)  {
      _aceitarContrato() async {
        _idDono = widget.uid;
        _idLocatario = document['idCotra'];
        _url = document['urlImagens'];
        _log = document['logadouro'];
        _comp = document['complemento'];
        _tipo = document['tipo'];
        _valor = document['valor'];
        _detalhes = document['detalhes'];
        _estado = document['estado'];
        _nomeDaFoto = document['nomeDaImagem'];
        _cep = document['cep'];
        _cidade = document['cidade'];
        _bairro = document['bairro'];
        _numero = document['numero'];

        print("Localização: ${_cidade} - " + _estado);
        print("Endereço: ${_log} - ${_comp} - Bairro: " + _bairro);
        print("Detalhes: " + _detalhes);
        print("tipo do Imóvel: " + _tipo);
        print('CEP: ' + _cep);
        print('Numero: ' + _numero);
        print("Valor: " + _valor);
        print("URL: " + _url);
        print("id: " + _idLocatario);

        // minhas informações
        // Dono do imóvel
        DocumentSnapshot snapshot =
        await db.collection("usuarios").document(_idDono).get();
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
        await db.collection("usuarios").document(_idLocatario).get();
        Map<String, dynamic> dados2 = snapshot2.data;
        _idU = dados2['idUsuario'];
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
        await db.collection("cartao").document(_idLocatario).get();
        Map<String, dynamic> dados3 = snapshot3.data;
        setState(() {
          _id = dados3['idUsuario'];
          print("Aqui: " + _id);
        });


        _cadastrarDono(DonoDoImovel donoDoImovel) {
          Firestore db = Firestore.instance;

          db
              .collection("meuImovel")
              .document(document['idImovel'])
              .setData(donoDoImovel.toMap());
        }

        _cadastrarAluguel(AlugarImovel alugarImovel) {
          //Salvar dados do Imovel
          Firestore db = Firestore.instance;
          //String nomeImovel = DateTime.now().millisecondsSinceEpoch.toString();
          db
              .collection("imovelAlugado")
              .document(_idLocatario)
              .collection("Detalhes")
              .document(document['idImovel'])
              .setData(alugarImovel.toMap());
        }

        _validarCampos() {
          // Para quem alugou
          AlugarImovel alugarImovel = AlugarImovel();
          Imovel imovel = Imovel();
          alugarImovel.telefoneDoDono = _teleneDono;
          alugarImovel.cpfDoDono = _cpfDono;
          alugarImovel.cepImovelAlugado = _cep;
          alugarImovel.cidadeImovelAlugado = _cidade;
          alugarImovel.bairroImovelAlugado = _bairro;
          alugarImovel.numeroImovelAlugado = _numero;
          alugarImovel.nomeDaImagemImovelAlugado = _nomeDaFoto;
          alugarImovel.nomeDaImagemImovelAlugado2 = document['nomeDaImagem2'];
          alugarImovel.nomeDaImagemImovelAlugado3 = document['nomeDaImagem3'];
          alugarImovel.nomeDaImagemImovelAlugado4 = document['nomeDaImagem4'];
          alugarImovel.nomeDaImagemImovelAlugado5 = document['nomeDaImagem5'];
          alugarImovel.dataFinal = _dataFinal;
          alugarImovel.idImovel = document['idImovel'];
          alugarImovel.estadoImovelAlugado = _estado;
          alugarImovel.detalhesImovelAlugado = _detalhes;
          alugarImovel.urlImagensImovelAlugado = _url;
          alugarImovel.urlImagensImovelAlugado2 = document['urlImagens2'];
          alugarImovel.urlImagensImovelAlugado3 = document['urlImagens3'];
          alugarImovel.urlImagensImovelAlugado4 = document['urlImagens4'];
          alugarImovel.urlImagensImovelAlugado5 = document['urlImagens5'];
          alugarImovel.valorImovelAlugado = _valor;
          alugarImovel.tipoImovelImovelAlugado = _tipo;
          alugarImovel.complementoImovelAlugado = _comp;
          alugarImovel.logadouroImovelAlugado = _log;
          alugarImovel.nomeDoDono = _nomeDoDono;
          alugarImovel.urlImagemDoDono = _photoDoDono;
          alugarImovel.emailDoDono = _emailDoDono;
          alugarImovel.idDono = _idDono;
          alugarImovel.urlDoContrato = document['url2'];
          alugarImovel.idLocatario = _idLocatario;
          alugarImovel.tipoDePagamento = "Cartão de Crédito";
          alugarImovel.dataInicio =
              formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();

          // Para o dono do imovel
          DonoDoImovel donoDoImovel = DonoDoImovel();
          donoDoImovel.telefoneUsuario = _telefoneDoLocatario;
          donoDoImovel.cpfUsuario = _cpfDoLocatario;
          donoDoImovel.cepDonoDoImovel = _cep;
          donoDoImovel.urlDoContrato = document['url2'];
          donoDoImovel.cidadeDonoDoImovel = _cidade;
          donoDoImovel.bairroDonoDoImovel = _bairro;
          donoDoImovel.numeroDonoDoImovel = _numero;
          donoDoImovel.nomeDaImagemImovel = _nomeDaFoto;
          donoDoImovel.nomeDaImagemImovel2 = document['nomeDaImagem2'];
          donoDoImovel.nomeDaImagemImovel3 = document['nomeDaImagem3'];
          donoDoImovel.nomeDaImagemImovel4 = document['nomeDaImagem4'];
          donoDoImovel.nomeDaImagemImovel5 = document['nomeDaImagem5'];
          donoDoImovel.dataFinal = _dataFinal;
          donoDoImovel.idImovelAlugado = document['idImovel'];
          donoDoImovel.estadoDoImovel = _estado;
          donoDoImovel.detalhesDonoDoImovel = _detalhes;
          donoDoImovel.urlImagensDonoDoImovel = _url;
          donoDoImovel.urlImagensDonoDoImovel2 = document['urlImagens2'];
          donoDoImovel.urlImagensDonoDoImovel3 = document['urlImagens3'];
          donoDoImovel.urlImagensDonoDoImovel4 = document['urlImagens4'];
          donoDoImovel.urlImagensDonoDoImovel5 = document['urlImagens5'];
          donoDoImovel.valorDonoDoImovel = _valor;
          donoDoImovel.tipoDonoDoImovel = _tipo;
          donoDoImovel.complementoDonoDoImovel = _comp;
          donoDoImovel.logadouroDonoDoImovel = _log;
          donoDoImovel.nomeDoLocatario = _nomeDoLocatario;
          donoDoImovel.urlImagemDoLocatario = _photoDoLocatario;
          donoDoImovel.emailDoLocatario = _emailDoLocatario;
          donoDoImovel.idDono = _idDono;
          donoDoImovel.idLocatario = _idLocatario;
          donoDoImovel.tipoDeRecibo = "Cartão de Crédito";
          donoDoImovel.dataInicio =
              formatDate(_date, [dd, '/', mm, '/', yyyy]).toString();

          Map<String, dynamic> dadosAtualizar = {"finalizado": widget.uid};

          Firestore db = Firestore.instance;
          db.collection("propostas").document(document.documentID).updateData(dadosAtualizar);
          db.collection("propostas").document(document['idCotra']).updateData(dadosAtualizar);
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
                        Imovel imovel = Imovel();
                        imovel.logadouro = document['logadouro'];
                        imovel.complemento = document['complemento'];
                        imovel.valor = document['valor'];
                        imovel.urlImagens = document['urlImagens'];
                        imovel.url2 = document['urlImagens2'];
                        imovel.url3 = document['urlImagens3'];
                        imovel.url4 = document['urlImagens4'];
                        imovel.url5 = document['urlImagens5'];
                        imovel.detalhes = document['detalhes'];
                        imovel.siglaEstado = document['estado'];
                        imovel.cidade = document['cidade'];
                        imovel.cep = document['cep'];
                        imovel.bairro = document['bairro'];
                        imovel.numero = document['numero'];
                        imovel.tipoImovel = document['tipo'];
                        imovel.idUsuario = widget.uid;
                        imovel.nomeDaImagem = document['nomeDaImagem'];
                        imovel.nomeDaImagem2 = document['nomeDaImagem2'];
                        imovel.nomeDaImagem3 = document['nomeDaImagem3'];
                        imovel.nomeDaImagem4 = document['nomeDaImagem4'];
                        imovel.nomeDaImagem5 = document['nomeDaImagem5'];
                        imovel.cpfUsuario = document['cpf'];
                        imovel.telefoneUsuario = document['telefone'];
                        db.collection("imoveis").document().setData(imovel.toMap());
                        db
                            .collection("propostas")
                            .document(document['idCotra'])
                            .delete();
                        db
                            .collection("propostas")
                            .document(document.documentID)
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


      _atualizarUrlImagemFirestore(String url) {
        Map<String, dynamic> dadosAtualizar = {"url": url};

        Firestore db = Firestore.instance;
        db.collection("propostas").document(document.documentID).updateData(dadosAtualizar);
        db.collection("propostas").document(document['idCotra']).updateData(dadosAtualizar);
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
            .child("propostas")
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


      return Card(
        child:  ListTile(
          title: GestureDetector(
            onTap: () async {
              Firestore db = Firestore.instance;
              DocumentSnapshot snapshot =
              await db.collection("usuarios").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados = snapshot.data;
              String _nome, _email, _photo;
              setState(() {
                _nome = dados['nome'];
                _email = dados['email'];
                _photo = dados['photo'];
              });
              String _numero, _nomeDoCartao, _cpfDoCartao;
              DocumentSnapshot snapshot2 =
              await db.collection("cartao").document(document['idPropostaUsuarioLogado']).get();
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
                      document['finalizado'] != null
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
                                '\nTelefone: ' + document['telefone'] +
                                '\nCPF: ' + document['cpf'],
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
                          document['url'] != null && document['url2'] == null
                          ? Text("Imagem Anexada!", textAlign: TextAlign.center,)
                          : document['url2'] != null && document['finalizado'] == null
                          ? Text('Contrato assinado pelo Locatário!', textAlign: TextAlign.center,)
                          : document['finalizado'] != null
                          ? Text('Você possui um contrato ativo com o Locatário ' + _nome + '\nPara mais informações va na pagina Meu Imóvel')
                          : Text("Clique para anexar o contrato!", textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          document['url'] != null
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
                        document['url'] != null && document['url2'] == null
                          ? Image.network(document['url'],)
                          : document['url2'] != null
                          ? Image.network(document['url2'])
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
//                          document['url'] != null && document['url2'] == null
//                          ? Container()
//                          : FlatButton(
//                            child: Text('Enviar Contrato'),
//                            onPressed: () {
//                              _atualizarUrlImagemFirestore(_urlImagemRecuperada);
//                            },
//                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },

            child: document['url'] != null && document['url2'] == null
            ? Text('Aguardando Assinatura do contrato pelo Locátario', textAlign: TextAlign.center,)
            : document['url2'] != null && document['finalizado'] == null
            ? Text('Contrato assinado pelo locatário!', textAlign: TextAlign.center,)
            : document['finalizado'] != null
            ? Text('Imóvel Locado', textAlign: TextAlign.center,)
            : Text(document['proposta'], textAlign: TextAlign.center,),
          ),
          leading: Icon(Icons.business_center),

          trailing: document['finalizado'] != null
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
        ),
      );
    } else {
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
                        'Você deseja recusa a proposta do Locador!'),
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
                        Imovel imovel = Imovel();
                        imovel.logadouro = document['logadouro'];
                        imovel.complemento = document['complemento'];
                        imovel.valor = document['valor'];
                        imovel.urlImagens = document['urlImagens'];
                        imovel.url2 = document['urlImagens2'];
                        imovel.url3 = document['urlImagens3'];
                        imovel.url4 = document['urlImagens4'];
                        imovel.url5 = document['urlImagens5'];
                        imovel.detalhes = document['detalhes'];
                        imovel.siglaEstado = document['estado'];
                        imovel.cidade = document['cidade'];
                        imovel.cep = document['cep'];
                        imovel.bairro = document['bairro'];
                        imovel.numero = document['numero'];
                        imovel.tipoImovel = document['tipo'];
                        imovel.idUsuario = document['idPropostaUsuarioLogado'];
                        imovel.nomeDaImagem = document['nomeDaImagem'];
                        imovel.nomeDaImagem2 = document['nomeDaImagem2'];
                        imovel.nomeDaImagem3 = document['nomeDaImagem3'];
                        imovel.nomeDaImagem4 = document['nomeDaImagem4'];
                        imovel.nomeDaImagem5 = document['nomeDaImagem5'];
                        imovel.cpfUsuario = document['cpf'];
                        imovel.telefoneUsuario = document['telefone'];
                        db.collection("imoveis").document().setData(imovel.toMap());
                        db
                            .collection("propostas")
                            .document(document['idPropostaUsuarioLogado'])
                            .delete();
                        db
                            .collection("propostas")
                            .document(document.documentID)
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
      List<String> itensMenu = ["Recusar Proposta"];
      _escolhaMenuItem(String itemEscolhido) {
        switch (itemEscolhido) {
          case "Recusar Proposta":
            _CancelarContrato();
            break;
        }
      }

      _atualizarUrlImagemFirestore(String url) {
        Map<String, dynamic> dadosAtualizar = {"url2": url};

        Firestore db = Firestore.instance;
        db.collection("propostas").document(document.documentID).updateData(dadosAtualizar);
        db.collection("propostas").document(document['idProposta']).updateData(dadosAtualizar);
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
            .child("propostas")
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

      return Card(
        child:  ListTile(
          title: GestureDetector(
            onTap: () async {
              Firestore db = Firestore.instance;
              DocumentSnapshot snapshot =
              await db.collection("usuarios").document(document['idPropostaUsuarioLogado']).get();
              Map<String, dynamic> dados = snapshot.data;
              String _nome, _email, _photo;
              setState(() {
                _nome = dados['nome'];
                _email = dados['email'];
                _photo = dados['photo'];
              });
              String _numero, _nomeDoCartao, _cpfDoCartao;
              DocumentSnapshot snapshot2 =
              await db.collection("cartao").document(document['idPropostaUsuarioLogado']).get();
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
                      document['finalizado'] != null
                      ? 'Informações do Locador'
                      : 'Proposta do Locador',
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
                                '\nTelefone: ' + document['telefone'] +
                                '\nCPF: ' + document['cpf'],
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
                          document['url'] != null && document['url2'] == null
                          ? Text('Contrato do Locador disponivel abaixo!', textAlign: TextAlign.center,)
                          : document['url2'] != null
                          ? Container()
                          : Text('O Contrato estará disponivel aqui, aguardando a resposta!', textAlign: TextAlign.center,),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),
                          _subindoImagem
                              ? CircularProgressIndicator()
                              : Container(),

                          document['url'] != null && document['url2'] == null
                              ? Image.network(
                            document['url'],)
                              : document['url2'] != null
                              ? Image.network(document['url2'])
                              : Container(),

                          Divider(),

                        document['url'] != null && document['url2'] == null
                          ? Center(
                        child: RaisedButton(
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
                        ),
                      )
                          :Container(),
                          Divider(),
                          document['url'] != null && document['url2'] == null
                          ? Text('Clique em Enviar Contrato e anexe o contrato assinado, ao selecionar o contrato será enviado automáticamente ao Locatário!', textAlign: TextAlign.center,)
                          : document['url2'] != null && document['finalizado'] == null
                          ? Text('Contrato Anexado!', textAlign: TextAlign.center,)
                          : document['finalizado'] != null
                          ? Text('Você possui um contrato ativo com o Locador ' + _nome + "\nPara mais informações va na página Imóvel Alugado")
                          : Container(),
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
//                          document['url'] != null && document['url2'] == null
//                          ? FlatButton(
//                            child: Text('Enviar Contrato Assinado'),
//                            onPressed: () {
//
//                              _atualizarUrlImagemFirestore(_urlImagemRecuperada);
//                            },
//                          )
//                          : Container(),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            child: document['url'] != null && document['url2'] == null
            ? Text('Contrato disp. para assinar', textAlign: TextAlign.center,)
            : document['url2'] != null && document['finalizado'] == null
            ? Text('Aguardando o Proprietario aceitar o contrato!', textAlign: TextAlign.center,)
            : document['finalizado'] != null
            ? Text('Imóvel Alugado', textAlign: TextAlign.center,)
            : Text(document['proposta'],
              textAlign: TextAlign.center,

            ),
          ),
          leading: Icon(Icons.business_center),
          trailing: document['finalizado'] != null
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
        ),
      );
    }


  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Propostas"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),

            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('propostas').where('idPropostaUsuarioLogado', isEqualTo: widget.uid).snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  var docs = snapshot.data.documents;


                  return ListView.builder(
                    itemExtent: 80.0,
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      return _buildList(
                          context, docs[index]);
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
