/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated} from "./validators";
import {UserRecord} from "firebase-functions/v1/auth";
import {donationsRef, userRef} from "./references";

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
  let email;
  let phoneNumber;
  let likes;
  let isLiked;
  try {
    const user = await userRef.doc(data.uid).get();
    email = user.data()?.email;
    phoneNumber = user.data()?.phoneNumber;
    likes = user.data()?.likes;
    const likedUsers = user.data()?.likedUsers || [];
    isLiked = likedUsers.includes(context.auth!.uid);
  } catch (err) {
    email = "";
    phoneNumber = "";
    likes = 0;
    isLiked = false;
  }
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
    email,
    phoneNumber,
    totalDonation,
    totalRecipient,
    rating,
    likes,
    isLiked,
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
  let email;
  let phoneNumber;
  let likes;
  let isLiked;
  try {
    const user = await userRef.doc(data.uid).get();
    email = user.data()?.email;
    phoneNumber = user.data()?.phoneNumber;
    likes = user.data()?.likes;
    const likedUsers = user.data()?.likedUsers || [];
    isLiked = likedUsers.includes(context.auth!.uid);
  } catch (err) {
    email = "";
    phoneNumber = "";
    likes = 0;
    isLiked = false;
  }
  const donations = await donationsRef
      .where(`recipients.${data.uid}`, "!=", null)
      .get();
  const totalReceivedDonation = donations.docs.length;
  const rating = 0;
  return {
    displayName,
    photoURL,
    email,
    phoneNumber,
    totalReceivedDonation,
    rating,
    likes,
    isLiked,
  };
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
