import 'package:flutter/material.dart';

import '../../maze.dart';

/// Maze Properties
class MazeProperties {
  ///Default constructor
  const MazeProperties({
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
  final BuildContext context;

  ///Background color of the maze
  final Color? backgroundColor;

  ///List of checkpoints
  final List<MazeItem> checkpoints;

  ///Columns of the maze
  final int columns;

  ///The finish image
  final MazeItem? finishImage;

  ///Height of the maze
  final double? height;

  ///A widget to show while loading all
  final Widget? loadingWidget;

  ///Callback when the player pass through a checkpoint
  final Function(int)? onCheckpoint;

  ///Callback when the player reach finish
  final Function()? onFinish;

  ///The main player
  final MazeItem player;

  ///Rows of the maze
  final int rows;

  ///Wall color
  final Color? wallColor;

  ///Wall thickness
  ///
  ///Default: 3.0
  final double? wallThickness;

  ///Width of the maze
  final double? width;
}
