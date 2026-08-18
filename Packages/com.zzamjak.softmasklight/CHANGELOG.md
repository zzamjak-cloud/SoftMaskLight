# Changelog

이 프로젝트의 주요 변경 사항을 기록합니다.
형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/)를 따릅니다.

## [1.0.0] - 2026-08-18

### Added

- 첫 배포. RenderTexture 없는 단일 패스 텍스처 알파 소프트 마스크
  - 추가 드로우콜 0 / 추가 텍스처 메모리 0 / per-frame GC 0
  - 마스크 이동·회전·스케일이 유니폼 갱신만으로 처리됨 (풀스크린 재베이크 없음)
- Image 타입 형태 대응: Simple / Sliced(9-slice) / Tiled / Filled(H·V·Radial 90/180/360)
  - 픽셀당 나눗셈·atan2 없음 (C# 사전 계산: 역수 기울기 + 반평면 2개)
  - fillAmount 런타임 애니메이션 지원, fill 경계 ~1px 소프트 AA
- 중첩 마스크 2단, Sprite Atlas(트리밍 보정), Screen Space Overlay/Camera
- TextMeshPro 지원 (원본 폰트 Material 기준 마스크 Material 공유 — 드로우콜 N→1)
- UIParticle(com.coffee.ui-particle) 지원 — 원본 블렌드 모드 보존 변형 셰이더
- UIEffect(com.coffee.ui-effect) 지원 — "UIEffect Support" 샘플 임포트 방식
  (baseMaterial 기준 공유 프록시로 배칭 유지)
- IMaterialModifier 프록시 패턴 (graphic.material 미수정), RectMask2D/UI Mask 병용 지원
- Optional Shader 자동 등록 인스톨러 (불변 패키지 설치 대응, 원본 부재 변형 빌드 제외)

### Notes

- 마스크 스프라이트는 알파 채널이 필요합니다 (알파 없는 압축 포맷 불가)
- Tiled 마스크 스프라이트는 Generate Mip Maps 해제를 권장합니다
- `fillCenter=false`, `preserveAspect`는 마스크 형태에 반영되지 않습니다
