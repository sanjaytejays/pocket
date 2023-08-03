class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String dateJoined;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.dateJoined,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'dateJoined': dateJoined,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      dateJoined: map['dateJoined'],
    );
  }
}
