import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("A propos", style: TextStyle(fontSize: 18),),
            SizedBox(height: 10,),
            Text("Cette application est développé par Patrice de Saint Steban. Elle est indépendante de la bibliothèque municipale de Nantes et ne fait que dialoguer avec les serveurs de celle-ci.", style: TextStyle(fontSize: 14),),
            SizedBox(height: 10,),
            Text("Les informations sur vos cartes de bibliothèques sont uniquement enregistrés dans votre téléphone. "
                "Ils sont simplement utilisé pour se connecter sur les serveurs de la bibliothèque de Nantes. "
                "A aucun moment, l'application ne dialogue avec un autre serveur ou partage de l'information avec l'auteur de l'application.", style: TextStyle(fontSize: 14),),
            SizedBox(height: 10,),
            Text("Si vous rencontrez un problème sur l'application ou une idée d'amélioration, n'hésitez pas à me contacter à ", style: TextStyle(fontSize: 14),),
            TextButton(onPressed: () async {
              await lauchUrl('mailto:biblionantes@desaintsteban.fr');
            },
            child: Text("biblionantes@desaintsteban.fr"),),
            Text("Pour tous problèmes sur ou avec un document de la bibliothèque, vous devez contacter directement la bibliothèque.", style: TextStyle(fontSize: 14),),
            TextButton(onPressed: () async {
              await lauchUrl('https://bm.nantes.fr/home/contacts.html');
            },
              child: Text("Contacter la bibliothèque de Nantes"),),
            SizedBox(height: 10,),
            Text("Le projet est opensource, vous pouvez retrouver tous le code ici :  ", style: TextStyle(fontSize: 14),),
            TextButton(onPressed: () async {
              await lauchUrl('https://github.com/patou/biblionantes');
            },
              child: Text("github.com/patou/biblionantes"),),
          ],
        ),
      ),
    );
  }

  Future<void> lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
