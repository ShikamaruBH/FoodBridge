/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated, isExist} from "./validators";
import {usersRef} from "./references";

exports.onCreateUser = functions
    .auth
    .user()
    .onCreate(async (userRecord) => {
      return usersRef
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
  try {
    await admin
        .auth()
        .setCustomUserClaims(
          context.auth!.uid,
          {role: data.role}
        );
    await usersRef.doc(context.auth!.uid).update({role: data.role});
    return {"": ""};
  } catch (err: any) {
    console.log("Error: ", err);
    throw new functions.https.HttpsError(err.code, err.message);
  }
});

exports.updateUserInfo = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  const uid = context.auth!.uid;
  try {
    const user = await usersRef.doc(uid).get();
    isExist(user);
    const temp = user.get("messageToken") || [];
    if (data.messageToken != undefined) {
      console.log("Message Token: ", data.messageToken);
      console.log("Message Tokens: ", temp);
      const messageToken = new Set(temp);
      messageToken.add(data.messageToken);
      data.messageToken = Array.from(messageToken);
      console.log("Data: ", data);
    }
  } catch (err: any) {
    console.log("Error: ", err);
    throw new functions.https.HttpsError(err.code, err.message);
  }

  return usersRef
      .doc(uid)
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
