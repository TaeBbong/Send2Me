import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidget extends StatelessWidget {
  ChatWidget({this.text});
  final String text;
  final String _name = "나";

  @override
  Widget build(BuildContext context) {
    // return Bubble(
    //   style: BubbleStyle(
    //     nip: BubbleNip.leftTop,
    //     color: Colors.white,
    //     elevation: 1 * 0.5,
    //     margin: BubbleEdges.only(top: 8.0, right: 50.0),
    //     alignment: Alignment.topLeft,
    //   ),
    //   child: Text('Hi Jason. Sorry to bother you. I have a queston for you.'),
    // );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Spacer(),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Bubble(
                    nip: BubbleNip.rightTop,
                    elevation: 1 * 0.5,
                    alignment: Alignment.topRight,
                    margin: BubbleEdges.only(left: 30.0),
                    // child: Text(text),
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: text,
                      maxLines: 3,
                    ),
                  ),
                )
              ],
            ),
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
