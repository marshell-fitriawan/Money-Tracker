import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trancs.dart';

class HomeTransactionList extends StatelessWidget {
  final List<Trancs> trancs;
  const HomeTransactionList({super.key, required this.trancs});

  @override
  Widget build(BuildContext context) {
    if (trancs.isEmpty) {
      return const Center(child: Text('Belum ada transaksi'));
    }
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return ListView.builder(
      itemCount: trancs.length,
      itemBuilder: (ctx, i) {
        final t = trancs[i];
        final dateStr = DateFormat('dd MMM yyyy').format(t.date);
        return ListTile(
          leading: Icon(
            t.jenis ? Icons.arrow_upward : Icons.arrow_downward,
            color: t.jenis ? Colors.green : Colors.red,
          ),
          title: Text(t.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (t.desc != null && t.desc!.isNotEmpty) Text(t.desc!),
              Text(dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          trailing: Text(
            formatter.format(t.amount),
            style: TextStyle(
              color: t.jenis ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
