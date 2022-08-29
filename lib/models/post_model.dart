import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final Timestamp timestamp;
  final String imageUrl;
  final String description;
  PostModel(
      {required this.id,
      required this.userName,
      required this.userId,
      required this.imageUrl,
      required this.description,
      required this.timestamp});
}
