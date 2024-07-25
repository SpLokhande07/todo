class ProfileModel {
  final String name;
  final String dob;
  final String? profileImageUrl;
  final bool isLoading;
  final String? errorMessage;

  ProfileModel({
    required this.name,
    required this.dob,
    this.profileImageUrl,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileModel copyWith({
    String? name,
    String? dob,
    String? profileImageUrl,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
