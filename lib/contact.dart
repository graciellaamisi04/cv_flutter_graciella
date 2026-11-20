import 'package:cv_flutter_graciella/Acceuil.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Me contacter"),
        centerTitle: true,
       // backgroundColor: Colors.blue,
       // foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        child: Column(
          children: [

            const SizedBox(height: 25),

            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("assets/photo.jpg"),
            ),

            const SizedBox(height: 15),

            const Text(
              "GRACIELLA AMISI",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "N'hésitez pas à me contacter !",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            sectionTitre("Mes coordonnées"),

            contactInformation(
              Icons.phone,
              "Téléphone",
              "+243 970208069",
            ),

            contactInformation(
              Icons.email,
              "Adresse Email",
              "graciellaamisi04@gmail.com",
            ),

            contactInformation(
              Icons.location_on,
              "Adresse",
              "Goma, RDC",
            ),

            const SizedBox(height: 15),

            sectionTitre("Mes réseaux sociaux"),

            contactInformation(
              Icons.chat,
              "WhatsApp",
              "+243 970208069",
            ),

            contactInformation(
              Icons.facebook,
              "Facebook",
              "Graciella Amisi",
            ),

            contactInformation(
              Icons.camera_alt,
              "Instagram",
              "@graciella_amisi",
            ),

            contactInformation(
              Icons.work,
              "LinkedIn",
              "Graciella Amisi",
            ),

            const SizedBox(height: 25),

            const Text(
              "Merci de visiter mon portfolio !",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6D2E46),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}

Widget contactInformation(
    IconData icone,
    String titre,
    String contenu,
) {

  return Card(

    margin: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 7,
    ),

    elevation: 3,

    child: ListTile(

      leading: Icon(
        icone,
        color: const Color(0xFF6D2E46),
        size: 30,
      ),

      title: Text(
        titre,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      subtitle: Text(contenu),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),

    ),
  );
}