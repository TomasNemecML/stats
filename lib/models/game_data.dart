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

  // Convert GameData to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'goals': goals,
      'assists': assists,
      'points': points,
      'myTeamScore': myTeamScore,
      'opponentScore': opponentScore,
    };
  }

  // Create GameData from JSON
  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      goals: json['goals'],
      assists: json['assists'],
      points: json['points'],
      myTeamScore: json['myTeamScore'],
      opponentScore: json['opponentScore'],
    );
  }
}
