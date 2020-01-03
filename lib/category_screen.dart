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
      appBar: this.pressed
          ? AppBar(
              title: Text(
                  widget.widgetList.elementAt(this.index - 1).elementAt(0)),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {},
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ],
            )
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
          ? Container(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          CheckboxListTile(
                            value: inputs[index],
                            title: Text(items.elementAt(index).text),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool value) {},
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
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
