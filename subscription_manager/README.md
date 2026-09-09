# 구독 서비스 관리 앱 (Subscription Manager)

Flutter로 만든 구독 서비스 관리 앱입니다. 넷플릭스, 유튜브 프리미엄 같은 정기 결제 서비스를 등록해두면, 결제일이 다가올수록 색깔로 알려주고 '갱신하기' 버튼으로 다음 결제일을 자동 계산해줍니다.

## 주요 기능

- 구독 추가 / 수정 / 삭제
- 결제 주기(매월, 매년)에 따른 월 환산 지출 합계 표시
- 결제일까지 남은 일수를 D-day와 색상으로 표시 (3일 이내: 빨강, 7일 이내: 주황)
- '갱신하기'로 다음 결제일 자동 계산
- 서버 없이 기기 로컬(SharedPreferences)에 데이터 저장

## 실행 방법

1. [Flutter SDK](https://docs.flutter.dev/get-started/install)가 설치되어 있어야 합니다. 터미널에서 `flutter --version`으로 설치를 확인하세요.

2. 이 폴더를 압축 해제한 뒤, 폴더 안에서 아래 명령어로 필요한 안드로이드/iOS 실행 파일 뼈대를 생성합니다. (lib 폴더와 pubspec.yaml은 이미 만들어져 있으므로 덮어쓰지 않습니다.)

   ```bash
   flutter create --platforms=android,ios .
   ```

3. 의존성을 설치합니다.

   ```bash
   flutter pub get
   ```

4. 에뮬레이터나 실제 기기를 연결한 뒤 실행합니다.

   ```bash
   flutter run
   ```

5. 제출용 APK 파일을 만들 때는 아래 명령어를 사용합니다. 빌드가 끝나면 `build/app/outputs/flutter-apk/app-release.apk` 경로에 파일이 생성됩니다.

   ```bash
   flutter build apk --release
   ```

## 폴더 구조

```
lib/
  main.dart                        # 앱 진입점
  models/subscription.dart         # 구독 데이터 모델 + 편집 결과 클래스
  services/storage_service.dart    # 로컬 저장소 (SharedPreferences)
  screens/home_screen.dart         # 목록 화면
  screens/add_edit_subscription_screen.dart  # 추가/수정 화면
  widgets/summary_card.dart        # 상단 지출 요약 카드
  widgets/subscription_card.dart   # 개별 구독 카드
```

## 발표 자료에 쓰기 좋은 포인트

- **문제 정의:** 자동 결제되는 구독 서비스가 늘어나면서 본인도 모르게 새는 지출을 파악하기 어렵다는 점에서 출발했습니다.
- **차별점:** 단순 기록 앱이 아니라, 결제 주기에 맞춰 다음 결제일을 자동 계산하는 로직(`markAsRenewed`)을 직접 구현했습니다. 매월 결제일이 말일 부근인 경우(예: 1월 31일)에도 다음 달 마지막 날로 안전하게 보정하는 예외 처리를 넣었습니다.
- **기술적으로 다룬 것:** 로컬 데이터 영속성(SharedPreferences + JSON 직렬화), 상태 관리(StatefulWidget), 폼 검증(Form, TextFormField validator), 날짜 선택 위젯(showDatePicker) 등을 사용했습니다.

## 확장 아이디어 (시간이 남는다면)

- `flutter_local_notifications` 패키지로 결제 며칠 전 실제 푸시 알림 보내기
- 카테고리별 지출 비중을 파이 차트로 시각화 (`fl_chart` 패키지)
- 구독 목록을 홈 화면 위젯으로 노출하기
