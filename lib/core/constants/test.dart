import 'dart:async';
import 'package:flutter/material.dart';

class Asset3DTimer extends StatefulWidget {
  final int initialSeconds;
  const Asset3DTimer({Key? key, this.initialSeconds = 5}) : super(key: key);

  @override
  _Asset3DTimerState createState() => _Asset3DTimerState();
}

class _Asset3DTimerState extends State<Asset3DTimer> {
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatted = _timeLeft.toString().padLeft(2, '0');
    String digit1 = formatted[0]; // e.g. "0"
    String digit2 = formatted[1]; // e.g. "5"

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/numbers/$digit1.png', height: 120),
        const SizedBox(width: 4),
        Image.asset('assets/numbers/$digit2.png', height: 120),
      ],
    );
  }
}