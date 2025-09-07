import 'camera_screen.dart';
import 'home_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MainPageView extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const MainPageView({super.key, required this.cameras});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // Home Screen (Page 0)
              HomeScreen(onPageChange: _goToPage),
              
              // Camera Screen (Page 1)
              CameraScreen(cameras: widget.cameras),
            ],
          ),
          
            
          // Back to home button for camera screen
          if (_currentPage == 1)
            Positioned(
              top: 50,
              left: 16,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => _goToPage(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

}
