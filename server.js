const express = require('express');
const path = require('path');
const app = express();

// Serve os arquivos estáticos da aplicação Flutter
app.use(express.static(path.join(__dirname, 'build/web')));

app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, 'build/web', 'index.html'));
});

// Listen to the app on the port provided by Heroku or a default port
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
