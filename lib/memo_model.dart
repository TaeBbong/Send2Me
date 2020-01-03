class Memo {
  int _id;
  String _text;
  int _color;
  int _category;

  Memo(this._text, this._color, this._category);

  Memo.map(dynamic obj) {
    this._id = obj['id'];
    this._text = obj['text'];
    this._color = obj['color'];
    this._category = obj['category'];
  }

  int get id => _id;
  String get text => _text;
  int get color => _color;
  int get category => _category;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['text'] = _text;
    map['color'] = _color;
    map['category'] = _category;

    return map;
  }

  Memo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['text'];
    this._color = map['color'];
    this._category = map['category'];
  }
}
