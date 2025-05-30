## 프로젝트 소개

상태관리 라이브러리 BLoC을 사용하여 구현한 날씨 애플리케이션입니다.

SharedPreferences를 통해 로컬 저장소에 위치와 날씨 정보를 저장하고,

앱 실행 시 이를 먼저 화면에 표시한 뒤, API를 통해 최신 날씨 정보를 불러와 갱신합니다.



위치 정보 업데이트 시 Method Channel을 사용하여 플랫폼에 전달하고,

iOS에서 UserDefaults, App Group을 사용하여 위젯에 전달하고 타임라인을 업데이트합니다.

---

### 앱 내부 화면

<img width="794" alt="스크린샷 2025-05-28 오후 5 58 55" src="https://github.com/user-attachments/assets/ec14f8bc-0b6f-4dff-a6d6-821d3d5339f7" />


### iOS 위젯 화면

<img width="789" alt="image" src="https://github.com/user-attachments/assets/3fda5865-4fab-4b4f-9e03-4b17b34c57d5" />

