import 'dart:async';
import 'package:flutter/material.dart';

class BookTimer extends StatefulWidget {
  final Function(bool)? onRunning;
  final Function(Duration)? onPause;

  const BookTimer({super.key, this.onRunning, this.onPause});

  @override
  State<BookTimer> createState() => _BookTimerState();
}

class _BookTimerState extends State<BookTimer> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  DateTime? _startTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _startTime = DateTime.now().subtract(Duration(seconds: _elapsedSeconds));
    _isRunning = true;
    widget.onRunning?.call(_isRunning);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
      });
    });
  }

  void _pauseTimer() {
    _timer!.cancel();
    setState(() {
      _isRunning = false;
    });
    widget.onRunning?.call(_isRunning);
    widget.onPause?.call(Duration(seconds: _elapsedSeconds));
  }

  void _resetTimer() {
    _timer!.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
      _startTime = null;
    });
    widget.onRunning?.call(_isRunning);
    widget.onPause?.call(Duration(seconds: _elapsedSeconds));
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(_elapsedSeconds),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                child: Text(
                  _isRunning ? "Pausar" : "Iniciar",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text(
                  "Limpiar",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
