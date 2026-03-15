import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/round.dart';
import '../models/score_event.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _totalRounds = 0;
  int _totalAces = 0;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final roundsMap = await StorageService.getRounds();
    final rounds = roundsMap.values.toList();
    int aces = 0;
    int points = 0;

    for (final round in rounds) {
      final events = await StorageService.getScoreEventsByRound(round.id);
      for (final event in events) {
        if (event.resultType == 'ace') aces++;
        points += event.points;
      }
    }

    setState(() {
      _totalRounds = rounds.length;
      _totalAces = aces;
      _totalPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard('Total Rounds', _totalRounds.toString()),
            _buildStatCard('Total Aces', _totalAces.toString()),
            _buildStatCard('Total Points', _totalPoints.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}