import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:async';
class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeString = DateFormat('HH:mm:ss').format(_currentTime);
    String dateString = DateFormat('EEEE, d MMM').format(_currentTime);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () {},
          child: const Text(
            "Sửa",
            style: TextStyle(color: Colors.orange, fontSize: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.orange),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giờ Quốc tế',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hà Nội", style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text("Hôm nay, +07:00", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeString.substring(0, 5),
                      style: const TextStyle(color: Colors.white, fontSize: 38),
                    ),
                    Text(
                      dateString,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: ClockPainter(_currentTime),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final fillBrush = Paint()..color = Colors.grey[900]!;
    final outlineBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final centerDotBrush = Paint()..color = Colors.white;

    final secHandBrush = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final minHandBrush = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final hourHandBrush = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, fillBrush);
    canvas.drawCircle(center, radius, outlineBrush);

    final hourX = center.dx + radius * 0.4 * cos((time.hour % 12 + time.minute / 60) * 30 * pi / 180 - pi / 2);
    final hourY = center.dy + radius * 0.4 * sin((time.hour % 12 + time.minute / 60) * 30 * pi / 180 - pi / 2);
    canvas.drawLine(center, Offset(hourX, hourY), hourHandBrush);

    final minX = center.dx + radius * 0.6 * cos(time.minute * 6 * pi / 180 - pi / 2);
    final minY = center.dy + radius * 0.6 * sin(time.minute * 6 * pi / 180 - pi / 2);
    canvas.drawLine(center, Offset(minX, minY), minHandBrush);

    final secX = center.dx + radius * 0.7 * cos(time.second * 6 * pi / 180 - pi / 2);
    final secY = center.dy + radius * 0.7 * sin(time.second * 6 * pi / 180 - pi / 2);
    canvas.drawLine(center, Offset(secX, secY), secHandBrush);

    canvas.drawCircle(center, 5, centerDotBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}