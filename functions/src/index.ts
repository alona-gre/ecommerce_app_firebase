import * as admin from "firebase-admin"
import * as functions from "firebase-functions"
import * as logger from "firebase-functions/logger"
 
admin.initializeApp()
 
export const makeAdminIfWhitelisted = functions.auth.user().onCreate(async (user, _) => {
  const email = user.email
  // anonymous users don't have an email
  if (email === undefined) {
    logger.log(`User ${user.uid} doesn't have an email address`)
    return
  }
  // * disabled to make testing easier with email & password auth
  // if (!user.emailVerified) {
  //   logger.log(`${email} is not verified`)
  //   return
  // }
  if (!email.endsWith("@example.com")) {
    logger.log(`${email} doesn't belong to a whitelisted domain`)
    return
  }
  if (user.customClaims?.admin === true) {
    logger.log(`${email} is already an admin`)
    return
  }
  // set custom claim
  await admin.auth().setCustomUserClaims(user.uid, {
    admin: true,
  })
  logger.log(`Custom claim set! ${email} is now an admin`)
})