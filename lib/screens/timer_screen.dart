import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_desk_assistant_new/services/settings_service.dart';

// Enum to represent the current timer mode
enum TimerMode { work, breakTime }

// Enum for the state of the timer
enum TimerState { initial, running, paused }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  TimerMode _currentMode = TimerMode.work;
  TimerState _timerState = TimerState.initial;

  @override
  void initState() {
    super.initState();
    // Initialize the timer with the work duration from settings when the screen is first built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer when the widget is removed.
    super.dispose();
  }

  /// Starts or resumes the countdown timer.
  void _startTimer() {
    if (_timerState == TimerState.running) return;

    setState(() {
      _timerState = TimerState.running;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // When the timer hits zero, switch modes and reset.
        _switchMode();
      }
    });
  }

  /// Pauses the currently running timer.
  void _pauseTimer() {
    if (_timerState != TimerState.running) return;
    _timer?.cancel();
    setState(() {
      _timerState = TimerState.paused;
    });
  }

  /// Resets the timer to its initial state for the current mode.
  void _resetTimer() {
    _timer?.cancel();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      _remainingSeconds = (_currentMode == TimerMode.work
          ? settings.workDuration
          : settings.breakDuration) *
          60;
      _timerState = TimerState.initial;
    });
  }

  /// Switches the timer between Work and Break modes.
  void _switchMode() {
    _timer?.cancel();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      _currentMode =
      _currentMode == TimerMode.work ? TimerMode.breakTime : TimerMode.work;
      _remainingSeconds = (_currentMode == TimerMode.work
          ? settings.workDuration
          : settings.breakDuration) *
          60;
      _timerState = TimerState.initial;
    });
    // Optional: Auto-start the next timer session
    _startTimer();
  }

  // --- UI Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work/Break Timer"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background,
              const Color(0xFF1c2a3f),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerDisplay(),
            const SizedBox(height: 60),
            _buildTimerControls(),
          ],
        ),
      ),
    );
  }

  /// Builds the circular timer display.
  Widget _buildTimerDisplay() {
    // Format the remaining time into MM:SS string.
    final String minutes =
    (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final String seconds =
    (_remainingSeconds % 60).toString().padLeft(2, '0');
    final bool isWork = _currentMode == TimerMode.work;

    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: (isWork ? Colors.cyan : Colors.amber).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isWork ? "Work Session" : "Break Time",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: isWork ? Colors.cyan.shade200 : Colors.amber.shade200,
              ),
            ),
            Text(
              "$minutes:$seconds",
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Start/Pause/Reset control buttons.
  Widget _buildTimerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        IconButton(
          icon: const Icon(Icons.refresh, size: 32),
          onPressed: _resetTimer,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 20),
        // Start/Pause Floating Action Button
        SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: _timerState == TimerState.running ? _pauseTimer : _startTimer,
            child: Icon(
              _timerState == TimerState.running ? Icons.pause : Icons.play_arrow,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Skip/Switch Mode Button
        IconButton(
          icon: const Icon(Icons.skip_next, size: 32),
          onPressed: _switchMode,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}
