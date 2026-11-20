import 'package:flutter/material.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

Widget membreFamille({
  required String photo,
  required String nom,
  required String parente,
  required String age,
  required String description,
}) {

  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),

    elevation: 4,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),

    child: Padding(
      padding: const EdgeInsets.all(15),

      child: Row(
        children: [

          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(photo),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  nom,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  "Lien : $parente",
                  style: const TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF6D2E46),
                  ),
                ),

                const SizedBox(height: 5),

                Text("Âge : $age"),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Ma Famille"),
        centerTitle: true,
       // backgroundColor: Colors.blue,
       // foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 15),

            const Text(
              "Les membres de ma famille",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),


            membreFamille(
              photo: "assets/b.jpg",
              nom: "BEN AMISI",
              parente: "frère",
              age: "25 ans",
              description: "entrepreneur",
            ),


            membreFamille(
              photo: "assets/mm.jpg",
              nom: "Alua Josephine",
              parente: "Mère",
              age: "48 ans",
              description: "Mère de famille",
            ),


            membreFamille(
              photo: "assets/j.jpg",
              nom: "ZAS AMISI",
              parente: "Frère",
              age: "17 ans",
              description: "ÉLEVE",
            ),

          ],
        ),
      ),
    );
  }
}