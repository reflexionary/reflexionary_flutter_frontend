// Qubera_screen.dart
import 'dart:convert';
import 'dart:ui';
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
  final String defaultFont = 'RobotoMono'; // 👈 Change this to your desired font

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

  Widget _buildBalanceBox(List balances) {
    return Card(
      margin: const EdgeInsets.all(12),
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
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(show: false),
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
    );
  }

  Widget _buildCategorySpending(List<String> categories, List<double> values) {
    return Card(
      margin: const EdgeInsets.all(12),
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
    return Card(
      margin: const EdgeInsets.all(12),
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
            child: Card(
              color: Colors.red.shade50,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("🚨 ALERT: ${json['alerts']}", style: textStyle(fontSizes[0], color: Colors.red, weight: FontWeight.bold)),
              ),
            ),
          ),
        if (json.containsKey("suggestions"))
          Expanded(
            child: Card(
              color: Colors.green.shade50,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("💡 Suggestion: ${json['suggestions']}", style: textStyle(fontSizes[0], color: Colors.green, weight: FontWeight.bold)),
              ),
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