const express = require("express"),
  router = express.Router(),
  getFamousQuotes = require("../lib/famousQuotesRepository"),
  FamousQuoteModel = require("../models/famousQuote");

/* GET home page. */
router.get("/", async (req, res, next) => {
  const quotes = await getFamousQuotes();
  res.render("index", { famousQuotes: quotes });
});

/* GET new command page */
router.get("/newquote", (req, res, next) => {
  res.render("newquote");
});

router.post("/newquote", async (req, res, next) => {
  // Extremely simple implementation to get a command in the database
  const quoteData = {
    quote: req.body.quote,
    author: req.body.author,
  };
  const quote = new FamousQuoteModel(quoteData);
  try {
    const cmd = await quote.save();
    console.log(cmd.quote + " saved to quotes collection.");
  } catch (err) {
    console.log(err);
  }
  res.redirect("/");
});

module.exports = router;
