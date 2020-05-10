import 'package:flutter/material.dart';
import 'package:industries/service/via_cep_service.dart';


class ConsultarCep extends StatefulWidget {
  @override
  _ConsultarCepState createState() => _ConsultarCepState();
}

class _ConsultarCepState extends State<ConsultarCep> {
  var _searchCepController = TextEditingController();
  var _localidadeController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
    _localidadeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm(),
            SizedBox(
              width: 5,
            ),
          TextField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Localidade'),
            controller: _localidadeController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;


    final resultCep = await ViaCepService.fetchCep(cep: cep);
    _localidadeController.text = resultCep.localidade + ' - ' + resultCep.uf;
    print(resultCep.localidade);
    print(resultCep.uf);// Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson();
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(_result ?? ''),
    );
  }
}
