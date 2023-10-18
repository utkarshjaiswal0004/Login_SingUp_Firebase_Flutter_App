import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserName(String userId, String newName) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'name': newName});
    } catch (e) {
      throw Exception('Error updating user name: $e');
    }
  }

  Stream<List<UserModel>> listenToUserUpdates() {
    final CollectionReference usersCollection = _firestore.collection('users');
    List<UserModel> users = [];

    final userUpdatesController = StreamController<List<UserModel>>();

    usersCollection.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            users.add(
                UserModel.fromJson(change.doc.data() as Map<String, dynamic>));
            break;
          case DocumentChangeType.modified:
            int modifiedUserIndex =
                users.indexWhere((user) => user.uid == change.doc.id);
            if (modifiedUserIndex != -1) {
              users[modifiedUserIndex] =
                  UserModel.fromJson(change.doc.data() as Map<String, dynamic>);
            }
            break;
          case DocumentChangeType.removed:
            users.removeWhere((user) => user.uid == change.doc.id);
            break;
        }
      }

      userUpdatesController.add(List<UserModel>.from(users));
    });

    return userUpdatesController.stream;
  }
}
