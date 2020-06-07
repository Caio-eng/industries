import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sobre'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SIMOB',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "imagens/logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Detalhes',
                            textAlign: TextAlign.center,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Divider(),
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.asset(
                                    "imagens/logo.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Divider(),
                                Text('SIMOB',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),),
                                Divider(),
                                Text('Aplicativo com intuito em tornar, sua vida mais facil,'
                                    'agora você além de cadastrar seus imóveis, pode gerencia-los '
                                    'enviar contrato, trocar mensagens com Locatário ou Locador,'
                                    'Alem de controlar se está recebendo ou não!',
                                  textAlign: TextAlign.center,),
                                Divider(),
                                Text('Contato', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('simob@gmail.com', textAlign: TextAlign.center,),
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
                  child: Text('Sobre Nós !',
                    textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 20,
                    ),),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Cadastro de Imóveis',
                            textAlign: TextAlign.center,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Divider(),
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.asset(
                                    "imagens/sobre.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Divider(),
                              Text('1° Cadastre o seu CPF',
                                textAlign: TextAlign.center,),
                                Divider(),
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.asset(
                                    "imagens/2.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Divider(),
                                Text('2°Cadastre o seu Cartão',
                                  textAlign: TextAlign.center,),
                                Divider(),
                                Text('3° Vá nos três pontos, no canto inferior da tela, e clique e MEUS IMÓVEIS, e Clique em CADASTRAR',
                                textAlign: TextAlign.center,)
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
                  child: Text('Como Cadastrar um Imóvel ?',style: TextStyle(
                      fontSize: 20,

                  ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Contrato',
                            textAlign: TextAlign.center,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Parte Como Locador',
                                  textAlign: TextAlign.center,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Divider(),
                                Text('1° Vá em Propostas', textAlign: TextAlign.center, ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('2° Clique sobre a Proposta', textAlign: TextAlign.center,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('3° Clique Enviar Contrato, selecione e aguarde a respota do Locatário!', textAlign: TextAlign.center,),
                                Divider(),
                                Text('Parte Como Locatário',
                                  textAlign: TextAlign.center,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Divider(),
                                Text('1° Vá em Propostas', textAlign: TextAlign.center, ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('2° Clique sobre a Proposta', textAlign: TextAlign.center,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('3° Clique Enviar Contrato, selecione e aguarde o Locador aceitar a Proposta!', textAlign: TextAlign.center,),
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
                  child: Text('Como Enviar um Contrato ?', style: TextStyle(
                    fontSize: 20
                  ),),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Pagamento',
                            textAlign: TextAlign.center,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('1° Vá em Imóvel Alugado', textAlign: TextAlign.center, ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('2° Clique nos três pontos, e vá em Pagar Aluguel', textAlign: TextAlign.center,),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('3° Clique sobre a Parcela do Aluguel e clique em confirmar, Pronto pagamento Realizado!!', textAlign: TextAlign.center,),
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
                  child: Text('Como Pagar o Aluguel ?', style: TextStyle(
                      fontSize: 20
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
