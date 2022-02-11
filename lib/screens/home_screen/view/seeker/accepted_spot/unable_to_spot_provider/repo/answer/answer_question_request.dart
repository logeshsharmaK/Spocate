class AnswerQuestionRequest {
  String userId;
  String comment;
  String reasonList;

  AnswerQuestionRequest({
    this.userId,
    this.comment,
    this.reasonList,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customerid'] = this.userId;
    data['comment'] = this.comment;
    data['ReasonList'] = this.reasonList;
    return data;
  }
}
