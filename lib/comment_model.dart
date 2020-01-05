class Comment {
  int _id;
  int _rootId;
  String _text;
  String _date;

  Comment(this._id, this._rootId, this._text, this._date);

  Comment.map(dynamic obj) {
    this._id = obj['id'];
    this._text = obj['text'];
    this._rootId = obj['rootid'];
    this._date = obj['date'];
  }

  int get id => _id;
  String get text => _text;
  int get rootid => _rootId;
  String get date => _date;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['text'] = _text;
    map['rootid'] = _rootId;
    map['date'] = _date;

    return map;
  }

  Comment.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['text'];
    this._rootId = map['rootid'];
    this._date = map['date'];
  }
}
