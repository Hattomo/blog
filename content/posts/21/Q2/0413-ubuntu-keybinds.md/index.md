---
title: "Ubuntuでキーバインドをカスタマイズする"
date: 2021-04-13T09:36:35+09:00
lastmod: 2021-04-13T09:36:35+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: [""]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Ubuntuでキーバインドをカスタムする方法"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---

# はじめに
研究室のPCが与えられ、OSが`Ubuntu`でした。`Ubuntu`でデフォルトで使えるキーバンドをカスタマイズしたので方法をまとめておきます。変更したキーバインドは以下のようです。
1. 変換、無変換で日本語、英語を切り替える
1. `emacs`流のキーバインド(→,↓,←,↑,backspace,delete,home,end)
1. `Ctrl`と`Alt`を入れ替える。

受け取った際、`Mozc`はすでにインストールされていました。追加でインストールしたのは、以下のソフトウェアです。`autokey-gtk`については、aptでインストールされるものは古いので、GitHubのリーリスにあるものをインストールした方がいいというブログもありましたが、aptでインストールされるものとバージョンは同じだったので、aptでインストールを行いました。

```sh
$ sudo apt install gnome-tweak-tool autokey-gtk dconf-editor
```

# カスタマイズ!
## 変換、無変換で日本語、英語を切り替える
これは`Mozc`の設定で行いました。`Mozc`の設定を開き、henkan,muhenkanの枠をそれぞれ、`IMEの有効化`,`IMEの無効化`に設定します。[Ubuntu18.04にて、半角 / 全角の切り替えをMac風に行なう方法](https://magidropack.hatenablog.com/entry/2018/11/30/120602)と同じように行いました。

## `emacs`流のキーバインド
`emacs`流のキーバインドを設定したのは、macを使っていたため、単に慣れていることと、`CapsLock`を押してしまい、入力設定が変化してしまうため、イライラしていたためです。  
これを行うために、`autokey`[GitHub](https://github.com/autokey/autokey)をインストールしました。`x11`環境向けに開発されているようで`wayland`の環境では100%は動作しないようです。`Ubuntu21.04`からは`wayland`がデフォルトになるようなので`wayland`でも使えるツールあるといいのですが、探したところ見つかりませんでした。autokeyをインストールしてからの設定は[LinuxでMacっぽくCmd,Ctrlキーを使い分ける](https://qiita.com/MTfirst/items/61bc6b8d3da9742b4130)を参考にしました。しかし、`hyper(CapsLock)+P`でウインドウの設定が起動してしまうため、このショートカットを無効にしました。この方法は[stackoverflow](https://askubuntu.com/questions/68463/how-to-disable-global-super-p-shortcut)にズバリな質問がありました。設定を行った後、再起動したところ反映されました。

## `Ctrl`と`Alt`を入れ替える
`Tweak`で行いました。`Keyboard & Mouse` > `Additional Layout Options`から、`Caps Lock behavior`を Make additional Hyperに
`Ctrl position`を`Swap Left Alt with Left Ctrl`に設定

# Reference
上の文中であげさせていただきました。先人たちの知見に感謝します。