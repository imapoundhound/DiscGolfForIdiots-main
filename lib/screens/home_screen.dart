import 'package:flutter/material.dart';
import '../widget/fun_card.dart';
import 'ace_race_setup_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disc Golf For Idiots'),
        centerTitle: true,
      ),
      body: _buildGameCards(context),
    );
  }

  Widget _buildGameCards(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FunCard(
            title: 'New Round',
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.golf_course),
                  title: const Text('Ace Race'),
                  subtitle: const Text('Fast-paced ace hunting'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AceRaceSetupScreen()),
                  ),
                ),
              ],
            ),
          ),
          FunCard(
            title: 'History',
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Recent Rounds'),
              subtitle: const Text('View past rounds'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
            ),
          ),
          FunCard(
            title: 'Stats',
            child: ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Ace Rate & Performance'),
              subtitle: const Text('Track your stats'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
