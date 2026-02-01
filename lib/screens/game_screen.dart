import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/scoreboard.dart';
import '../widgets/creek_grid.dart';
import '../widgets/incubator_button.dart';
import '../widgets/ad_banner_slot.dart';

/// The main game screen containing all game UI elements.
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Scoreboard: Creek Level and Points
            const Scoreboard(),

            // The Creek: Main game grid
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CreekGrid(),
              ),
            ),

            // Incubator button to spawn new eggs
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: IncubatorButton(),
            ),

            // Ad banner slot (placeholder for now)
            const AdBannerSlot(),
          ],
        ),
      ),
    );
  }
}
