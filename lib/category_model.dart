class Category {
  int _id;
  String _text;

  Category(this._id, this._text);

  Category.map(dynamic obj) {
    this._id = obj['id'];
    this._text = obj['text'];
  }

  int get id => _id;
  String get text => _text;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['text'] = _text;

    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._text = map['text'];
  }
}
