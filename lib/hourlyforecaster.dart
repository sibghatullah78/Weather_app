import 'package:flutter/material.dart';

class HourlyForecaster extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;
  const HourlyForecaster(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Icon(
              icon,
              size: 32,
            ),
            Text(
              temp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
