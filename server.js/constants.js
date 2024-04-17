const serverIp = "http://localhost";
const Port = 8080;
const dbURI = "mongodb://localhost:27017/RecipesAppDB";
const tokenExpiresIn = 7 * 24 * 60 * 60;

module.exports = {serverIp, Port, dbURI, tokenExpiresIn};