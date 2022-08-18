import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("À propos"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              " propos",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Cette application est développé par Patrice de Saint Steban. Elle est indépendante de la bibliothèque municipale de Nantes et ne fait que dialoguer avec les serveurs de celle-ci.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              """Les informations sur vos cartes de bibliothèques sont uniquement enregistrés dans votre téléphone.
                Ils sont simplement utilisé pour se connecter sur les serveurs de la bibliothèque de Nantes.
                A aucun moment, l'application ne dialogue avec un autre serveur ou partage de l'information avec l'auteur de l'application.""",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Si vous rencontrez un problème sur l'application ou une idée d'amélioration, n'hésitez pas à me contacter à ",
              style: TextStyle(fontSize: 14),
            ),
            TextButton(
              onPressed: () async {
                await lauchUrl('mailto:biblionantes@desaintsteban.fr');
              },
              child: const Text("biblionantes@desaintsteban.fr"),
            ),
            const Text(
              "Pour tous problèmes sur ou avec un document de la bibliothèque, vous devez contacter directement la bibliothèque.",
              style: TextStyle(fontSize: 14),
            ),
            TextButton(
              onPressed: () async {
                await lauchUrl('https://bm.nantes.fr/home/contacts.html');
              },
              child: const Text("Contacter la bibliothèque de Nantes"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Le projet est opensource, vous pouvez retrouver tous le code ici :  ",
              style: TextStyle(fontSize: 14),
            ),
            TextButton(
              onPressed: () async {
                await lauchUrl('https://github.com/patou/biblionantes');
              },
              child: const Text("github.com/patou/biblionantes"),
            ),
            const Text(
              "Le projet utilise firebase crashlytics pour récuper les rapports de bugs pour permettre d'améliorer la stabilité de l'application.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> lauchUrl(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
