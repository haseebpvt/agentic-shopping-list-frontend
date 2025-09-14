import 'package:advanced_shopping_list_frontend/core/core.dart';
import 'package:advanced_shopping_list_frontend/core/services/category_service.dart';
import 'package:advanced_shopping_list_frontend/ui/ui.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

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
  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiServiceImpl(
      Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 2),
      )),
    );

    final LocalShoppingListService localService = LocalShoppingListService();
    final CategoryService categoryService = CategoryService();

    return MaterialApp(
      title: 'Shopping List',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductSuggestionBloc(apiService: apiService),
          ),
          BlocProvider(
            create: (context) => ShoppingListBloc(apiService: apiService),
          ),
          BlocProvider(
            create: (context) => PreferenceListBloc(apiService: apiService),
          ),
          BlocProvider(
            create: (context) => LocalShoppingListBloc(
              service: localService,
              apiService: apiService,
            ),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              apiService: apiService,
              categoryService: categoryService,
            )..add(const LoadCategories()),
          ),
        ],
        child: MainPageView(cameras: _cameras),
      ),
    );
  }
}

