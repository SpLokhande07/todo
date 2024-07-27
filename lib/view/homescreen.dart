import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_noorisys/pod/profile_pod.dart';
import 'package:todo_noorisys/view/task_view.dart';
import 'calendar_view.dart';
import 'profile_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final profileNotifier = ref.read(profileProvider.notifier);
    profileNotifier.loadProfile();
  }

  @override
  void dispose() {
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
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Upcoming Tasks',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Consumer(builder: (context, ref, widget) {
              return CircleAvatar(
                radius: 15,
                backgroundImage: ref.watch(profileProvider).profileImageUrl !=
                        null
                    ? NetworkImage(ref.watch(profileProvider).profileImageUrl!)
                    : null,
                child: ref.watch(profileProvider).profileImageUrl == null
                    ? const Icon(Icons.person)
                    : null,
              );
            }),
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
