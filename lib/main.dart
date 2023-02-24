import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';

import 'enums.dart';
import 'methods.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  int gridCount = 10;
  List<Widget> gridChildren = [];
  Direction currentDirection = Direction.down;
  List<int> activeIndices = [300, 123, 100, 2];

  @override
  void initState() {
    gridChildren = List.generate(
        gridCount,
        (index) => Container(
              child: Text("sss"),
              width: 20,
              height: 20,
              color: Colors.grey,
            ));
    super.initState();
  }

  int crossAxisCount = 35;
  int itemsCount = 35 * 65; //65 row recommended

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
                    changeDirection(
                        activeIndices: activeIndices,
                        crossAxisCount: crossAxisCount,
                        headIndex: activeIndices.last,
                        pressedIndex: index,
                        itemsCount: itemsCount);
                    setState(() {});
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
