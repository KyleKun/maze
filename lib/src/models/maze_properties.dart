import 'package:flutter/material.dart';

import '../../maze.dart';

/// Maze Properties
class MazeProperties {
  ///Default constructor
  MazeProperties({
    required this.context,
    required this.player,
    this.backgroundColor,
    this.checkpoints = const [],
    this.columns = 18,
    this.finishImage,
    this.height,
    this.loadingWidget,
    this.onCheckpoint,
    this.onFinish,
    this.rows = 9,
    this.wallColor = Colors.black,
    this.wallThickness = 4.0,
    this.width,
  });

  ///BuildContext
  BuildContext context;

  ///Background color of the maze
  Color? backgroundColor;

  ///List of checkpoints
  List<MazeItem> checkpoints;

  ///Columns of the maze
  int columns;

  ///The finish image
  MazeItem? finishImage;

  ///Height of the maze
  double? height;

  ///A widget to show while loading all
  Widget? loadingWidget;

  ///Callback when the player pass through a checkpoint
  Function(int)? onCheckpoint;

  ///Callback when the player reach finish
  Function()? onFinish;

  ///The main player
  MazeItem player;

  ///Rows of the maze
  int rows;

  ///Wall color
  Color? wallColor;

  ///Wall thickness
  ///
  ///Default: 3.0
  double? wallThickness;

  ///Width of the maze
  double? width;
}
