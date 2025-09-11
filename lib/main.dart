import 'package:advanced_shopping_list_frontend/core/core.dart';
import 'package:advanced_shopping_list_frontend/ui/ui.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiServiceImpl(
      Dio(BaseOptions(
        baseUrl: "https://shoppinglistagent.shop/api",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
      )),
    );

    final LocalShoppingListService localService = LocalShoppingListService();

    return MaterialApp(
      title: 'Shopping List',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
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
            create: (context) => LocalShoppingListBloc(service: localService),
          ),
        ],
        child: MainPageView(cameras: _cameras),
      ),
    );
  }
}

