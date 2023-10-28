import 'package:flutter/foundation.dart';

@immutable
class Profile {
  String profileId;
  String name;
  bool isAnimal;

  Profile({
    required this.profileId,
    required this.name,
    required this.isAnimal,
  });

  Profile copyWith({
    String? profileId,
    String? name,
    bool? isAnimal,
}) {
    return Profile(
      profileId : profileId ?? this.profileId,
      name : name ?? this.name,
      isAnimal : isAnimal ?? this.isAnimal,
    );
  }
}
