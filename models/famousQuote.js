var mongoose = require("mongoose"),
  Schema = mongoose.Schema;

var famousQuoteSchema = Schema({
  quote: { type: String, required: true },
  author: { type: String, required: true },
});

var FamousQuoteModel = mongoose.model("famousQuote", famousQuoteSchema);

module.exports = FamousQuoteModel;
