import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart'; // For generating unique user IDs


class LighthouseHomePage extends StatefulWidget {
  const LighthouseHomePage({super.key});

  @override
  State<LighthouseHomePage> createState() => _LighthouseHomePageState();
}

class _LighthouseHomePageState extends State<LighthouseHomePage> {
  final String _baseUrl = 'http://127.0.0.1:8000'; // *IMPORTANT: Update if your FastAPI backend is on a different address/port*
  late String _userId; // Will be generated or fetched (mocked)
  final TextEditingController _memoryController = TextEditingController();

  List<dynamic> _memories = [];
  Map<String, dynamic>? _analysisResults;
  Map<String, dynamic>? _compassResults;
  Map<String, dynamic>? _whatIfResults;

  bool _isLoadingMemories = false;
  bool _isLoadingAnalysis = false;
  bool _isLoadingCompass = false;
  bool _isLoadingWhatIf = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // Mock user initialization - in a real app, this would involve Firebase Auth
  void _initializeUser() {
    // For demo purposes, generate a unique ID. In a real app, this would come from Firebase Auth.
    _userId = const Uuid().v4();
    print('Generated User ID: $_userId');
    _fetchMemories(); // Fetch existing memories for this mock user
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --- API Calls to FastAPI Backend ---

  Future<void> _addMemory() async {
    if (_memoryController.text.isEmpty) {
      _showErrorDialog('Please enter a memory.');
      return;
    }

    setState(() {
      _isLoadingMemories = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add-memory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': _userId,
          'text': _memoryController.text,
        }),
      );

      if (response.statusCode == 200) {
        _memoryController.clear();
        await _fetchMemories(); // Refresh memories list
      } else {
        _showErrorDialog('Failed to add memory: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error adding memory: $e');
    } finally {
      setState(() {
        _isLoadingMemories = false;
      });
    }
  }

  Future<void> _fetchMemories() async {
    setState(() {
      _isLoadingMemories = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse('$_baseUrl/get-memories/$_userId'));
      if (response.statusCode == 200) {
        setState(() {
          _memories = jsonDecode(response.body);
        });
      } else {
        _showErrorDialog('Failed to load memories: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error fetching memories: $e');
    } finally {
      setState(() {
        _isLoadingMemories = false;
      });
    }
  }

  Future<void> _runFullAnalysis() async {
    setState(() {
      _isLoadingAnalysis = true;
      _errorMessage = null;
      _analysisResults = null; // Clear previous results
    });

    try {
      final response = await http.post(Uri.parse('$_baseUrl/run-full-analysis/$_userId'));
      if (response.statusCode == 200) {
        setState(() {
          _analysisResults = jsonDecode(response.body);
        });
      } else {
        _showErrorDialog('Failed to run analysis: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error running analysis: $e');
    } finally {
      setState(() {
        _isLoadingAnalysis = false;
      });
    }
  }

  Future<void> _getLighthouseCompass() async {
    setState(() {
      _isLoadingCompass = true;
      _errorMessage = null;
      _compassResults = null; // Clear previous results
    });

    try {
      // First, ensure deterministic recommendations are generated (if not already)
      await http.post(Uri.parse('$_baseUrl/generate-deterministic-recommendations/$_userId'));

      final response = await http.get(Uri.parse('$_baseUrl/lighthouse-compass/$_userId'));
      if (response.statusCode == 200) {
        setState(() {
          _compassResults = jsonDecode(response.body);
        });
      } else {
        _showErrorDialog('Failed to get Compass insights: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error getting Compass insights: $e');
    } finally {
      setState(() {
        _isLoadingCompass = false;
      });
    }
  }

  Future<void> _runWhatIfScenario(String scenarioType) async {
    setState(() {
      _isLoadingWhatIf = true;
      _errorMessage = null;
      _whatIfResults = null; // Clear previous results
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/what-if-scenario/$_userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': _userId,
          'scenario_type': scenarioType,
          'periods': 60, // Simulate for 60 days
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _whatIfResults = jsonDecode(response.body);
        });
      } else {
        _showErrorDialog('Failed to run What-If scenario: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error running What-If scenario: $e');
    } finally {
      setState(() {
        _isLoadingWhatIf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lighthouse: Your Financial Co-pilot'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User ID Display
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Lighthouse ID:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blueGrey[600]),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _userId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                            fontFamily: 'monospace',
                          ),
                    ),
                    const Text(
                      'This ID links your app to your unique financial profile.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // Digital Financial Autobiography (Memory Layer)
            _buildSection(
              context,
              title: '1. Digital Financial Autobiography',
              description: 'Add your financial thoughts, goals, and experiences. Tethys learns from these.',
              children: [
                TextField(
                  controller: _memoryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'e.g., "My goal is to save for a down payment by 2030." or "I felt anxious during the last market dip."',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoadingMemories ? null : _addMemory,
                  icon: _isLoadingMemories ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.add),
                  label: Text(_isLoadingMemories ? 'Adding...' : 'Add Memory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Your Memories:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _memories.isEmpty
                    ? const Text('No memories yet. Add some above!', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _memories.length,
                        itemBuilder: (context, index) {
                          final memory = _memories[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(memory['text'], style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Added: ${DateTime.parse(memory['timestamp']).toLocal().toString().split('.')[0]}',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
            const SizedBox(height: 24),

            // Intelligent Insight Generation (Tethys Analysis)
            _buildSection(
              context,
              title: '2. Tethys: Intelligent Insight Generation',
              description: 'Run Tethys\'s full analysis to detect anomalies, forecast trends, and get strategic parameters.',
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoadingAnalysis ? null : _runFullAnalysis,
                  icon: _isLoadingAnalysis ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.analytics),
                  label: Text(_isLoadingAnalysis ? 'Analyzing...' : 'Run Full Analysis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (_analysisResults != null) ...[
                  const SizedBox(height: 16),
                  Text('Analysis Results (from Tethys):', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: Colors.teal[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alert Message: ${_analysisResults!['alert_message']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Behavioral Mirror Insight: ${_analysisResults!['behavioral_mirror_insight']}'),
                          const SizedBox(height: 8),
                          Text('Detected Anomalies: ${(_analysisResults!['anomalies'] as List).length}'),
                          // You can expand to show details of anomalies and forecasts here
                          if ((_analysisResults!['anomalies'] as List).isNotEmpty)
                            ExpansionTile(
                              title: const Text('View Anomalies'),
                              children: (_analysisResults!['anomalies'] as List).map((anomaly) {
                                return ListTile(
                                  title: Text(anomaly['description']),
                                  subtitle: Text('Type: ${anomaly['type']} on ${anomaly['date'].split('T')[0]}'),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Rational Recommendation Core (Lighthouse Compass)
            _buildSection(
              context,
              title: '3. Lighthouse: The Rational Compass',
              description: 'Get objective, bias-free recommendations and a summary of your emotional vs. logical pull.',
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoadingCompass ? null : _getLighthouseCompass,
                  icon: _isLoadingCompass ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.explore),
                  label: Text(_isLoadingCompass ? 'Getting Compass...' : 'Get Lighthouse Compass'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (_compassResults != null) ...[
                  const SizedBox(height: 16),
                  Text('Lighthouse Compass Insights:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: Colors.indigo[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary: ${_compassResults!['compass_summary']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Behavioral Mirror: ${_compassResults!['behavioral_mirror_insight']}'),
                          const SizedBox(height: 8),
                          Text('Pre-Commitment Anchors:', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ...(_compassResults!['pre_commitment_anchors'] as List).map((anchor) => Text('- $anchor')),
                          const SizedBox(height: 8),
                          Text('Rational Recommendations:', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ...(_compassResults!['rational_recommendations'] as List).isEmpty
                              ? [const Text('No specific recommendations at this moment.')]
                              : (_compassResults!['rational_recommendations'] as List).map((rec) => Text('- ${rec['description']}')).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // What-If Scenario Simulation
            _buildSection(
              context,
              title: '4. What-If Scenario Simulation',
              description: 'See the potential impact of different decisions (e.g., emotional vs. rational).',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoadingWhatIf ? null : () => _runWhatIfScenario('fear_sell'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Simulate Fear-Sell'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoadingWhatIf ? null : () => _runWhatIfScenario('rational_hold'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Simulate Rational-Hold'),
                      ),
                    ),
                  ],
                ),
                if (_isLoadingWhatIf)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_whatIfResults != null) ...[
                  const SizedBox(height: 16),
                  Text('What-If Scenario Outcome:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scenario: ${_whatIfResults!['scenario_type']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Description: ${_whatIfResults!['description']}'),
                          const SizedBox(height: 8),
                          Text('Projected Outcome:', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('  Income Impact: \$${_whatIfResults!['projected_outcome']['income_impact']?.toStringAsFixed(2)}'),
                          Text('  Expenditure Impact: \$${_whatIfResults!['projected_outcome']['expenditure_impact']?.toStringAsFixed(2)}'),
                          Text('  Portfolio Value Change: \$${_whatIfResults!['projected_outcome']['portfolio_value_change']?.toStringAsFixed(2)}'),
                          // In a full app, you'd use a charting library here with _whatIfResults!['chart_data']
                          const SizedBox(height: 8),
                          const Text(' (Chart visualization would go here)', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String description, required List<Widget> children}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const Divider(height: 24, thickness: 1, color: Colors.blueGrey),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _memoryController.dispose();
    super.dispose();
  }
}