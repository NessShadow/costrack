import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CostTrackApp());
}

class CostTrackApp extends StatelessWidget {
  const CostTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CosTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

// Model representing a single expense item
class ExpenseItem {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final String category;

  ExpenseItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.date,
    required this.category,
  });
}

// -------------------------------------------------------------
// SCREEN 1: HOMEPAGE / DASHBOARD
// -------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Global central list of expenses for State Management
  final List<ExpenseItem> _expenses = [
     ];

  void _addExpense(ExpenseItem newExpense) {
    setState(() {
      _expenses.add(newExpense);
    });
  }

  void _updateExpense(String id, ExpenseItem updatedExpense) {
    setState(() {
      final index = _expenses.indexWhere((element) => element.id == id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CosTrack Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 178, 196, 223),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet, size: 80, color: Color.fromARGB(255, 1, 76, 190)),
              const SizedBox(height: 10),
              const Text(
                'Welcome to CosTrack',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text('Track your daily expenses seamlessly.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              
              // Button 1: Add New Expense
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewCostPage()),
                    );
                    if (result != null && result is ExpenseItem) {
                      _addExpense(result);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Cost', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 32, 150),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Button 2: Go to My List View
              SizedBox(
                width: 220,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CostListPage(
                          expenses: _expenses,
                          onUpdate: _updateExpense,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('My List', style: TextStyle(fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color.fromARGB(255, 0, 17, 150), width: 2),
                    foregroundColor: const Color.fromARGB(255, 0, 40, 150),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 2: ADD NEW COST (Form Input & Validation)
// -------------------------------------------------------------
class NewCostPage extends StatefulWidget {
  const NewCostPage({super.key});

  @override
  State<NewCostPage> createState() => _NewCostPageState();
}

class _NewCostPageState extends State<NewCostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedCurrency = 'THB';
  String _selectedCategory = 'Food & Drinks';
  DateTime _selectedDate = DateTime.now();

  final List<String> _currencies = ['THB', 'USD', 'EUR', 'JPY', 'Robux'];
  final List<String> _categories = ['Food & Drinks', 'Transport', 'Shopping', 'Entertainment', 'Others'];

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Cost'),
        backgroundColor: const Color.fromARGB(255, 224, 230, 242),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field with Validation
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Field with Numeric Validation
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid number higher than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Currency Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                ),
                items: _currencies.map((curr) => DropdownMenuItem(value: curr, child: Text(curr))).toList(),
                onChanged: (val) => setState(() => _selectedCurrency = val!),
              ),
              const SizedBox(height: 16),

              // Date Picker Field
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 32),

              // Action Buttons: Record and Cancel
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 20, 150), foregroundColor: Colors.white),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newExpense = ExpenseItem(
                            id: DateTime.now().toString(),
                            title: _titleController.text,
                            amount: double.parse(_amountController.text),
                            currency: _selectedCurrency,
                            date: _selectedDate,
                            category: _selectedCategory,
                          );
                          Navigator.pop(context, newExpense);
                        }
                      },
                      child: const Text('Record'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SCREEN 3: COST LIST PAGE (With Toggles, Sorting, and Dynamic Totals)
// -------------------------------------------------------------
class CostListPage extends StatefulWidget {
  final List<ExpenseItem> expenses;
  final Function(String, ExpenseItem) onUpdate;

  const CostListPage({super.key, required this.expenses, required this.onUpdate});

  @override
  State<CostListPage> createState() => _CostListPageState();
}

class _CostListPageState extends State<CostListPage> {
  String _categoryFilter = 'All';
  String _currencyFilter = 'All';
  bool _sortByAmountAscending = true;

  @override
  Widget build(BuildContext context) {
    // 1. Apply Filtering and Sorting Logic dynamically
    List<ExpenseItem> displayedList = List.from(widget.expenses);

    if (_categoryFilter != 'All') {
      displayedList = displayedList.where((item) => item.category == _categoryFilter).toList();
    }
    if (_currencyFilter != 'All') {
      displayedList = displayedList.where((item) => item.currency == _currencyFilter).toList();
    }

    displayedList.sort((a, b) => _sortByAmountAscending ? a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));

    // 2. Dynamic Summary Total calculation based on items shown
    double totalValue = displayedList.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost List'),
        backgroundColor: const Color.fromARGB(255, 224, 229, 242),
      ),
      body: Column(
        children: [
          // Filter Controls Area (Matches the top filters on your sketch)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category Toggle
                    DropdownButton<String>(
                      value: _categoryFilter,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.filter_alt, size: 18),
                      items: ['All', 'Food & Drinks', 'Transport', 'Shopping', 'Entertainment', 'Others']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (value) => setState(() => _categoryFilter = value!),
                    ),
                    // Currency Toggle
                    DropdownButton<String>(
                      value: _currencyFilter,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.money, size: 18),
                      items: ['All', 'THB', 'USD', 'EUR', 'JPY', 'Robux']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (value) => setState(() => _currencyFilter = value!),
                    ),
                    // Sort Order Toggle
                    IconButton(
                      icon: Icon(_sortByAmountAscending ? Icons.arrow_upward : Icons.arrow_downward, size: 18),
                      tooltip: 'Sort by Amount',
                      onPressed: () {
                        setState(() {
                          _sortByAmountAscending = !_sortByAmountAscending;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),

          // Total Banner Display (Fulfills assignment requirement for Dynamic Totals)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 18, 121),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filtered Sum Total', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  '${totalValue.toStringAsFixed(2)} ${_currencyFilter == 'All' ? 'Units' : _currencyFilter}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Scrollable List (ListView setup)
          Expanded(
            child: displayedList.isEmpty
                ? const Center(child: Text('No expenses match your filters.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedList.length,
                    itemBuilder: (context, index) {
                      final item = displayedList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 226, 224, 242),
                            child: Icon(_getCategoryIcon(item.category), color: const Color.fromARGB(255, 0, 10, 150)),
                          ),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.category} • ${DateFormat('yyyy-MM-dd').format(item.date)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.amount.toStringAsFixed(2)} ${item.currency}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 0, 27, 150)),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                                onPressed: () async {
                                  // Navigates to Edit Screen (Analogous to Edit Cost Page written in sketch)
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditCostPage(expense: item)),
                                  );
                                  if (result != null && result is ExpenseItem) {
                                    widget.onUpdate(item.id, result);
                                    setState(() {});
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Drinks': return Icons.fastfood;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_bag;
      case 'Entertainment': return Icons.movie;
      default: return Icons.payment;
    }
  }
}

// -------------------------------------------------------------
// SCREEN 4: EDIT COST PAGE (Matches "Similar to New Cost Page")
// -------------------------------------------------------------
class EditCostPage extends StatefulWidget {
  final ExpenseItem expense;
  const EditCostPage({super.key, required this.expense});

  @override
  State<EditCostPage> createState() => _EditCostPageState();
}

class _EditCostPageState extends State<EditCostPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _selectedCurrency;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedCurrency = widget.expense.currency;
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Cost')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Enter a valid amount' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 30, 150), foregroundColor: Colors.white),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updated = ExpenseItem(
                      id: widget.expense.id,
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      currency: _selectedCurrency,
                      date: _selectedDate,
                      category: _selectedCategory,
                    );
                    Navigator.pop(context, updated);
                  }
                },
                child: const Text('Save Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}