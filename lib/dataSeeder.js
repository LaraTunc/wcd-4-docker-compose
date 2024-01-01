const FamousQuote = require("../models/famousQuote");

var dataInitializer = (function () {
  const initializeData = async (callback) => {
    const nelsonFamousQuote = new FamousQuote({
      quote:
        "The greatest glory in living lies not in never falling, but in rising every time we fall.",
      author: "Nelson Mandela",
    });

    const waltFamousQuote = new FamousQuote({
      quote: "The way to get started is to quit talking and begin doing.",
      author: "Walt Disney",
    });

    const steveFamousQuote = new FamousQuote({
      quote:
        "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma, which is living with the results of other people's thinking.",
      author: "Steve Jobs",
    });

    const oprahFamousQuote = new FamousQuote({
      quote:
        "If you look at what you have in life, you'll always have more. If you look at what you don't have in life, you'll never have enough.",
      author: "Oprah Winfrey",
    });

    try {
      await nelsonFamousQuote.save();
      await waltFamousQuote.save();
      await steveFamousQuote.save();
      await oprahFamousQuote.save();
      callback();
    } catch (err) {
      callback(err);
    }
  };

  return {
    initializeData: initializeData,
  };
})();

module.exports = dataInitializer;
