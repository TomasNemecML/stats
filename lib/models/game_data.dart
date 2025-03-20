class GameData {
  final DateTime date;
  final int goals;
  final int assists;
  final int points;
  final int myTeamScore;
  final int opponentScore;

  GameData({
    required this.date,
    required this.goals,
    required this.assists,
    required this.points,
    required this.myTeamScore,
    required this.opponentScore,
  });

  bool get isWin => myTeamScore > opponentScore;
  bool get isLoss => myTeamScore < opponentScore;
  bool get isTie => myTeamScore == opponentScore;
}
