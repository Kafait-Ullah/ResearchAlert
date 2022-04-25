import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  String title;
  String desc;
  Timestamp createdAt;
  Timestamp reminder;

  Notes({
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.reminder,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      title: json['title'],
      desc: json['detail'],
      createdAt: json['createdAt'],
      reminder: json['reminder'],
    );
  }
}
