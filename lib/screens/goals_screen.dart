import 'package:flutter/material.dart';
import '../models/goals.dart';
import '../db/db_helper.dart';

class GoalsScreen extends StatefulWidget {
  final VoidCallback? onChanged; // Tambahkan ini
  const GoalsScreen({super.key, this.onChanged});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _targetController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  List<Goal> _goals = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final data = await DBHelper().getGoals();
    setState(() {
      _goals = data;
      _selectedIndex = null;
    });
  }

  Future<void> _saveGoal() async {
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) return;
    final goal = Goal(
      title: _titleController.text,
      desc: _descController.text,
      target: double.tryParse(_targetController.text) ?? 0,
    );
    await DBHelper().insertGoal(goal);
    _titleController.clear();
    _descController.clear();
    _targetController.clear();
    await _loadGoals();
    widget.onChanged?.call(); // Panggil callback setelah save
  }

  Future<void> _editGoal() async {
    if (_selectedIndex == null) return;
    final goal = _goals[_selectedIndex!];
    _titleController.text = goal.title;
    _descController.text = goal.desc;
    _targetController.text = goal.target.toString();
    await DBHelper().deleteGoal(goal.id!);
    setState(() {
      _selectedIndex = null;
    });
    widget.onChanged?.call(); // Panggil callback setelah edit
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF4B2354);
    final grey = const Color(0xFFE0DEE2);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: purple,
          centerTitle: true,
          title: const Text(
            'Goals',
            style: TextStyle(
              color: Color(0xFF4B2354),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4B2354)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Input fields
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Target (Jumlah Tujuan)',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description (Optional)',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // List goals
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Card(
                      color: isSelected ? grey.withOpacity(0.5) : Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? purple : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: purple, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.circle,
                                color: Colors.deepOrange, size: 16),
                          ),
                        ),
                        title: Text(
                          goal.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B2354),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target: ${goal.target.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              goal.desc,
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Tombol Edit, Save, Delete
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        onPressed: _selectedIndex != null ? _editGoal : null,
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
                        onPressed: _saveGoal,
                        child: const Text('Save',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: _selectedIndex != null
                            ? () async {
                                final goal = _goals[_selectedIndex!];
                                await DBHelper().deleteGoal(goal.id!);
                                setState(() {
                                  _selectedIndex = null;
                                });
                                await _loadGoals();
                                widget.onChanged
                                    ?.call(); // Panggil callback setelah delete
                              }
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
        ),
      ),
    );
  }
}
