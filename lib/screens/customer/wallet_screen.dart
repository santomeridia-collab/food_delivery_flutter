import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/providers/user_provider.dart';
import 'package:food_delivery/screens/customer/providers/wallet_provider.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/customer/widgets/transaction_card.dart';
import 'package:provider/provider.dart';
import 'models/transaction_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final user = userProvider.currentUser;
    final transactions = walletProvider.transactions;

    final creditTransactions =
        transactions.where((t) => t.type == TransactionType.credit).toList();
    final debitTransactions =
        transactions.where((t) => t.type == TransactionType.debit).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$${user.walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showAddMoneyDialog(context);
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Money'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text('Send'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Transaction History Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Credits'),
              Tab(text: 'Debits'),
            ],
          ),

          // Tab Bar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(transactions),
                _buildTransactionList(creditTransactions),
                _buildTransactionList(debitTransactions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.sp, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            Text(
              'No transactions yet',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionCard(transaction: transactions[index]);
      },
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    double amount = 0;
    final List<double> presetAmounts = [10, 20, 50, 100];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Money to Wallet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),

                  // Preset Amounts
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children:
                        presetAmounts.map((preset) {
                          return ChoiceChip(
                            label: Text('\$$preset'),
                            selected: amount == preset,
                            onSelected: (selected) {
                              setState(() {
                                amount = preset;
                              });
                            },
                            selectedColor: AppTheme.primaryColor,
                            backgroundColor: Colors.grey.shade100,
                            labelStyle: TextStyle(
                              color:
                                  amount == preset
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 16.h),

                  // Custom Amount
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Custom Amount',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        amount = double.tryParse(value) ?? 0;
                      });
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed:
                          amount > 0
                              ? () {
                                Navigator.pop(context);
                                _processAddMoney(amount);
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Add \$${amount.toStringAsFixed(2)}'),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _processAddMoney(double amount) async {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // Close loading dialog

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    userProvider.addWalletBalance(amount);
    walletProvider.addTransaction(
      amount: amount,
      type: TransactionType.credit,
      description: 'Added money to wallet',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\$${amount.toStringAsFixed(2)} added to wallet'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
