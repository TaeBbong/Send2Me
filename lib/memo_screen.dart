import 'package:flutter/material.dart';
import 'package:flutter_memo/comment_model.dart';
import 'package:flutter_memo/memo_model.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class MemoScreen extends StatefulWidget {
  final int memo_id;
  MemoScreen({this.memo_id});
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  DatabaseHelper db = DatabaseHelper();
  final TextEditingController _textController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
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
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text(
                  currentMemo.text,
                  maxLines: 2,
                ),
                subtitle: Text(currentMemo.date),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(comments.elementAt(index).text),
                        subtitle: Text(currentMemo.date),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _backToggle() {
    print('back clicked');
    Navigator.pop(context);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.length == 0) {
      return;
    }
    _textController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    setState(() {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy/MM/dd kk:mm').format(now);
      // _messages.add(message);
      // _messages.insert(0, message);
      // db.saveMemo(Memo(text, r_color, 0, formattedDate)).then((_) {
      //   print('save done with $text, $r_color, $formattedDate');
      // });
    });
  }
}
