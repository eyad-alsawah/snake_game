import 'package:flutter/material.dart';

class GameDrawer extends StatelessWidget {
  final VoidCallback onResetGame;
  final VoidCallback onEatAllFood;
  final ValueChanged<double> onChangeRefreshRate;

  GameDrawer({
    Key? key,
    required this.onEatAllFood,
    required this.onResetGame,
    required this.onChangeRefreshRate,
  }) : super(key: key);

  final ValueNotifier<double> refreshRateValueListenable = ValueNotifier<double>(10);

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
            child: Center(
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
            onTap: onEatAllFood,
          ),
          ListTile(
            leading: const Icon(Icons.replay),
            title: const Text('Reset Game'),
            onTap: onResetGame,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refresh Rate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: refreshRateValueListenable,
                  builder: (context, value, child) => Slider(
                     thumbColor: Colors.green,
                     activeColor: Colors.greenAccent,
                    min: 1,
                    max: 300,
                    value: value,
                    divisions: 99,
                    label: value.toStringAsFixed(1),
                    onChanged: (newValue) {
                      refreshRateValueListenable.value = newValue;
                      onChangeRefreshRate(newValue);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
