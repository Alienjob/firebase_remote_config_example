import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:firebase_remote_config_example/soccer/player_two.dart';
import 'package:firebase_remote_config_example/soccer/ball.dart';
import 'dart:math';

enum WorldMode { load, playerOneKick, playerTwoKick, finish }

enum WorldEvents {
  ballStoped,
  playerOneKick,
  playerOneJump,
  playerTwoKick,
  playerTwoNeedKick,
  playerOneFail,
  playerOneGet,
  playerTwoFail,
  playerTwoGet,
  playerTwoJump,
  buildedLeft,
  buildedRight,
}

class World {
  static const double gravity = 5;
  static const double playerForce = 3.4;
  static const double airFrictionForce = 0.1;
  static const double earthFrictionForce = 1;
  static const double minSpeed = 1;
  static const double heightToStop = 1;
  static const double rebuildDelay = 1;
  static late SoccerGame game;
  static bool offInput = false;
  static WorldMode mode = WorldMode.load;
  static int playerOneScore = 0;
  static int playerTwoScore = 0;
  static final _random = Random();

  static onEvent(WorldEvents event) {
    if (event == WorldEvents.playerOneKick) {
      autojump();
      return;
    }
    if (event == WorldEvents.playerTwoNeedKick) {
      autoKick();
      return;
    }
    if (event == WorldEvents.playerOneFail) {
      playerTwoScore++;
      mode = WorldMode.playerOneKick;
      rebuild();
      return;
    }
    if (event == WorldEvents.playerOneGet) {
      mode = WorldMode.playerOneKick;
      rebuild();
      return;
    }
    if (event == WorldEvents.playerTwoFail) {
      playerOneScore++;
      mode = WorldMode.playerTwoKick;
      rebuild();
      return;
    }
    if (event == WorldEvents.playerTwoGet) {
      mode = WorldMode.playerTwoKick;
      rebuild();
      return;
    }
    if (event == WorldEvents.buildedLeft) {
      return;
    }
    if (event == WorldEvents.buildedRight) {
      onEvent(WorldEvents.playerTwoNeedKick);
      return;
    }
    if (event == WorldEvents.ballStoped) {
      if (mode == WorldMode.playerOneKick) {
        onEvent(WorldEvents.playerTwoGet);
        return;
      }
      if (mode == WorldMode.playerTwoKick) {
        onEvent(WorldEvents.playerOneGet);
        return;
      }
      return;
    }
  }

  static Future<void> autojump() async {
    await Future.delayed(
      Duration(milliseconds: _random.nextInt(1000)),
      () => game.jumpPlayerTwo(game.playerTwo, game.playerTwoLeg),
    );
  }

  static Future<void> autoKick() async {
    await Future.delayed(
      Duration(milliseconds: _random.nextInt(1000)),
      () => game.kickPlayerTwo(
        game.ball,
        playerForce + (_random.nextDouble() - 0.5) * playerForce * 0.3,
        playerForce + (_random.nextDouble() - 0.5) * playerForce * 0.3,
      ),
    );
  }

  static void rebuild() async {
    offInput = true;
    await game.rebuild(rebuildDelay);
    onEvent((mode == WorldMode.playerOneKick)
        ? WorldEvents.buildedLeft
        : WorldEvents.buildedRight);
    offInput = false;
  }
}
