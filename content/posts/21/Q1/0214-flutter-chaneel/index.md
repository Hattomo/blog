---
title: "Flutterが使える機能の管理"
date: 2021-02-14T17:27:04+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["flutter"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Flutterが使える機能はどのように管理されているか"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
少し前に、ひさしぶりに`flutter`のイベント[Flutter Engage](https://events.flutter.dev/)が開かれることが発表されました。コロナウイルスの影響で2020年は、flutterのイベントだけでなく、GoogleIOもなくなってしまい残念でした。

## Flutterの機能管理
Flutterのそれぞれのチャンネルで利用可能なプラットフォームは[ここ](https://github.com/flutter/flutter/blob/master/packages/flutter_tools/lib/src/features.dart)で管理されています。Flutterはオープンソースなのでこの場所を見ることでイベントでの発表を予測することができます。  
たとえば、macOSの部分を見ると

```dart
/// The [Feature] for macOS desktop.
const Feature flutterMacOSDesktopFeature = Feature(
  name: 'beta-quality support for desktop on macOS',
  configSetting: 'enable-macos-desktop',
  environmentOverride: 'FLUTTER_MACOS',
  extraHelpText: flutterNext ?
      'Newer beta versions are available on the beta channel.' : null,
  master: FeatureChannelSetting(
    available: true,
    enabledByDefault: false,
  ),
  dev: FeatureChannelSetting(
    available: true,
    enabledByDefault: false,
  ),
  beta: FeatureChannelSetting(
    available: flutterNext,
    enabledByDefault: false,
  ),
  stable: FeatureChannelSetting(
    available: flutterNext,
    enabledByDefault: false,
  ),
);
```
このようになっています。`available`の部分に`flutterNext`と書かれていますが、ファイルの最後の行に
```dart
const bool flutterNext = true;
```
このように定義されています。この変更は最近なされたものであり、次のイベントでβ版に昇格するということだと考えられます。同じように変更はWindowsとLinux向けにもなされています。Web版はstableリリースとなるようです。 

このほかにも、The fast hot reload feature(singleWidgetReload)やThe CFE experimental invalidation strategy(なんだろう?)などが開発されているようです。(2021/02/14 現在)

気になるのは残るfuchsiaです。Androidを置き換えるのではないかといううわさが出ていますが...。Flutterでは、masterのみで利用できるように設定されています。