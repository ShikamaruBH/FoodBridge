/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated} from "./validators";
import {userRef} from "./references";

exports.onCreateUser = functions
    .auth
    .user()
    .onCreate(async (userRecord) => {
      return userRef
          .doc(userRecord.uid)
          .set({
            displayName: userRecord.displayName,
            photoURL: userRecord.photoURL,
            email: userRecord.email,
          })
          .then(() => {
            return;
          })
          .catch((err) => {
            console.log("Error: ", err);
            return;
          });
    });

exports.createUser = functions.https.onCall(async (data) => {
  try {
    await admin.auth().getUserByEmail(data.email);
    throw new functions.https.HttpsError("already-exists", "already-exists");
  } catch (err) {
    return admin
        .auth()
        .createUser({
          email: data.email,
          password: data.password,
          displayName: data.displayName,
        })
        .then(() => ({"": ""}))
        .catch((err) => {
          throw new functions.https.HttpsError(err.code, err.message);
        });
  }
});

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

exports.updateUserInfo = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  return userRef
      .doc(context.auth!.uid)
      .set(
          data,
          {merge: true})
      .then(() => ({"": ""}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});

exports.likeUser = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  const userRef = admin.firestore().collection("users").doc(data.uid);
  return admin
      .firestore()
      .runTransaction(async (t) => {
        const user = await t.get(userRef);
        const temp = user.get("likedUsers") || [];
        console.log("Liked user: ", temp);
        const likedUsers = new Set(temp);
        const uid = context.auth!.uid;
        if (likedUsers.has(uid)) {
          likedUsers.delete(uid);
        } else {
          likedUsers.add(uid);
        }
        console.log("Liked user after: ", likedUsers);
        const likes = likedUsers.size;
        console.log("Likes: ", likes);
        t.set(userRef, {
          likedUsers: Array.from(likedUsers),
          likes,
        },
        {
          merge: true,
        });
      })
      .then(() => ({"": ""}))
      .catch((err) => {
        console.log("Error:", err);
        throw new functions.https.HttpsError(err.code, err.message);
      });
});
