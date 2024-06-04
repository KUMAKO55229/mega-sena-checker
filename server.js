const express = require('express');
const path = require('path');
const app = express();

// Servir os arquivos estáticos da aplicação Flutter
app.use(express.static(path.join(__dirname, 'build/web')));

app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

app.listen(process.env.PORT || 8080);
