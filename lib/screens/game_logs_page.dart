import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_data.dart';
import '../widgets/summary_card.dart';

class GameLogsPage extends StatelessWidget {
  final int year;
  final List<GameData> games;

  const GameLogsPage({Key? key, required this.year, required this.games})
    : super(key: key);

  // Calculate stats based on games
  int get totalGames => games.length;
  int get totalGoals => games.fold(0, (sum, game) => sum + game.goals);
  int get totalAssists => games.fold(0, (sum, game) => sum + game.assists);
  int get totalPoints => games.fold(0, (sum, game) => sum + game.points);
  double get pointsPerGame => totalGames > 0 ? totalPoints / totalGames : 0;
  int get totalWins => games.where((game) => game.isWin).length;
  int get totalLosses => games.where((game) => game.isLoss).length;
  int get totalTies => games.where((game) => game.isTie).length;

  @override
  Widget build(BuildContext context) {
    // Sort games by date (newest first) - we already do this, but just to be safe
    final sortedGames = List<GameData>.from(games)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text('$year Season Games')),
      body:
          sortedGames.isEmpty
              ? Center(
                child: Text(
                  'No games recorded for $year',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Hero(
                      tag: 'season_summary_$year',
                      child: SummaryCard(
                        gamesPlayed: totalGames,
                        totalGoals: totalGoals,
                        totalAssists: totalAssists,
                        totalPoints: totalPoints,
                        wins: totalWins,
                        losses: totalLosses,
                        ties: totalTies,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sortedGames.length,
                      itemBuilder: (context, index) {
                        final game = sortedGames[index];
                        return _buildGameCard(context, game);
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildGameCard(BuildContext context, GameData game) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final formattedDate = dateFormat.format(game.date);

    // Determine the result label and color
    String resultText;
    Color resultColor;

    if (game.isWin) {
      resultText = 'W';
      resultColor = Colors.green;
    } else if (game.isLoss) {
      resultText = 'L';
      resultColor = Colors.red;
    } else {
      resultText = 'T';
      resultColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Date
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                // Result badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: resultColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    resultText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Goals', game.goals.toString()),
                _buildStatColumn('Assists', game.assists.toString()),
                _buildStatColumn('Points', game.points.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
