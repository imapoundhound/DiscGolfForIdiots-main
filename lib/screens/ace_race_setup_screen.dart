import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/round.dart';
import '../services/firestore_service.dart';
import '../services/ace_race_generator.dart';

class AceRaceSetupScreen extends StatefulWidget {
  const AceRaceSetupScreen({super.key});

  @override
  State<AceRaceSetupScreen> createState() => _AceRaceSetupScreenState();
}

class _AceRaceSetupScreenState extends State<AceRaceSetupScreen> {
  final _courseController = TextEditingController(text: 'Wickham Park');
  int _holeCount = 9;
  int _acePoints = 5;
  int _metalPoints = 1;
  final int _attemptsPerHole = 2;
  bool _randomTee = true;
  bool _randomBasket = true;
  bool _randomThrow = false;
  final List<String> _players = ['You'];
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ace Race Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course (optional)',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _holeCount,
              decoration: const InputDecoration(
                labelText: 'Holes',
                border: OutlineInputBorder(),
              ),
              items: [3, 6, 9, 18].map((h) => DropdownMenuItem(value: h, child: Text('$h holes'))).toList(),
              onChanged: (value) => setState(() => _holeCount = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Ace Points',
                prefixIcon: Icon(Icons.star),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _acePoints = int.tryParse(value) ?? 5,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Metal Points',
                prefixIcon: Icon(Icons.circle),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _metalPoints = int.tryParse(value) ?? 1,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Random Tee (short/long)'),
              value: _randomTee,
              onChanged: (value) => setState(() => _randomTee = value),
            ),
            SwitchListTile(
              title: const Text('Random Basket (short/long)'),
              value: _randomBasket,
              onChanged: (value) => setState(() => _randomBasket = value),
            ),
            SwitchListTile(
              title: const Text('Random Throw Type'),
              value: _randomThrow,
              onChanged: (value) => setState(() => _randomThrow = value),
            ),
            const SizedBox(height: 16),
            const Text(
              'Players:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ..._players.asMap().entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                trailing: _players.length > 1
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _players.removeAt(entry.key)),
                      )
                    : null,
              );
            }),
            ElevatedButton.icon(
              onPressed: () => setState(() => _players.add('Player ${_players.length + 1}')),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Player'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isCreating ? null : _startAceRace,
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Start Ace Race!',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _startAceRace() async {
    setState(() => _isCreating = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showError('User not logged in');
        setState(() => _isCreating = false);
        return;
      }

      final roundId = const Uuid().v4();
      final rules = {
        'acePoints': _acePoints,
        'metalPoints': _metalPoints,
        'attemptsPerHole': _attemptsPerHole,
        'randomTee': _randomTee,
        'randomBasket': _randomBasket,
        'randomThrow': _randomThrow,
      };

      final round = Round(
        id: roundId,
        ownerId: currentUser.uid,
        mode: 'ace_race',
        courseName: _courseController.text.isEmpty ? null : _courseController.text,
        rules: rules,
        roundPlayers: {
          for (int i = 0; i < _players.length; i++)
            'player_$i': {'userId': currentUser.uid, 'order': i + 1, 'name': _players[i]},
        },
        includeInStats: true,
        startedAt: DateTime.now(),
      );

      await FirestoreService.createRound(round);

      final challenges = AceRaceGenerator.generateChallenges(
        roundId,
        _holeCount,
        {'randomThrow': _randomThrow},
      );

      for (final challenge in challenges) {
        await FirestoreService.createChallenge(challenge);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ace Race created! Round ID: ${roundId.substring(0, 8)}...'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Error creating round: $e');
    }

    setState(() => _isCreating = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }
}
