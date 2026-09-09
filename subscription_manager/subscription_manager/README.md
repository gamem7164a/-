# 구독 서비스 관리 앱 (Subscription Manager)

Flutter로 만든 구독 서비스 관리 앱입니다. 넷플릭스, 유튜브 프리미엄 같은 정기 결제 서비스를 등록해두면, 결제일이 다가올수록 색깔로 알려주고 '갱신하기' 버튼으로 다음 결제일을 자동 계산해줍니다.

## 주요 기능

- 구독 추가 / 수정 / 삭제
- 결제 주기(매월, 매년)에 따른 월 환산 지출 합계 표시
- 결제일까지 남은 일수를 D-day와 색상으로 표시 (3일 이내: 빨강, 7일 이내: 주황)
- '갱신하기'로 다음 결제일 자동 계산
- 서버 없이 기기 로컬(SharedPreferences)에 데이터 저장

## 컴퓨터에 Flutter를 설치하지 않고 APK 만들기 (GitHub Actions)

이 프로젝트에는 `.github/workflows/build.yml`이 이미 포함되어 있어서, GitHub에 코드를 올리기만 하면 GitHub의 서버가 대신 Flutter를 설치하고 APK를 빌드해줍니다.

1. [github.com](https://github.com)에서 새 저장소(Repository)를 만듭니다. Public이든 Private이든 상관없습니다.
2. 이 폴더 전체(압축 푼 subscription_manager 폴더)를 그 저장소에 업로드합니다. GitHub 웹사이트에서 "uploading an existing file" 링크로 파일을 드래그해서 올려도 되고, git 명령어에 익숙하다면 `git init`, `git add .`, `git commit`, `git push`로 올려도 됩니다.
3. 저장소 상단의 **Actions** 탭을 클릭합니다. 코드가 올라가는 순간 자동으로 "Build APK" 워크플로가 시작됩니다. (탭에 아무것도 안 뜨면 좌측에서 "Build APK" 워크플로를 선택하고 우측의 "Run workflow" 버튼을 눌러 수동으로 실행할 수 있습니다.)
4. 빌드는 보통 3~5분 정도 걸립니다. 초록색 체크 표시가 뜨면 완료된 것입니다. 그 실행 기록을 클릭하고 페이지 아래쪽 **Artifacts** 항목에서 `app-release-apk`를 다운로드하면 zip 안에 APK 파일이 들어 있습니다.
5. 그 apk 파일을 폰으로 옮겨서 설치하면 됩니다. (폰에서 "출처를 알 수 없는 앱 설치 허용"을 한 번 켜야 설치가 진행됩니다.)

## 실행 방법 (컴퓨터에 직접 설치하는 경우)

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
