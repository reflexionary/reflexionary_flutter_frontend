// Qubera_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';

class QuberaScreen extends StatefulWidget {
  const QuberaScreen({super.key});

  @override
  State<QuberaScreen> createState() => _QuberaScreenState();
}

class _QuberaScreenState extends State<QuberaScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  String duration = 'Monthly';
  final List<String> availableDurations = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Annually'];
  final List<double> fontSizes = [22, 40];
  final String defaultFont = 'RobotoMono';

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadMockData();
  }

  Future<Map<String, dynamic>> _loadMockData() async {
    final data = await rootBundle.loadString('lib/assets/mock/financial_dashboard_data.json');
    return json.decode(data);
  }

  TextStyle textStyle(double size, {Color? color, FontWeight? weight}) => TextStyle(
    fontFamily: defaultFont,
    fontSize: size,
    color: color,
    fontWeight: weight ?? FontWeight.normal,
  );

  BoxDecoration cardShadowDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(2, 4),
      )
    ],
  );

  String formatAmount(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return value.toInt().toString();
    }
  }

  Widget _buildBalanceBox(List balances) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: cardShadowDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Account Balances", style: textStyle(fontSizes[1], weight: FontWeight.bold)),
          ),
          ...balances.map((acc) => ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text("${acc['bank']} (${acc['type']})", style: textStyle(fontSizes[0])),
                trailing: Text("₹${acc['balance']}", style: textStyle(fontSizes[0])),
              )),
        ],
      ),
    );
  }

  Widget _buildSpendingChart(List<String> labels, List<double> income, List<double> expense) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: cardShadowDecoration.copyWith(
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Income vs Expenditure", style: textStyle(fontSizes[1], weight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 360,
            width: MediaQuery.of(context).size.width - 24,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('Duration', style: textStyle(fontSizes[0], weight: FontWeight.bold, color: Colors.black)),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        if (value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(labels[value.toInt()], style: textStyle(12)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text('Amount (₹)', style: textStyle(fontSizes[0], weight: FontWeight.bold)),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(formatAmount(value), style: textStyle(12)),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(income.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(toY: income[index], color: Colors.green),
                      BarChartRodData(toY: expense[index], color: Colors.red),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendBox("Income", Colors.green),
              const SizedBox(width: 10),
              _buildLegendBox("Expenditure", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(label, style: textStyle(fontSizes[0]))
      ],
    );
  }

  Widget _buildCategorySpending(List<String> categories, List<double> values) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: cardShadowDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Spending by Category", style: textStyle(fontSizes[1], weight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(categories[i], style: textStyle(fontSizes[0])),
                trailing: Text("₹${values[i].toStringAsFixed(2)}", style: textStyle(fontSizes[0])),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuspiciousTable(List txs) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: cardShadowDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Suspicious Transactions", style: textStyle(fontSizes[1], weight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              children: txs.map<Widget>((tx) => ListTile(
                title: Text("₹${tx['amount']} - ${tx['category']}", style: textStyle(fontSizes[0], weight: FontWeight.bold)),
                subtitle: Text(tx['description'], style: textStyle(fontSizes[0] - 2, color: Colors.grey)),
                trailing: Text(tx['date'], style: textStyle(fontSizes[0] - 2, color: Colors.grey)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsAndSuggestions(Map<String, dynamic> json) {
    return Row(
      children: [
        if (json.containsKey("alerts"))
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: cardShadowDecoration.copyWith(color: Colors.red.shade50),
              padding: const EdgeInsets.all(12.0),
              child: Text("🚨 ALERT: ${json['alerts']}", style: textStyle(fontSizes[0], color: Colors.red, weight: FontWeight.bold)),
            ),
          ),
        if (json.containsKey("suggestions"))
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: cardShadowDecoration.copyWith(color: Colors.green.shade50),
              padding: const EdgeInsets.all(12.0),
              child: Text("💡 Suggestion: ${json['suggestions']}", style: textStyle(fontSizes[0], color: Colors.green, weight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final json = snapshot.data!;

          final incomeData = json['income_vs_expenditure'];
          final monthlyData = json['monthly_quarterly'];
          final categoryData = json['category_spending'];
          final suspicious = json['suspicious_transactions']['transactions'];
          final balances = json['account_balances']['accounts'];

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildBalanceBox(balances),
                _buildSpendingChart(
                  List<String>.from(incomeData['x']),
                  List<double>.from(incomeData['income']),
                  List<double>.from(incomeData['expenditure']),
                ),
                _buildCategorySpending(
                  List<String>.from(categoryData['categories']),
                  List<double>.from(categoryData['amounts']),
                ),
                _buildSuspiciousTable(suspicious),
                _buildAlertsAndSuggestions(json),
              ],
            ),
          );
        },
    );
  }
}
