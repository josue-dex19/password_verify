import 'package:flutter/material.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  bool _obscureText = true;
  String _password = '';
  String _confirmPassword = '';
  int _strengthLevel = 0; // Niveau de force du mot de passe
  String? _passwordMatchMessage; // Message de validation du mot de passe

  final List<Map<String, dynamic>> _buttons = [
    {'text': 'Uppercase', 'isValid': false, 'regex': RegExp(r'[A-Z]')},
    {'text': 'Lowercase', 'isValid': false, 'regex': RegExp(r'[a-z]')},
    {'text': 'Number', 'isValid': false, 'regex': RegExp(r'\d')},
    {
      'text': 'Special character',
      'isValid': false,
      'regex': RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    },
    {
      'text': 'At least 8 characters',
      'isValid': false,
      'regex': RegExp(r'.{8,}'),
    },
  ];

  final List<Map<String, dynamic>> _levels = [
    {'text': 'Weak', 'color': Colors.red, 'bars': 1},
    {'text': 'Medium', 'color': Colors.orange, 'bars': 2},
    {'text': 'Very Strong', 'color': Colors.green, 'bars': 3},
  ];

  /// Fonction pour mettre à jour la validation des critères
  void _validatePassword(String value) {
    setState(() {
      _password = value;

      // Vérifier chaque critère
      int validCount = 0;
      for (var btn in _buttons) {
        btn['isValid'] = btn['regex'].hasMatch(_password);
        if (btn['isValid']) validCount++;
      }

      // Définir la force du mot de passe
      if (validCount >= 4) {
        _strengthLevel = 2; // Très fort
      } else if (validCount >= 2) {
        _strengthLevel = 1; // Moyen
      } else {
        _strengthLevel = 0; // Faible
      }

      // Vérifier la conformité du mot de passe confirmé
      _checkPasswordMatch();
    });
  }

  /// Vérifie si les mots de passe correspondent
  void _checkPasswordMatch() {
    setState(() {
      if (_confirmPassword.isEmpty) {
        _passwordMatchMessage = null; // Pas de message si le champ est vide
      } else if (_password == _confirmPassword) {
        _passwordMatchMessage = "Mot de passe validé ✔";
      } else {
        _passwordMatchMessage = "Les mots de passe ne correspondent pas ❌";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create password',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Create a strong password to secure your account.',
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' * ',
                          style: TextStyle(color: Colors.red),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.info, color: Colors.grey, size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: _obscureText,
                    onChanged: _validatePassword, // Vérification en temps réel
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Affichage du niveau de force du mot de passe
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_alt,
                        color: _levels[_strengthLevel]['color'],
                        size: 15,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _levels[_strengthLevel]['text'],
                        style: TextStyle(
                          color: _levels[_strengthLevel]['color'],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Boutons des critères de mot de passe
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                    _buttons.map((btn) {
                      return AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 300,
                        ), // Animation fluide
                        decoration: BoxDecoration(
                          color:
                          btn['isValid']
                              ? Colors.green
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                            btn['isValid'] ? Colors.green : Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Text(
                            btn['text'],
                            style: TextStyle(
                              color:
                              btn['isValid']
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Confirm Password',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' * ',
                          style: TextStyle(color: Colors.red),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.info, color: Colors.grey, size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: _obscureText,
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                        _checkPasswordMatch();
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Message de conformité des mots de passe
                  if (_passwordMatchMessage != null)
                    Text(
                      _passwordMatchMessage!,
                      style: TextStyle(
                        color: _passwordMatchMessage ==
                            "Mot de passe validé ✔"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      Colors.green[700]!,
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {},
                  child: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
