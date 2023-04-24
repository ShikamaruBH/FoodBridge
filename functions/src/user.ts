import functions = require("firebase-functions");
import admin = require("firebase-admin");

exports.updateUserRole = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "unauthenticated");
  }
  return admin
      .auth()
      .setCustomUserClaims(
          context.auth.uid,
          {role: data.role}
      )
      .then(() => ({"message": "update-role-success"}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});
