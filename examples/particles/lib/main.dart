import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/timer.dart' as flame_timer;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() async {
  final game = await loadGame();
  runApp(
    GameWidget(
      game: game,
    ),
  );
}

class MyGame extends BaseGame {
  static const gridSize = 5.0;
  static const steps = 5;

  final Random rnd = Random();
  final StepTween stepTween = StepTween(begin: 0, end: 5);
  final trafficLight = TrafficLightComponent();
  final TextConfig fpsTextConfig = TextConfig(
    color: const Color(0xFFFFFFFF),
  );

  final sceneDuration = const Duration(seconds: 1);

  Vector2 cellSize;
  Vector2 halfCellSize;

  @override
  Future<void> onLoad() async {
    await images.load('zap.png');
    await images.load('boom3.png');

    cellSize = cellSize / gridSize;
    halfCellSize = cellSize * .5;

    Timer.periodic(sceneDuration, (_) => spanParticles());
  }

  void 
}

class MyGame extends BaseGame {}

Future<BaseGame> loadGame() async {
  WidgetsFlutterBinding.ensureInitialized();
  return MyGame();
}

class TrafficLightComponent extends Component {
  final Rect rect = Rect.fromCenter(center: Offset.zero, height: 32, width: 32);
  final flame_timer.Timer colorChangeTimer = flame_timer.Timer(2, repeat: true);
  final colors = <Color>[
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  TrafficLightComponent() {
    colorChangeTimer.start();
  }

  @override
  void render(Canvas c) {
    c.drawRect(rect, Paint()..color = currentColor);
  }

  @override
  void update(double dt) {
    super.update(dt);
    colorChangeTimer.update(dt);
  }

  Color get currentColor {
    return colors[(colorChangeTimer.progress * colors.length).toInt()];
  }
}
