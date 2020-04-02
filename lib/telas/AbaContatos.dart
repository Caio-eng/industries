import 'package:flutter/material.dart';
import 'package:industries/model/Conversa.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Conversa> listaConversas = [
    Conversa(
      "Scream",
      "Top mano",
      "https://firebasestorage.googleapis.com/v0/b/industries-6e1c0.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=e14c2bef-1a5c-4781-9793-732dd45a7031",
    ),
    Conversa(
      "Lorena",
      "Oii",
      "https://firebasestorage.googleapis.com/v0/b/industries-6e1c0.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=d4bc1d98-b9c4-43c0-a5f3-1ef595b83f82",
    ),
    Conversa(
      "Marta",
      "Onde você está ?",
      "https://firebasestorage.googleapis.com/v0/b/industries-6e1c0.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=49267dd5-fa48-4dcd-ab32-5a9ed1dd8560",
    ),
    Conversa(
      "Kleyton",
      "Fala Mano",
      "https://firebasestorage.googleapis.com/v0/b/industries-6e1c0.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=2866c56f-b83d-4871-9ee7-023af3e7d5c7",
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaConversas.length,
        itemBuilder: (context, indice) {

          Conversa conversa = listaConversas[indice];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage( conversa.caminhoFoto ),
            ),
            title: Text(
              conversa.nome,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          );
        }
    );
  }
}
