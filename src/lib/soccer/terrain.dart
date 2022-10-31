import 'package:flame/components.dart';
import 'package:game1/game.dart';

extension TerrainX on SoccerGame {
  void buildTerrain(double height) {
    double current = 0;
    while (current <= size.x) {
      add(TerrainComponent()
        ..size = Vector2(height, height)
        ..position = Vector2(current, size.y));
      current += height;
    }
  }
}

class TerrainComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('terreno.png');
    return super.onLoad();
  }
}
