import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {Role} from "./roles";

const donationsRef = admin.firestore().collection("donations");

exports.createDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  data.donor = context.auth?.uid;
  data.created = new Date();
  return donationsRef
      .add(data)
      .then((documentRef) => ({"id": documentRef.id}))
      .catch((err) => {
        throw new functions.https.HttpsError(err.code, err.message);
      });
});

exports.updateDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  data.updateAt = new Date();
  const donationRef = donationsRef.doc(data.id);
  try {
    const donation = await donationRef.get();
    if (!donation.exists) {
      throw new functions.https.HttpsError("not-found", "not-found");
    }
    const uid = context.auth?.uid;
    if (donation.data()?.donor != uid) {
      throw new functions.https
          .HttpsError("unauthenticated", "unauthenticated");
    }
    const imgs = donation.data()?.imgs;
    for (const img of imgs) {
      if (!data.imgs.includes(img)) {
        await admin.storage().bucket().file(`${uid}/${img}`).delete();
      }
    }
    const {id, ...newDonation} = data;
    return donationsRef
        .doc(data.id)
        .update(newDonation)
        .then((writeResult) => ({"": ""}))
        .catch((err) => {
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (error) {
    console.log(`Error ${error}`);
    throw new functions.https
        .HttpsError("unknown", "unknown");
  }
});

exports.deleteDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  const donationRef = donationsRef.doc(data.id);
  try {
    const donation = await donationRef.get();
    if (!donation.exists) {
      throw new functions.https.HttpsError("not-found", "not-found");
    }
    const uid = context.auth?.uid;
    if (donation.data()?.donor != uid) {
      throw new functions.https
          .HttpsError("unauthenticated", "unauthenticated");
    }
    const imgs = donation.data()?.imgs;
    for (const img of imgs) {
      await admin.storage().bucket().file(`${uid}/${img}`).delete();
    }
    return donationsRef
        .doc(data.id)
        .delete()
        .then((writeResult) => ({"": ""}))
        .catch((err) => {
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (error) {
    console.log(`Error ${error}`);
    throw new functions.https
        .HttpsError("unknown", "unknown");
  }
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
