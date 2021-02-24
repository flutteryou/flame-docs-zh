# 粒子

```dart
var rund = Random();

class GlitchParticle extends Particle with SingleChildParticle {
  @override
  Particle child;

  GlitchParticle(
    @required this.child,
    double lifespan,
  ) : super(lifespan: lifespan);

  @override
  render(Canvas canvas) {
    canvas.save();
    canvas.translate(rnd.nextDouble() * 100, rnd.nextDouble() * 100);
    super.render();
    canvas.restore();
  }
}
```
