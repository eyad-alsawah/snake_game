import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game/core/enums.dart';
import 'package:snake_game/presentation/logic/game_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/presentation/logic/update_view_bloc.dart';
import 'package:snake_game/presentation/views/drawer.dart';

class GameView extends StatefulWidget {
  const GameView({
    Key? key,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late GameController gameController;
  late UpdateViewCubit updateViewCubit;

  late double cellSize;
  late int squaresCount;
  final int numberOfSquaresHorizontally = 30;
  final double screenWidth = 1.sw;
  final double screenHeight = 0.75.sh;

  @override
  void initState() {
    updateViewCubit = UpdateViewCubit([]);

    // Calculate the cell size based on the screen width and the number of squares horizontally
    cellSize = screenWidth / numberOfSquaresHorizontally;

    // Calculate the number of squares vertically based on the screen height and the calculated cell size
    int numberOfSquaresVertically = (screenHeight / cellSize).floor();

    // Adjust the grid item count to fill the entire height
    squaresCount = numberOfSquaresHorizontally * numberOfSquaresVertically;

    gameController = GameController(
      refreshRate: 10,
      snakeLength: 4,
      updateView: () =>
          updateViewCubit.updateView(gameController.activeIndices),
      redrawView: () {
        updateViewCubit.updateView([]);
        setState(() {});
      },
      numberOfSquaresHorizontally: numberOfSquaresHorizontally,
      itemsCount: squaresCount,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Snake'),
        backgroundColor: const Color(0xFF9FC304),
      ),
      backgroundColor: const Color(0xFF9FC304),
      drawer: GameDrawer(
        onEatAllFood: () => gameController.eatAllFood(),
        onResetGame: () => gameController.resetGame(),
        onChangeRefreshRate: (newValue) =>
            gameController.changeRefreshRate(newValue.ceil()),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: squaresCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberOfSquaresHorizontally,
                childAspectRatio: 1, // Ensure square cells
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => gameController.handleInput(index),
                  child: BlocConsumer<UpdateViewCubit, List<int>>(
                    bloc: updateViewCubit,
                    listener: ((context, state) {}),
                    buildWhen: (previous, current) =>
                        previous.isEmpty ||
                        previous.contains(index) ||
                        current.contains(index),
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: gameController.getSnakeColor(index: index),
                          border: Border.all(
                              color: const Color(0xFF9FC304), width: 0.5),
                        ),
                        width: cellSize,
                        height: cellSize,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Center(
            child: InkWell(
              onTap: () => gameController.changeDirection(Direction.up),
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 76, 83, 68),
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: const Color(0xFF8EB605),
                  size: 40.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                focusColor:   const Color(0xFF8EB605),
                onTap: () => gameController.changeDirection(Direction.left),
                child: Ink(
                
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 76, 83, 68),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF8EB605),
                    size: 40.w,
                  ),
                ),
              ),
              SizedBox(width: 25.w),
              InkWell(
                onTap: () => gameController.changeDirection(Direction.down),
                child: Ink(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 76, 83, 68),
                  ),
                  child: Icon(
                    Icons.arrow_downward,
                    color: const Color(0xFF8EB605),
                    size: 40.w,
                  ),
                ),
              ),
              SizedBox(width: 25.w),
              InkWell(
                onTap: () => gameController.changeDirection(Direction.right),
                child: Ink(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 76, 83, 68),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF8EB605),
                    size: 40.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
