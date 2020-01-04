import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import './memo_model.dart';
import './database_helper.dart';

class CategoryScreen extends StatefulWidget {
  final int id;
  final String text;
  CategoryScreen({Key key, this.id, this.text}) : super(key: key);
  _CategoryScreenState createState() =>
      _CategoryScreenState(id: this.id, text: this.text);
}

class _CategoryScreenState extends State<CategoryScreen> {
  final int id;
  final String text;
  _CategoryScreenState({this.id, this.text});

  List<Memo> items = <Memo>[];
  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    db.getMemosByCategory(this.id).then((memos) {
      setState(() {
        memos.forEach((memo) {
          items.add(Memo.fromMap(memo));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.text),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _backToggle,
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            print(items.elementAt(index).text);
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
                  subtitle: Text(items.elementAt(index).date),
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
        'category': 0,
        'date': memo.toMap()['date'],
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
