import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({this.text});
  final String text;
  final String _name = "나";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(_name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Bubble(nip: BubbleNip.rightTop, child: Text(text)),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
        ],
      ),
    );
  }
}
