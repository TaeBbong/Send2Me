import 'package:flutter/material.dart';
import 'package:flutter_memo/comment_model.dart';
import 'package:flutter_memo/memo_model.dart';
import 'database_helper.dart';

class MemoScreen extends StatefulWidget {
  final int memo_id;
  MemoScreen({this.memo_id});
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  DatabaseHelper db = DatabaseHelper();
  Memo currentMemo;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    db.getMemo(widget.memo_id).then((memo) {
      setState(() {
        currentMemo = memo;
      });
    });

    db.getCommentsByRoot(widget.memo_id).then((results) {
      setState(() {
        results.forEach((result) {
          comments.add(Comment.fromMap(result));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _backToggle,
        ),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(currentMemo.text),
                  subtitle: Text(currentMemo.date),
                ),
              );
            }),
      ),
      // Container(
      //   child: ListView.builder(
      //       itemCount: comments.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         return Card(
      //           child: ListTile(
      //             title: Text(comments.elementAt(index).text),
      //             subtitle: Text(currentMemo.date),
      //           ),
      //         );
      //       }),
      // ),
    );
  }

  void _backToggle() {
    print('back clicked');
    Navigator.pop(context);
  }
}
