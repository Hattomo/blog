---
title: "自作OS 0 環境構築"
date: 2021-02-23T13:53:51+09:00
lastmod: 2021-05-27T23:13:24+09:00
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["自作OS"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Desc Text."
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
OSはどのように動いているのか気になり、自作をしてみることにしました。基本の用語から何もわからん...。
`Rust`+`RISC-V` でいきたい...

## docker 
`docker`をインストールし、ubuntu:2004を利用します。すべての開発はdocker上で行います。

## Build qemu
`qemu`をビルドします。最初に必要なものを`apt install`します。  
```
sudo apt install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
                 gawk build-essential bison flex texinfo gperf libtool patchutils bc \
                 zlib1g-dev libexpat-dev git
```

```sh
git clone https://github.com/qemu/qemu
cd qemu
git checkout v5.2.0
./configure --target-list=riscv64-softmmu
make -j $(nproc)
sudo make install
```
途中、ninjaがないと怒られたので下のものを追加しました。
```
sudo -i
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
python3 -m pip install ninja
exit
```
## Rustのインストール
とりあえず、通常版です。
```sh
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ rustup target add riscv64gc-unknown-none-elf
$ rustc --version
rustc 1.50.0 (cb75ad5db 2021-02-10)
```

## risc-v向けgccのインストール
```
sudo apt install gcc-riscv64-unknown-elf
```
## 確認
```
$ qemu-system-riscv64 --version
QEMU emulator version 5.2.0 (v5.2.0)
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
```

```
 riscv64-unknown-elf-gcc -T src/asm/linker.ld src/asm/boot.s target/riscv64gc-unknown-none-elf/debug/librust_v_os.a -o rist-v-os -mabi=lp64 -nostdlib
hattomo@722b63d75c70:~/rust-v-os$ qemu-system-riscv64 -nographic -machine virt -kernel rist-v-os
```

## Reference 
https://risc-v-getting-started-guide.readthedocs.io/en/latest/linux-qemu.html
https://github.com/mesonbuild/meson/issues/7258
