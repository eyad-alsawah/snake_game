import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game/presentation/logic/game_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/presentation/logic/update_view_bloc.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Timer timer = Timer.periodic(const Duration(seconds: 1), (_) {});
  late GameController gameController;
  late UpdateViewCubit updateViewCubit;

  int crossAxisCount = 20;
  int itemsCount = 34 * 20; //65 row recommended

  @override
  void initState() {
    updateViewCubit = UpdateViewCubit([]);
    gameController = GameController(
        foodCount: 40,
        refreshRate: 30,
        snakeLength: 10,
        updateView: () =>
            updateViewCubit.updateView(gameController.activeIndices),
        crossAxisCount: crossAxisCount,
        itemsCount: itemsCount);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: itemsCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          itemBuilder: (context, index) {
            return BlocConsumer<UpdateViewCubit, List<int>>(
              bloc: updateViewCubit,
              listener: ((context, state) {}),
              buildWhen: (previous, current) =>
                  previous.isEmpty ||
                  previous.contains(index) ||
                  current.contains(index),
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => gameController.handleInput(index),
                  child: Container(
                    decoration: BoxDecoration(
                        color: gameController.getSnakeColor(index: index),
                        border: Border.all(
                            color: const Color(0xFF9FC304), width: 1)),
                    width: 10,
                    height: 10,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
