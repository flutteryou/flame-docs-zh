## 图片

如果使用了 Component 模块并且操作比较简单，可能根本用不到之前提到的一些类。使用 `SpriteComponent` 和 `AnimationComponent` 就够了。

首先要创建配套的文件结构，然后把文件路径添加到 `pubspect.yaml` 中。

```yaml
flutter:
  assets:
    - assets/image/player.png
    - assets/image/enemy.png
```

必须为 PNG 文件，可以有透明色。

### 加载图片

Flame 提供了一个工具类 - `Images`，它可以轻松地从 assets 目录中加载图片然后将其缓存到内存中。

Flutter 有很多与图片相关的类型，正确地把本地资源转换成可以绘制在 Canvas 上的图片就显得有些繁琐(convoluted)。而借助 `Image` 类的 `drawImageRect` 方法则可以轻松地获取一个可以绘制在 Canvas 上的图片。

它会自动缓存任何基于文件名加载出来的图片，所以多次调用也没关系。

加载到已经清除缓存的方法包括：`load`、`loadAll`、`clear`、以及 `clearAll`。返回值是 `Future` 类型。

同步方式获取一个之前已经缓存过的图片，可以用 `frameCache` 方法。如果图片并没有提前加载，那么会抛出异常。

#### 独立使用

手动使用之前需要先执行初始化。

```dart
import `package:flame/imaged.dart`;
final imageLoader = Images();
Image image = await imagesLoader.load('asd');
```

但是 Flame 也提供了两种无需初始化的使用方式。

#### Flame.images

这是一个由 `Flame` 类提供的单例，可用做全局图片的缓存。

```dart
import 'package:flame/flame.dart'

// inside an async context
Image image = await Flame.images.load('player.png');

final playerSprite = Sprite(image);

```

#### Game.images

`Game` 类也提供处理图片加载的工具类。它内置了一个 `Image` 类的实例，可用于加载游戏所需的图片资源。当图片组件被从组件树移除后，`Game` 会自动释放缓存。

`Game` 类的 `onLoad` 方式是初始资源加载的绝佳之地。

```dart
class MyGame extends Game {

  Sprite player;

  Future<void> onLoad() async {
    final playerImage = await images.load('player.png');
    player = Sprite(playerImage);
  }
}
```

已经加载过的资源也可以在游戏运行中重复获取，使用 `images.fromCache` 方法：

```dart
class MyGame extends Game {
  
  // attributes omitted

  @override
  Future<void> onLoad() async { 
    // other loads omitted
    await images.load('bullet.png');
  }

  void shoot() {
    _shoots.add(Sprite(images.fromCache('bullet.png')))
  }
}
```

### Sprite

Flame 用 `Sprite` 类来表示图像的一部分（或全部）。

创建 `Sprite` 时可以提供一个 `Image` 以及定义了图片一部分的坐标。

例如，下面的代码创建了一个表示整个图片的 sprite，并且会自动触发加载：

```dart
final image = await loadImage();
Sprite player = Sprite(image);
```

也可以在 sprite 所在的原始图片上指定坐标。这样可以使用 sprite sheets 并且减少内存中的图片数量：

```dart
final image = await loadImage();
final playerFrame = Sprite(
  image,
  srcPosition: Vector2(32.0, 0),
  srcSize: Vector2(16.0, 16.0),
);
```


