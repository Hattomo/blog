---
title: "シェルでHugoのポストを新規作成する"
date: 2021-02-13T18:47:00+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["hugo","shellscript"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "hugoのポストをシェルで新規作成する"
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
Hugoで新しいポストを作成するコマンドは、
```sh
hugo new [path to new file]
```
ですが、私はフォルダを分けているので
```sh
hugo new posts/21/Q1/0213-[title]
```
のような長いパスになっていました。いちいち入力するのはめんどくさいし、よく間違えるのでシェルスクリプトを作りました。
```sh
# usage
./new.sh title
```

## 作り方
中身は以下のようになっています。
```sh
title=$1
year=`date '+%y'`
quoter=`date '+Q%q'`
date=`date '+%m%d-'`
path=posts/$year/$quoter/$date$title/index.md
hugo new $path
```
まず、`$1`はコマンドライン引数を表しています。ここにタイトルが入ります。  
また、このようにすると変数varにコマンドの結果を入れることができます。
```sh
var=`command`
```
dateコマンドを利用して必要な値を取得し、変数に入れ、`$path`で結合しています。
あとはコマンドを実行して新しいポストを生成するだけです。