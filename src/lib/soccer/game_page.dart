import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LandscapePage extends StatefulWidget {
  const LandscapePage({super.key});

  @override
  State<LandscapePage> createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return const GamePage();
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: SoccerGame(),
      ),
    );
  }
}
