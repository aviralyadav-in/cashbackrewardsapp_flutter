import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? defaultUid}) {
    return UserModel(
      uid: map['uid'] as String? ?? defaultUid ?? '',
      fullName: map['fullName'] as String? ?? map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? map['phone'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.uid == uid &&
      other.fullName == fullName &&
      other.email == email &&
      other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode;
  }
}
