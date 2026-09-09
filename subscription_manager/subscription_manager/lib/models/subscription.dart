// 추가/수정 화면에서 목록 화면으로 결과를 전달할 때 쓰는 클래스
class SubscriptionEditResult {
  final Subscription? subscription;
  final bool deleted;
  SubscriptionEditResult({this.subscription, this.deleted = false});
}

// 구독 서비스 하나를 표현하는 모델 클래스
class Subscription {
  final String id;
  String name; // 서비스 이름 (예: 넷플릭스)
  double price; // 결제 금액
  String category; // 카테고리 (OTT, 음악, 클라우드, 헬스, 기타)
  String billingCycle; // 'monthly' 또는 'yearly'
  DateTime nextPaymentDate; // 다음 결제일
  String memo; // 메모 (선택)

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.billingCycle,
    required this.nextPaymentDate,
    this.memo = '',
  });

  // 이 구독을 한 달 기준으로 환산한 금액 (전체 지출 합산용)
  double get monthlyEquivalent {
    if (billingCycle == 'yearly') {
      return price / 12;
    }
    return price;
  }

  // 다음 결제일까지 남은 일수
  int get daysUntilPayment {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      nextPaymentDate.year,
      nextPaymentDate.month,
      nextPaymentDate.day,
    );
    return target.difference(today).inDays;
  }

  // 결제 완료 처리: 주기에 맞춰 다음 결제일을 자동으로 갱신
  void markAsRenewed() {
    if (billingCycle == 'yearly') {
      nextPaymentDate = DateTime(
        nextPaymentDate.year + 1,
        nextPaymentDate.month,
        nextPaymentDate.day,
      );
    } else {
      final newMonth = nextPaymentDate.month + 1;
      final year = nextPaymentDate.year + (newMonth > 12 ? 1 : 0);
      final month = newMonth > 12 ? newMonth - 12 : newMonth;
      // 말일 넘어가는 경우 방지 (예: 1월 31일 -> 2월 31일 오류 방지)
      final lastDayOfMonth = DateTime(year, month + 1, 0).day;
      final day = nextPaymentDate.day > lastDayOfMonth
          ? lastDayOfMonth
          : nextPaymentDate.day;
      nextPaymentDate = DateTime(year, month, day);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'billingCycle': billingCycle,
      'nextPaymentDate': nextPaymentDate.toIso8601String(),
      'memo': memo,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      billingCycle: json['billingCycle'] as String,
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] as String),
      memo: json['memo'] as String? ?? '',
    );
  }
}
