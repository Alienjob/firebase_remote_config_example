import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';

class PortaLeftComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('porta left.png');
    add(RectangleHitbox());

    return super.onLoad();
  }
}

extension PlayerOneX on SoccerGame {
  void buildPortaLeft(double height) {
    add(PortaLeftComponent()
      ..size = Vector2(height, height * 2)
      ..position = Vector2(height, size.y - height));
  }
}
