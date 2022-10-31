import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:firebase_remote_config_example/soccer/math.dart';
import 'package:firebase_remote_config_example/soccer/player_one.dart';
import 'package:firebase_remote_config_example/soccer/player_two.dart';
import 'package:firebase_remote_config_example/soccer/porta_left.dart';
import 'package:firebase_remote_config_example/soccer/porta_right.dart';
import 'package:firebase_remote_config_example/soccer/world.dart';

class BallComponent extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  final Vector2 onGroundPosition;
  bool onGround = true;
  Vector2 speed = Vector2(0, 0);

  BallComponent(this.onGroundPosition) {
    position = onGroundPosition;
  }

  @override
  void update(double dt) {
    if (onGround) return;
    if (position.y > onGroundPosition.y) {
      position.y = onGroundPosition.y - 1;
      speed.y = speed.y - speed.y * World.earthFrictionForce * dt;
      speed.y = -mod(speed.y);
      speed.x = speed.x - speed.x * World.earthFrictionForce * dt;
    }
    speed.x = speed.x - speed.x * World.airFrictionForce * dt;
    speed.y = speed.y + World.gravity * dt;

    if ((speed.length < World.minSpeed) &&
        (mod(position.y - onGroundPosition.y) < World.heightToStop)) {
      onGround = true;
      position.y = onGroundPosition.y;
      World.onEvent(WorldEvents.ballStoped);
      return;
    }

    if (position.x > gameRef.size.x + 10) {
      onGround = true;
      position.y = onGroundPosition.y;
      World.onEvent(WorldEvents.ballStoped);
      return;
    }

    if (position.x < -10) {
      onGround = true;
      position.y = onGroundPosition.y;
      World.onEvent(WorldEvents.ballStoped);
      return;
    }

    position += speed;

    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomCenter;
    sprite = await gameRef.loadSprite('ball.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (onGround) return;
    if ((other is PlayerTwoComponent) || (other is PlayerTwoLegComponent)) {
      if ((World.mode == WorldMode.playerOneKick)) {
        onGround = true;
        speed.x = 0;
        World.onEvent(WorldEvents.playerTwoGet);
      }
    }
    if ((other is PortaRightComponent)) {
      onGround = true;
      speed.x = 0;
      World.onEvent(WorldEvents.playerTwoFail);
    }
    if ((other is PlayerOneComponent) || (other is PlayerOneLegComponent)) {
      if ((World.mode == WorldMode.playerTwoKick)) {
        onGround = true;
        speed.x = 0;
        World.onEvent(WorldEvents.playerOneGet);
      }
    }
    if ((other is PortaLeftComponent)) {
      onGround = true;
      speed.x = 0;
      World.onEvent(WorldEvents.playerOneFail);
    }
    super.onCollision(intersectionPoints, other);
  }
}

extension BallX on SoccerGame {
  BallComponent buildBallLeft(double height) {
    var ballH = height * 20 / 100;

    var result = BallComponent(
      Vector2(height * 2 + ballH * 2, size.y - height),
    )..size = Vector2(ballH, ballH);

    add(result);
    return result;
  }

  BallComponent buildBallRight(double height) {
    var ballH = height * 20 / 100;

    var result = BallComponent(
      Vector2(size.x - height * 2 - ballH * 2, size.y - height),
    )..size = Vector2(ballH, ballH);

    add(result);
    return result;
  }

  void kickPlayerOne(BallComponent ball, double x, double y) {
    if (!ball.onGround) return;
    ball.onGround = false;
    ball.speed += Vector2(x, -y);
    World.onEvent(WorldEvents.playerOneKick);
  }

  void kickPlayerTwo(BallComponent ball, double x, double y) {
    if (!ball.onGround) return;
    ball.onGround = false;
    ball.speed += Vector2(-x, -y);
    World.onEvent(WorldEvents.playerTwoKick);
  }
}
