import functions = require("firebase-functions");
import {DocumentSnapshot} from "firebase-functions/v1/firestore";
import {Role} from "./roles";

export const isAuthenticated = (context: functions.https.CallableContext) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "unauthenticated");
  }
};

export const hasRole = (
    context: functions.https.CallableContext,
    role: Role
) => {
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  if (context.auth!.token.role != role) {
    throw new functions.https.
        HttpsError("permission-denied", "permission-denied");
  }
};

export const isExist = (donation: DocumentSnapshot) => {
  if (!donation.exists) {
    throw new functions.https.HttpsError("not-found", "not-found");
  }
};

export const isOwner = (
    donation: DocumentSnapshot,
    uid: string | undefined
) => {
  if (donation.data()?.donor != uid) {
    throw new functions.https
        .HttpsError("unauthenticated", "unauthenticated");
  }
};
