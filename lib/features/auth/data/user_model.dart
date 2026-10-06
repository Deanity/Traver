class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool emailVerified;
  final List<String> favoriteCategories;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.emailVerified,
    required this.favoriteCategories,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'emailVerified': emailVerified,
        'favoriteCategories': favoriteCategories,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? emailVerified,
    List<String>? favoriteCategories,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      emailVerified: emailVerified ?? this.emailVerified,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
    );
  }
}
