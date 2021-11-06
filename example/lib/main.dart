import 'package:flutter/material.dart';
import 'package:maze/maze.dart';

void main() => runApp(MazeApp());

class MazeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Maze Demo',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: Colors.blueGrey),
        home: MazeScreen());
  }
}

class MazeScreen extends StatefulWidget {
  @override
  _MazeScreenState createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            child: Text('Show Maze'),
            onPressed: () => MazeMinigame.show(
              MazeProperties(
                context: context,
                player: MazeItem(
                    'https://image.flaticon.com/icons/png/512/808/808433.png',
                    ImageType.network),
                finishImage: MazeItem(
                    'https://image.flaticon.com/icons/png/512/1506/1506339.png',
                    ImageType.network),
                onFinish: () => print('Hi from finish line!'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
