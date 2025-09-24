// data/datasources/profile_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/data/models/user.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserModel> getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    final doc =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

    print("Im here");
    print((doc.data()));

    final data = doc.data();
    if (data == null) {
      throw Exception("User document not found");
    }

    return UserModel.fromMap(data);
  }
}
