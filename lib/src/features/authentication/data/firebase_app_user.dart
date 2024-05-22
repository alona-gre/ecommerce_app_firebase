import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/authentication/domain/app_user.dart';

class FirebaseAppUser implements AppUser {
  final User _user;

  const FirebaseAppUser(this._user);

  @override
  String? get email => _user.email;

  @override
  bool get emailVerified => _user.emailVerified;

  @override
  UserID get uid => _user.uid;

  // * Note: after calling this method, [emailVerified] isn't updated until the
  // * next time an ID token is generated for the user.
  // * Read this for more info: https://stackoverflow.com/a/63258198/436422
  @override
  Future<void> sendEmailVerification() => _user.sendEmailVerification();
}
