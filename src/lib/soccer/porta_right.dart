import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';

class PortaRightComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('porta right.png');
    add(RectangleHitbox());
    return super.onLoad();
  }
}

extension PlayerOneX on SoccerGame {
  void buildPortaRight(double height) {
    add(PortaRightComponent()
      ..size = Vector2(height, height * 2)
      ..position = Vector2(size.x - height, size.y - height));
  }
}
