class WebExceptions implements Exception {
  final _message;
  final _prefix;

  WebExceptions([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends WebExceptions {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends WebExceptions {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends WebExceptions {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends WebExceptions {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}