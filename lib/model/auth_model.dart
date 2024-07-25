import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  AuthModel({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthModel copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthModel(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
