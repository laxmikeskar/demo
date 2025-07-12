import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InvestmentForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InvestmentForm extends StatefulWidget {
  const InvestmentForm({super.key});

  @override
  State<InvestmentForm> createState() => _InvestmentFormState();
}

class _InvestmentFormState extends State<InvestmentForm> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  double _timeFrame = 5;
  double _riskValue = 3;
  String _investmentFrequency = 'Recurring';

  // Convert riskValue to label
  String get _riskLabel {
    if (_riskValue <= 2) return "Conservative";
    if (_riskValue >= 4) return "Aggressive";
    return "Moderate";
  }

  void _onRiskRadioChange(String? value) {
    setState(() {
      _riskValue = value == "Conservative" ? 1 : 5;
    });
  }

  void _submitForm() {
    final summary = '''
🎯 Target Amount: ₹${_targetController.text}
📅 Timeframe: ${_timeFrame.toStringAsFixed(0)} years
📊 Risk Appetite: $_riskLabel
🔁 Frequency: $_investmentFrequency
💰 Investment Amount: ₹${_amountController.text}
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Investment Summary'),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Investment Planner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Target Amount
            const Text("🎯 Target amount to achieve"),
            const SizedBox(height: 6),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter target amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Timeframe Slider
            Text("⏳ Select timeframe to achieve (${_timeFrame.toStringAsFixed(0)} years)"),
            Slider(
              value: _timeFrame,
              min: 1,
              max: 30,
              divisions: 29,
              label: _timeFrame.toStringAsFixed(0),
              onChanged: (value) => setState(() => _timeFrame = value),
            ),
            const SizedBox(height: 20),

            // Risk Appetite Slider + Radio
            Text("📊 Risk Appetite ($_riskLabel)"),
            Slider(
              value: _riskValue,
              min: 1,
              max: 5,
              divisions: 4,
              label: _riskLabel,
              onChanged: (value) => setState(() => _riskValue = value),
            ),
            Row(
              children: [
                Radio<String>(
                  value: "Conservative",
                  groupValue: _riskLabel,
                  onChanged: _onRiskRadioChange,
                ),
                const Text("Conservative"),
                const SizedBox(width: 20),
                Radio<String>(
                  value: "Aggressive",
                  groupValue: _riskLabel,
                  onChanged: _onRiskRadioChange,
                ),
                const Text("Aggressive"),
              ],
            ),
            const SizedBox(height: 20),

            // Investment Frequency (on same line)
            const Text("🔁 Investment Frequency"),
            Row(
              children: [
                Radio<String>(
                  value: 'Recurring',
                  groupValue: _investmentFrequency,
                  onChanged: (value) =>
                      setState(() => _investmentFrequency = value!),
                ),
                const Text('Recurring'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Lumpsum',
                  groupValue: _investmentFrequency,
                  onChanged: (value) =>
                      setState(() => _investmentFrequency = value!),
                ),
                const Text('Lumpsum'),
              ],
            ),
            const SizedBox(height: 20),

            // Investment Amount
            const Text("💰 Investment Amount"),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter investment amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Submit
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
