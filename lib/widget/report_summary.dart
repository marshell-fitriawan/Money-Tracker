import 'package:flutter/material.dart';

class ReportSummary extends StatelessWidget {
  final double totalExp;
  final double totalInc;
  final double balance;

  const ReportSummary({
    super.key,
    required this.totalExp,
    required this.totalInc,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Expence', style: TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 4),
            Text("Rp ${totalExp.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          children: [
            const Text('Balance', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              balance >= 0
                  ? 'Rp +${balance.toStringAsFixed(0)}'
                  : 'Rp ${balance.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Column(
          children: [
            const Text('Income', style: TextStyle(color: Colors.green)),
            const SizedBox(height: 4),
            Text("Rp ${totalInc.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
