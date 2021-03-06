import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:industries/model/IdEnviar.dart';

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
    final todayDate = DateTime.now();
    print(todayDate.month + 1);

    if (document['idDoPagador'] == _logado || document['idDoRecebedor'] == _idEnvioDeslo) {
      return Card(
          child: ListTile(
            title: Text(
              document['logadouro'] + ' - ' + document['bairro'] + ' CEP: ${document['cep']}' + '\n' + document['comp'] + ' N°: ${document['numero']}' +
                  '\n' + 'Nome do Pagador: ${document['nome'] +  '\nCPF do Pagador: ${document['cpf']}'}' + '\nData de pagamento: ${document['dataDoPagamento']}',
              textAlign: TextAlign.center,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Nome do Dono: ${document['nomeDoDono'] + '\nCPF do Dono: ${document['cpfDoDono']}'  +  
                    '\n ${document.documentID}' + ' - Valor Pago: ' + document['valorTotal']}',
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
//    QuerySnapshot querySnapshot = await db.collection("idEnvios").where('idUsuarioLogado', isEqualTo: _logado).getDocuments();
//
//    for (DocumentSnapshot item in querySnapshot.documents) {
//      var dados = item.data;
//
//      setState(() {
//        _idEnvioLogado = dados['idUsuarioLogado'];
//        _idEnvioDeslo = dados['idUsuarioDeslogado'];
//        _idEnvioImovel = dados['idDoImovel'];
//
//        print("1: " + _idEnvioLogado);
//        print("2: " + _idEnvioDeslo);
//      });

    DocumentSnapshot snapshot3 = await db.collection("usuarios").document(widget.uid).get();
    Map<String, dynamic> dados3 = snapshot3.data;

    setState(() {
      _idEnvioImovel = dados3['idImovel'];
      _idEnvioDeslo = dados3['idPg1'];
      _idEnvioLogado = widget.uid;
    });
      DocumentSnapshot snapshot =
      await db.collection("meuImovel").document(_idEnvioImovel).get();
      Map<String, dynamic> dados2 = snapshot.data;
      print('Logadouro: ' + dados2['logadouroDonoDoImovel']);



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
            StreamBuilder(
                stream: Firestore.instance
                    .collection('pagarImoveis')
                    .document(widget.uid)
                    .collection(_idEnvioImovel)
                    .snapshots(),
                //print an integer every 2secs, 10 times
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemExtent: 230,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return _buildList(
                            context, snapshot.data.documents[index]);
                      },
                    ),
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
}
