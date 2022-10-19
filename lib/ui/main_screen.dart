import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_review/data/Post.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostList(getPosts()),
    );
  }

  Future<List<Post>> getPosts() async {
    final postsCollection = db.collection("Posts").withConverter(
        fromFirestore: Post.fromFirestore,
        toFirestore: (Post post, _) => post.toFirestore());
    final postsSnapShot = await postsCollection.get();
    final posts = postsSnapShot.docs.map((doc) => doc.data()).toList();
    return posts;
  }
}

class PostList extends StatelessWidget {
  PostList(this._posts);

  final Future<List<Post>> _posts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: _posts,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostItem(snapshot.data![index]);
                });
          } else {
            return Text("loading");
          }
        });
  }
}

class PostItem extends StatelessWidget {
  PostItem(this._post);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_post.content!),
      trailing: LikeIcon(_post.isLike!),
    );
  }
}

class LikeIcon extends StatelessWidget {
  LikeIcon(this._isLike);

  final bool _isLike;

  @override
  Widget build(BuildContext context) {
    if (_isLike) {
      return const Icon(Icons.favorite);
    } else {
      return const Icon(Icons.favorite_border);
    }
  }
}
