import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/answer/answer_question_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/answer/answer_question_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/answer/answer_question_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/questions/question_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/questions/question_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/bloc/questions/question_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer_question_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/answer/answer_question_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/questions/question_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/unable_to_spot_provider/repo/questions/question_response.dart';
import 'package:spocate/utils/app_utils.dart';
import 'package:spocate/utils/network_utils.dart';

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  QuestionBloc _questionBloc;
  AnswerQuestionBloc _answerQuestionBloc;

  // Map _answerMap = LinkedHashMap<String, int>();

  UserInfo _userInfo;

  List<Reason> _reasonList = [];
  List<int> _groupValues = [];
  List<Answer> _answerValues = [];

  final commentTextController = TextEditingController();
  String userId;

  @override
  void initState() {
    print("initState QuestionList");
    final QuestionListRepository questionListRepository =
        QuestionListRepository(webserviceRequest: Webservice());
    _questionBloc = QuestionBloc(repository: questionListRepository);

    final AnswerQuestionRepo answerQuestionRepo =
        AnswerQuestionRepo(webserviceRequest: Webservice());
    _answerQuestionBloc = AnswerQuestionBloc(repository: answerQuestionRepo);

    _getUserDetail();

    _getQuestionsList();

    super.initState();
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_ROUTE_QUESTIONS),
      body: Container(
        child: MultiBlocListener(
          child: _buildQuestionListView(context, _reasonList),
          listeners: [
            BlocListener<QuestionBloc, QuestionListState>(
              cubit: _questionBloc,
              listener: (context, state) {
                _blocQuestionListListener(context, state);
              },
            ),
            BlocListener<AnswerQuestionBloc, AnswerQuestionState>(
              cubit: _answerQuestionBloc,
              listener: (context, state) {
                _blocAnswerSubmitListener(context, state);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReasonComment() {
    // During keyboard enabled to type the comment box not moving upward
    // This is the issue caused because scaffold not used

    return Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120.0,
            child: TextField(
              textAlign: TextAlign.start,
              controller: commentTextController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: WordConstants.QUESTIONS_LABEL_COMMENT,
                hintText: WordConstants.QUESTIONS_HINT_COMMENT,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_64,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              child: Text(
                WordConstants.QUESTIONS_BUTTON_SUBMIT,
                style: AppStyles.buttonFillTextStyle(),
              ),
              style: AppStyles.buttonFillStyle(),
              onPressed: () {
                _submitAnswerQuestion(commentTextController.text);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuestionListView(BuildContext context, List<Reason> reasons) {
    // print(" Question List  ${reasons.length}");
    // print(" _answerValues List  ${_answerValues.length}");
    // print(" _groupValues List  ${_groupValues.length}");
    if (reasons.isNotEmpty) {
      // Every time build question list view both group and answer values increase by 4
      // To avoid this we are checking if group values are empty because for the first time only it is empty
      if (_groupValues.isEmpty) {
        for (int i = 0; i < reasons.length; i++) {
          _groupValues.add(0);
          _answerValues.add(Answer(reason: reasons[i].reason, value: 0));
        }
      }
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  return _buildQuestionItemView(
                      index, reasons[index].id, reasons[index].reason);
                }),
            _buildReasonComment()
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          MessageConstants.SHOW_LOADING,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
        ),
      );
    }
  }

  Widget _buildQuestionItemView(
      int index, int questionId, String questionText) {
    return Card(
      margin: EdgeInsets.all(SizeConstants.SIZE_8),
      child: Container(
        margin: EdgeInsets.all(SizeConstants.SIZE_16),
        height: SizeConstants.SIZE_100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConstants.SIZE_4,
                  SizeConstants.SIZE_4,
                  SizeConstants.SIZE_4,
                  SizeConstants.SIZE_4),
              child: Text(
                "$questionText",
                style: AppStyles.questionListItemQuestionTextStyle(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConstants.SIZE_4),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                        title: Text(
                          WordConstants.QUESTIONS_ANSWER_NO,
                          style: AppStyles.questionListItemAnswerTextStyle(),
                        ),
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: _groupValues[index],
                        onChanged: (int value) {
                          setState(() {
                            _groupValues[index] = value;
                            _answerValues[index].setValue(value);
                            // _answerMap[questionText] = 0;
                          });
                        }),
                  ),
                  SizedBox(width: SizeConstants.SIZE_32),
                  Expanded(
                    child: RadioListTile(
                        title: Text(
                          WordConstants.QUESTIONS_ANSWER_YES,
                          style: AppStyles.questionListItemAnswerTextStyle(),
                        ),
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: _groupValues[index],
                        onChanged: (int value) {
                          setState(() {
                            _groupValues[index] = value;
                            _answerValues[index].setValue(value);
                            // _answerMap[questionText] = 1;
                          });
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getQuestionsList() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _questionBloc.add(QuestionItemsEvent());
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitAnswerQuestion(String comment) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        print("answerValues ${jsonEncode(_answerValues)}");
        var answerQuestionRequest = AnswerQuestionRequest(
            userId: userId,
            comment: comment,
            reasonList: jsonEncode(_answerValues));
        _answerQuestionBloc.add(AnswerQuestionClickEvent(
            answerQuestionRequest: answerQuestionRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocQuestionListListener(BuildContext context, QuestionListState state) {
    if (state is QuestionListEmpty) {}
    if (state is QuestionListLoading) {
      EasyLoading.show(status: MessageConstants.SHOW_LOADING);
    }
    if (state is QuestionListError) {
      EasyLoading.dismiss();
      AppWidgets.showSnackBar(context, "${state.message}");
    }
    if (state is QuestionListSuccess) {
      EasyLoading.dismiss();
      setState(() {
        _reasonList.clear();
        print(" Question List  ${state.questionResponse}");
        _reasonList = state.questionResponse.reasonList;
      });
    }
  }

  _blocAnswerSubmitListener(BuildContext context, AnswerQuestionState state) {
    if (state is AnswerQuestionEmpty) {}
    if (state is AnswerQuestionLoading) {
      EasyLoading.show(status: MessageConstants.SHOW_LOADING);
    }
    if (state is AnswerQuestionError) {
      EasyLoading.dismiss();
      AppWidgets.showSnackBar(context, "${state.message}");
    }
    if (state is AnswerQuestionSuccess) {
      EasyLoading.dismiss();
      setState(() {
        print(" Answer Submitted  ${state.answerQuestionResponse}");
        Navigator.pushReplacementNamed(context, RouteConstants.ROUTE_HOME_SCREEN);
      });
    }
  }
}
