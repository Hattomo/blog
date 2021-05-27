---
title: "UbuntuをアップデートしたらNvidia Driverが壊れた"
date: 2021-04-16T23:22:08+09:00
lastmod: 2021-05-27T23:13:25+09:00
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
description: "UbuntuをアップデートしたらNvidia Driverが壊れた際の修正方法"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---

## はじめに
先日、`Ubuntu`を`apt update`&`apt upgrade`をして再起動したら、見事にGeForceのドライバーが認識しなくなったので、その対応方法をメモします。

## 環境
OS  : Ubuntu20.04  
GPU : Geforce 1080Ti

## 症状
- マルチモニター環境で、片方はGPU、もう片方は、マザーボードから出力しているが、GPUに接続している画面が映らなくなった。
- もちろん`nvidia-smi`などのコマンドもつかうことができなかった
- 起動時に`Esc`キーを押して`Grub Menu`に入り、アップデート前のカーネルから起動するとGPUを認識し、普通に使うことができる。

## 対応方法
いろいろ試したのですが、結局ドライバーを再インストールし、再起動することで直りました。ドライバーのインストール中にカーネル関係のログが出てたので、ドライバーとカーネルが密接な関係にあり、カーネルのアップデートの後には、ドライバーを入れなおす必要がある場合もあるようです。
以下はドライバーの再インストールの方法です。`sudo apt purge nvidia-driver-xxx`のみでアンインストールした場合は、うまくいきませんでした。

```bash
sudo apt update
sudo apt upgrade

# uninstall nvidia driver
sudo apt purge nvidia-*
sudo apt purge cuda-*

# check driver
ubuntu-drivers devices
# install driver
sudo ubuntu-drivers install
# check GPU status
nvidia-smi
```