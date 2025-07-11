import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/add_tranc.dart';
import '../screens/report.dart';
import '../screens/trancs_screen.dart';
import '../screens/goals_screen.dart';
import '../db/db_helper.dart';
import '../models/trancs.dart';
import '../widget/home_summary.dart';
import '../widget/home_transaction_list.dart';

class ExpenseHomeScreen extends StatefulWidget {
  const ExpenseHomeScreen({super.key});

  @override
  _ExpenseHomeScreenState createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  int _selectedIndex = 0;
  double totalExp = 0;
  double totalInc = 0;
  double balance = 0;
  List<Trancs> _trancs = [];

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final data = await DBHelper().getTransactions();
    double exp = 0;
    double inc = 0;
    for (var t in data) {
      if (t.jenis) {
        inc += t.amount;
      } else {
        exp += t.amount;
      }
    }
    setState(() {
      _trancs = data;
      totalExp = exp;
      totalInc = inc;
      balance = inc - exp;
    });
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4B2354),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                HomeSummary(
                  totalExp: totalExp,
                  totalInc: totalInc,
                  balance: balance,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: HomeTransactionList(trancs: _trancs),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F8),
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
              centerTitle: true,
              title: const Text(
                'Money Manager',
                style: TextStyle(
                  color: Color(0xFF4B2354),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            )
          : null,
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : (_selectedIndex == 1
              ? AddTranc(onChanged: _loadSummary)
              : (_selectedIndex == 2
                  ? const ReportsScreen()
                  : const GoalsScreen())),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 239, 211, 247),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.emoji_events),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoalsScreen(onChanged: _loadSummary),
                    ),
                  );
                  _loadSummary();
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrancsScreen(onChanged: _loadSummary),
                    ),
                  );
                  _loadSummary();
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF4B2354),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTranc(onChanged: _loadSummary),
            ),
          );
          setState(() {
            _selectedIndex = 0;
          });
          _loadSummary();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
