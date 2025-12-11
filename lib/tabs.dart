import 'package:flutter/material.dart';
import 'package:recipe_app/screens/favorites_screen.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String _activeScreen = 'home-screen';
  int _currentIndex = 0;
  Widget? _content;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 0) {
      _content = HomeScreen();
    } else if (_currentIndex == 1){
      _content = SearchScreen();
    }else{
      _content = FavoritesScreen();
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightGreen,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon:Icon(Icons.favorite),label: 'Favorite'),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          'Foodazo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),

        ),
        centerTitle: true,
      ),
      body: _content,
    );
  }
}
