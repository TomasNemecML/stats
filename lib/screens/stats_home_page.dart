import 'package:flutter/material.dart';
import '../models/game_data.dart';
import '../widgets/summary_card.dart';
import '../widgets/stat_card.dart';
import 'add_game_page.dart';

import 'package:soft_edge_blur/soft_edge_blur.dart';

class StatsHomePage extends StatefulWidget {
  const StatsHomePage({super.key});

  @override
  State<StatsHomePage> createState() => _StatsHomePageState();
}

class _StatsHomePageState extends State<StatsHomePage> {
  // Year tracking
  int _selectedYear = DateTime.now().year;

  // Dummy data
  final List<GameData> _games = [
    GameData(
      date: DateTime(2024, 10, 5),
      goals: 2,
      assists: 1,
      points: 3,
      myTeamScore: 4,
      opponentScore: 2,
    ),
    GameData(
      date: DateTime(2024, 10, 12),
      goals: 0,
      assists: 2,
      points: 2,
      myTeamScore: 3,
      opponentScore: 3,
    ),
    GameData(
      date: DateTime(2025, 10, 19),
      goals: 1,
      assists: 0,
      points: 1,
      myTeamScore: 2,
      opponentScore: 5,
    ),
    GameData(
      date: DateTime(2025, 10, 26),
      goals: 3,
      assists: 1,
      points: 4,
      myTeamScore: 5,
      opponentScore: 1,
    ),
    GameData(
      date: DateTime(2025, 11, 2),
      goals: 0,
      assists: 3,
      points: 3,
      myTeamScore: 2,
      opponentScore: 4,
    ),
    GameData(
      date: DateTime(2025, 11, 9),
      goals: 1,
      assists: 1,
      points: 2,
      myTeamScore: 3,
      opponentScore: 2,
    ),
    GameData(
      date: DateTime(2025, 11, 16),
      goals: 2,
      assists: 0,
      points: 2,
      myTeamScore: 4,
      opponentScore: 4,
    ),
  ];

  // Filtered games based on the selected year
  List<GameData> get _filteredGames =>
      _games.where((game) => game.date.year == _selectedYear).toList();

  // Calculate stats based on filtered games
  int get totalGames => _filteredGames.length;
  int get totalGoals => _filteredGames.fold(0, (sum, game) => sum + game.goals);
  int get totalAssists =>
      _filteredGames.fold(0, (sum, game) => sum + game.assists);
  int get totalPoints =>
      _filteredGames.fold(0, (sum, game) => sum + game.points);
  double get pointsPerGame => totalGames > 0 ? totalPoints / totalGames : 0;
  int get totalWins => _filteredGames.where((game) => game.isWin).length;
  int get totalLosses => _filteredGames.where((game) => game.isLoss).length;
  int get totalTies => _filteredGames.where((game) => game.isTie).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoftEdgeBlur(
        edges: [
          EdgeBlur(
            type: EdgeType.topEdge,
            size: MediaQuery.of(context).padding.top,
            sigma: 20,
            controlPoints: [
              ControlPoint(position: 0.5, type: ControlPointType.visible),
              ControlPoint(position: 1, type: ControlPointType.transparent),
            ],
          ),
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.0,
                16.0 + MediaQuery.of(context).padding.top,
                16.0,
                16.0,
              ),
              child: Column(
                children: [
                  // Year selector
                  _buildYearSelector(),
                  const SizedBox(height: 16),

                  // Display message if no games for selected year
                  if (_filteredGames.isEmpty) ...[
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.sports_hockey,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No games recorded for $_selectedYear',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],

                  // Only show stats if there are games for the selected year
                  if (_filteredGames.isNotEmpty) ...[
                    // Summary card
                    SummaryCard(
                      gamesPlayed: totalGames,
                      totalGoals: totalGoals,
                      totalAssists: totalAssists,
                      totalPoints: totalPoints,
                      wins: totalWins,
                      losses: totalLosses,
                      ties: totalTies,
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      title: 'Goals',
                      value: totalGoals.toString(),
                      data:
                          _filteredGames
                              .map((g) => g.goals.toDouble())
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      title: 'Assists',
                      value: totalAssists.toString(),
                      data:
                          _filteredGames
                              .map((g) => g.assists.toDouble())
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      title: 'Points',
                      value: totalPoints.toString(),
                      data:
                          _filteredGames
                              .map((g) => g.points.toDouble())
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    StatCard(
                      title: 'Points Per Game',
                      value: pointsPerGame.toStringAsFixed(2),
                      data:
                          _filteredGames
                              .map((g) => g.points.toDouble())
                              .toList(),
                      isAverage: true,
                    ),
                  ],
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddGamePage(
                    onAddGame: (game) {
                      setState(() {
                        _games.add(game);
                        // Auto-select the year of the new game
                        _selectedYear = game.date.year;
                      });
                    },
                  ),
            ),
          );
        },
        label: const Text('Add Game'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildYearSelector() {
    // Get all years that have games
    final Set<int> availableYears =
        _games.map((game) => game.date.year).toSet();

    // Add current year if not already in the set
    availableYears.add(DateTime.now().year);

    // Sort the years
    final sortedYears = availableYears.toList()..sort();
    final currentIndex = sortedYears.indexOf(_selectedYear);

    // Determine if we can navigate to previous or next years
    final canGoBack = currentIndex > 0;
    final canGoForward = currentIndex < sortedYears.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous year button
        _buildYearButton(
          icon: Icons.chevron_left,
          onPressed:
              canGoBack
                  ? () {
                    setState(() {
                      _selectedYear = sortedYears[currentIndex - 1];
                    });
                  }
                  : null,
        ),

        // Year display
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _selectedYear.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),

        // Next year button
        _buildYearButton(
          icon: Icons.chevron_right,
          onPressed:
              canGoForward
                  ? () {
                    setState(() {
                      _selectedYear = sortedYears[currentIndex + 1];
                    });
                  }
                  : null,
        ),
      ],
    );
  }

  Widget _buildYearButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isDisabled = onPressed == null;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color:
            isDisabled
                ? Theme.of(context).colorScheme.surfaceVariant
                : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color:
              isDisabled
                  ? Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
