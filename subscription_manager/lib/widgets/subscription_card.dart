import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';

// 카테고리별 아이콘 매핑
IconData _iconForCategory(String category) {
  switch (category) {
    case 'OTT':
      return Icons.movie_outlined;
    case '음악':
      return Icons.music_note_outlined;
    case '클라우드':
      return Icons.cloud_outlined;
    case '헬스':
      return Icons.fitness_center_outlined;
    default:
      return Icons.apps_outlined;
  }
}

Color _colorForDday(int days) {
  if (days < 0) return Colors.grey;
  if (days <= 2) return const Color(0xFFE85D5D); // 임박: 빨강
  if (days <= 7) return const Color(0xFFE8A94D); // 곧 다가옴: 주황
  return const Color(0xFF5B4FE9); // 여유 있음: 보라
}

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onTap;
  final VoidCallback onRenew;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onTap,
    required this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');
    final dateFormat = DateFormat('M월 d일');
    final days = subscription.daysUntilPayment;
    final dColor = _colorForDday(days);

    String dLabel;
    if (days < 0) {
      dLabel = '결제일 지남';
    } else if (days == 0) {
      dLabel = '오늘 결제';
    } else {
      dLabel = 'D-$days';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: const Color(0xFFF7F7FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: dColor.withOpacity(0.15),
                radius: 22,
                child: Icon(_iconForCategory(subscription.category), color: dColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currencyFormat.format(subscription.price.round())}원 · '
                      '${subscription.billingCycle == 'yearly' ? '매년' : '매월'} · '
                      '${dateFormat.format(subscription.nextPaymentDate)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: dColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dLabel,
                      style: TextStyle(color: dColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onRenew,
                    child: Text(
                      '갱신하기',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
