import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../core/enums.dart';
import 'dart:math';

typedef UpdateView = void Function();

class PeriodicTimer {
  final Duration _duration;
  Timer? _timer; // Change to Timer?
  final StreamController<int> _tickController = StreamController<int>();

  PeriodicTimer(this._duration);

  Stream<int> get ticks => _tickController.stream;

  bool get isActive => _timer?.isActive ?? false; // Use null-aware operator

  void _handleTick(Timer timer) {
    _tickController.add(timer.tick);
  }

  void start() {
    if (_timer != null && _timer!.isActive) {
      return; // Check for null and isActive
    }
    _timer = Timer.periodic(_duration, _handleTick);
  }

  void cancel() {
    _timer?.cancel(); // Use null-aware operator
    _tickController.close();
  }
}

class GameController {
  final UpdateView updateView;
  final int numberOfSquaresHorizontally;
  final int itemsCount;
  final int snakeLength;
  late PeriodicTimer periodicTimer;

  //------------------------------------------
  List<int> foodList = [];
  List<int> activeIndices = [];
  //-----------------------
  Direction currentDirection = Direction.down;
  GameController(
      {required this.updateView,
      required int refreshRate,
      required this.numberOfSquaresHorizontally,
      required this.itemsCount,
      required this.snakeLength,
      required int foodCount}) {
    periodicTimer = PeriodicTimer(Duration(milliseconds: 1000 ~/ refreshRate));
    activeIndices = List.generate(snakeLength, (index) => index);
    foodList =
        List.generate(foodCount, (index) => Random().nextInt(itemsCount));
  }

  void handleInput(int index) {
    if (!periodicTimer.isActive) {
      _startGameLoop();
    } else {
      currentDirection = _getDirectionFromTapPosition(
        index,
      );
    }
  }

  void _startGameLoop() {
    periodicTimer.start();
    periodicTimer.ticks.listen((tick) {
      // todo: refactor all these methods into one
      _move();
      didReachEdge();
      if (didHitSelf()) {
        activeIndices.clear();
        activeIndices = List.generate(snakeLength, (index) => index);
      }
      didEatFood();

      updateView();
    });
  }

  void _moveUp({
    required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount,
  }) {
    int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
    activeIndices.add(lastItem - crossAxisCount);
    _maintainSnakeLength(activeIndices);
  }

  void _moveDown({
    required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount,
  }) {
    int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
    activeIndices.add(lastItem + crossAxisCount);
    _maintainSnakeLength(activeIndices);
  }

  void _moveLeft({
    required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount,
  }) {
    int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
    activeIndices.add(lastItem - 1);
    _maintainSnakeLength(activeIndices);
  }

  void _moveRight({
    required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount,
  }) {
    int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
    activeIndices.add(lastItem + 1);
    _maintainSnakeLength(activeIndices);
  }

  void _maintainSnakeLength(List<int> activeIndices) {
    if (activeIndices.length > 1) {
      activeIndices.removeAt(0);
    }
  }

  // input processing related-------------------------------------
  void _move() {
    switch (currentDirection) {
      case Direction.up:
        _moveUp(
            activeIndices: activeIndices,
            crossAxisCount: numberOfSquaresHorizontally,
            itemsCount: itemsCount);
        break;
      case Direction.down:
        _moveDown(
            activeIndices: activeIndices,
            crossAxisCount: numberOfSquaresHorizontally,
            itemsCount: itemsCount);
        break;
      case Direction.left:
        _moveLeft(
            activeIndices: activeIndices,
            crossAxisCount: numberOfSquaresHorizontally,
            itemsCount: itemsCount);
        break;
      case Direction.right:
        _moveRight(
            activeIndices: activeIndices,
            crossAxisCount: numberOfSquaresHorizontally,
            itemsCount: itemsCount);
        break;
      default:
        break;
    }
  }

  RowRelativePosition _getRowRelativePosition(
      {required int pressedIndex,
      required int itemsCount,
      required int crossAxisCount,
      required int headIndex,
      required List<int> activeIndices}) {
    int rowStart = headIndex - (headIndex % crossAxisCount);
    int rowEnd = rowStart + crossAxisCount - 1;

    if (pressedIndex > rowEnd) {
      return RowRelativePosition.belowRow;
    } else if (pressedIndex < rowEnd && pressedIndex < rowStart) {
      return RowRelativePosition.aboveRow;
    } else {
      return RowRelativePosition.onRow;
    }
  }

  ColumnRelativePosition _getColumnRelativePosition(
      {required int pressedIndex,
      required int itemsCount,
      required int crossAxisCount,
      required int headIndex}) {
    double yAxisCount = itemsCount / crossAxisCount;
    int headColumnStart = (headIndex % crossAxisCount);
    int pressedColumnStart = (pressedIndex % crossAxisCount);

    double headColumnEnd =
        headColumnStart + (crossAxisCount * (yAxisCount - 1));
    double pressedColumnEnd =
        pressedColumnStart + (crossAxisCount * (yAxisCount - 1));

    List<int> headColumnList = [];
    List<int> pressedColumnList = [];

    for (int x = 0; x < yAxisCount; x++) {
      headColumnList.add(headColumnStart + (crossAxisCount * x));
    }
    for (int x = 0; x < yAxisCount; x++) {
      pressedColumnList.add(pressedColumnStart + (crossAxisCount * x));
    }

    if (pressedColumnList[0] > headColumnList[0]) {
      return ColumnRelativePosition.rightOfColumn;
    } else if (pressedColumnList[0] < headColumnList[0]) {
      return ColumnRelativePosition.leftOfColumn;
    } else if (pressedIndex > headIndex) {
      return ColumnRelativePosition.onColumnBelowCenter;
    } else if (pressedIndex < headIndex) {
      return ColumnRelativePosition.onColumnAboveCenter;
    } else {
      return ColumnRelativePosition.onCenter;
    }
  }

  Direction _getDirectionFromTapPosition(
    int pressedIndex,
  ) {
    Direction newDirection = Direction.right;
    Position position = _getTapPositionFromRowAndColumn(
        activeIndices: activeIndices,
        headIndex: activeIndices.last,
        crossAxisCount: numberOfSquaresHorizontally,
        itemsCount: itemsCount,
        pressedIndex: pressedIndex);
    // print("position: $position");
    bool secondToLastOnSameRowAsLast = isSecondToLastOnSameRowAsLast(
        activeIndices: activeIndices,
        crossAxisCount: numberOfSquaresHorizontally);
    if (position == Position.southWest) {
      return secondToLastOnSameRowAsLast ? Direction.down : Direction.left;
    } else if (position == Position.east) {
      newDirection = Direction.right;
    } else if (position == Position.north) {
      newDirection = Direction.up;
    } else if (position == Position.northWest) {
      newDirection =
          secondToLastOnSameRowAsLast ? Direction.up : Direction.left;
    } else if (position == Position.northEast) {
      newDirection =
          secondToLastOnSameRowAsLast ? Direction.up : Direction.right;
    } else if (position == Position.west) {
      newDirection = Direction.left;
    } else if (position == Position.southEast) {
      newDirection =
          secondToLastOnSameRowAsLast ? Direction.down : Direction.right;
    } else {
      /// always => Position.south
      newDirection = Direction.down;
    }

    if (isNewDirectionTheOppositeOfThePrevious(
        newDirection: newDirection, previousDirection: currentDirection)) {
      print("returning $currentDirection");
      return currentDirection;
    } else {
      return newDirection;
    }
  }

  Position _getTapPositionFromRowAndColumn(
      {required int pressedIndex,
      required int itemsCount,
      required int crossAxisCount,
      required int headIndex,
      required List<int> activeIndices}) {
    RowRelativePosition rowRelativePosition = _getRowRelativePosition(
        pressedIndex: pressedIndex,
        itemsCount: itemsCount,
        crossAxisCount: crossAxisCount,
        headIndex: headIndex,
        activeIndices: activeIndices);
    ColumnRelativePosition columnRelativePosition = _getColumnRelativePosition(
        pressedIndex: pressedIndex,
        itemsCount: itemsCount,
        crossAxisCount: crossAxisCount,
        headIndex: headIndex);

    //---------
    //example on what we will do
    if (rowRelativePosition == RowRelativePosition.belowRow &&
        columnRelativePosition == ColumnRelativePosition.leftOfColumn) {
      return Position.southWest;
    } else if (rowRelativePosition == RowRelativePosition.onRow &&
        columnRelativePosition == ColumnRelativePosition.rightOfColumn) {
      return Position.east;
    } else if (columnRelativePosition ==
        ColumnRelativePosition.onColumnAboveCenter) {
      return Position.north;
    } else if (rowRelativePosition == RowRelativePosition.aboveRow &&
        columnRelativePosition == ColumnRelativePosition.leftOfColumn) {
      return Position.northWest;
    } else if (rowRelativePosition == RowRelativePosition.aboveRow &&
        columnRelativePosition == ColumnRelativePosition.rightOfColumn) {
      return Position.northEast;
    } else if (rowRelativePosition == RowRelativePosition.onRow &&
        columnRelativePosition == ColumnRelativePosition.leftOfColumn) {
      return Position.west;
    } else if (rowRelativePosition == RowRelativePosition.belowRow &&
        columnRelativePosition == ColumnRelativePosition.rightOfColumn) {
      return Position.southEast;
    } else {
      /// always => columnRelativePosition ==ColumnRelativePosition.onColumnBelowCenter
      return Position.south;
    }
  }

  // Collision Detection -------------------------------------------
  bool didHitSelf() {
    int headIndex = activeIndices.last;
    return activeIndices
        .sublist(0, activeIndices.length - 1)
        .contains(headIndex);
  }

  bool didReachEdge() {
    int lastItem = activeIndices.last;
    bool reachedEdge = false;

    // Check if the snake reached the right edge
    if (currentDirection == Direction.right &&
        (lastItem + 1) % numberOfSquaresHorizontally == 0) {
      activeIndices.add(lastItem - numberOfSquaresHorizontally + 1);
      reachedEdge = true;
    }
    // Check if the snake reached the left edge
    else if (currentDirection == Direction.left &&
        lastItem % numberOfSquaresHorizontally == 0) {
      activeIndices.add(lastItem + numberOfSquaresHorizontally - 1);
      reachedEdge = true;
    }
    // Check if the snake reached the bottom edge
    else if (currentDirection == Direction.down && lastItem >= itemsCount) {
      activeIndices.add(lastItem % numberOfSquaresHorizontally);
      reachedEdge = true;
    }
    // Check if the snake reached the top edge
    else if (currentDirection == Direction.up && lastItem < 0) {
      activeIndices.add(lastItem + itemsCount - numberOfSquaresHorizontally);
      reachedEdge = true;
    }

    if (reachedEdge) {
      activeIndices
          .removeAt(0); // Remove the tail to maintain the snake's length
    }

    return reachedEdge;
  }

  bool isSecondToLastOnSameRowAsLast({
    required List<int> activeIndices,
    required int crossAxisCount,
  }) {
    int secondToLastItem =
        getSecondToLastItemIndex(activeIndices: activeIndices);
    int headIndex = activeIndices.last;
    int rowStart =
        getRowStartIndex(crossAxisCount: crossAxisCount, headIndex: headIndex);
    int rowEnd =
        getRowEndIndex(crossAxisCount: crossAxisCount, rowStart: rowStart);
    return secondToLastItem < rowEnd && secondToLastItem > rowStart;
  }

  int getRowStartIndex({required int headIndex, required int crossAxisCount}) {
    int rowStart = headIndex - (headIndex % crossAxisCount);
    return rowStart;
  }

  int getRowEndIndex({required int rowStart, required int crossAxisCount}) {
    int rowEnd = rowStart + crossAxisCount - 1;
    return rowEnd;
  }

  int getSecondToLastItemIndex({required List<int> activeIndices}) {
    int secondToLastItem = activeIndices[activeIndices.length - 2];
    return secondToLastItem;
  }

  bool isNewDirectionTheOppositeOfThePrevious(
      {required Direction newDirection, required Direction previousDirection}) {
    if (newDirection == Direction.up && previousDirection == Direction.down) {
      return true;
    } else if (newDirection == Direction.down &&
        previousDirection == Direction.up) {
      return true;
    } else if (newDirection == Direction.right &&
        previousDirection == Direction.left) {
      return true;
    } else if (newDirection == Direction.left &&
        previousDirection == Direction.right) {
      return true;
    } else {
      return false;
    }
  }

  // Food related-------------------------------------
  List<int> spawnFood({required int itemsCount}) {
    Random random = Random();
    List<int> foodList = List.generate(
      20,
      (index) => random.nextInt(itemsCount - 1),
    );
    return foodList;
  }

  bool didEatFood() {
    // true when the head index is the same as the
    bool didEatFood = foodList.contains(activeIndices.last);
    if (didEatFood) {
      foodList.removeWhere((element) => element == activeIndices.last);
      activeIndices.insert(0, activeIndices.last);
    }

    didEatFood ? vibrate() : null;
    return didEatFood;
  }

  // Sound related -----------------------------------------------
  Future<void> vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }

  // UI related-----------------------------------------------
  Color getSnakeColor({
    required int index,
  }) {
    if (index == activeIndices.last) {
      return Colors.black87;
    }
    if (foodList.contains(index) && !activeIndices.contains(index)) {
      return const Color.fromARGB(255, 76, 83, 68);
    }
    return activeIndices.contains(index)
        ? const Color(0xFF2F342A)
        : const Color(0xFF8EB605);
  }
}
