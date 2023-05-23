/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated, isExist} from "./validators";
import {userRef} from "./references";

exports.markAsRead = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  const uid = context.auth!.uid;
  const notificationRef = userRef
      .doc(uid)
      .collection("notifications")
      .doc(data.id);
  const notification = await notificationRef.get();
  isExist(notification);
  return notificationRef
      .update({
        hasRead: true,
      })
      .then(() => ({"": ""}))
      .catch((err) => {
        console.log("Error:", err);
        throw new functions.https.HttpsError(err.code, err.message);
      });
});

exports.markAllAsRead = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  const uid = context.auth!.uid;
  try {
    const batch = admin.firestore().batch();
    const notificationsRef = userRef.doc(uid).collection("notifications");
    const querySnapshot = await notificationsRef.get();
    querySnapshot.forEach((doc) => {
      const notificationDocRef = notificationsRef.doc(doc.id);
      batch.update(notificationDocRef, {hasRead: true});
    });
    return batch
        .commit()
        .then(() => ({"": ""}))
        .catch((err) => {
          console.log("Error:", err);
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (err) {
    console.log("Error: ", err);
    throw new functions.https.HttpsError("unknown", "unknown");
  }
});
