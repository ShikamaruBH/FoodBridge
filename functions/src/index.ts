import admin = require("firebase-admin");
admin.initializeApp();

exports.user = require("./user");
exports.donation = require("./donation");
