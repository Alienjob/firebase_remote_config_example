import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:firebase_remote_config_example/soccer/world.dart';

class PlayerOneComponent extends SpriteComponent with HasGameRef {
  final Vector2 onGroundPosition;
  bool onGround = true;
  double speed = 0;

  PlayerOneComponent(this.onGroundPosition) {
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
    sprite = await gameRef.loadSprite('Player Blu.png');
    add(CircleHitbox());
    return super.onLoad();
  }
}

class PlayerOneLegComponent extends SpriteComponent with HasGameRef {
  final Vector2 onGroundPosition;
  bool onGround = true;
  double speed = 0;

  PlayerOneLegComponent(this.onGroundPosition) {
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
    sprite = await gameRef.loadSprite('Player blu left leg.png');
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }
}

extension PlayerOneX on SoccerGame {
  PlayerOneComponent buildPlayerOne(double height) {
    var legH = height * 20 / 100;
    var spaceH = height * 5 / 100;
    var headH = height * 75 / 100;

    var result = PlayerOneComponent(
      Vector2(height * 2, size.y - height - legH - spaceH),
    )..size = Vector2(headH, headH);

    add(result);
    return result;
  }

  PlayerOneLegComponent buildPlayerOneLeg(double height) {
    var legH = height * 20 / 100;
    var headH = height * 75 / 100;

    var result = PlayerOneLegComponent(Vector2(height * 2, size.y - height))
      ..size = Vector2(headH, legH);
    add(result);
    return result;
  }

  void jumpPlayerOne(
      PlayerOneComponent playerOne, PlayerOneLegComponent playerOneLeg) {
    if (!playerOne.onGround) return;
    playerOne.onGround = false;
    playerOneLeg.onGround = false;
    playerOne.speed = -World.playerForce;
    playerOneLeg.speed = -World.playerForce + 0.01;
    World.onEvent(WorldEvents.playerOneJump);
  }
}
