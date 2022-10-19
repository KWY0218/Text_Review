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
      body: PostList(getPosts(), onClickLike),
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

  onClickLike(int index, int currLikeCount, bool currIsLike) async {
    final currDoc = db.collection("Posts").doc("$index");
    final likeCount = currIsLike ? currLikeCount - 1 : currLikeCount + 1;
    db.runTransaction((transaction) => transaction
        .get(currDoc)
        .then((value) => {
              transaction.update(currDoc, {"isLike": !currIsLike}).update(
                  currDoc, {"likeCount": likeCount})
            })
        .then((value) => Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {});
            })));
  }
}

class PostList extends StatelessWidget {
  PostList(this._posts, this.onClick);

  final Future<List<Post>> _posts;
  void Function(int, int, bool) onClick;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: _posts,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostItem(snapshot.data![index], index, onClick);
                });
          } else {
            return const Text("loading");
          }
        });
  }
}

class PostItem extends StatelessWidget {
  PostItem(this._post, this._index, this.onClick);

  void Function(int, int, bool) onClick;
  final Post _post;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(_post.content!),
        trailing: LikeIcon(_post, _index, onClick),
      ),
    );
  }
}

class LikeIcon extends StatelessWidget {
  LikeIcon(this._post, this._index, this.onClick);

  final Post _post;
  void Function(int, int, bool) onClick;
  final int _index;

  @override
  Widget build(BuildContext context) {
    var icon =
        Icon(_post.isLike == true ? Icons.favorite : Icons.favorite_border);

    return IconButton(
      icon: icon,
      onPressed: () {
        onClick(_index, _post.likeCount!, _post.isLike!);
      },
    );
  }
}
