import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String title;
  final String description;
  final String uploaderName;
  final String? profilePicture;
  final Timestamp createdAt;

  Entry({
    required this.title,
    required this.description,
    required this.uploaderName,
    this.profilePicture,
    required this.createdAt,
  });

  // Convert a Firestore DocumentSnapshot to a Dart object
  factory Entry.fromDocument(DocumentSnapshot doc) {
    return Entry(
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      uploaderName: doc['uploaderName'] ?? '',
      profilePicture: doc['profilePicture'],
      createdAt: doc['createdAt'],
    );
  }

  // Convert the Dart object to a JSON-like map, suitable for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'uploaderName': uploaderName,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
    };
  }
}
//24648