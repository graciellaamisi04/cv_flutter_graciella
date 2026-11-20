import 'package:flutter/material.dart';

import 'Acceuil.dart';
import 'famille.dart';
import 'contact.dart';

class NavigationP extends StatefulWidget {
  const NavigationP({super.key});

  @override
  State<NavigationP> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationP> {

  int pageActuelle = 0;

  // Liste des trois pages
  final List<Widget> pages = [
    const MonCV(),
    const FamillePage(),
    const Contact(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Affichage de la page sélectionnée
      body: pages[pageActuelle],

      // Barre de navigation en bas
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: pageActuelle,

        onTap: (index) {
          setState(() {
            pageActuelle = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF6D2E46),
        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: "Famille",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact",
          ),

        ],
      ),
    );
  }
}