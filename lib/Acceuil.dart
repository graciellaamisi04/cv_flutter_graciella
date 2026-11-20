import 'package:flutter/material.dart';

class MonCV extends StatelessWidget {
  const MonCV({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Mon Curriculum Vitae"),
        centerTitle: true,
       // backgroundColor: Colors.blue,
       // foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage("assets/photo.jpg"),
            ),

            const SizedBox(height: 15),

            const Text(
              "SAKINA AMISI Graciella",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Etudiante en reseau informatique et telecommunication",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
               // color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),
            sectionTitre("Informations personnelles"),

            information("Téléphone", "+243 970208069"),
            information("Email", "graciellaamisi04@gmail.com"),
            information("Adresse", "Goma, RDC"),

            sectionTitre("Formation"),

            information(
              "2024 - 2026",
              "Études en informatique",
            ),

            information(
              "2017 - 2023",
              "Études secondaires",
            ),

            sectionTitre("Expériences professionnelles"),

            information(
              "2025",
              "Stage en informatique",
            ),

            information(
              "2024",
              "Initiation au développement web",
            ),

            sectionTitre("Compétences"),

            information("Programmation", "Flutter, Dart, Python"),
            information("Bureautique", "Word, Excel, PowerPoint"),

            sectionTitre("Langues"),

            information("Français", "Courant"),
            information("Anglais", "Intermédiaire"),
            information("Lingala", "courant"),
            information("mandarin", "Intermédiaire"),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}

Widget sectionTitre(String titre) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(
      left: 15,
      right: 15,
      top: 15,
      bottom: 10,
    ),
   color: const Color(0xFF6D2E46),

    child: Text(
      titre,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}


Widget information(String titre, String contenu) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 7,
    ),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          flex: 2,
          child: Text(
            titre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),

        Expanded(
          flex: 3,
          child: Text(
            contenu,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),

      ],
    ),
  );
}