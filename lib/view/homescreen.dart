import 'package:flutter/material.dart';
import 'package:todo_noorisys/view/task_view.dart';

import '../helper/connection_helper.dart';
import 'calendar_view.dart';
import 'profile_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late ConnectionHelper _connectionHelper;

  @override
  void initState() {
    super.initState();
    _connectionHelper = ConnectionHelper(context)..initialize();
  }

  @override
  void dispose() {
    _connectionHelper.dispose();
    super.dispose();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    TaskListScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Upcoming Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
