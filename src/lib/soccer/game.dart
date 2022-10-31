import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:firebase_remote_config_example/soccer/player_one.dart';
import 'package:firebase_remote_config_example/soccer/player_two.dart';
import 'package:firebase_remote_config_example/soccer/terrain.dart';
import 'package:firebase_remote_config_example/soccer/porta_left.dart';
import 'package:firebase_remote_config_example/soccer/porta_right.dart';
import 'package:firebase_remote_config_example/soccer/world.dart';
import 'package:firebase_remote_config_example/soccer/ball.dart';
import 'package:firebase_remote_config_example/soccer/back.dart';
import 'package:firebase_remote_config_example/soccer/player_one_score.dart';
import 'package:firebase_remote_config_example/soccer/player_two_score.dart';

class SoccerGame extends FlameGame with TapDetector, HasCollisionDetection {
  static const double height = 40;

  late BallComponent ball;
  late PlayerOneComponent playerOne;
  late PlayerOneLegComponent playerOneLeg;
  late PlayerTwoComponent playerTwo;
  late PlayerTwoLegComponent playerTwoLeg;
  late PlayerOneScoreComponent playerOneScore;
  late PlayerTwoScoreComponent playerTwoScore;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    World.mode = WorldMode.playerOneKick;
    World.game = this;
    buildBack();
    buildTerrain(height);
    buildPortaLeft(height);
    buildPortaRight(height);

    build();
  }

  Future<void> rebuild(double delay) async {
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        destroy();
        build();
      },
    );
  }

  void destroy() {
    removeAll([
      playerOne,
      playerOneLeg,
      playerOneScore,
      playerTwo,
      playerTwoLeg,
      playerTwoScore,
      ball,
    ]);
  }

  void build() {
    playerOne = buildPlayerOne(height);
    playerOneLeg = buildPlayerOneLeg(height);
    playerOneScore = buildPlayerOneScore(height, World.playerOneScore);
    playerTwo = buildPlayerTwo(height);
    playerTwoLeg = buildPlayerTwoLeg(height);
    playerTwoScore = buildPlayerTwoScore(height, World.playerTwoScore);
    if ((World.mode == WorldMode.playerOneKick)) {
      ball = buildBallLeft(height);
    }
    if ((World.mode == WorldMode.playerTwoKick)) {
      ball = buildBallRight(height);
    }
  }

  void doPunt() {
    FlameAudio.play('football-punt.mp3');
  }

  void doApplause() {
    FlameAudio.play('applause.mp3');
  }

  @override
  void onTap() {
    if (World.offInput) return;
    if (World.mode == WorldMode.playerOneKick) {
      kickPlayerOne(ball, World.playerForce, World.playerForce);
      return;
    } else {
      jumpPlayerOne(playerOne, playerOneLeg);
      return;
    }
  }
}
