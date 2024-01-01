const famousQuote = require("../models/famousQuote");

const getfamousQuotes = async () => {
  try {
    const quotes = await famousQuote.find();
    return quotes;
  } catch (err) {
    return [];
  }
};

module.exports = getfamousQuotes;
