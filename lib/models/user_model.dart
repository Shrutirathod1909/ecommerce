class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobile;
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
  });

  // 🔥 Convert Firestore → Model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // 🔥 Convert Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
    };
  }

  // ✅ Add copyWith method
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? mobile,
    String? address,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
    );
  }
}
