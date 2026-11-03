# AppleMusicIconAlternative

Apple Music(음악) 앱 아이콘의 대체 이미지와, 그 아이콘을 쓰는 **런처 앱**입니다.
런처 앱은 열자마자 `music://` 으로 Apple Music을 엽니다. 홈 화면에 다른 아이콘의 "음악" 앱을 두고 싶을 때 쓰세요.

> English: alternative Apple Music icon artwork plus a tiny launcher app that opens Apple Music through `music://`.

## 받기

[Releases](../../releases)에서 받을 수 있습니다.

| 파일 | 내용 |
|---|---|
| `AppleMusicIcons.zip` | 아이콘 이미지만 (밝은/다크/틴트 1024px + 기기별 크기) |
| `MusicLauncher.ipa` | 런처 앱 (서명되지 않음, 직접 서명해서 설치) |

## 아이콘

`icons/` 폴더에 있습니다.

- `AppIcon-Light-1024.png` : 기본
- `AppIcon-Dark-1024.png` : 다크모드용. 기본 이미지의 명암을 뒤집어 배경을 완전 검정으로 만들었습니다 (`tools/make_variants.swift`로 자동 생성).
- `AppIcon-Tinted-1024.png` : 틴트 모드용. 흑백이고, iOS가 선택한 색을 입힙니다.
- `legacy/` : `musicValkyrie20x20@2x.png` 처럼 기기별 크기로 나눈 PNG. 이미 만들어진 IPA 안의 아이콘을 직접 바꿀 때 씁니다.

## 런처 앱

- 앱이 활성화될 때마다 `music://` 을 열어 Apple Music으로 넘어갑니다.
- **앱 이름**은 기기 언어가 한국어면 `음악`, 그 외에는 `Music`으로 표시됩니다 (`Resources/*.lproj/InfoPlist.strings`).
- 번들 ID는 기본 `com.MACHU.MusicLauncher` 입니다. 기본 음악 앱의 ID(`com.apple.Music`)와 같으면 설치가 막히기 때문에 `com.apple.` 로 시작하지 않는 값을 쓰세요.
- iOS 16 이상.

### 직접 빌드

Xcode가 설치된 Mac에서:

```sh
./build.sh
# 번들 ID를 바꾸려면
BUNDLE_ID=com.example.Music ./build.sh
```

`build/MusicLauncher.ipa` 가 만들어집니다. ad-hoc 서명만 되어 있으니 Feather, AltStore, Sideloadly 같은 도구로 다시 서명해서 설치하세요.

## 구성

```
Sources/main.m              Objective-C 앱 (music:// 열기)
Resources/Info.plist        앱 정보
Resources/*.lproj           앱 이름 (한국어: 음악)
icons/                      아이콘 이미지
tools/make_variants.swift   기본 아이콘에서 다크/틴트 이미지 생성
build.sh                    IPA 빌드
```

## 안내

아이콘 이미지는 Apple Music 앱 아이콘을 바탕으로 한 비공식 대체 이미지입니다. Apple 및 Apple Music은 Apple Inc.의 상표이며, 이 프로젝트는 Apple과 관련이 없습니다.
