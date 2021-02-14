---
title: "Hugoで読了時間や文字数表示がおかしい"
date: 2021-02-14T23:11:34+09:00
draft: true
# weight: 1
# aliases: ["/first"]
tags: ["hugo"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Hugoで読了時間や文字数表示がおかしい場合の対処法"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
Hugoをつかって、このページを作成していますが、読了時間の表示が常に1 minと表示されていました。おかしいと思っていましたが、さらにrss用のindex.xmlをたまたま見たところ、descriptionタグに記事のほぼすべての文章が入っており、これは日本語が文字数としてカウントされていないためのようでした。

## 対処法
`config.yml`ファイルに
```yml
HasCJKLanguage: true
```
を追記します。日本語、中国語、韓国語の文字がある場合、これを書いていないと文字カウントがおかしくなってしまうようです。これを追記したところ、正しく動作するようになりました。