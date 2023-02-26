import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';

import 'enums.dart';
import 'methods.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> activeIndices = List.generate(10, (index) => index);
  Timer timer = Timer.periodic(const Duration(seconds: 1), (_) {});

  int crossAxisCount = 20;
  int itemsCount = 34 * 20; //65 row recommended

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: itemsCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    timer.cancel();
                    Direction direction = getDirectionFromTapPosition(
                        pressedIndex: index,
                        itemsCount: itemsCount,
                        crossAxisCount: crossAxisCount,
                        headIndex: activeIndices.last,
                        activeIndices: activeIndices);
                    timer = Timer.periodic(const Duration(milliseconds: 100),
                        (timer) {
                      changeDirection(
                          direction: direction,
                          activeIndices: activeIndices,
                          crossAxisCount: crossAxisCount,
                          headIndex: activeIndices.last,
                          pressedIndex: index,
                          itemsCount: itemsCount);
                      bool didCollide = didReachEdge(
                          direction: direction,
                          crossAxisCount: crossAxisCount,
                          activeIndices: activeIndices,
                          itemCounts: itemsCount);
                      didCollide
                          ? activeIndices = [
                              -9,
                              -8,
                              -7,
                              -6,
                              -5,
                              -4,
                              -3,
                              -2,
                              -1,
                              0
                            ]
                          : null;
                      setState(() {});
                    });

                    // setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: getSnakeColor(
                            activeIndices: activeIndices, index: index),
                        border: Border.all(
                            color: const Color(0xFF9FC304), width: 1)),
                    width: 10,
                    height: 10,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
