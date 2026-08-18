# SoftMaskLight

RenderTexture 없이 **단일 패스**로 동작하는 모바일 최적화 소프트 마스크 UPM 패키지입니다.

이 레포지토리는 **개발용 Unity 프로젝트**이며, 패키지 본체는 [`Packages/com.zzamjak.softmasklight`](Packages/com.zzamjak.softmasklight)에 임베디드되어 있습니다.

## 특징

- 추가 드로우콜 0 / 추가 텍스처 메모리 0 / per-frame GC 0 — 마스크 이동·애니메이션이 유니폼 갱신만으로 처리
- Image 타입 형태 대응: Simple / Sliced(9-slice) / **Tiled** / **Filled(H·V·Radial 90/180/360, fillAmount 애니메이션)**
- 픽셀당 나눗셈·atan2 없는 셰이더 경로 (C# 사전 계산)
- 중첩 마스크 2단, Sprite Atlas, Screen Space Overlay/Camera
- TextMeshPro / UIParticle / UIEffect(샘플) 지원, RectMask2D·UI Mask 병용 가능

## 설치

### OpenUPM (권장)

Project Settings → Package Manager → Scoped Registries:

```
Name:   OpenUPM
URL:    https://package.openupm.com
Scopes: com.zzamjak
```

Package Manager → My Registries에서 **SoftMaskLight** 설치.

### Git URL

Unity Package Manager → Install package from git URL:

```
https://github.com/zzamjak-cloud/SoftMaskLight.git?path=/Packages/com.zzamjak.softmasklight#v1.0.0
```

## 빠른 시작

1. 마스크로 쓸 `Image`(알파 채널 있는 스프라이트)에 `SoftMaskLight` 컴포넌트 추가
2. 마스킹할 UI를 자식으로 배치 — 끝. (Softness/Invert는 인스펙터에서 조절)
3. UIEffect와 함께 쓰려면 Package Manager에서 **"UIEffect Support" 샘플** 임포트

## 문서

- [패키지 README — 아키텍처, 커스텀 셰이더 대응, 제약사항](Packages/com.zzamjak.softmasklight/README.md)
- [CHANGELOG](Packages/com.zzamjak.softmasklight/CHANGELOG.md)
- [LICENSE (MIT)](Packages/com.zzamjak.softmasklight/LICENSE.md)
