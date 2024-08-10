import 'package:flutter/material.dart';

class GameDrawer extends StatefulWidget {
  final VoidCallback onResetGame;
  final VoidCallback onEatAllFood;
  final ValueChanged<double> onChangeRefreshRate;
  final double currentRefreshRate;

  const GameDrawer({
    Key? key,
    required this.onEatAllFood,
    required this.onResetGame,
    required this.currentRefreshRate,
    required this.onChangeRefreshRate,
  }) : super(key: key);

  @override
  State<GameDrawer> createState() => _GameDrawerState();
}

class _GameDrawerState extends State<GameDrawer> {
  late ValueNotifier<double> refreshRateValueListenable;

  @override
  void initState() {
    refreshRateValueListenable =
        ValueNotifier<double>(widget.currentRefreshRate);
    print(widget.currentRefreshRate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF9FC304),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green.shade700,
            ),
            child: const Center(
              child: Text(
                'Game Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Eat All Food'),
            onTap: widget.onEatAllFood,
          ),
          ListTile(
            leading: const Icon(Icons.replay),
            title: const Text('Reset Game'),
            onTap: widget.onResetGame,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Refresh Rate',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // ValueListenableBuilder<double>(
                //   valueListenable: refreshRateValueListenable,
                //   builder: (context, value, child) => Slider(
                //     thumbColor: Colors.green,
                //     activeColor: Colors.greenAccent,
                //     min: 1,
                //     max: 300,
                //     value: value,
                //     divisions: 99,
                //     label: value.toStringAsFixed(1),
                //     onChanged: (newValue) {
                //       refreshRateValueListenable.value = newValue;
                //       widget.onChangeRefreshRate(newValue);
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
