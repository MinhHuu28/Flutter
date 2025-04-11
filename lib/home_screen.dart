import 'package:flutter/material.dart';
import 'clock_page.dart';
import 'alarm_page.dart';
import 'timer_page.dart';
import 'stopwatch_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ClockPage(),
    const AlarmPage(),
     TimerPage(),
    CountdownTimerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Minh Hữu-Minh Hoàng",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'Giờ Quốc tế',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Báo thức',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Bấm giờ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
            label: 'Hẹn giờ',
          ),
        ],
      ),
    );
  }
}
