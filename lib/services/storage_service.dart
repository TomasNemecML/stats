import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_data.dart';

class StorageService {
  static const String _gamesKey = 'games';

  // Save the list of games to local storage
  Future<void> saveGames(List<GameData> games) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> gamesJson =
        games.map((game) => jsonEncode(game.toJson())).toList();
    await prefs.setStringList(_gamesKey, gamesJson);
  }

  // Load the list of games from local storage
  Future<List<GameData>> loadGames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? gamesJson = prefs.getStringList(_gamesKey);

    if (gamesJson == null || gamesJson.isEmpty) {
      return [];
    }

    return gamesJson
        .map((gameJson) => GameData.fromJson(jsonDecode(gameJson)))
        .toList();
  }
}
