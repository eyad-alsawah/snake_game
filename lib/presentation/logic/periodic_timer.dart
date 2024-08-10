import 'dart:async';

class PeriodicTimer {
  Duration _duration;
  Timer? _timer;
  StreamController<int> _tickController = StreamController<int>.broadcast();
  int _tickCount = 0;

  PeriodicTimer(this._duration);

  Stream<int> get ticks => _tickController.stream;

  bool get isActive => _timer?.isActive ?? false;

  void _handleTick() {
    _tickCount++;
    _tickController.add(_tickCount);
    _timer = Timer(_duration, _handleTick); // Schedule the next tick
  }

  void start() {
    if (_timer != null && _timer!.isActive) {
      return;
    }
    _handleTick(); // Start the ticking process
  }

  void cancel() {
    _timer?.cancel();
    if (!_tickController.isClosed) {
      _tickController.close();
    }
    _tickController = StreamController<int>.broadcast();
    _tickCount = 0; // Reset the tick count
  }

  // Method to change the duration
  void changeDuration(Duration newDuration) {
    _duration = newDuration;
    if (isActive) {
      _timer?.cancel();
      _handleTick(); // Restart the ticking process with the new duration
    }
  }

  Duration getCurrentDuration(){
    return _duration;
  }
}
