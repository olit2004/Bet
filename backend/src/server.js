require('dotenv').config();
const app = require('./app');

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`✅ Bet API server running on http://localhost:${PORT}`);
});
