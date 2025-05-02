import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:librometro/core/services/notifications.dart';

class BookTimer extends StatefulWidget {
  final Function(bool)? onRunning;
  final Function(Duration)? onPause;
  const BookTimer({super.key, this.onRunning, this.onPause});

  @override
  State<BookTimer> createState() => _BookTimerState();
}

class _BookTimerState extends State<BookTimer> with WidgetsBindingObserver {
  late Timer _timer;
  int _elapsedSeconds = 0;
  DateTime? _startTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _startTime = DateTime.now().subtract(Duration(seconds: _elapsedSeconds));
    _isRunning = true;
    widget.onRunning?.call(_isRunning);
    _saveState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
      });
      NotificationService.showRunningNotification(_formatTime(_elapsedSeconds)); // Muestra la notificación
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
    widget.onRunning?.call(_isRunning);
    widget.onPause?.call(Duration(seconds: _elapsedSeconds));
    _saveState();
    NotificationService.cancelNotification(); // Cancela la notificación
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
      _startTime = null;
    });
    widget.onRunning?.call(_isRunning);
    widget.onPause?.call(Duration(seconds: _elapsedSeconds));
    _saveState();
    NotificationService.cancelNotification(); // Cancela la notificación
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _elapsedSeconds = prefs.getInt('elapsed') ?? 0;
      _isRunning = prefs.getBool('running') ?? false;
      widget.onRunning?.call(_isRunning);
      final startTimeMillis = prefs.getInt('startTime');
      if (startTimeMillis != null) {
        _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
      }

      if (_isRunning && _startTime != null) {
        _startTimer();
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('elapsed', _elapsedSeconds);
    await prefs.setBool('running', _isRunning);
    if (_startTime != null) {
      await prefs.setInt('startTime', _startTime!.millisecondsSinceEpoch);
    }
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
                child: Text(_isRunning ? "Pausar" : "Iniciar", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
              ),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text("Limpiar", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
