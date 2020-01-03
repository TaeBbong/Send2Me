import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    print(this.index);
    return Scaffold(
      appBar: this.pressed
          ? AppBar()
          : AppBar(
              title: Text(
                  widget.widgetList.elementAt(this.index - 1).elementAt(0)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _backToggle,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                )
              ],
            ),
      body: pressed
          ? Container()
          : Container(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(items.elementAt(index).text),
                    ),
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
}
