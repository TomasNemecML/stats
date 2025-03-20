import 'package:flutter/material.dart';
import 'progress_chart.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final List<double> data;
  final bool isAverage;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.data,
    this.isAverage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ProgressChart(data: data, isAverage: isAverage),
            ),
          ],
        ),
      ),
    );
  }
}
