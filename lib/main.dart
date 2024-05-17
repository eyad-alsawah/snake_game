import 'package:flutter/material.dart';
import 'package:snake_game/presentation/views/game_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: false,
      splitScreenMode: false,
      child: MaterialApp(
        title: 'Snake Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameView(
        
        ),
      ),
    );
  }
}
