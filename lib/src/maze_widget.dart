// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:ui' as ui;
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:maze/src/models/maze_properties.dart';
import 'package:universal_io/io.dart';
import 'maze_painter.dart';
import 'models/item.dart';

class MazeMinigame {
  static void show(MazeProperties mazeProperties) {
    Future.delayed(
      const Duration(milliseconds: 300),
      () => showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: mazeProperties.context,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.center,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: _Maze(mazeProperties: mazeProperties),
            ),
          );
        },
      ),
    );
  }
}

///Maze
///
///Create a simple but powerfull maze game
///You can customize [mazeProperties]
class _Maze extends StatefulWidget {
  ///Default constructor
  _Maze({required this.mazeProperties});
  // Maze properties
  final MazeProperties mazeProperties;

  @override
  _MazeState createState() => _MazeState();
}

class _MazeState extends State<_Maze> {
  bool _loaded = false;
  late MazePainter _mazePainter;
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  final FocusNode _focusNode = FocusNode();
  int lastKbEvent = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    setUp();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  void setUp() async {
    final playerImage = await _itemToImage(widget.mazeProperties.player);
    final checkpoints = await Future.wait(widget.mazeProperties.checkpoints
        .map((c) async => await _itemToImage(c)));
    final finishImage = widget.mazeProperties.finishImage != null
        ? await _itemToImage(widget.mazeProperties.finishImage!)
        : null;

    _mazePainter = MazePainter(
      context: context,
      checkpointsImages: checkpoints,
      columns: widget.mazeProperties.columns,
      finishImage: finishImage,
      onCheckpoint: widget.mazeProperties.onCheckpoint,
      onFinish: widget.mazeProperties.onFinish,
      playerImage: playerImage,
      rows: widget.mazeProperties.rows,
      wallColor: widget.mazeProperties.wallColor ?? Colors.black,
      wallThickness: widget.mazeProperties.wallThickness ?? 4.0,
    );
    setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.mazeProperties.backgroundColor ??
          Colors.white.withOpacity(0.8),
      child: Container(
        child: Builder(
          builder: (context) {
            if (_loaded) {
              return RawKeyboardListener(
                autofocus: true,
                focusNode: _focusNode,
                onKey: _handleKeyEvent,
                child: GestureDetector(
                  onVerticalDragUpdate: (info) =>
                      _mazePainter.updatePosition(info.localPosition, null),
                  child: CustomPaint(
                    painter: _mazePainter,
                    size: Size(widget.mazeProperties.width ?? context.width,
                        widget.mazeProperties.height ?? context.height),
                  ),
                ),
              );
            } else {
              if (widget.mazeProperties.loadingWidget != null) {
                return widget.mazeProperties.loadingWidget!;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<ui.Image> _itemToImage(MazeItem item) {
    switch (item.type) {
      case ImageType.file:
        return _fileToByte(item.path);
      case ImageType.network:
        return _networkToByte(item.path);
      default:
        return _assetToByte(item.path);
    }
  }

  ///Creates a Image from file
  Future<ui.Image> _fileToByte(String path) async {
    final completer = Completer<ui.Image>();
    final bytes = await File(path).readAsBytes();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  ///Creates a Image from asset
  Future<ui.Image> _assetToByte(String asset) async {
    final completer = Completer<ui.Image>();
    final bytes = await rootBundle.load(asset);
    ui.decodeImageFromList(bytes.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  ///Creates a Image from network
  Future<ui.Image> _networkToByte(String url) async {
    final completer = Completer<ui.Image>();
    final response = await http.get(Uri.parse(url));
    ui.decodeImageFromList(
        response.bodyBytes.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  void _handleKeyEvent(RawKeyEvent event) {
    final currentKbEvent = DateTime.now().millisecondsSinceEpoch;
    final allowKbEvent = (currentKbEvent - lastKbEvent) > 150;

    if (allowKbEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyA ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _mazePainter.updatePosition(Offset.zero, Direction.left);
      } else if (event.logicalKey == LogicalKeyboardKey.keyW ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _mazePainter.updatePosition(Offset.zero, Direction.up);
      } else if (event.logicalKey == LogicalKeyboardKey.keyD ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _mazePainter.updatePosition(Offset.zero, Direction.right);
      } else if (event.logicalKey == LogicalKeyboardKey.keyS ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _mazePainter.updatePosition(Offset.zero, Direction.down);
      }

      lastKbEvent = currentKbEvent;
    }
  }
}

///Extension to get screen size
extension ScreenSizeExtension on BuildContext {
  ///Gets the current height
  double get height => MediaQuery.of(this).size.height;

  ///Gets the current width
  double get width => MediaQuery.of(this).size.width;
}
