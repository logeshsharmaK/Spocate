class SeekerCancelProviderWaitResponse {
  String _status;
  String _message;

  SeekerCancelProviderWaitResponse({String status, String message}) {
    this._status = status;
    this._message = message;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get message => _message;
  set message(String message) => _message = message;

  SeekerCancelProviderWaitResponse.fromJson(Map<String, dynamic> json) {
    _status = json['Status'];
    _message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this._status;
    data['Message'] = this._message;
    return data;
  }

}