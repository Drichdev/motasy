const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

// Secret pour la génération et la vérification des JWT
const secret = process.env.JWT_SECRET;

// Génération d'un JWT pour tester
const payload = { userId: 123 }; // Exemple d'utilisateur
const token = jwt.sign(payload, secret, { expiresIn: '1h' }); // Expiration : 1 heure
console.log('Token généré :', token);

// Middleware pour gérer les requêtes CORS
app.use(cors());

// Middleware pour parser les requêtes JSON
app.use(express.json());

// Middleware de vérification du JWT
function verifyToken(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  console.log('Token reçu :', token);

  if (!token) {
    return res.status(403).send('Token requis');
  }

  jwt.verify(token, secret, (err, decoded) => {
    if (err) {
      console.log('Erreur de vérification JWT :', err.message);
      return res.status(401).send('Token invalide ou expiré');
    }

    console.log('Token valide, utilisateur :', decoded);
    req.user = decoded; // Ajoute les données du token décodé à la requête
    next();
  });
}

// État initial des commandes
let command = { on: false, plus: false, minus: false };

// Route pour mettre à jour l'état des commandes
app.post('/command', verifyToken, (req, res) => {
  const { on, plus, minus } = req.body;

  if (typeof on !== 'boolean' || typeof plus !== 'boolean' || typeof minus !== 'boolean') {
    return res.status(400).send('Données invalides. Les valeurs doivent être booléennes.');
  }

  command = { on, plus, minus };
  console.log('Nouvelle commande :', command);
  res.status(200).send('Commande mise à jour');
});

// Route pour récupérer l'état des commandes
app.get('/command', verifyToken, (req, res) => {
  res.status(200).json(command);
});

// Middleware global pour gérer les erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Erreur du serveur');
});

// Lancement du serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}`);
});
