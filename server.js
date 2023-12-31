const express = require("express"),
  fs = require("fs"),
  path = require("path"),
  config = require("./lib/configLoader"),
  port = process.env.PORT || 3000,
  db = require("./lib/database"),
  routes = require("./routes/index"),
  bodyParser = require("body-parser"),
  app = express();

// Body parser middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve React frontend from the build folder
app.use(express.static(path.join(__dirname, "client/build")));

// This route serves the static React app
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "client/build", "index.html"));
});

//Pass database config settings
db.init(config.databaseConfig);

app.use("/", routes);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  var err = new Error("Not Found");
  err.status = 404;
  next(err);
});

// error handlers
app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.render("error", {
    message: err.message,
    error: err,
  });
});

app.listen(port, (err) => {
  console.log("[%s] Listening on http://localhost:%d", app.settings.env, port);
});

module.exports = app;
