/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated} from "./validators";
import {UserRecord} from "firebase-functions/v1/auth";
import {donationsRef} from "./references";

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

exports.getDonorInfo = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  let userRecord: UserRecord;
  try {
    userRecord = await admin.auth().getUser(data.uid);
  } catch (error) {
    throw new functions.https.HttpsError("not-found", "not-found");
  }
  const displayName = userRecord.displayName;
  const photoURL = userRecord.photoURL;
  const donations = await donationsRef.where("donor", "==", data.uid).get();
  const totalDonation = donations.docs.length;
  let rating = 0;
  let count = 0;
  const recipientsSet = new Set<string>();
  donations.docs.forEach((doc) => {
    const donation = doc.data();
    if (donation.reviews) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      Object.values(donation.reviews).forEach((review: any) => {
        rating += review.rating;
        count++;
      });
    }
    if (donation.recipients) {
      const recipients = Object.keys(donation.recipients);
      recipients.forEach(recipientsSet.add, recipientsSet);
    }
  });
  const totalRecipient = recipientsSet.size;
  if (count == 0) count = 1;
  rating /= count;
  return {
    displayName,
    photoURL,
    totalDonation,
    totalRecipient,
    rating,
  };
});

exports.getUserInfo = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  return admin
      .auth()
      .getUser(data.uid)
      .then((userRecord) => ({
        displayName: userRecord.displayName,
        photoURL: userRecord.photoURL,
      }))
      .catch(() => {
        throw new functions.https.HttpsError("not-found", "not-found");
      });
});

exports.getRecipientInfo = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  let userRecord: UserRecord;
  try {
    userRecord = await admin.auth().getUser(data.uid);
  } catch (error) {
    throw new functions.https.HttpsError("not-found", "not-found");
  }
  const displayName = userRecord.displayName;
  const photoURL = userRecord.photoURL;
  const donations = await donationsRef
      .where(`recipients.${data.uid}`, "!=", null)
      .get();
  const totalReceivedDonation = donations.docs.length;
  const rating = 0;
  return {
    displayName,
    photoURL,
    totalReceivedDonation,
    rating,
  };
});
