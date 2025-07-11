import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/trancs.dart';
import '../models/chart_data.dart';
import '../widget/report_summary.dart';
import '../widget/report_donut_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isWeekly = true;
  List<Trancs> _allTransactions = [];
  List<Trancs> _filteredTransactions = [];
  double totalExp = 0;
  double totalInc = 0;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DBHelper().getTransactions();
    setState(() {
      _allTransactions = data;
    });
    _filterTransactions();
  }

  void _filterTransactions() {
    DateTime now = DateTime.now();
    List<Trancs> filtered;
    if (isWeekly) {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      filtered = _allTransactions.where((t) {
        return t.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            t.date.isBefore(endOfWeek.add(const Duration(days: 1)));
      }).toList();
    } else {
      filtered = _allTransactions
          .where((t) => t.date.month == now.month && t.date.year == now.year)
          .toList();
    }

    double exp = 0;
    double inc = 0;
    for (var t in filtered) {
      if (t.jenis) {
        inc += t.amount;
      } else {
        exp += t.amount;
      }
    }
    setState(() {
      _filteredTransactions = filtered;
      totalExp = exp;
      totalInc = inc;
      balance = inc - exp;
    });
  }

  List<ChartData> _getChartData() {
    DateTime now = DateTime.now();
    if (isWeekly) {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      List<double> dailyTotals = List.filled(7, 0);
      for (var t in _filteredTransactions) {
        int idx = t.date.difference(startOfWeek).inDays;
        if (idx < 0 || idx >= 7) continue;
        dailyTotals[idx] += t.jenis ? t.amount : -t.amount;
      }
      const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
      return List.generate(7, (i) => ChartData(days[i], dailyTotals[i]));
    } else {
      List<double> weeklyTotals = List.filled(4, 0);
      DateTime firstDay = DateTime(now.year, now.month, 1);
      for (var t in _filteredTransactions) {
        int dayOfMonth = t.date.day;
        int weekIdx = ((dayOfMonth + firstDay.weekday - 2) / 7).floor();
        if (weekIdx < 0) weekIdx = 0;
        if (weekIdx > 3) weekIdx = 3;
        weeklyTotals[weekIdx] += t.jenis ? t.amount : -t.amount;
      }
      return List.generate(4, (i) => ChartData('W${i + 1}', weeklyTotals[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF4B2354);
    final grey = const Color(0xFFE0DEE2);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Money Report',
          style: TextStyle(
            color: Color(0xFF4B2354),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Toggle Weekly/Monthly
              Container(
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isWeekly = true);
                          _filterTransactions();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isWeekly ? purple : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                color: isWeekly ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isWeekly = false);
                          _filterTransactions();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isWeekly ? purple : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                color:
                                    !isWeekly ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Card dengan ringkasan dan grafik
              Container(
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Text(
                      isWeekly ? 'This Week' : 'This Month',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReportSummary(
                      totalExp: totalExp,
                      totalInc: totalInc,
                      balance: balance,
                    ),
                    const SizedBox(height: 16),
                    // ReportChart(
                    //   chartData: _getChartData(),
                    // ),
                    // Tampilkan hanya donut chart
                    ReportDonutChart(
                      totalExp: totalExp,
                      totalInc: totalInc,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
