// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/student/onlineExam/module/controller/OnlineExamController.dart';
import 'package:infixedu/screens/student/onlineExam/module/model/TakeExamModel.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reorderables/reorderables.dart';

class TakeExamScreen extends StatefulWidget {
  final TakeExamModel takeExamModel;
  TakeExamScreen({this.takeExamModel});

  @override
  _TakeExamScreenState createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen> {
  final OnlineExamController _questionController =
      Get.put(OnlineExamController());

  @override
  void initState() {
    _questionController.startController(widget.takeExamModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Take Exam'),
      body: Obx(() {
        if (_questionController.finalSubmitExam.value) {
          return Stack(
            children: [
              Container(
                color: Color(0xff18294d),
                width: Get.width,
                height: Get.height,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Exam Result Processing. Please wait".tr,
                    style:
                        Get.textTheme.subtitle1.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text.rich(
                      TextSpan(
                        text: "Question".tr +
                            " ${_questionController.questionNumber.value}",
                        style: Theme.of(context).textTheme.subtitle1,
                        children: [
                          TextSpan(
                              text:
                                  "/${_questionController.quiz.value.totalQuestions.toString()}",
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    ),
                  ),
                  TimerWidget(),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            QuestionSelectorWidget(),
            SizedBox(height: 10.0),
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _questionController.pageController,
                onPageChanged: _questionController.updateTheQnNum,
                itemCount: _questionController.questions.length,
                itemBuilder: (context, index) {
                  return QuestionCard(
                    assign: _questionController.questions[index],
                    index: index,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class QuestionSelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnlineExamController>(
        init: OnlineExamController(),
        builder: (qnController) {
          return Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    qnController.questionSelect(index);
                  },
                  child: qnController.answered[index] == true
                      ? Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff7C32FF),
                                Color(0xffC738D8),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: qnController.checkSelected(index)
                                ? LinearGradient(
                                    colors: [
                                      Color(0xff7C32FF),
                                      Color(0xffC738D8),
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                    ],
                                  ),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: qnController.checkSelected(index)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: qnController.checkSelected(index)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  width: 5.0,
                );
              },
              itemCount: qnController.quiz.value.examQuestions.length,
            ),
          );
        });
  }
}

class QuestionCard extends StatefulWidget {
  QuestionCard({this.assign, this.index});

  final ExamQuestion assign;
  final int index;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with AutomaticKeepAliveClientMixin {
  final OnlineExamController _examController = Get.put(OnlineExamController());
  final UserController _userController = Get.put(UserController());
  final TextEditingController shortAnsCtrl = TextEditingController();

  final TextEditingController longAnsCtrl = TextEditingController();

  final TextEditingController fillInTheBlanksCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<CheckboxModal> multipleChoiceList = [];
  List<CheckboxModal> multipleImageList = [];
  List<CheckboxModal> imageQuestionList = [];
  List<CheckboxModal> pairMatchQuestionList = [];
  List<int> assignIds = [];

  int defaultChoiceIndex;
  List<String> _choicesList = [
    'True',
    'False',
  ];

  List<Widget> _rows;
  List<Widget> _titleRows;

  List<String> s = [];
  Map<String, String> m = {};

  Future onItemClicked(CheckboxModal ckbItem) async {
    setState(() {
      ckbItem.value = !ckbItem.value;
    });
    if (ckbItem.value) {
      assignIds.add(ckbItem.id);

      Map data = {
        'student_id': _userController.studentId.value,
        'online_exam_id': _examController.quiz.value.onlineExam.id,
        'question_id': widget.assign.id,
        'record_id': _userController.selectedRecord.value.id,
        'school_id': _userController.schoolId.value,
        'submit_value': ckbItem.id,
        'option': ckbItem.id,
      };

      await _examController.singleSubmit(widget.index, data, true);
    } else {
      assignIds.remove(ckbItem.id);
    }
    print(assignIds);
  }

  @override
  void initState() {
    if (widget.assign.questionType == "M") {
      widget.assign.mQuestions.forEach((element) {
        multipleChoiceList.add(CheckboxModal(
          title: element.mTitle,
          id: element.mId,
          value: false,
          alphabet: element.alphabet,
        ));
      });
    } else if (widget.assign.questionType == "MI") {
      widget.assign.miQuestions.forEach((element) {
        multipleImageList.add(CheckboxModal(
          image: element.miTitle,
          id: element.miId,
          value: false,
        ));
      });
    } else if (widget.assign.questionType == "IMQ") {
      widget.assign.imqQuestions.forEach((element) {
        imageQuestionList.add(CheckboxModal(
          image: element.imqTitle,
          id: element.imqId,
          imageTitle: element.imqImageTitle,
          value: false,
        ));
      });
    } else if (widget.assign.questionType == "PM") {
      widget.assign.piQuestions.forEach((element) {
        pairMatchQuestionList.add(CheckboxModal(
          id: element.pmId,
          image: element.pTitle,
          imageTitle: element.pmTitle,
          value: false,
        ));

        s.add("${element.pTitle}");

        // m.addAll({"answer[${element.pmId}]": "${element.pTitle}"});
      });

      print(s);

      _rows = List<Widget>.generate(
        widget.assign.piQuestions.length,
        (int index) => Container(
          width: 100,
          height: 100,
          key: ValueKey(index),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            clipBehavior: Clip.antiAlias,
            child: FadeInImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "${AppConfig.domainName}/${pairMatchQuestionList[index].image}",
              ),
              placeholder: AssetImage('assets/images/onlineexam.png'),
            ),
          ),
        ),
      );
      _titleRows = List<Widget>.generate(
        widget.assign.piQuestions.length,
        (int index2) => Container(
          height: 100,
          key: ValueKey(index2),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              child: Text("${pairMatchQuestionList[index2].imageTitle}")),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<OnlineExamController>(
        init: OnlineExamController(),
        builder: (qnController) {
          if (qnController.finalSubmitExam.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (widget.assign.questionType == "SA") {
              return Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  padding: EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            QuestionTypeWidget(title: "Short Answer"),
                            SizedBox(height: 10),
                            HtmlWidget(
                              '''
                              ${widget.assign.question ?? "____"}
                               ''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: shortAnsCtrl,
                              maxLines: 2,
                              cursorColor: Get.theme.primaryColor,
                              style: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                              enabled: !qnController.answered[widget.index]
                                  ? true
                                  : false,
                              validator: (value) {
                                if (value.length == 0) {
                                  return "Please type something";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff7C32FF),
                                      Color(0xffC738D8),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Map data = {
                                      'student_id':
                                          _userController.studentId.value,
                                      'online_exam_id': _examController
                                          .quiz.value.onlineExam.id,
                                      'question_id': widget.assign.id,
                                      'record_id': _userController
                                          .selectedRecord.value.id,
                                      'school_id':
                                          _userController.schoolId.value,
                                      'submit_value': shortAnsCtrl.text,
                                    };

                                    await _examController.singleSubmit(
                                        widget.index, data, false);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  child: Text(
                                    "Submit Answer".tr,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContinueSkipSubmitBtn(
                        qnController: qnController,
                        index: widget.index,
                      ),
                    ],
                  ),
                ),
              );
            } else if (widget.assign.questionType == "SUBQ") {
              return Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  padding: EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            QuestionTypeWidget(title: "Subjective"),
                            SizedBox(height: 10),
                            HtmlWidget(
                              '''
                        ${widget.assign.question ?? "____"}
                        ''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: longAnsCtrl,
                              maxLines: 5,
                              cursorColor: Get.theme.primaryColor,
                              style: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                              enabled: !qnController.answered[widget.index]
                                  ? true
                                  : false,
                              validator: (value) {
                                if (value.length == 0) {
                                  return "Please type something";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff7C32FF),
                                      Color(0xffC738D8),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Map data = {
                                      'student_id':
                                          _userController.studentId.value,
                                      'online_exam_id': _examController
                                          .quiz.value.onlineExam.id,
                                      'question_id': widget.assign.id,
                                      'record_id': _userController
                                          .selectedRecord.value.id,
                                      'school_id':
                                          _userController.schoolId.value,
                                      'submit_value': longAnsCtrl.text,
                                    };

                                    await _examController.singleSubmit(
                                        widget.index, data, false);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  child: Text(
                                    "Submit Answer".tr,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContinueSkipSubmitBtn(
                        qnController: qnController,
                        index: widget.index,
                      ),
                    ],
                  ),
                ),
              );
            } else if (widget.assign.questionType == "F") {
              return Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  padding: EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            QuestionTypeWidget(title: "Fill in the blanks"),
                            SizedBox(height: 10),
                            HtmlWidget(
                              '''
                        ${widget.assign.question ?? "____"}
                        ''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: fillInTheBlanksCtrl,
                              maxLines: 1,
                              cursorColor: Get.theme.primaryColor,
                              style: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                              enabled: !qnController.answered[widget.index]
                                  ? true
                                  : false,
                              validator: (value) {
                                if (value.length == 0) {
                                  return "Please type something";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff7C32FF),
                                      Color(0xffC738D8),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Map data = {
                                      'student_id':
                                          _userController.studentId.value,
                                      'online_exam_id': _examController
                                          .quiz.value.onlineExam.id,
                                      'question_id': widget.assign.id,
                                      'record_id': _userController
                                          .selectedRecord.value.id,
                                      'school_id':
                                          _userController.schoolId.value,
                                      'submit_value': fillInTheBlanksCtrl.text,
                                    };

                                    await _examController.singleSubmit(
                                        widget.index, data, false);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  child: Text(
                                    "Submit Answer".tr,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ContinueSkipSubmitBtn(
                        qnController: qnController,
                        index: widget.index,
                      ),
                    ],
                  ),
                ),
              );
            } else if (widget.assign.questionType == "M") {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          QuestionTypeWidget(title: "MCQ"),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: HtmlWidget(
                              '''${widget.assign.question ?? ""}''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10),
                          ...multipleChoiceList.map((item) {
                            return ListTile(
                              onTap: () => onItemClicked(item),
                              contentPadding: EdgeInsets.zero,
                              leading: Checkbox(
                                value: item.value,
                                onChanged: (value) => onItemClicked(item),
                                checkColor: Colors.white,
                                activeColor: Color(0xff7C32FF),
                              ),
                              title: Transform.translate(
                                  offset: Offset(-16, 0),
                                  child: Text(
                                    item.title,
                                    style: Get.textTheme.subtitle1
                                        .copyWith(color: Colors.black),
                                  )),
                            );
                          }).toList(),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ContinueSkipSubmitBtn(
                      qnController: qnController,
                      index: widget.index,
                    ),
                  ],
                ),
              );
            } else if (widget.assign.questionType == "MI") {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          QuestionTypeWidget(title: "Multiple Image Question"),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: HtmlWidget(
                              '''${widget.assign.question ?? ""}''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                            ),
                            itemCount: multipleImageList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () =>
                                    onItemClicked(multipleImageList[index]),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: assignIds.contains(
                                                      multipleImageList[index]
                                                          .id)
                                                  ? Colors.purpleAccent
                                                  : Colors.transparent,
                                              width: assignIds.contains(
                                                      multipleImageList[index]
                                                          .id)
                                                  ? 5
                                                  : 0,
                                            ),
                                          ),
                                          child: FadeInImage(
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(
                                              "${AppConfig.domainName}/${multipleImageList[index].image}",
                                            ),
                                            placeholder: AssetImage(
                                                'assets/images/onlineexam.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => PhotoViewerWidget(
                                                image: multipleImageList[index]
                                                    .image,
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xff415094),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 30,
                                          width: 30,
                                          child: Icon(
                                            FontAwesomeIcons.expandAlt,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    assignIds.contains(
                                            multipleImageList[index].id)
                                        ? Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color.fromARGB(
                                                  99, 35, 31, 46),
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ContinueSkipSubmitBtn(
                      qnController: qnController,
                      index: widget.index,
                    ),
                  ],
                ),
              );
            } else if (widget.assign.questionType == "IMQ") {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          QuestionTypeWidget(title: "Image Question"),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: HtmlWidget(
                              '''${widget.assign.question ?? ""}''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: imageQuestionList.length,
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () =>
                                    onItemClicked(imageQuestionList[index]),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: assignIds.contains(
                                                  imageQuestionList[index].id)
                                              ? Colors.purpleAccent
                                              : Colors.transparent,
                                          width: assignIds.contains(
                                                  imageQuestionList[index].id)
                                              ? 1
                                              : 0,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            clipBehavior: Clip.antiAlias,
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              image: NetworkImage(
                                                "${AppConfig.domainName}/${imageQuestionList[index].image}",
                                              ),
                                              placeholder: AssetImage(
                                                  'assets/images/onlineexam.png'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${imageQuestionList[index].imageTitle}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    assignIds.contains(
                                            imageQuestionList[index].id)
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color.fromARGB(
                                                    99, 35, 31, 46),
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ContinueSkipSubmitBtn(
                      qnController: qnController,
                      index: widget.index,
                    ),
                  ],
                ),
              );
            } else if (widget.assign.questionType == "T") {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          QuestionTypeWidget(title: "True False"),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: HtmlWidget(
                              '''${widget.assign.question ?? ""}''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: List.generate(
                                _choicesList.length,
                                (index) => ChoiceChip(
                                      labelPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      label: Text(
                                        _choicesList[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      selected: defaultChoiceIndex == index,
                                      selectedColor: Color(0xff7C32FF),
                                      onSelected: (value) async {
                                        setState(() {
                                          defaultChoiceIndex = value
                                              ? index
                                              : defaultChoiceIndex;
                                        });

                                        Map data = {
                                          'student_id':
                                              _userController.studentId.value,
                                          'online_exam_id': _examController
                                              .quiz.value.onlineExam.id,
                                          'question_id': widget.assign.id,
                                          'record_id': _userController
                                              .selectedRecord.value.id,
                                          'school_id':
                                              _userController.schoolId.value,
                                          'submit_value':
                                              defaultChoiceIndex == 0
                                                  ? "T"
                                                  : "F",
                                        };

                                        await _examController.singleSubmit(
                                            widget.index, data, false);
                                      },
                                      // backgroundColor: color,
                                      elevation: 1,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ContinueSkipSubmitBtn(
                      qnController: qnController,
                      index: widget.index,
                    ),
                  ],
                ),
              );
            } else if (widget.assign.questionType == "PM") {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          QuestionTypeWidget(title: "Pair Match"),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: HtmlWidget(
                              '''${widget.assign.question ?? ""}''',
                              textStyle: Get.textTheme.subtitle2
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: ReorderableColumn(
                                  isReorderable: false,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  ignorePrimaryScrollController: true,
                                  mainAxisSize: MainAxisSize.max,
                                  padding: EdgeInsets.zero,
                                  needsLongPressDraggable: false,
                                  children: _titleRows,
                                  onReorder: (int oldIndex, int newIndex) {},
                                ),
                              ),
                              Flexible(
                                child: ReorderableColumn(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  ignorePrimaryScrollController: true,
                                  mainAxisSize: MainAxisSize.max,
                                  padding: EdgeInsets.zero,
                                  needsLongPressDraggable: false,
                                  children: _rows,
                                  onReorder:
                                      (int oldIndex, int newIndex) async {
                                    setState(() {
                                      String item = s.removeAt(oldIndex);

                                      s.insert(newIndex, item);

                                      Widget row = _rows.removeAt(oldIndex);

                                      _rows.insert(newIndex, row);
                                    });

                                    List<String> ans = [];

                                    Map<String, String> answers = {};

                                    widget.assign.piQuestions
                                        .forEach((element2) {
                                      ans.add("${element2.pmId}");
                                    });

                                    for (var i = 0; i < ans.length; i++) {
                                      answers.addAll({"${ans[i]}": "${s[i]}"});
                                    }

                                    Map data = {
                                      'student_id':
                                          _userController.studentId.value,
                                      'online_exam_id': _examController
                                          .quiz.value.onlineExam.id,
                                      'question_id': widget.assign.id,
                                      'record_id': _userController
                                          .selectedRecord.value.id,
                                      'school_id':
                                          _userController.schoolId.value,
                                      'ansers': answers,
                                    };

                                    print(data.toString());

                                    await _examController.singleSubmit(
                                        widget.index, data, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ContinueSkipSubmitBtn(
                      qnController: qnController,
                      index: widget.index,
                    ),
                  ],
                ),
              );
            }
            return Container();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class ContinueSkipSubmitBtn extends StatelessWidget {
  ContinueSkipSubmitBtn({
    this.qnController,
    this.index,
  });

  final OnlineExamController qnController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: qnController.submitSingleAnswer.value
          ? Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ))
          : Align(
              alignment: Alignment.bottomCenter,
              child: qnController.lastQuestion.value
                  ? Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7C32FF),
                            Color(0xffC738D8),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await qnController.finalSubmit();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // elevation: MaterialStateProperty.all(3),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          "Submit Exam".tr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7C32FF),
                            Color(0xffC738D8),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          qnController.skipPress(index);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // elevation: MaterialStateProperty.all(3),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          "Next".tr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnlineExamController>(
      init: OnlineExamController(),
      builder: (controller) {
        Duration clockTimer = Duration(seconds: controller.animation.value);
        String remainingTime =
            '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$remainingTime" + " " + "min".tr),
            controller.quiz.value.onlineExam.durationType == "exam"
                ? Text("Left for the exam".tr)
                : Text("Left for this question".tr),
          ],
        );
      },
    );
  }
}

class PhotoViewerWidget extends StatelessWidget {
  final String image;

  PhotoViewerWidget({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: ""),
      body: PhotoView(
        imageProvider: NetworkImage(
          AppConfig.domainName + '/' + image,
        ),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        enableRotation: false,
      ),
    );
  }
}

class QuestionTypeWidget extends StatelessWidget {
  final String title;
  QuestionTypeWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                colors: [
                  Color(0xff7C32FF),
                  Color(0xffC738D8),
                ],
              ),
            ),
            child: Text("$title".tr,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    )),
          ),
        ),
      ],
    );
  }
}
