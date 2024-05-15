import 'package:flutter/material.dart';
import 'package:snake_game/presentation/logic/game_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/presentation/logic/update_view_bloc.dart';

class GameView extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final int numberOfSquaresHorizontally;

  const GameView({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.numberOfSquaresHorizontally,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late GameController gameController;
  late UpdateViewCubit updateViewCubit;

  late double cellSize;
  late int squaresCount;

  @override
  void initState() {
    updateViewCubit = UpdateViewCubit([]);

    // Calculate the cell size based on the screen width and the number of squares horizontally
    cellSize = widget.screenWidth / widget.numberOfSquaresHorizontally;

    // Calculate the number of squares vertically based on the screen height and the calculated cell size
    int numberOfSquaresVertically = (widget.screenHeight / cellSize).floor();

    // Adjust the grid item count to fill the entire height
    squaresCount =
        widget.numberOfSquaresHorizontally * numberOfSquaresVertically;

    gameController = GameController(
      foodCount: 50,
      refreshRate: 20,
      snakeLength: 5,
      updateView: () =>
          updateViewCubit.updateView(gameController.activeIndices),
      numberOfSquaresHorizontally: widget.numberOfSquaresHorizontally,
      itemsCount: squaresCount,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: squaresCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.numberOfSquaresHorizontally,
          childAspectRatio: 1, // Ensure square cells
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
                    border:
                        Border.all(color: const Color(0xFF9FC304), width: 0.5),
                  ),
                  width: cellSize,
                  height: cellSize,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
