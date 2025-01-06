import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ControlInterface extends StatefulWidget {
  const ControlInterface({Key? key}) : super(key: key);

  @override
  State<ControlInterface> createState() => _ControlInterfaceState();
}

class _ControlInterfaceState extends State<ControlInterface> {
  bool isOn = false; // État du bouton Allumer/Éteindre
  bool isPlusActive = false; // État du bouton Plus
  bool isMinusActive = false; // État du bouton Moins
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _saveDefaultJWT(); // Enregistrer un JWT par défaut pour le test
  }

  // Sauvegarde du JWT par défaut (exemple)
  Future<void> _saveDefaultJWT() async {
    const String jwtExample = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywiaWF0IjoxNzM2MTY1NDA0LCJleHAiOjE3MzYxNjkwMDR9.4Uu2wMG5Q7gW8EWVUYm4xCKBrnQnkyhGRRtgrzTGDOU"; // Clé JWT tirée du .env
    await _storage.write(key: "jwt", value: jwtExample);
  }

  // Méthode pour envoyer des données à l'API
  Future<void> sendDataToApi(String action, bool status) async {
    final String apiUrl = dotenv.env['API_URL']!;
    final String? jwt = await _storage.read(key: "jwt");

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/command'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({
          "on": isOn, // État du bouton Allumer/Éteindre
          "plus": isPlusActive, // État du bouton Plus
          "minus": isMinusActive, // État du bouton Moins
        }),
      );

      if (response.statusCode == 200) {
        print('Action envoyée avec succès : on=$isOn, plus=$isPlusActive, minus=$isMinusActive');
      } else {
        print('Erreur API : ${response.body}');
      }
    } catch (e) {
      print('Erreur réseau : $e');
    }
  }

  void togglePower() {
    setState(() {
      isOn = !isOn;
      if (isOn) {
        isMinusActive = true;
        isPlusActive = false;
      } else {
        isMinusActive = false;
        isPlusActive = false;
      }
      sendDataToApi("power", isOn); // Envoyer à l'API
    });
  }

  void activatePlus() {
    if (isOn) {
      setState(() {
        isPlusActive = true;
        isMinusActive = false;
      });
      sendDataToApi("plus", true); // Envoyer vrai si le bouton Plus est activé
    }
  }

  void activateMinus() {
    if (isOn) {
      setState(() {
        isMinusActive = true;
        isPlusActive = false;
      });
      sendDataToApi("minus", true); // Envoyer vrai si le bouton Moins est activé
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton Plus
            GestureDetector(
              onTap: isOn ? activatePlus : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isPlusActive ? Colors.green : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Bouton Allumer/Éteindre
            GestureDetector(
              onTap: togglePower,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: isOn ? Colors.blue : Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isOn
                          ? Colors.blue.withOpacity(0.6)
                          : Colors.red.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isOn ? 'ÉTEINDRE' : 'ALLUMER',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Bouton Moins
            GestureDetector(
              onTap: isOn ? activateMinus : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isMinusActive ? Colors.green : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.remove, size: 40, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
