import 'package:firebase_remote_config_example/soccer/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class LandscapePage extends StatefulWidget {
  const LandscapePage({super.key});

  @override
  State<LandscapePage> createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if ((MediaQuery.of(context).orientation == Orientation.landscape)) {
      return const GamePage();
    } else {
      Future.delayed(
        const Duration(milliseconds: 10),
        () => super.setState(() {}),
      );
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
