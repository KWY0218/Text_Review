import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text_review/data/Post.dart';
import 'package:text_review/ui/posts_count_screen.dart';

import 'login_screen.dart';
import 'posts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var db = FirebaseFirestore.instance;
  final _authentication = FirebaseAuth.instance;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _pagerWidgets = [
      PostList(getPosts(), onClickLike),
      PostCountList(getPosts())
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Review Screen'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _authentication.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: _pagerWidgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Main',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_sharp),
              label: 'Like',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped),
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
