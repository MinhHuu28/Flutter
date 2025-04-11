import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/scheduler.dart';



class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  late Ticker _ticker;
  late Stopwatch _stopwatch;
  Duration _elapsed = Duration.zero;
  List<Duration> _laps = [];
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _ticker = createTicker((_) => _updateTime())..start();
  }

  void _updateTime() {
    if (_stopwatch.isRunning) {
      setState(() {
        _elapsed = _stopwatch.elapsed;
      });
    }
  }

  void _toggleStartStop() {
    setState(() {
      if (_isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
      _isRunning = !_isRunning;
    });
  }

  void _lapOrReset() {
    setState(() {
      if (_isRunning) {
        _laps.insert(0, _elapsed);
      } else {
        _stopwatch.reset();
        _elapsed = Duration.zero;
        _laps.clear();
      }
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hundredths = (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds,$hundredths';
  }

  Widget _buildCupertinoButton(String text, Color color, VoidCallback onPressed, {bool disabled = false}) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      color: color.withOpacity(disabled ? 0.05 : 0.1),
      borderRadius: BorderRadius.circular(100),
      onPressed: disabled ? null : onPressed,
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Bấm giờ', style: TextStyle(color: CupertinoColors.white)),
        backgroundColor: CupertinoColors.black,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: const TextStyle(
                      fontFamily: '.SF Pro Display',
                      fontSize: 70,
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.w400,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    child: Text(_formatDuration(_elapsed)),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCupertinoButton(
                        _isRunning ? "Vòng" : "Đặt lại",
                        CupertinoColors.systemGrey,
                        _lapOrReset,
                        disabled: !_isRunning && _elapsed == Duration.zero,
                      ),
                      _buildCupertinoButton(
                        _isRunning ? "Dừng" : "Bắt đầu",
                        _isRunning ? CupertinoColors.systemRed : CupertinoColors.activeGreen,
                        _toggleStartStop,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Danh sách vòng
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  final lap = _laps[index];
                  final lapNumber = _laps.length - index;
                  final lapTime = _formatDuration(lap);

                  // Tô màu nhanh/chậm nhất
                  Duration? fastest = _laps.isNotEmpty ? _laps.reduce((a, b) => a < b ? a : b) : null;
                  Duration? slowest = _laps.isNotEmpty ? _laps.reduce((a, b) => a > b ? a : b) : null;

                  Color textColor = CupertinoColors.white;
                  if (lap == fastest) textColor = CupertinoColors.activeGreen;
                  if (lap == slowest) textColor = CupertinoColors.systemRed;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Vòng $lapNumber', style: TextStyle(color: textColor, fontSize: 16)),
                        Text(lapTime, style: TextStyle(color: textColor, fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
