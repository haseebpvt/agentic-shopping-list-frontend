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
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: CameraPreview(controller),
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  print("📸 Taking picture...");
                  final file = await controller.takePicture();
                  print("✅ Picture taken: ${file.path}");

                  final options = BaseOptions(baseUrl: "http://10.0.2.2:8000");
                  final apiService = ApiServiceImpl(Dio(options));

                  print("🔄 Calling getProductSuggestion...");
                  final result = await apiService.getProductSuggestion(
                    "8",
                    file,
                  );
                  print("🎉 Final result received: ${result.type}");
                } catch (e) {
                  print("💥 Error occurred: $e");
                }
              },
              icon: Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}
