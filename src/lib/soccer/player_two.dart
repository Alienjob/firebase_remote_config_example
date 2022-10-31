import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:firebase_remote_config_example/soccer/world.dart';

class PlayerTwoComponent extends SpriteComponent with HasGameRef {
  final Vector2 onGroundPosition;
  bool onGround = true;
  double speed = 0;

  PlayerTwoComponent(this.onGroundPosition) {
    position = onGroundPosition;
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('Player Red.png');
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (onGround) return;
    if (position.y > onGroundPosition.y) {
      onGround = true;
      position = onGroundPosition;
      return;
    }
    speed = speed + World.gravity * dt;
    position.y += speed;

    super.update(dt);
  }
}

class PlayerTwoLegComponent extends SpriteComponent with HasGameRef {
  final Vector2 onGroundPosition;
  bool onGround = true;
  double speed = 0;
  PlayerTwoLegComponent(this.onGroundPosition) {
    position = onGroundPosition;
  }

  @override
  void update(double dt) {
    if (onGround) return;
    if (position.y > onGroundPosition.y) {
      onGround = true;
      position = onGroundPosition;
      return;
    }
    speed = speed + World.gravity * dt;
    position.y += speed;

    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('Player red left leg.png');
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }
}

extension PlayerTwoX on SoccerGame {
  PlayerTwoComponent buildPlayerTwo(double height) {
    var legH = height * 20 / 100;
    var spaceH = height * 5 / 100;
    var headH = height * 75 / 100;

    var player = PlayerTwoComponent(
        Vector2(size.x - height * 2, size.y - height - legH - spaceH))
      ..size = Vector2(headH, headH);
    add(player);
    return player;
  }

  PlayerTwoLegComponent buildPlayerTwoLeg(double height) {
    var legH = height * 20 / 100;
    var spaceH = height * 5 / 100;
    var headH = height * 75 / 100;

    var leg =
        PlayerTwoLegComponent(Vector2(size.x - height * 2, size.y - height))
          ..size = Vector2(headH, legH);
    add(leg);
    return leg;
  }

  void jumpPlayerTwo(
      PlayerTwoComponent playerOne, PlayerTwoLegComponent playerOneLeg) {
    playerOne.speed = -7;
    playerOne.onGround = false;
    playerOneLeg.speed = -6.8;
    playerOneLeg.onGround = false;
  }
}
