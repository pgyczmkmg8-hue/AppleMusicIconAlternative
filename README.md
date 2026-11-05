# AppleMusicIconAlternative

Apple Music(음악) 앱 아이콘의 대체 이미지와, 그 아이콘을 쓰는 **아이콘 앱**입니다.
홈 화면에 다른 아이콘의 "음악" 앱을 두고, 누르면 Apple Music이 열리게 할 때 쓰세요.

> English: alternative Apple Music icon artwork plus a tiny app that carries it. Pair the app with a Shortcuts automation and tapping it opens Apple Music.

## 받기

[Releases](../../releases)에서 받을 수 있습니다.

| 파일 | 내용 |
|---|---|
| `AppleMusicIcons.zip` | 아이콘 이미지만 (밝은/다크/틴트 1024px + 기기별 크기) |
| `MusicLauncher.ipa` | 아이콘 앱 (서명되지 않음, 직접 서명해서 설치) |

## 아이콘

`icons/` 폴더에 있습니다.

- `AppIcon-Light-1024.png` : 기본
- `AppIcon-Dark-1024.png` : 다크모드용. 기본 이미지의 명암을 뒤집어 배경을 완전 검정으로 만들었습니다 (`tools/make_variants.swift`로 자동 생성).
- `AppIcon-Tinted-1024.png` : 틴트 모드용. 흑백이고, iOS가 선택한 색을 입힙니다.
- `legacy/` : `musicValkyrie20x20@2x.png` 처럼 기기별 크기로 나눈 PNG. 이미 만들어진 IPA 안의 아이콘을 직접 바꿀 때 씁니다.

## 아이콘 앱

v1.1.0부터 앱은 **실행하자마자 스스로 종료**하고, Apple Music은 **단축어 자동화**가 엽니다.
화면이 생기기 전에 끝나서 멀티태스킹 창에 앱 카드가 남지 않습니다. 앱이 직접 음악을 열던 이전 방식은 앱이 화면에 한 번 떠서 카드가 남았습니다.

- **앱 이름**은 기기 언어가 한국어면 `음악`, 그 외에는 `Music`으로 표시됩니다 (`Resources/*.lproj/InfoPlist.strings`).
- 번들 ID는 기본 `com.MACHU.MusicLauncher` 입니다. 기본 음악 앱의 ID(`com.apple.Music`)와 같으면 설치가 막히기 때문에 `com.apple.` 로 시작하지 않는 값을 쓰세요.
- iOS 16 이상.
- 실행할 때마다 크래시 기록이 쌓입니다. 일부러 종료하는 방식이라 정상입니다.

### 단축어 자동화 만들기

앱만 설치해서는 아무것도 열리지 않습니다. 설치한 뒤 한 번만 만들어 두세요.

1. 단축어 앱 → **자동화** → 새로운 자동화 → **앱**
2. 이 앱(`음악` 또는 `Music`)을 고르고 **열었을 때**를 선택
3. **즉시 실행**을 켜고, **실행 시 알림**은 끄기
4. 동작에서 **앱 열기**를 고르고 **음악**을 선택

앱 이름이 기본 음악 앱과 같아서 목록에서 헷갈리기 쉽습니다. 처음 만들 때 아이콘으로 구분하거나, 앱을 고르는 화면에서 이 앱이 맞는지 확인하세요.
자동화는 앱의 번들 ID에 묶입니다. 번들 ID를 바꿔 다시 설치하면 자동화에서 앱을 다시 골라야 할 수 있습니다.

### 앱이 직접 음악을 열게 하려면

자동화 없이 쓰고 싶으면 직접 빌드할 때 `DIRECT_OPEN=1`을 붙이세요. 앱이 `music://` 으로 Apple Music을 열고, 돌아올 때마다 다시 엽니다.
대신 앱이 화면에 한 번 뜨기 때문에 멀티태스킹 창에 카드가 남습니다.

### 직접 빌드

Xcode가 설치된 Mac에서:

```sh
./build.sh
# 앱이 직접 music:// 을 열게 하려면
DIRECT_OPEN=1 ./build.sh
# 번들 ID를 바꾸려면
BUNDLE_ID=com.example.Music ./build.sh
```

`build/MusicLauncher.ipa` 와 `build/AppleMusicIcons.zip` 이 만들어집니다. IPA는 ad-hoc 서명만 되어 있으니 Feather, AltStore, Sideloadly 같은 도구로 다시 서명해서 설치하세요.

## 구성

```
Sources/main.m              Objective-C 앱 (기본: 즉시 종료, DIRECT_OPEN: music:// 열기)
Resources/Info.plist        앱 정보
Resources/*.lproj           앱 이름 (한국어: 음악)
icons/                      아이콘 이미지
tools/make_variants.swift   기본 아이콘에서 다크/틴트 이미지 생성
build.sh                    IPA와 아이콘 zip 빌드
```

## 안내

아이콘 이미지는 Apple Music 앱 아이콘을 바탕으로 한 비공식 대체 이미지입니다. Apple 및 Apple Music은 Apple Inc.의 상표이며, 이 프로젝트는 Apple과 관련이 없습니다.
