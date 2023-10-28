import 'package:flutter/foundation.dart';

@immutable
class Profile {
  String profileId;
  String name;
  bool isAnimal;
  String userId;

  Profile({
    required this.profileId,
    required this.name,
    required this.isAnimal,
    required this.userId,
  });

  Profile copyWith({
    String? profileId,
    String? name,
    bool? isAnimal,
    String? userId,
}) {
    return Profile(
      profileId : profileId ?? this.profileId,
      name : name ?? this.name,
      isAnimal : isAnimal ?? this.isAnimal,
      userId : userId ?? this.userId,
    );
  }
}
