import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import './memo_model.dart';
import './database_helper.dart';

class CategoryScreen extends StatefulWidget {
  List<Set> widgetList = [
    {'STUDY', Colors.lightGreen, 1},
    {'QUICK', Colors.deepOrange, 2},
    {'TODO', Colors.pink, 3},
    {'IDEA', Colors.deepPurple, 4}
  ];

  final int index;
  CategoryScreen({Key key, this.index}) : super(key: key);
  _CategoryScreenState createState() => _CategoryScreenState(index: this.index);
}

class _CategoryScreenState extends State<CategoryScreen> {
  final int index;
  bool pressed = false;
  List<bool> inputs = new List<bool>();
  _CategoryScreenState({this.index});

  List<Memo> items = <Memo>[];
  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getMemosByCategory(this.index).then((memos) {
      setState(() {
        memos.forEach((memo) {
          items.add(Memo.fromMap(memo));
        });
      });
    });

    for (int i = 0; i < items.length; i++) {
      inputs.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this.index);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.widgetList.elementAt(this.index - 1).elementAt(0)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _backToggle,
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              child: Card(
                child: ListTile(
                  // title: Text(items.elementAt(index).text),
                  title: Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: items.elementAt(index).text,
                    maxLines: 3,
                  ),
                ),
              ),
              key: Key(items.elementAt(index).text),
              background: slideRightBackground(),
              secondaryBackground: slideLeftBackground(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('메모를 삭제하시겠습니까?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              setState(() {
                                _popFromMemos(items.elementAt(index).id);
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('카테고리를 초기화 하시겠습니까?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '초기화',
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              setState(() {
                                _resetCategory(items.elementAt(index).id);
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _backToggle() {
    print('back clicked');
    Navigator.pop(context);
  }

  void _popFromMemos(int data) {
    print('pop start');
    items.removeWhere((item) => item.id == data);
    db.deleteMemo(data).then((_) {
      print('delete $data done');
    });
    print('pop complete');
  }

  void _resetCategory(int data) {
    print('category reset start');
    items.removeWhere((item) => item.id == data);
    db.getMemo(data).then((memo) {
      db.updateMemo(Memo.fromMap({
        'id': data,
        'text': memo.toMap()['text'],
        'color': memo.toMap()['color'],
        'category': 0
      }));
      print('update done');
    });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            Text(
              " 초기화",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " 삭제",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
