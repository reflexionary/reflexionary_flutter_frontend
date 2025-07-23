import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.auto_graph, size: 30),
        title: Text("Insights",
            style: TextStyle(fontFamily: 'Runalto', fontSize: 26)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Discover patterns in your emotions and trading performance.",
                style: TextStyle(fontSize: 14, fontFamily: 'Casanova'),
              ),
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard("Mood vs P&L", Icons.bar_chart, _buildMoodBarChart()),
            const SizedBox(height: 20),
            _buildCard("Bias Trends", Icons.psychology, _buildBiasPieChart()),
            const SizedBox(height: 20),
            _buildCard("Emotional Accuracy", Icons.timeline, _buildLineChart()),
            const SizedBox(height: 20),
            _buildPlaceholderCard(),
            const SizedBox(height: 20),
            _buildSubconsciousPatterns(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Widget chartWidget) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 28),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(fontFamily: 'Runalto', fontSize: 22,fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            chartWidget
          ],
        ),
      ),
    );
  }

  Widget _buildMoodBarChart() {
    final data = [
      {'mood': 'Focused', 'pnl': 300, 'trades': 5},
      {'mood': 'Calm', 'pnl': 150, 'trades': 8},
      {'mood': 'Anxious', 'pnl': -200, 'trades': 10},
      {'mood': 'FOMO', 'pnl': -350, 'trades': 6},
      {'mood': 'Confident', 'pnl': 250, 'trades': 4},
    ];

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 400,
          minY: -400,
          barGroups: data
              .asMap()
              .entries
              .map(
                (e) => BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(
                      toY: e.value['pnl']!as double,
                      width: 14,
                      color: Colors.blueAccent),
                  BarChartRodData(
                      toY: (e.value['trades']! as double) * 20,
                      width: 14,
                      color: Colors.orangeAccent),
                ]),
              )
              .toList(),
          titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final mood = data[value.toInt()]['mood'];
                      return Text(
                        mood as String,
                        style:TextStyle(fontFamily: 'Casanova', fontSize: 10),
                      );
                    }),
              )),
        ),
      ),
    );
  }

  Widget _buildBiasPieChart() {
    final data = [
      {'name': 'Confirmation Bias', 'frequency': 12},
      {'name': 'Recency Bias', 'frequency': 8},
      {'name': 'Anchoring', 'frequency': 5},
    ];
    final total = data.fold(0, (sum, e) => sum + (e['frequency']! as double).round());
    return SizedBox(
      height: 300,
      child: PieChart(PieChartData(
        sections: data
            .asMap()
            .entries
            .map((entry) => PieChartSectionData(
                color: Colors.primaries[entry.key * 2],
                value: (entry.value['frequency']! as double),
                title: "${((entry.value['frequency']! as double)/ total * 100).toStringAsFixed(1)}%",
                radius: 60))
            .toList(),
      )),
    );
  }

  Widget _buildLineChart() {
    final data = [
      {'date': 'Jul 1', 'accuracy': 0.75},
      {'date': 'Jul 8', 'accuracy': 0.80},
      {'date': 'Jul 15', 'accuracy': 0.70},
      {'date': 'Jul 22', 'accuracy': 0.85},
      {'date': 'Jul 29', 'accuracy': 0.90},
    ];

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(),
                      (e.value['accuracy']! as double)))
                  .toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value < 0 || value >= data.length) return Container();
                      return Text(data[value.toInt()]['date']! as String,
                          style: TextStyle(fontFamily: 'Casanova', fontSize: 10));
                    }),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true))),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return _buildCard("Calendar Heatmap", Icons.calendar_month, Container(
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text("Calendar Heatmap Coming Soon..."),
    ));
  }

  Widget _buildSubconsciousPatterns() {
    final patterns = [
      "After 2 consecutive losses, you tend to log 'Frustration' and reduce trade size.",
      "Journal entries on Mondays often mention 'Market Uncertainty' before your first trade.",
      "A logged mood of 'Excited' is often followed by trades with higher than average risk."
    ];

    return _buildCard(
        "Subconscious Pattern Detector", Icons.psychology_alt_outlined,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: patterns
              .map((e) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(e,
                        style: TextStyle(fontFamily: 'Runalto',
                            fontWeight: FontWeight.w500)),
                  ))
              .toList(),
        ));
  }
}
