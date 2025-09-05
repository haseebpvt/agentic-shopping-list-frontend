import 'package:advanced_shopping_list_frontend/data/model/quiz_resume/quiz_resume.dart';
import 'package:advanced_shopping_list_frontend/suggested_product_view.dart';
import 'package:animated_quiz_widget/quiz_view.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'data/api_service.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  String _text = "Status";
  bool _showQuiz = false;
  List<QuizQuestion>? quizQuestionAnswerList = [];
  String threadId = "";
  QuizResumeResponse? quizResumeResponse;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 300,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final file = await controller.takePicture();
                    final apiService = ApiServiceImpl(
                      Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000")),
                    );

                    apiService.getProductSuggestion("8", file).listen((data) {
                      threadId = data.threadId;

                      setState(() {
                        if (data.type == "quiz_interrupt") {
                          _showQuiz = true;
                          final quizQuestions = data.quiz!.quiz;

                          quizQuestionAnswerList = quizQuestions?.map((item) {
                            return QuizQuestion(
                              id: item.question.hashCode.toString(),
                              question: item.question,
                              options: item.answers,
                            );
                          }).toList();
                        }

                        _text = data.message;
                      });
                    });
                  },
                  icon: Icon(Icons.camera),
                ),
              ],
            ),
            Text(_text),
            Visibility(
              visible: _showQuiz,
              child: QuizWidget(
                questions: quizQuestionAnswerList ?? [],
                onQuizCompleted: (data) {
                  setState(() {
                    _showQuiz = false;
                  });

                  final apiService = ApiServiceImpl(
                    Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000")),
                  );

                  final questionAndAnswers = data.map((data) {
                    return "${data.question}: ${data.selectedAnswer}";
                  }).toList();

                  apiService
                      .resumeQuiz(
                        QuizResumeRequest(
                          threadId: threadId,
                          questionAndAnswers: questionAndAnswers,
                        ),
                      )
                      .then((questionAndAnswerData) {
                        setState(() {
                          quizResumeResponse = questionAndAnswerData;
                        });
                      });
                },
              ),
            ),
            // ListView.builder(
            //   itemCount: quizResumeResponse?.data.products.length,
            //   itemBuilder: (context, index) {
            //
            //
            //     // return SuggestedProductView(product: )
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
