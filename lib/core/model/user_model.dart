import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String photoURL;
  final String name;
  final String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.uid,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "name": name,
        "photoURL": photoURL,
      };

  static UserModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      photoURL: snapshot['photoURL'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      email: snapshot['email'],
    );
  }
}
