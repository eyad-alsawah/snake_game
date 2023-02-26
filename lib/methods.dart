import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'enums.dart';
import 'dart:math';

void moveLeft(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount}) {
  int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
  if (!activeIndices.contains(lastItem - 1)) {
    activeIndices.add(lastItem - 1);
    (activeIndices.isNotEmpty && activeIndices.length != 1)
        ? activeIndices.removeAt(0)
        : null;
    // didReachEdge(
    //     direction: Direction.left,
    //     crossAxisCount: crossAxisCount,
    //     activeIndices: activeIndices,
    //     itemCounts: itemsCount);
  }
}

// Direction getTapPositionRelativeToHead(
//     {required int tapPosition,
//     required int headIndex,
//     required int crossAxisCount}) {
//   if (tapPosition % crossAxisCount == headIndex % crossAxisCount) {
//     // tapPosition > headIndex
//     //     ? print("should move down")
//     //     : print("should move up");
//   }
//   return Direction.up;
// }
//  required int
//  required int
// rDown + cLeft +sTLTrue => down else left
// onR +  cRight  =>  right
// onCup => up
// rUp + cLeft + StlTrue=> up else left
// rUp + cRight  + StlTrue => up else right
// onR + cLeft => left
// onCdown => down
//------------------------------------
//  required int
//  required int
//
//  required int
//
//  required int
//  required int
Color getSnakeColor({
  required List<int> foodList,
  required int index,
  required List<int> activeIndices,
}) {
  if (index == activeIndices.last) {
    return Colors.black87;
  }
  if (foodList.contains(index)) {
    return const Color(0xFF2F342A);
  }
  return activeIndices.contains(index)
      ? const Color(0xFF2F342A)
      : const Color(0xFF8EB605);
}

//stl == second to last item in active indices list
void moveUp(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount}) {
  int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
  if (!activeIndices.contains(lastItem - crossAxisCount)) {
    activeIndices.add(lastItem - crossAxisCount);
    (activeIndices.isNotEmpty && activeIndices.length != 1)
        ? activeIndices.removeAt(0)
        : null;
    // didReachEdge(
    //     direction: Direction.up,
    //     crossAxisCount: crossAxisCount,
    //     activeIndices: activeIndices,
    //     itemCounts: itemsCount);
  }
}

void moveDown(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount}) async {
  int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
  if (!activeIndices.contains(lastItem + crossAxisCount)) {
    activeIndices.add(lastItem + crossAxisCount);
    (activeIndices.isNotEmpty && activeIndices.length != 1)
        ? activeIndices.removeAt(0)
        : null;
    // didReachEdge(
    //     direction: Direction.down,
    //     crossAxisCount: crossAxisCount,
    //     activeIndices: activeIndices,
    //     itemCounts: itemsCount);
  }
}

void moveRight(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount}) {
  // didReachEdge(
  //     direction: Direction.right,
  //     crossAxisCount: crossAxisCount,
  //     activeIndices: activeIndices,
  //     itemCounts: itemsCount);
  int lastItem = activeIndices.isEmpty ? -1 : activeIndices.last;
  if (!activeIndices.contains(lastItem + 1)) {
    activeIndices.add(lastItem + 1);
    (activeIndices.isNotEmpty && activeIndices.length != 1)
        ? activeIndices.removeAt(0)
        : null;
  }
}

void changeDirection(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemsCount,
    required int pressedIndex,
    required Direction direction,
    required int headIndex}) {
  //------------------------------
  // print("direction: $direction");
  switch (direction) {
    case Direction.up:
      moveUp(
          activeIndices: activeIndices,
          crossAxisCount: crossAxisCount,
          itemsCount: itemsCount);
      break;
    case Direction.down:
      moveDown(
          activeIndices: activeIndices,
          crossAxisCount: crossAxisCount,
          itemsCount: itemsCount);
      break;
    case Direction.left:
      moveLeft(
          activeIndices: activeIndices,
          crossAxisCount: crossAxisCount,
          itemsCount: itemsCount);
      break;
    case Direction.right:
      moveRight(
          activeIndices: activeIndices,
          crossAxisCount: crossAxisCount,
          itemsCount: itemsCount);
      break;
    default:
      break;
  }
}

bool didReachEdge(
    {required List<int> activeIndices,
    required int crossAxisCount,
    required int itemCounts,
    required Direction direction}) {
  if (direction == Direction.right &&
      ((activeIndices.last + 1) % crossAxisCount == 0)) {
    print("collided with right side");
    return true;
  } else if (direction == Direction.left &&
      ((activeIndices.last + 1) % crossAxisCount == 0)) {
    print("collided with left side");
  } else if (direction == Direction.down &&
      (activeIndices.last > (itemCounts - 1))) {
    print("collided with bottom side");
    return true;
  } else if (direction == Direction.up && (activeIndices.last < 0)) {
    print("collided with top side");
  }

  return false;

  // if (activeIndices.last > (itemCounts - 1)) {
  //   print("collided with bottom side!!");
  //   return false;
  // } else if ((activeIndices.last % crossAxisCount == 0) &&
  //     activeIndices.last < (itemCounts - 1)) {
  //   print("collided with right side");
  //   return false;
  // } else {
  //   return true;
  // }
}

//--------------------------------

RowRelativePosition getRowRelativePosition(
    {required int pressedIndex,
    required int itemsCount,
    required int crossAxisCount,
    required int headIndex,
    required List<int> activeIndices}) {
  List<int> row = [];
  int rowStart = headIndex - (headIndex % crossAxisCount);
  int rowEnd = rowStart + crossAxisCount - 1;

  if (pressedIndex > rowEnd) {
    // print("pressed down to the head row");
    return RowRelativePosition.belowRow;
  } else if (pressedIndex < rowEnd && pressedIndex < rowStart) {
    // print("pressed up to the head row");
    return RowRelativePosition.aboveRow;
  } else {
    // print("pressed on head row");
    return RowRelativePosition.onRow;
  }
}

ColumnRelativePosition getColumnRelativePosition(
    {required int pressedIndex,
    required int itemsCount,
    required int crossAxisCount,
    required int headIndex}) {
  double yAxisCount = itemsCount / crossAxisCount;
  int headColumnStart = (headIndex % crossAxisCount);
  int pressedColumnStart = (pressedIndex % crossAxisCount);

  double headColumnEnd = headColumnStart + (crossAxisCount * (yAxisCount - 1));
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
  // print("headColumnList:$headColumnList");
  // print("pressedColumnList: $pressedColumnList");
  // pressedColumnList[0] > headColumnList[0]
  //     ? print("pressed right")
  //     : print("pressed left");
  if (pressedColumnList[0] > headColumnList[0]) {
    // print("pressed right to the head column");
    return ColumnRelativePosition.rightOfColumn;
  } else if (pressedColumnList[0] < headColumnList[0]) {
    // print("pressed left to the head column");
    return ColumnRelativePosition.leftOfColumn;
  } else if (pressedIndex > headIndex) {
    // print("pressed on the head column but down ");
    return ColumnRelativePosition.onColumnBelowCenter;
  } else if (pressedIndex < headIndex) {
    // print("pressed on the head column but up ");
    return ColumnRelativePosition.onColumnAboveCenter;
  } else {
    // print("pressed on head");
    return ColumnRelativePosition.onCenter;
  }
  print("--------");
}

//--------------------------------------------------

// rDown + cRight + sTLTrue=> down else right

//  required int

// rDown/rUp/onR
// cLeft/cRight/onC-Up/onC-down
// onHead

//

Direction getDirectionFromTapPosition(
    {required int pressedIndex,
    required int itemsCount,
    required int crossAxisCount,
    required int headIndex,
    required List<int> activeIndices}) {
  Position position = getTapPositionFromRowAndColumn(
      activeIndices: activeIndices,
      headIndex: activeIndices.last,
      crossAxisCount: crossAxisCount,
      itemsCount: itemsCount,
      pressedIndex: pressedIndex);
  // print("position: $position");
  bool secondToLastOnSameRowAsLast = isSecondToLastOnSameRowAsLast(
      activeIndices: activeIndices, crossAxisCount: crossAxisCount);
  if (position == Position.southWest) {
    return secondToLastOnSameRowAsLast ? Direction.down : Direction.left;
  } else if (position == Position.east) {
    return Direction.right;
  } else if (position == Position.north) {
    return Direction.up;
  } else if (position == Position.northWest) {
    return secondToLastOnSameRowAsLast ? Direction.up : Direction.left;
  } else if (position == Position.northEast) {
    return secondToLastOnSameRowAsLast ? Direction.up : Direction.right;
  } else if (position == Position.west) {
    return Direction.left;
  } else if (position == Position.southEast) {
    return secondToLastOnSameRowAsLast ? Direction.down : Direction.right;
  } else {
    /// always => Position.south
    return Direction.down;
  }
}

Position getTapPositionFromRowAndColumn(
    {required int pressedIndex,
    required int itemsCount,
    required int crossAxisCount,
    required int headIndex,
    required List<int> activeIndices}) {
  RowRelativePosition rowRelativePosition = getRowRelativePosition(
      pressedIndex: pressedIndex,
      itemsCount: itemsCount,
      crossAxisCount: crossAxisCount,
      headIndex: headIndex,
      activeIndices: activeIndices);
  ColumnRelativePosition columnRelativePosition = getColumnRelativePosition(
      pressedIndex: pressedIndex,
      itemsCount: itemsCount,
      crossAxisCount: crossAxisCount,
      headIndex: headIndex);
  // print("rowRelativePosition: $rowRelativePosition");
  // print("columnRelativePosition: $columnRelativePosition");
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

// Position getTapPosition() {}

// ---> get tap position relative to column and row --->get position --> get direction

//--------------------------------------------
bool isSecondToLastOnSameRowAsLast({
  required List<int> activeIndices,
  required int crossAxisCount,
}) {
  int secondToLastItem = getSecondToLastItemIndex(activeIndices: activeIndices);
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

List<int> spawnFood({required int itemsCount}) {
  Random random = Random();
  List<int> foodList = List.generate(
    20,
    (index) => random.nextInt(itemsCount - 1),
  );
  return foodList;
}

bool didEatFood(
    {required List<int> activeIndices, required List<int> foodList}) {
  bool didEatFood = foodList.contains(activeIndices.last);
  didEatFood ? vibrate() : null;
  return didEatFood;
}

Future<void> vibrate() async {
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate();
  }
}
