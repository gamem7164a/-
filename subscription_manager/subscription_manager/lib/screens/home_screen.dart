import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/subscription_card.dart';
import 'add_edit_subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  List<Subscription> _subscriptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _storage.loadSubscriptions();
    // 결제일이 가까운 순으로 정렬
    data.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
    setState(() {
      _subscriptions = data;
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    await _storage.saveSubscriptions(_subscriptions);
  }

  Future<void> _openAddEdit({Subscription? existing}) async {
    final result = await Navigator.push<SubscriptionEditResult>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditSubscriptionScreen(subscription: existing),
      ),
    );

    if (result == null) return;

    setState(() {
      if (result.deleted && existing != null) {
        _subscriptions.removeWhere((s) => s.id == existing.id);
      } else if (existing != null) {
        final index = _subscriptions.indexWhere((s) => s.id == existing.id);
        if (index != -1) _subscriptions[index] = result.subscription!;
      } else if (result.subscription != null) {
        _subscriptions.add(result.subscription!);
      }
      _subscriptions.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
    });
    await _save();
  }

  Future<void> _renew(Subscription subscription) async {
    setState(() {
      subscription.markAsRenewed();
      _subscriptions.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
    });
    await _save();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${subscription.name} 결제일이 다음 주기로 갱신되었어요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('구독 관리', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SummaryCard(subscriptions: _subscriptions),
                  const SizedBox(height: 20),
                  if (_subscriptions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text(
                          '등록된 구독이 없어요.\n오른쪽 아래 + 버튼으로 추가해보세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    )
                  else
                    ..._subscriptions.map(
                      (s) => SubscriptionCard(
                        subscription: s,
                        onTap: () => _openAddEdit(existing: s),
                        onRenew: () => _renew(s),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5B4FE9),
        onPressed: () => _openAddEdit(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

