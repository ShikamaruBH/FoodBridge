/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated} from "./validators";

exports.updateUserRole = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  return admin
      .auth()
      .setCustomUserClaims(
          context.auth!.uid,
          {role: data.role}
      )
      .then(() => ({"message": "update-role-success"}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});

exports.updateUserAvatar = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  return admin
      .auth()
      .updateUser(
      context.auth!.uid,
      {
        photoURL: data.photoURL,
      }
      )
      .then(() => ({"": ""}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});
