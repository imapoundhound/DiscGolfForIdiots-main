import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/round.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Round> _rounds = [];

  @override
  void initState() {
    super.initState();
    _loadRounds();
  }

  Future<void> _loadRounds() async {
    final roundsMap = await StorageService.getRounds();
    setState(() {
      _rounds = roundsMap.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Round History')),
      body: _rounds.isEmpty
          ? const Center(child: Text('No rounds yet'))
          : ListView.builder(
              itemCount: _rounds.length,
              itemBuilder: (context, index) {
                final round = _rounds[index];
                return ListTile(
                  title: Text('Round ${round.id.substring(0, 8)}'),
                  subtitle: Text('Mode: ${round.mode}, Course: ${round.courseName ?? 'Unknown'}'),
                  trailing: Text(round.startedAt.toString()),
                );
              },
            ),
    );
  }
}