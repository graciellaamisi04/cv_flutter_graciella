import 'package:flutter/material.dart';
import 'api_service.dart';
import 'main.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    const Color couleurPrincipale = Color(0xFF6D2E46);
    const Color couleurDeFond = Color(0xFFF7F5F7);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: couleurDeFond,
        colorScheme: ColorScheme.fromSeed(
          seedColor: couleurPrincipale,
          primary: couleurPrincipale,
          surface: couleurDeFond,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: couleurPrincipale,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleurPrincipale,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color couleurPrincipale = Color(0xFF6D2E46);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _afficherMessage(String message, {required bool isError}) {
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

  Future<void> _seConnecter() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _afficherMessage(
        'Veuillez saisir votre email et votre mot de passe.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationP(),
          ),
        );
      } else {
        _afficherMessage(
          result['message']?.toString() ?? 'Identifiants incorrects.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _afficherMessage(
        'Erreur de connexion au serveur : $e',
        isError: true,
      );
    }
  }

  void _ouvrirDialogueInscription() {
    final TextEditingController regEmailController = TextEditingController();
    final TextEditingController regPasswordController = TextEditingController();
    bool isRegistering = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Créer un compte',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: regEmailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isRegistering,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: regPasswordController,
                    obscureText: true,
                    enabled: !isRegistering,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe (min. 6 caractères)',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isRegistering
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
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
                  onPressed: isRegistering
                      ? null
                      : () async {
                          final regEmail = regEmailController.text.trim();
                          final regPassword = regPasswordController.text;

                          if (regEmail.isEmpty || regPassword.length < 6) {
                            _afficherMessage(
                              'Saisissez un email valide et un mot de passe (6 caractères min.).',
                              isError: true,
                            );
                            return;
                          }

                          setDialogState(() {
                            isRegistering = true;
                          });

                          try {
                            final result = await ApiService.register(
                              email: regEmail,
                              password: regPassword,
                            );

                            if (!mounted || !dialogContext.mounted) return;

                            if (result['success'] == true) {
                              _emailController.text = regEmail;
                              Navigator.pop(dialogContext);
                              _afficherMessage(
                                'Compte créé ! Vous pouvez vous connecter.',
                                isError: false,
                              );
                            } else {
                              setDialogState(() {
                                isRegistering = false;
                              });
                              _afficherMessage(
                                result['message']?.toString() ??
                                    'Inscription impossible.',
                                isError: true,
                              );
                            }
                          } catch (e) {
                            if (!mounted || !dialogContext.mounted) return;
                            setDialogState(() {
                              isRegistering = false;
                            });
                            _afficherMessage(
                              'Erreur : $e',
                              isError: true,
                            );
                          }
                        },
                  child: isRegistering
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("S'inscrire"),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      regEmailController.dispose();
      regPasswordController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _isLoading ? null : _seConnecter(),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _seConnecter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: couleurPrincipale,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Se connecter',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: _isLoading ? null : _ouvrirDialogueInscription,
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: couleurPrincipale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}