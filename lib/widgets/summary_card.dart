import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int gamesPlayed;
  final int totalGoals;
  final int totalAssists;
  final int totalPoints;
  final int wins;
  final int losses;
  final int ties;

  const SummaryCard({
    super.key,
    required this.gamesPlayed,
    required this.totalGoals,
    required this.totalAssists,
    required this.totalPoints,
    required this.wins,
    required this.losses,
    required this.ties,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Season Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Games', gamesPlayed.toString()),
                _buildStat('Goals', totalGoals.toString()),
                _buildStat('Assists', totalAssists.toString()),
                _buildStat('Points', totalPoints.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Wins', wins.toString(), color: Colors.green),
                _buildStat('Losses', losses.toString(), color: Colors.red),
                _buildStat('Ties', ties.toString(), color: Colors.orange),
                _buildStat('Record', '$wins-$losses-$ties'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
