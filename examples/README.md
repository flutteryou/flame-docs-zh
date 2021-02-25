# 例子学习知识

* Game 对应的 Widget 叫 `GameWidget`，可以嵌入到 Flutter Widgets 中使用。

```dart
return Scaffold(
  body: GameWidget<ExampleGame>(
    game: _myGame,
    overlayBuilderMap: {
      'PauseMenu': pauseMenuBuilder,
    },
    initialActiveOverlays: const ['PauseMenu'],
  );
);
```

---

* render 方法中可以 new Paint ，Android 的 onDraw 是不建议这么做的。

```dart
@override
void render(Canvas canvas) {
  canvas.drawRect(
    const Rect.fromLTWH(100, 100, 100, 100),
    Paint()..color = BasicPalette.white.color,
  );
}
```

---

* WidgetsFlutterBinding.ensureInitialized(); 有什么用

main 方法的第一行会调用。

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final game = MyGame();
  runApp(
    GameWidget(
      game: game,
    ),
  );
}
```

---

* `BaseGame` 类与 `Game` 到底有什么区别？

---

* 游戏开发中的 Sprite 是图片的一部分

这段代码写得很 6，特别是最后那个 `.forEach(add)`。

```dart
class MyGame extends BaseGame {
  @override
  Future<void> onLoad() async {
    final r = Random();
    final image = await images.load('test.png');
    List.generate(
      500,
      (i) => SpriteComponent(
        position: Vector2(
          r.nextInt(size.x.toInt()).toDouble(),
          r.nextInt(size.x.toInt()).toDouble(),
        ),
        size: Vector2.all(32),
        sprite: Sprite(image),
      ),
    ).forEach(add);
  }
}
```


