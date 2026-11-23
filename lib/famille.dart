import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  static const Color couleurPrincipale = Color(0xFF6D2E46);
  static const Color couleurDeFond = Color(0xFFF7F5F7);

  List<dynamic> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  void _afficherSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }

  String _champNettoye(dynamic valeur, {String fallback = 'Non renseigné'}) {
    if (valeur == null) return fallback;
    final texte = valeur.toString().trim();
    if (texte.isEmpty || texte.toLowerCase() == 'null') return fallback;
    return texte;
  }

  Future<void> _chargerMembres() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getMembres().timeout(
        const Duration(seconds: 20),
      );

      if (!mounted) return;

      setState(() {
        _members = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _ouvrirFormulaireMembre({
    Map<String, dynamic>? membreExistant,
  }) {
    final bool estModification = membreExistant != null;

    final nomController = TextEditingController(
      text: _champNettoye(membreExistant?['nom'], fallback: ''),
    );
    final postnomController = TextEditingController(
      text: _champNettoye(membreExistant?['postnom'], fallback: ''),
    );
    final prenomController = TextEditingController(
      text: _champNettoye(membreExistant?['prenom'], fallback: ''),
    );
    final lieuController = TextEditingController(
      text: _champNettoye(membreExistant?['lieu_naissance'], fallback: ''),
    );
    final dateController = TextEditingController(
      text: _champNettoye(membreExistant?['date_naissance'], fallback: ''),
    );
    final parenteController = TextEditingController(
      text: _champNettoye(membreExistant?['parente'], fallback: ''),
    );

    final ImagePicker picker = ImagePicker();
    XFile? imageChoisie;
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (modalContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                estModification
                    ? 'Modifier un membre'
                    : 'Ajouter un membre',
                style: const TextStyle(
                  color: couleurPrincipale,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nom *',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextField(
                      controller: postnomController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Postnom *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    TextField(
                      controller: prenomController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Prénom *',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextField(
                      controller: lieuController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Lieu de naissance *',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    TextField(
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance (AAAA-MM-JJ) *',
                        hintText: 'Exemple : 2000-05-15',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    TextField(
                      controller: parenteController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Lien de parenté *',
                        prefixIcon: Icon(Icons.family_restroom),
                      ),
                    ),
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: couleurPrincipale,
                      ),
                      onPressed: isSaving
                          ? null
                          : () async {
                              try {
                                final XFile? picked = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 70,
                                  maxWidth: 1000,
                                  maxHeight: 1000,
                                );

                                if (picked != null && modalContext.mounted) {
                                  setDialogState(() {
                                    imageChoisie = picked;
                                  });
                                }
                              } catch (e) {
                                _afficherSnackBar(
                                  'Impossible de choisir la photo : $e',
                                  isError: true,
                                );
                              }
                            },
                      icon: const Icon(Icons.photo_library),
                      label: Text(
                        imageChoisie == null
                            ? 'Ajouter une photo'
                            : 'Changer la photo',
                      ),
                    ),
                    if (imageChoisie != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imageChoisie!.path),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop();
                        },
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: couleurPrincipale),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: couleurPrincipale,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          final nom = nomController.text.trim();
                          final postnom = postnomController.text.trim();
                          final prenom = prenomController.text.trim();
                          final lieu = lieuController.text.trim();
                          final date = dateController.text.trim();
                          final parente = parenteController.text.trim();

                          if (nom.isEmpty ||
                              postnom.isEmpty ||
                              prenom.isEmpty ||
                              lieu.isEmpty ||
                              date.isEmpty ||
                              parente.isEmpty) {
                            _afficherSnackBar(
                              'Veuillez remplir tous les champs obligatoires.',
                              isError: true,
                            );
                            return;
                          }

                          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
                            _afficherSnackBar(
                              'La date doit respecter le format AAAA-MM-JJ.',
                              isError: true,
                            );
                            return;
                          }

                          final payload = <String, String>{
                            'nom': nom,
                            'postnom': postnom,
                            'prenom': prenom,
                            'lieu_naissance': lieu,
                            'date_naissance': date,
                            'parente': parente,
                          };

                          if (modalContext.mounted) {
                            setDialogState(() {
                              isSaving = true;
                            });
                          }

                          bool operationReussie = false;
                          String message = '';

                          try {
                            final int? membreId = estModification
                                ? int.tryParse(
                                    membreExistant['id']?.toString() ?? '',
                                  )
                                : null;

                            if (estModification && membreId == null) {
                              throw Exception(
                                'Identifiant du membre introuvable.',
                              );
                            }

                            late Map<String, dynamic> response;

                            if (imageChoisie != null) {
                              response = await ApiService.saveMembreMultipart(
                                id: membreId,
                                fields: payload,
                                imagePath: imageChoisie!.path,
                              ).timeout(const Duration(seconds: 30));
                            } else if (estModification) {
                              response = await ApiService.updateMembreJson(
                                membreId!,
                                payload,
                              ).timeout(const Duration(seconds: 30));
                            } else {
                              response = await ApiService.createMembreJson(
                                payload,
                              ).timeout(const Duration(seconds: 30));
                            }

                            if (response['success'] == true) {
                              operationReussie = true;
                              message = response['message']?.toString() ??
                                  'Opération effectuée avec succès.';
                            } else {
                              message = response['message']?.toString() ??
                                  'Impossible d’effectuer cette opération.';
                            }
                          } catch (e) {
                            message = 'Erreur : $e';
                          }

                          if (!mounted) return;

                          if (operationReussie) {
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                            _afficherSnackBar(message, isError: false);
                            await _chargerMembres();
                          } else {
                            if (modalContext.mounted) {
                              setDialogState(() {
                                isSaving = false;
                              });
                            }
                            _afficherSnackBar(message, isError: true);
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          estModification ? 'Enregistrer' : 'Ajouter',
                        ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        nomController.dispose();
        postnomController.dispose();
        prenomController.dispose();
        lieuController.dispose();
        dateController.dispose();
        parenteController.dispose();
      });
    });
  }

  Future<void> _supprimerMembre(int id) async {
    try {
      final response = await ApiService.deleteMembre(id).timeout(
        const Duration(seconds: 20),
      );

      if (!mounted) return;

      if (response['success'] == true) {
        _afficherSnackBar(
          response['message']?.toString() ?? 'Membre supprimé avec succès.',
          isError: false,
        );
        await _chargerMembres();
      } else {
        _afficherSnackBar(
          response['message']?.toString() ?? 'Suppression impossible.',
          isError: true,
        );
      }
    } catch (e) {
      _afficherSnackBar('Erreur : $e', isError: true);
    }
  }

  Future<void> _confirmerSuppression(
    int id,
    String nomMembre,
  ) async {
    final bool? confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Voulez-vous vraiment supprimer "$nomMembre" de la famille ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirme == true) {
      await _supprimerMembre(id);
    }
  }

  Widget _construireCarteMembre(Map<String, dynamic> member) {
    final String nomComplet = [
      _champNettoye(member['nom'], fallback: ''),
      _champNettoye(member['postnom'], fallback: ''),
      _champNettoye(member['prenom'], fallback: ''),
    ].where((part) => part.isNotEmpty).join(' ');

    final String relation = _champNettoye(member['parente']);
    final String lieu = _champNettoye(member['lieu_naissance']);
    final String date = _champNettoye(member['date_naissance']);

    final String imageUrl = _champNettoye(member['image_url'], fallback: '');
    final bool hasImage = imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 8,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: couleurPrincipale,
              backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
              onBackgroundImageError: hasImage ? (_, _) {} : null,
              child: !hasImage
                  ? const Icon(
                      Icons.person,
                      size: 38,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomComplet.isEmpty ? 'Nom inconnu' : nomComplet,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: couleurPrincipale,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lien : $relation',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lieu : $lieu',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date de naissance : $date',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _ouvrirFormulaireMembre(
                      membreExistant: member,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: couleurPrincipale,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final int? id = int.tryParse(
                      member['id']?.toString() ?? '',
                    );

                    if (id != null) {
                      _confirmerSuppression(
                        id,
                        nomComplet.isEmpty ? 'ce membre' : nomComplet,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: couleurDeFond,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: couleurPrincipale,
        foregroundColor: Colors.white,
        title: const Text(
          'Ma Famille',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _chargerMembres,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: couleurPrincipale,
        foregroundColor: Colors.white,
        onPressed: () {
          _ouvrirFormulaireMembre();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: couleurPrincipale,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _chargerMembres,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: couleurPrincipale,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : _members.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun membre enregistré.\n'
                        'Appuyez sur + pour ajouter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: couleurPrincipale,
                      onRefresh: _chargerMembres,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: _members.length,
                        itemBuilder: (context, index) {
                          final member = Map<String, dynamic>.from(
                            _members[index] as Map,
                          );

                          return _construireCarteMembre(member);
                        },
                      ),
                    ),
    );
  }
}