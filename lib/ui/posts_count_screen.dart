import 'package:flutter/material.dart';
import 'package:text_review/data/Post.dart';

class PostCountList extends StatelessWidget {
  PostCountList(this._posts);

  final Future<List<Post>> _posts;

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
                  return PostCountItem(snapshot.data![index]);
                });
          } else {
            return const Text("loading");
          }
        });
  }
}

class PostCountItem extends StatelessWidget {
  PostCountItem(this._post);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(_post.content!),
        trailing: TrailItem(_post),
      ),
    );
  }
}

class TrailItem extends StatelessWidget {
  TrailItem(this._post);

  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Likes"),
        const SizedBox(height: 8),
        Text("${_post.likeCount}")
      ],
    );
  }
}
