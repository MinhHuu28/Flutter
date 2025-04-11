import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Map<String, dynamic>> alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();

    // Kiểm tra báo thức mỗi 10 giây
    Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      final currentTime = formatTime(now);
      for (var alarm in alarms) {
        if (alarm['enabled'] && alarm['time'] == currentTime) {
          triggerAlarm();
        }
      }
    });
  }

  void triggerAlarm() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = alarms.map((alarm) => jsonEncode(alarm)).toList();
    await prefs.setStringList('alarms', alarmList);
  }

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = prefs.getStringList('alarms') ?? [];
    setState(() {
      alarms = alarmList.map((e) => jsonDecode(e)).toList().cast<Map<String, dynamic>>();
    });
  }

  String formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _addAlarm() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.black,
              hourMinuteTextColor: Colors.white,
              dialHandColor: Colors.orange,
              entryModeIconColor: Colors.orange,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final pickedDateTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final formattedTime = formatTime(pickedDateTime);
      setState(() {
        alarms.add({"time": formattedTime, "enabled": true});
      });
      saveAlarms();
    }
  }

  void _toggleAlarm(int index, bool value) {
    setState(() {
      alarms[index]['enabled'] = value;
    });
    saveAlarms();
  }

  void _removeAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
    saveAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () {},
          child: const Text("Sửa", style: TextStyle(color: Colors.orange, fontSize: 16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.orange),
            onPressed: _addAlarm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Báo thức',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.bedtime, color: Colors.white),
              title: const Text("Ngủ | Thức dậy", style: TextStyle(color: Colors.white)),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("THIẾT LẬP"),
              ),
            ),
            const Divider(color: Colors.white24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text("Khác", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  var alarm = alarms[index];
                  return Dismissible(
                    key: Key(alarm['time']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeAlarm(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã xóa báo thức")),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: SwitchListTile(
                      value: alarm['enabled'],
                      onChanged: (val) => _toggleAlarm(index, val),
                      title: Text(
                        alarm['time'],
                        style: TextStyle(
                          fontSize: 36,
                          color: alarm['enabled'] ? Colors.white : Colors.white.withOpacity(0.4),
                        ),
                      ),
                      subtitle: const Text("Báo thức", style: TextStyle(color: Colors.grey)),
                      activeColor: Colors.orange,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
