import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../widget/fun_card.dart';
import 'ace_race_setup_screen.dart';
import 'login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disc Golf For Idiots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService.signOut(),
          ),
        ],
      ),
      body: user.when(
        data: (user) => user != null 
            ? _buildGameCards(context)
            : const LoginScreen(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading user')),
      ),
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
            child: const ListTile(
              leading: Icon(Icons.history),
              title: Text('Recent Rounds'),
              subtitle: Text('View past rounds'),
            ),
          ),
          FunCard(
            title: 'Stats',
            child: const ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Ace Rate & Performance'),
              subtitle: Text('Track your stats'),
            ),
          ),
        ],
      ),
    );
  }
}

final authProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});
