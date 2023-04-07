import 'manual.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'edit.dart';

void main() {
  runApp(const MyApp());
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
    _pages = [const Home(), const Manual(), const Edit()];
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
            // onPageChanged: (_selectedPageIndex) {
            //   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            // },
            onPageChanged: (newPage) {
              setState(() {
                _selectedPageIndex = newPage;
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), label: 'Manual'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: 'Program'),
              ],
              currentIndex: _selectedPageIndex,
              onTap: (selectedPageIndex) {
                setState(() {
                  _selectedPageIndex = selectedPageIndex;
                  _pageController.animateToPage(selectedPageIndex,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                });
              })),
    );
  }
}
