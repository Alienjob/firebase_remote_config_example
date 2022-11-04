import 'package:flutter/material.dart';

class SpalshPage extends StatelessWidget {
  const SpalshPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42a5f5),
      body: Row(
        children: [
          const Spacer(),
          Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/icon/icon.png',
                height: 100,
                width: 100,
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
