import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {Role} from "./roles";
import {DocumentSnapshot} from "firebase-functions/v1/firestore";

const donationsRef = admin.firestore().collection("donations");

exports.createDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  data.donor = context.auth?.uid;
  data.createAt = new Date();
  data.deleteAt = null;
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
    isExist(donation);
    const uid = context.auth?.uid;
    isOwner(donation, uid);
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
        .then(() => ({"": ""}))
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
    isExist(donation);
    const uid = context.auth?.uid;
    isOwner(donation, uid);
    const imgs = donation.data()?.imgs;
    for (const img of imgs) {
      await admin.storage().bucket().file(`${uid}/${img}`).delete();
    }
    return donationsRef
        .doc(data.id)
        .delete()
        .then(() => ({"": ""}))
        .catch((err) => {
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (error) {
    console.log(`Error ${error}`);
    throw new functions.https
        .HttpsError("unknown", "unknown");
  }
});

exports.softDeleteDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  const donationRef = donationsRef.doc(data.id);
  try {
    const donation = await donationRef.get();
    isExist(donation);
    const uid = context.auth?.uid;
    isOwner(donation, uid);
    return donationsRef
        .doc(data.id)
        .update({
          deleteAt: new Date(),
        })
        .then(() => ({"": ""}))
        .catch((err) => {
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (error) {
    console.log(`Error ${error}`);
    throw new functions.https
        .HttpsError("unknown", "unknown");
  }
});

exports.restoreDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  const donationRef = donationsRef.doc(data.id);
  try {
    const donation = await donationRef.get();
    isExist(donation);
    const uid = context.auth?.uid;
    isOwner(donation, uid);
    return donationsRef
        .doc(data.id)
        .update({
          deleteAt: null,
        })
        .then(() => ({"": ""}))
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

const isExist = (donation: DocumentSnapshot) => {
  if (!donation.exists) {
    throw new functions.https.HttpsError("not-found", "not-found");
  }
};

const isOwner = (donation: DocumentSnapshot, uid: string | undefined) => {
  if (donation.data()?.donor != uid) {
    throw new functions.https
        .HttpsError("unauthenticated", "unauthenticated");
  }
};
