import 'dart:convert';
import 'package:http/http.dart' as http;

class MatchData {
  String apikey;
  Data data;
  String status;
  Info info;

  MatchData({
    required this.apikey,
    required this.data,
    required this.status,
    required this.info,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      apikey: json['apikey'],
      data: Data.fromJson(json['data']),
      status: json['status'],
      info: Info.fromJson(json['info']),
    );
  }
}

class Data {
  String id;
  String name;
  String matchType;
  String status;
  String venue;
  String date;
  String dateTimeGMT;
  List<String> teams;
  List<Score> score;
  String tossWinner;
  String tossChoice;
  String matchWinner;
  String seriesId;
  bool fantasyEnabled;

  Data({
    required this.id,
    required this.name,
    required this.matchType,
    required this.status,
    required this.venue,
    required this.date,
    required this.dateTimeGMT,
    required this.teams,
    required this.score,
    required this.tossWinner,
    required this.tossChoice,
    required this.matchWinner,
    required this.seriesId,
    required this.fantasyEnabled,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      matchType: json['matchType'],
      status: json['status'],
      venue: json['venue'],
      date: json['date'],
      dateTimeGMT: json['dateTimeGMT'],
      teams: List<String>.from(json['teams']),
      score: List<Score>.from(json['score'].map((x) => Score.fromJson(x))),
      tossWinner: json['tossWinner'],
      tossChoice: json['tossChoice'],
      matchWinner: json['matchWinner'],
      seriesId: json['series_id'],
      fantasyEnabled: json['fantasyEnabled'],
    );
  }
}

class Score {
  double r;
  double w;
  double o;
  String inning;

  Score({
    required this.r,
    required this.w,
    required this.o,
    required this.inning,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      r: json['r'].toDouble(),
      w: json['w'].toDouble(),
      o: json['o'].toDouble(),
      inning: json['inning'],
    );
  }
}

class Info {
  double hitsToday;
  double hitsLimit;
  double credits;
  double server;
  double queryTime;

  Info({
    required this.hitsToday,
    required this.hitsLimit,
    required this.credits,
    required this.server,
    required this.queryTime,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      hitsToday: json['hitsToday'].toDouble(),
      hitsLimit: json['hitsLimit'].toDouble(),
      credits: json['credits'].toDouble(),
      server: json['server'].toDouble(),
      queryTime: json['queryTime'].toDouble(),
    );
  }
}

class ApiService {
  final String baseUrl = 'https://api.cricapi.com/v1/match_info';
  final String apiKey = 'be2a5815-f607-4dbf-81d6-52e151982d9a';

  Future<MatchData> fetchMatchInfo(String id) async {
    final url = '$baseUrl?apikey=$apiKey&id=$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return MatchData.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch match info');
    }
  }
}
