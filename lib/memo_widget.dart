import 'package:flutter/material.dart';

class MemoWidget extends StatelessWidget {
  MemoWidget({this.text, this.color, this.id});
  final String text;
  final int color;
  final int id;

  @override
  Widget build(BuildContext context) {
    Color c = Color(color);
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
            backgroundColor: c,
          ),
        ),
      ),
      feedback: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            child: Text(text[0],
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: c,
          ),
        ),
      ),
      childWhenDragging: Container(),
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
