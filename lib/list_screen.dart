import 'package:flutter/material.dart';
import 'package:flutter_memo/category_model.dart';
import './memo_widget.dart';
import './database_helper.dart';
import './memo_model.dart';
import './category_screen.dart';

class ListScreen extends StatefulWidget {
  @override
  State createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  List<List> widgetList = [];
  bool pressed = false;

  List colors = [
    Color(0xffACCBE1),
    Color(0xff516c8d),
    Color(0xff304163),
    Color(0xff28385e),
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

    db.getAllCategories().then((categories) {
      setState(() {
        categories.forEach((category) {
          print(category['id']);
          widgetList.add(
            [category['id'], category['text'], colors[category['id'] - 1]],
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pressed
          ? AppBar(
              title: Text("카테고리를 수정하세요"),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    pressed = false;
                  });
                },
              ),
              actions: <Widget>[],
            )
          : AppBar(
              title: Text("카테고리"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: _backToggle,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    setState(() {
                      pressed = true;
                    });
                  },
                )
              ],
            ),
      body: Column(
        children: <Widget>[
          pressed
              ? Container(
                  margin: EdgeInsets.all(5.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    controller: ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: widgetList.map((List data) {
                      return InkWell(
                        child: Container(
                          height: 250.0,
                          margin: EdgeInsets.all(5.0),
                          child: Card(
                            elevation: 5,
                            color: colors.elementAt(
                              data.elementAt(0) - 1,
                            ),
                            child: Center(
                              child: Text(
                                data.elementAt(1),
                                style: TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                print('showing dialog');
                                return AlertDialog(
                                  title: Text('카테고리 이름을 수정하세요'),
                                  content: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                          child: new TextField(
                                        autofocus: true,
                                        decoration: new InputDecoration(
                                          labelText: '카테고리 이름',
                                          hintText: data.elementAt(1),
                                        ),
                                        onChanged: (value) {
                                          data[1] = value;
                                        },
                                      ))
                                    ],
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('완료'),
                                      onPressed: () {
                                        setState(() {
                                          db.updateCategory(Category(
                                              data.elementAt(0),
                                              data.elementAt(1)));
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      );
                    }).toList(),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(5.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    controller: ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: widgetList.map((List data) {
                      return InkWell(
                        child: Container(
                          height: 250.0,
                          // color: data.elementAt(2),
                          margin: EdgeInsets.all(5.0),
                          child: DragTarget(
                            builder: (context, List<int> candidateData,
                                rejectedData) {
                              return Card(
                                elevation: 5,
                                color: colors.elementAt(
                                  data.elementAt(0) - 1,
                                ),
                                child: Center(
                                  child: Text(
                                    data.elementAt(1),
                                    style: TextStyle(
                                      fontSize: 50.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onWillAccept: (d) {
                              print('will accept');
                              print(data.elementAt(0));
                              print(d);
                              return true;
                            },
                            onAccept: (d) {
                              print('accepted');
                              print(data.elementAt(2));
                              print(d);
                              setState(() {
                                _popFromMemos(d, data.elementAt(0));
                              });
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                id: data.elementAt(0),
                                text: data.elementAt(1),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
          pressed ? Container() : Spacer(),
          pressed ? Container() : Divider(height: 1.0),
          pressed
              ? Container()
              : Container(
                  height: 80,
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    // color: Colors.lightBlueAccent,
                  ),
                  child: _buildChatItems(),
                ),
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
        'category': category,
        'date': memo.toMap()['date'],
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
