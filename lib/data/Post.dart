import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? content;
  final bool? isLike;
  final int? likeCount;
  final int? sequnce;

  Post({this.content, this.isLike, this.likeCount, this.sequnce});

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Post(
      content: data?['content'],
      isLike: data?['isLike'],
      likeCount: data?['likeCount'],
      sequnce: data?['sequnce'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (content != null) "content": content,
      if (isLike != null) "isLike": isLike,
      if (likeCount != null) "likeCount": likeCount,
      if (sequnce != null) "sequnce": sequnce,
    };
  }
}
