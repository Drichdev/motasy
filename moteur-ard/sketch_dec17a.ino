#include <WiFi.h>
#include <HTTPClient.h>

// Paramètres Wi-Fi
const char* ssid = "name";
const char* password = "pass";

// URL du serveur et token d'autorisation
const char* serverUrl = "http://192.168.1.64:5000/command";
const String token = "token";

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Connexion au Wi-Fi
  Serial.print("Connexion au Wi-Fi...");
  WiFi.begin(ssid, password);

  // Attendre la connexion
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nWiFi connecté !");
  Serial.print("Adresse IP : ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    Serial.println("Envoi de la requête HTTP...");

    http.begin(serverUrl);
    http.addHeader("Authorization", "Bearer " + token);

    // Envoyer la requête GET
    int httpResponseCode = http.GET();

    if (httpResponseCode > 0) {
      if (httpResponseCode == 200) {
        String response = http.getString();
        Serial.println("Réponse : " + response);
      } else {
        Serial.print("Erreur HTTP (code autre que 200) : ");
        Serial.println(httpResponseCode);
      }
    } else {
      // Erreur de connexion
      Serial.print("Erreur de connexion HTTP : ");
      Serial.println(http.errorToString(httpResponseCode).c_str());
    }

    http.end(); // Terminer la connexion HTTP
  } else {
    // Reconnexion Wi-Fi si nécessaire
    Serial.println("Wi-Fi déconnecté. Tentative de reconnexion...");
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      Serial.print(".");
    }
    Serial.println("\nWiFi reconnecté !");
  }

  delay(5000); // Attendre 5 secondes avant la prochaine requête
}
