class Answer {
  String _reason;
   int _value;

  String get reason => _reason;
  int get value => _value;

  setValue(int value) {
    this._value = value;
  }

  Answer({
        String reason,int value}){
    _reason = reason;
    _value = value;
  }

  Answer.fromJson(dynamic json) {
    _reason = json["Reason"];
    _value = json["Value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Reason"] = _reason;
    map["Value"] = _value;
    return map;
  }

}