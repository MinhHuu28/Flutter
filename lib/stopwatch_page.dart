import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimerPage extends StatefulWidget {
  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState();
}

class _CountdownTimerPageState extends State<CountdownTimerPage> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  Duration? remainingDuration;
  Timer? timer;
  bool isRunning = false;
  List<Duration> history = [];

  void startTimer() {
    final totalDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
    if (totalDuration.inSeconds == 0) return;

    setState(() {
      remainingDuration = totalDuration;
      isRunning = true;
      history.insert(0, totalDuration); // Lưu vào đầu danh sách
    });

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingDuration!.inSeconds > 0) {
        setState(() {
          remainingDuration = remainingDuration! - Duration(seconds: 1);
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingDuration = null;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:"
        "${twoDigits(duration.inMinutes % 60)}:"
        "${twoDigits(duration.inSeconds % 60)}";
  }

  Widget _buildPicker(int itemCount, int selectedValue, void Function(int) onSelectedItemChanged, String unit) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: selectedValue),
        itemExtent: 40,
        onSelectedItemChanged: onSelectedItemChanged,
        backgroundColor: Colors.black,
        children: List.generate(itemCount, (index) {
          return Center(
            child: Text(
              "$index $unit",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("Hẹn giờ", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            if (!isRunning)
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    _buildPicker(24, hours, (value) => setState(() => hours = value), "giờ"),
                    _buildPicker(60, minutes, (value) => setState(() => minutes = value), "phút"),
                    _buildPicker(60, seconds, (value) => setState(() => seconds = value), "giây"),
                  ],
                ),
              )
            else if (remainingDuration != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  formatDuration(remainingDuration!),
                  style: TextStyle(color: Colors.white, fontSize: 48),
                ),
              ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: isRunning ? stopTimer : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRunning ? Colors.grey.shade800 : Colors.grey.shade900,
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text("Huỷ", style: TextStyle(color: Colors.white)),
                  ),
                ),
                GestureDetector(
                  onTap: isRunning ? null : startTimer,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRunning ? Colors.green.shade900 : Colors.green,
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text("Bắt đầu", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
            Divider(color: Colors.white24),

            /// Gần đây (Lịch sử)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text("Gần đây", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  if (history.isEmpty)
                    Text("Chưa có hẹn giờ nào", style: TextStyle(color: Colors.white38))
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final duration = history[index];
                          return ListTile(
                            title: Text(
                              formatDuration(duration),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            subtitle: Text(
                              "${duration.inHours} giờ, ${duration.inMinutes % 60} phút",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
