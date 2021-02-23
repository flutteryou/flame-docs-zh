# 组件（Component）

## Component

所有的组件继承自抽象类 `Component`。

每个 `Component` 定义的一些方法，可供开发者有选择地实现它们，这些方法会被 `BaseGame` 用到。如果没有使用 `BaseGame` ，可以直接在自实现的游戏循环（game loop）中直接使用这些方法。

* `resize` 的调用发生在屏幕大小发生变化时，以及组件通过 `add` 方法被添加时，不过这种情况下，`resize` 方法只在一开始被调用一次。
* `shouldRemove` 方法可以被覆写，也可以被设置为 `true` ，`BaseGame` 会在下一个更新循环之前删除这个组件。之后，这个组件将不再被渲染或者更新。 
  * > 注意 `game.remove(Component c)` 也可以用来删除组件。
* `isHUB` 可以被覆写或者设置为 `true`（默认为 `false`），这样一来，`BaseGame` 会为这个元素忽视 `camera`，make it static in relation to the screen that is.
  * > TODO 这句暂时不理解
* `onMount` 方法可以被覆写来运行组件的初始化代码。当这个方法被调用时，`BaseGame` 会确保所有可能改变这个组件行为的 mixins 已经准备就绪（resolved）。
* `onRemove` 方法可以被覆写，覆写的代码运行在组件被从 game 中移除之前，而且只会运行一次，即使组件既被 `BaseGame` 的 remove 方法以及 `Component` 的 remove 方法移除。
* `onLoad` 方法可以被覆写来运行组件的异步初始化代码，比如加载图片。这个方法运行在组件的初始化“准备”之后，这就意味着该方法执行在 `onMount` 之后，组件被添加到 `BaseGame` 的组件列表之前。

## BaseComponent

通常，如果想定义自己的组件，可以继承 `PositionComponent`，但是如果除了控制效果（effect）和子组件之外还想控制位置（positioning），可以继承 `BaseComponent`。

在 Forge2D 中使用 `SpriteBodyComponent` 和 `BodyComponent`，因为这些组件的位置与屏幕（screen）无关，而与 **Forge2D** 有关。

## 组件聚合

有时候，我们需要用一个组件来嵌套其他的组件。比如用一个 hierarchy 分组可视化组件。我们可以通过为任何一个继承自 `BaseComponent` 的组件添加子组件来实现这个目的，比如 `PositionComponent` 和 `BodyComponent`。当一个组件拥有子组件时，每当父组件被更新或渲染时，所有的子组件也会在同样的条件下被渲染和更新。

用法举例，两个组件的可视化通过一个 wrapper 来控制：

```dart
class GameOverPanel extends PositionComponent with HasGameRef<MyGame> {
  bool visible = false; 
  GameOverText gameOverText;
  GameOverButon gameOverButton;

  GameOverPanel(Image spriteImage) : super() {
    gameOverText = GameOverText(spriteImage); // GameOverText is a Component
    gameOverButton = GameOverButton(spriteImage); // GameOverRestart is a SpriteComponent

    addChild(gameRef, gameOverText);
    addChild(gameRef, gameOverButton);
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      super.render(canvas);
    }
  }
}
```

## PositionComponent

这个类用来表示屏幕的一个物体，一个浮动的举行或一个旋转的精灵。

`PositionComponent` 有 `position`，`size` 和 `angle`，以及其他有用的方法，比如 `distance` 和 `angleBetween`。

