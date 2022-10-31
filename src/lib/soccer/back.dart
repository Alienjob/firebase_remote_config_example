import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';

extension BackX on SoccerGame {
  void buildBack() {
    add(BackComponent()..size = size);
  }
}

class BackComponent extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('back.png');
    return super.onLoad();
  }
}
