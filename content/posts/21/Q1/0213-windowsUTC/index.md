---
title: "Windowsの時間をUTCで管理する"
date: 2021-02-13T19:18:41+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["windows"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Windowsの時間をUTCで管理する方法"
# disableHLJS: true # to disable highlightjs
# disableShare: false
# disableHLJS: false

# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
WindowsをLinuxやmacOS(bootcampでない)とデュアルブートしていると、OSの時計表示がおかしくなってしまうことがあります。

## どうしておかしくなるのか
Windowsは内部でローカルの時間を利用しています。日本であればUTC+09:00です。電源を切るとき、BIOSにこの値を保存します。BIOSは搭載された電池によって、この値を保持・更新し、次回Windowsが起動する際にWindowsに渡します。しかし、LinuxやmacOSでは、UTCそのもので時間を管理し、表示する際にはタイムゾーンに合わせた値を計算します。このため、例えば、WindowsがUTC+09:00としてシャットダウン時に保存した値をLinuxはUTCと解釈してしまうのです。逆もまた然りです。このため、どちらかの方法に統一する必要があります。今回はWindowsの時間管理をUTCにあわせます。

## WindowsをUTCに
コマンドプロンプトを開いて以下のコマンドを実行します。
```cmd
# set UTC
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```
戻す際は、下のコマンドを実行してください。
```cmd
# unset
reg delete HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /f
```
このあと時刻表示がおかしくなっているOSをNTPサーバーと同期して正しい時刻に修正すれば、完了です。