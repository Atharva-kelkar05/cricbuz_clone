import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the ApiService class

void main() {
  runApp(const CricbuzzApp());
}

class CricbuzzApp extends StatelessWidget {
  const CricbuzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricbuzz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<MatchData> matchData;
  List<String> matchIds = [
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
    "820cfd88-3b56-4a6e-9dd8-1203051140da",
  ]; // List of match IDs to fetch info for
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricbuzz'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: matchIds.length,
        itemBuilder: (context, index) {
          return FutureBuilder<MatchData>(
            future: apiService.fetchMatchInfo(matchIds[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator()); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available');
              } else {
                return MatchCard(matchData: snapshot.data!);
              }
            },
          );
        },
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final MatchData matchData;

  MatchCard({required this.matchData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(matchData.data.name),
            subtitle: Text(matchData.data.venue),
            trailing: Text(matchData.data.date),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Match Type: ${matchData.data.matchType}'),
                Text('Status: ${matchData.data.status}'),
                Text('Toss Winner: ${matchData.data.tossWinner}'),
                Text('Toss Choice: ${matchData.data.tossChoice}'),
                Text('Match Winner: ${matchData.data.matchWinner}'),
                Text('Teams: ${matchData.data.teams.join(", ")}'),
                Text('Scores:'),
                for (var score in matchData.data.score)
                  Text(
                      '${score.inning}: ${score.r}/${score.w} in ${score.o} overs'),
                Text('Series ID: ${matchData.data.seriesId}'),
                Text('Fantasy Enabled: ${matchData.data.fantasyEnabled}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
