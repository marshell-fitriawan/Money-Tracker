import 'package:flutter/material.dart';
import '../models/trancs.dart';
import '../db/db_helper.dart';
import 'package:intl/intl.dart'; // Pastikan sudah ada import ini
import 'add_tranc.dart'; // Import jika ingin navigasi ke AddTranc untuk edit

class TrancsScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const TrancsScreen({super.key, this.onChanged});

  @override
  State<TrancsScreen> createState() => _TrancsScreenState();
}

class _TrancsScreenState extends State<TrancsScreen> {
  List<Trancs> _userTrancs = [];
  List<Trancs> _filteredTrancs = [];
  int? _selectedIndex;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrancs();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTrancs = _userTrancs
          .where((tranc) =>
              tranc.title.toLowerCase().contains(query) ||
              (tranc.amount.toString().contains(query)))
          .toList();
    });
  }

  void _loadTrancs() async {
    final data = await DBHelper().getTransactions();
    setState(() {
      _userTrancs = data;
      _filteredTrancs = data;
      _selectedIndex = null;
    });
    // Panggil callback jika ada
    if (widget.onChanged != null) widget.onChanged!();
  }

  void _deleteTranc(int id) async {
    await DBHelper().deleteTransaction(id);
    _loadTrancs();
  }

  void _editTranc(Trancs tranc) async {
    // Navigasi ke halaman edit, misal ke AddTranc dengan data lama
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTranc(
          editTranc: tranc,
          onChanged: _loadTrancs,
        ),
      ),
    );
    _loadTrancs();
  }

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final purple = const Color(0xFF4B2354);
    final lightPurple = const Color(0xFFE1D5E7);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: purple,
        centerTitle: true,
        title: const Text(
          'Edit List',
          style: TextStyle(
            color: Color(0xFF4B2354),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B2354)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0DEE2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.black38),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          // List transaksi
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTrancs.length,
              itemBuilder: (ctx, index) {
                final tranc = _filteredTrancs[index];
                final isIncome = tranc.jenis;
                final amountColor = isIncome ? Colors.green : Colors.red;
                final arrowIcon =
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward;
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Card(
                    color: isSelected
                        ? lightPurple.withOpacity(0.5)
                        : Colors.white,
                    elevation: 0,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: lightPurple,
                        child: Icon(
                          arrowIcon,
                          color: amountColor,
                        ),
                      ),
                      title: Text(
                        tranc.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tranc.desc != null && tranc.desc!.isNotEmpty)
                            Text(tranc.desc!),
                          Text(
                            DateFormat('dd MMM yyyy').format(tranc.date),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Text(
                        formatter.format(tranc.amount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Tombol Edit & Delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _selectedIndex != null
                        ? () => _editTranc(_filteredTrancs[_selectedIndex!])
                        : null,
                    child: const Text('Edit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _selectedIndex != null
                        ? () =>
                            _deleteTranc(_filteredTrancs[_selectedIndex!].id!)
                        : null,
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
