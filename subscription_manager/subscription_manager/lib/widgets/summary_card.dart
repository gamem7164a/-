import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

// 상단에 표시되는 월 지출 합계 요약 카드
class SummaryCard extends StatelessWidget {
  final List<Subscription> subscriptions;

  const SummaryCard({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    final double totalMonthly = subscriptions.fold(
      0,
      (sum, item) => sum + item.monthlyEquivalent,
    );

    // 7일 이내에 결제가 예정된 구독 개수
    final int upcomingCount = subscriptions
        .where((s) => s.daysUntilPayment <= 7 && s.daysUntilPayment >= 0)
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B4FE9), Color(0xFF8B7FF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이번 달 예상 지출',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            '${currencyFormat.format(totalMonthly.round())}원',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStat('등록된 구독', '${subscriptions.length}개'),
              const SizedBox(width: 24),
              _buildStat('7일 내 결제', '$upcomingCount개'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
