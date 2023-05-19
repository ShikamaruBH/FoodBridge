import admin = require("firebase-admin");

export const donationsRef = admin.firestore().collection("donations");
export const userRef = admin.firestore().collection("users");
