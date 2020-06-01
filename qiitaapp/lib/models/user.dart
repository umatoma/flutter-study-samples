import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String description;
  final String profileImageUrl;
  final int itemsCount;
  final int followersCount;

  User({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.profileImageUrl,
    @required this.itemsCount,
    @required this.followersCount,
  });
}
