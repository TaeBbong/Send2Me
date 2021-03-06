import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class MemoWidget extends StatelessWidget {
  MemoWidget({this.text, this.color, this.id});
  final String text;
  final int color;
  final int id;

  @override
  Widget build(BuildContext context) {
    Color c = Color(color);

    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor();
    print('hi');
    print(text);
    if (text.length == 0) {
      return Container();
    }
    print(c);
    return Draggable(
      data: id,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            child: Text(text[0],
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: _color,
          ),
        ),
      ),
      feedback: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                child: Text(text[0],
                    style: TextStyle(
                      color: Colors.white,
                    )),
                backgroundColor: _color,
              ),
            ),
            Container(
              width: 250,
              child: Bubble(
                nip: BubbleNip.leftTop,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                  maxLines: 3,
                ),
                margin: BubbleEdges.only(right: 30.0),
                // elevation: 1 * 0.5,
                alignment: Alignment.topLeft,
              ),
            )
          ],
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(text[0],
              style: TextStyle(
                color: Colors.white,
              )),
          backgroundColor: Colors.white,
        ),
      ),
      onDragStarted: () {
        print(id);
        print('drag start');
      },
      onDragCompleted: () {
        print('drag completed');
      },
      onDraggableCanceled: (Velocity, Offset) {
        print('drag canceled');
      },
    );
  }
}
