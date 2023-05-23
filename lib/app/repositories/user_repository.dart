import 'package:agile_cards/app/models/participant_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  FirebaseAuth firebase = FirebaseAuth.instance;

  Future<void> changeName(String name) async {
    await firebase.currentUser!.updateDisplayName(name);
  }

  Future<void> changeAvatar(String avatar) async {
    await firebase.currentUser!.updatePhotoURL(avatar);
  }

  Future<void> changeEmail(String email) async {
    await firebase.currentUser!.updateEmail(email);
  }

  Future<void> changePassword(String password) async {
    await firebase.currentUser!.updatePassword(password);
  }

  Future<void> changePhone(PhoneAuthCredential phone) async {
    await firebase.currentUser!.updatePhoneNumber(phone);
  }

  Future<Participant> getUser() async {
    return Participant.fromUser(firebase.currentUser!);
  }

  Future<void> changeDisplayName(String displayName) async {
    await firebase.currentUser!.updateDisplayName(displayName);
  }
}
