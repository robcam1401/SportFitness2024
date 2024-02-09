import 'package:exercise_app/explore.dart';
import 'package:exercise_app/feed.dart';
import 'package:exercise_app/profile.dart';
import 'package:exercise_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:exercise_app/near_you.dart';

void main() => runApp(MaterialApp(
  home: Home()
));

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // sets the index to the correct starting page
  int currentPageIndex = 0;
  // list holding all the main screens that will be in the navigation bar
  final screens = [
    Feed(),
    Explore(),
    NearYou(),
    Profile(),
    Settings(),
  ];

// a constaint setting the behavior of the navigation buttons
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    // creates the navigation bar and sets all the pages based on the indexing
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Near You',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}