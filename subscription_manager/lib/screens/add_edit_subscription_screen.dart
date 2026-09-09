import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/subscription.dart';

const List<String> kCategories = ['OTT', '음악', '클라우드', '헬스', '기타'];

class AddEditSubscriptionScreen extends StatefulWidget {
  final Subscription? subscription; // null이면 신규 추가

  const AddEditSubscriptionScreen({super.key, this.subscription});

  @override
  State<AddEditSubscriptionScreen> createState() => _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState extends State<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _memoController;
  late String _category;
  late String _billingCycle;
  late DateTime _nextPaymentDate;

  bool get _isEditing => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    _nameController = TextEditingController(text: s?.name ?? '');
    _priceController = TextEditingController(
      text: s != null ? s.price.round().toString() : '',
    );
    _memoController = TextEditingController(text: s?.memo ?? '');
    _category = s?.category ?? kCategories.first;
    _billingCycle = s?.billingCycle ?? 'monthly';
    _nextPaymentDate = s?.nextPaymentDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextPaymentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() => _nextPaymentDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final subscription = Subscription(
      id: widget.subscription?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _category,
      billingCycle: _billingCycle,
      nextPaymentDate: _nextPaymentDate,
      memo: _memoController.text.trim(),
    );

    Navigator.pop(
      context,
      SubscriptionEditResult(subscription: subscription),
    );
  }

  void _delete() {
    Navigator.pop(context, SubscriptionEditResult(deleted: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '구독 수정' : '구독 추가'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '서비스 이름 (예: 넷플릭스)'),
              validator: (v) => (v == null || v.trim().isEmpty) ? '이름을 입력해주세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: '결제 금액 (원)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '금액을 입력해주세요';
                if (double.tryParse(v.trim()) == null) return '숫자만 입력해주세요';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: '카테고리'),
              items: kCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 16),
            const Text('결제 주기', style: TextStyle(fontSize: 13, color: Colors.grey)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('매월'),
                    value: 'monthly',
                    groupValue: _billingCycle,
                    onChanged: (v) => setState(() => _billingCycle = v!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('매년'),
                    value: 'yearly',
                    groupValue: _billingCycle,
                    onChanged: (v) => setState(() => _billingCycle = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('다음 결제일'),
              subtitle: Text(
                '${_nextPaymentDate.year}년 ${_nextPaymentDate.month}월 ${_nextPaymentDate.day}일',
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(labelText: '메모 (선택)'),
              maxLines: 2,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B4FE9),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_isEditing ? '수정 완료' : '추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}
