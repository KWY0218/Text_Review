import 'package:flutter/material.dart';
import 'package:text_review/data/Post.dart';

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