import admin = require("firebase-admin");

export const donationsRef = admin.firestore().collection("donations");
