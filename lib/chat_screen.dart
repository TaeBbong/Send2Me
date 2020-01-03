import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'dart:math';
import './chat_widget.dart';
import './database_helper.dart';
import './memo_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  DatabaseHelper db = DatabaseHelper();
  final List<ChatWidget> _messages = <ChatWidget>[];
  final TextEditingController _textController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나에게 보내기"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _menuToggle,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(child: Text("M")),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("나에게 보내기", style: Theme.of(context).textTheme.subhead),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Bubble(
                          nip: BubbleNip.leftTop, child: Text("메모를 나에게 보내세요")),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
              height: 60,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer()),
        ],
      ),
    );
  }

  void _menuToggle() {
    print('List Page');
    Navigator.pushNamed(context, '/second');
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
    List<int> colors = [0xff91D4C2, 0xff45BB89, 0xff3D82AB, 0xff003853];
    _textController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    var message = ChatWidget(text: text);
    setState(() {
      int r_color = (colors.toList()..shuffle()).first;
      _messages.add(message);
      // _messages.insert(0, message);
      db.saveMemo(Memo(text, r_color, 0)).then((_) {
        print('save done with $text, $r_color');
      });
    });
  }
}
