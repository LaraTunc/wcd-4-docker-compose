const famousQuote = require("../models/famousQuote");

const getfamousQuotes = async () => {
  try {
    const quotes = await famousQuote.find();
    console.log("\nquotes", quotes);
    return quotes;
  } catch (err) {
    return [];
  }
};

module.exports = getfamousQuotes;
