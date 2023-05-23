import admin = require("firebase-admin");
admin.initializeApp();

exports.user = require("./user");
exports.donation = require("./donation");
exports.notification = require("./notification");
