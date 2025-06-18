class UserEntity {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  // final String image;
  // final int gender;

  UserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.isAdmin = false,
    // required this.image,
    // required this.gender
  });
}
