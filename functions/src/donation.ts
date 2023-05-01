import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {Role} from "./roles";

const donationRef = admin.firestore().collection("donations");

exports.createDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  data.donor = context.auth?.uid;
  return donationRef
      .add(data)
      .then((documentRef) => ({"id": documentRef.id}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});

const isAuthenticated = (context: any) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "unauthenticated");
  }
};

const hasRole = (context: any, role: Role) => {
  if (context.auth.token.role != role) {
    throw new functions.https.
        HttpsError("permission-denied", "permission-denied");
  }
};
