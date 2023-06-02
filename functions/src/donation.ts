/* eslint-disable @typescript-eslint/no-explicit-any */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {Role} from "./roles";
import {hasRole, isAuthenticated, isExist, isOwner} from "./validators";
import {donationsRef, userRef} from "./references";
import {RecipientStatus} from "./recipientstatus";

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
        .doc(id)
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

exports.deleteAllDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.DONOR);
  try {
    const uid = context.auth?.uid;
    const donationQuerySnapshot = await donationsRef
        .where("donor", "==", uid)
        .where("deleteAt", "!=", null)
        .get();

    const batchSize = 500;
    const totalDonations = donationQuerySnapshot.size;
    let processedDonations = 0;

    while (processedDonations < totalDonations) {
      const batch = admin.firestore().batch();
      const batchDonations = donationQuerySnapshot.docs.slice(
          processedDonations,
          processedDonations + batchSize,
      );
      for (const donation of batchDonations) {
        batch.delete(donation.ref);
      }
      await batch.commit();
      processedDonations += batchSize;
    }
    return {"": ""};
  } catch (err: any) {
    console.log("Error: ", err);
    throw new functions.https.HttpsError(err.code, err.message);
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

exports.receiveDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.RECIPIENT);
  const donationRef = donationsRef.doc(data.id);
  try {
    return admin
        .firestore()
        .runTransaction(async (t) => {
          const donation = await t.get(donationRef);
          isExist(donation);
          let recipients = donation.get("recipients");
          if (recipients == undefined) {
            recipients = {};
          }
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          const uid:string = context.auth!.uid;
          if (uid in recipients) {
            throw new functions.https
                .HttpsError("aborted", "aborted");
          }
          let total = 0;
          const quantity = donation.get("quantity");
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          Object.values(recipients).forEach((recipient: any) => {
            total += recipient.quantity;
          });
          if (total + data.quantity > quantity) {
            throw new functions.https
                .HttpsError("invalid-argument", "invalid-argument");
          }
          recipients[uid] = {
            quantity: data.quantity,
            expireAt: new Date(data.arriveTime),
            status: RecipientStatus.PENDING,
          };
          t.set(donationRef, {recipients}, {merge: true});

          const donorUid = donation.get("donor");
          const notificationRef = userRef
              .doc(donorUid)
              .collection("notifications")
              .doc();

          const donor = await admin
              .firestore()
              .collection("users")
              .doc(donorUid)
              .get();

          const donationTitle = donation.get("title");

          t.set(notificationRef, {
            from: donor.get("displayName"),
            donation: donationTitle,
            donationId: donation.id,
            createAt: new Date(),
            hasRead: false,
          });

          const recipient = await admin
              .firestore()
              .collection("users")
              .doc(uid)
              .get();

          const payload = {
            data: {
              title: donationTitle,
              recipient: recipient.get("displayName"),
            },
          };

          await admin
              .messaging()
              .sendToDevice(
                  donor.get("messageToken"),
                  payload,
              );
        })
        .then(() => ({"": ""}))
        .catch((err) => {
          console.log("Error:", err);
          throw new functions.https.HttpsError(err.code, err.message);
        });
  } catch (error) {
    console.log(`Error ${error}`);
    throw new functions.https
        .HttpsError("aborted", "aborted");
  }
});

exports.reviewDonation = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  hasRole(context, Role.RECIPIENT);
  const donationRef = donationsRef.doc(data.id);
  try {
    const donation = await donationRef.get();
    isExist(donation);
    return donationsRef
        .doc(data.id)
        .set({
          reviews: {
            // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
            [context.auth!.uid]: {
              rating: data.rating,
              review: data.review,
            },
          },
        }
        ,
        {merge: true})
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

exports.undoRecipient = functions.https.onCall(async (data, context) => {
  return updateRecipientStatus(RecipientStatus.PENDING, data, context);
});

exports.receivingDonation = functions.https.onCall(async (data, context) => {
  return updateRecipientStatus(RecipientStatus.RECEIVING, data, context);
});

exports.confirmReceived = functions.https.onCall(async (data, context) => {
  return updateRecipientStatus(RecipientStatus.RECEIVED, data, context);
});

exports.rejectRecipient = functions.https.onCall(async (data, context) => {
  return updateRecipientStatus(RecipientStatus.REJECTED, data, context);
});

const updateRecipientStatus = async (
    status: RecipientStatus,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    data: any,
    context: functions.https.CallableContext,
) => {
  isAuthenticated(context);
  if (status != RecipientStatus.RECEIVED) {
    hasRole(context, Role.DONOR);
  }
  const donationRef = donationsRef.doc(data.donationId);
  try {
    const donation = await donationRef.get();
    isExist(donation);
    const uid = context.auth?.uid;
    if (status != RecipientStatus.RECEIVED) {
      isOwner(donation, uid);
    }
    const recipients = donation.data()?.recipients;
    recipients[data.recipientUid].status = status;
    let deadline = new Date();
    deadline = new Date(deadline.getTime() + 60000);
    if (status == RecipientStatus.RECEIVING) {
      recipients[data.recipientUid].confirmDeadline = deadline;
    }
    return donationsRef
        .doc(data.donationId)
        .update({
          recipients,
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
};
