import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_noorisys/model/profile_model.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileModel>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw StateError('User must be authenticated');
  }
  return ProfileNotifier(user.uid);
});

class ProfileNotifier extends StateNotifier<ProfileModel> {
  final String uid;

  ProfileNotifier(this.uid) : super(ProfileModel(name: '', dob: ''));

  Future<void> loadProfile() async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        state = state.copyWith(
          name: userDoc['name'],
          dob: userDoc['dob'],
          profileImageUrl: userDoc['profileImageUrl'],
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadProfileImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      await _updateProfile(imageUrl: imageUrl);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> _updateProfile({String? imageUrl}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': state.name,
        'dob': state.dob,
        'profileImageUrl': imageUrl ?? state.profileImageUrl ?? '',
      });
      state = state.copyWith(profileImageUrl: imageUrl);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateProfile(String name, String dob) async {
    state = state.copyWith(name: name, dob: dob);
    await _updateProfile();
  }
}
