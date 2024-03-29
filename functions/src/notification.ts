/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import functions = require("firebase-functions");
import admin = require("firebase-admin");
import {isAuthenticated, isExist} from "./validators";
import {usersRef} from "./references";
import {Role} from "./roles";


exports.onNewDonation = functions.firestore
    .document("donations/{donationId}")
    .onCreate(async (snapshot, context) => {
      try {
        const donationId = context.params.donationId;
        const donationTitle = snapshot.get("title");
        const donationDonor = snapshot.get("donor");

        const usersQuerySnapshot = await usersRef
            .where("role", "==", Role.RECIPIENT)
            .get();

        const batchSize = 500;
        const totalUsers = usersQuerySnapshot.size;
        let processedUsers = 0;

        const donorSnapshot = await usersRef.doc(donationDonor).get();
        const donorDisplayName = donorSnapshot.get("displayName");

        while (processedUsers < totalUsers) {
          const batch = admin.firestore().batch();
          const batchUsers = usersQuerySnapshot.docs.slice(
              processedUsers,
              processedUsers + batchSize
          );

          for (const userDoc of batchUsers) {
            const notificationRef = userDoc
                .ref
                .collection("notifications")
                .doc(donationId);

            batch.set(
                notificationRef, {
                  from: donorDisplayName,
                  donation: donationTitle,
                  donationId: donationId,
                  createAt: new Date(),
                  hasRead: false,
                });
          }

          await batch.commit();
          processedUsers += batchSize;
        }
        const payload = {
          data: {
            title: donationTitle,
            donor: donorDisplayName,
          },
        };
        await admin.messaging().sendToTopic("newDonation", payload);
        return;
      } catch (err: any) {
        console.log("Error: ", err);
        throw new functions.https.HttpsError(err.code, err.message);
      }
    });

exports.markAsRead = functions.https.onCall(async (data, context) => {
  isAuthenticated(context);
  const uid = context.auth!.uid;
  const notificationRef = usersRef
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
    const notificationsRef = usersRef.doc(uid).collection("notifications");
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
