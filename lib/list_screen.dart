import 'package:flutter/material.dart';
import './memo_widget.dart';
import './database_helper.dart';
import './memo_model.dart';
import './category_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  State createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<Set> widgetList = [
    {'STUDY', Colors.lightGreen, 1},
    {'QUICK', Colors.deepOrange, 2},
    {'TODO', Colors.pink, 3},
    {'IDEA', Colors.deepPurple, 4}
  ];

  List<MemoWidget> items = <MemoWidget>[];
  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    db.getMemosByCategory(0).then((memos) {
      setState(() {
        if (memos.length != 0) {
          memos.forEach((memo) {
            if (memo['text'] != null) {
              items.add(MemoWidget(
                id: memo['id'],
                text: memo['text'],
                color: memo['color'],
              ));
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _backToggle,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5.0),
            child: GridView.count(
              crossAxisCount: 2,
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: widgetList.map((Set data) {
                return InkWell(
                  child: Container(
                    height: 250.0,
                    color: data.elementAt(1),
                    margin: EdgeInsets.all(5.0),
                    child: DragTarget(
                      builder:
                          (context, List<int> candidateData, rejectedData) {
                        return Center(
                          child: Text(
                            data.elementAt(0),
                            style:
                                TextStyle(fontSize: 50.0, color: Colors.white),
                          ),
                        );
                      },
                      onWillAccept: (d) {
                        print('will accept');
                        print(data.elementAt(2));
                        print(d);
                        return true;
                      },
                      onAccept: (d) {
                        print('accepted');
                        print(data.elementAt(2));
                        print(d);
                        setState(() {
                          _popFromMemos(d, data.elementAt(2));
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategoryScreen(index: data.elementAt(2))));
                  },
                );
              }).toList(),
            ),
          ),
          Spacer(),
          Divider(height: 1.0),
          Container(
              height: 80,
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                // color: Colors.lightBlueAccent,
              ),
              child: _buildChatItems()),
        ],
      ),
    );
  }

  void _backToggle() {
    print('back clicked');
    Navigator.pop(context);
  }

  void _popFromMemos(int data, int category) {
    print('pop start');
    items.removeWhere((item) => item.id == data);
    db.getMemo(data).then((memo) {
      db.updateMemo(Memo.fromMap({
        'id': data,
        'text': memo.toMap()['text'],
        'color': memo.toMap()['color'],
        'category': category
      }));
      print('update done');
    });
    print('pop complete');
  }

  Widget _buildChatItems() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) => items[index],
                itemCount: items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
