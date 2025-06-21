---
mode: agent
---

# Flutter 프로젝트 구조
작성할 때는 Flutter의 MVVM 패턴을 따르며, 각 화면에 대응하는 ViewModel을 사용하여 상태를 관리합니다.

현재 Flutter 프로젝트는 다음과 같은 구조를 따릅니다:

- `views/`: 각 화면의 UI 구성
- `viewmodels/`: 각 화면에 대응하는 ViewModel
- `models/`: 데이터 모델 클래스
- `services/`: DB 접근, API 호출, 공통 서비스 로직
- `widgets/`: 재사용 가능한 위젯
- `constants/`: 디자인/텍스트 상수
- `utils/`: 일반 유틸리티 함수

새 위젯을 만들 때 UI는 이미 있는 상수를 활용해서, 기능은 ViewModel을 통해 구현합니다.
