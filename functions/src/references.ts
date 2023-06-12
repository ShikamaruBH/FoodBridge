import admin = require("firebase-admin");

export const donationsRef = admin.firestore().collection("donations");
export const usersRef = admin.firestore().collection("users");
