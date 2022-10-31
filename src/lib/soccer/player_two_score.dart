import 'dart:math';

import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';

const List<String> _assets = [
  'zero.png',
  'one.png',
  'two.png',
  'three.png',
  'four.png',
  'five.png',
  'six.png',
  'seven.png',
  'eight.png',
  'nine.png',
];

extension PlayerTwoScoreX on SoccerGame {
  PlayerTwoScoreComponent buildPlayerTwoScore(double height, int score) {
    var result = PlayerTwoScoreComponent(min(9, score))
      ..size = Vector2(height, height)
      ..position = Vector2(size.x - height, size.y - height * 3);
    add(result);
    return result;
  }
}

class PlayerTwoScoreComponent extends SpriteComponent with HasGameRef {
  final int score;

  PlayerTwoScoreComponent(this.score);
  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite(_assets[score]);
    return super.onLoad();
  }
}
