import 'package:cpu_application/manual.dart';
import 'package:cpu_application/tutorial.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'programs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [Home(), Tutorial(), Programs(), Manual()];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(backgroundColor: Colors.blue),
          body: PageView(
            controller: _pageController,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.school), label: 'Tutorial'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: 'Programs'),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Manual')
              ],
              currentIndex: _selectedPageIndex,
              onTap: (selectedPageIndex) {
                setState(() {
                  _selectedPageIndex = selectedPageIndex;
                  _pageController.animateToPage(selectedPageIndex,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                });
              })),
    );
  }
}
