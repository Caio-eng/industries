import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReciboImovel extends StatefulWidget {
  final String uid;
  ReciboImovel(this.uid);
  @override
  _ReciboImovelState createState() => _ReciboImovelState();
}

class _ReciboImovelState extends State<ReciboImovel> {
  String _logado, _idEnvioLogado, _idEnvioDeslo, _idEnvioImovel, _dataIni;
  String _logadouro, _cpfDono, _nomeDono, _nome, _cpf, _comp, _estado, _tipoDoImo, _tipoDoPg;

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    if (document['idDoPagador'] == widget.uid || document['idDoRecebedor'] == _idEnvioDeslo) {
      return Card(
          child: ListTile(
            title: Text(
              document['logadouro'] + ' - ' + document['comp'] + '\n' + 'Nome do Pagador: ${document['nome'] +  '\nCPF do Pagador: ${document['cpf']}'}',
              textAlign: TextAlign.center,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Nome do Dono: ${document['nomeDoDono'] + '\nCPF do Dono: ${document['cpfDoDono']}'  + '\nParcela 1' + ' - Valor Pago: ' + document['valorTotal']}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            leading: Icon(Icons.receipt),

          ),
      );
    }
  }

  _recuperarDados() async{
    _logado = widget.uid;
    print(_logado);
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("idEnvios").document(widget.uid).get();
    Map<String, dynamic> dados = snapshot.data;


    setState(() {
      _idEnvioLogado = dados['idUsuarioLogado'];
      _idEnvioDeslo = dados['idUsuarioDeslogado'];
      _idEnvioImovel = dados['idDoImovel'];


    });

    print("Id Logado: " + _idEnvioLogado);
    print("Id Deslogado: " + _idEnvioDeslo);
    print("Id Imovel Referente: " + _idEnvioImovel);


  }

  @override
  void initState() {
    super.initState();
    _recuperarDados();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Recibos'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Divider(),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('pagarImoveis')
                    .document(_idEnvioLogado)
                    .collection(_idEnvioImovel)
                    .snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  return ListView.builder(
                    itemExtent: 125,
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
