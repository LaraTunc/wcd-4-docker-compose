const mongoose = require("mongoose");
const dataInitializer = require("./dataSeeder");
const { MongoMemoryServer } = require("mongodb-memory-server");

var database = (function () {
  var conn = null,
    init = async (config) => {
      if (process.env.NODE_ENV === "production") {
        console.log(
          "Trying to connect to " +
            config.host +
            "/" +
            config.database +
            " MongoDB database"
        );
        var connString = `mongodb://${config.host}/${config.database}`;
        mongoose.connect(connString);
      } else {
        console.log("Trying to connect to mongodb-memory-server");
        const mongoServer = await MongoMemoryServer.create();
        const mongoUri = mongoServer.getUri();
        mongoose.connect(mongoUri);
      }

      conn = mongoose.connection;
      conn.on("error", console.error.bind(console, "connection error:"));
      conn.once("open", () => console.log("db connection open"));
      dataInitializer.initializeData(function (err) {
        if (err) {
          console.log(err);
        } else {
          console.log("Data Initialized!");
        }
      });
      return conn;
    },
    close = () => {
      if (conn) {
        conn.close(() => {
          console.log(
            "Mongoose default connection disconnected through app termination"
          );
          process.exit(0);
        });
      }
    };

  return {
    init: init,
    close: close,
  };
})();

module.exports = database;
