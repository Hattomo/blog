---
title: "GitHub CodespacesでHugo"
date: 2021-02-13T05:18:27Z
lastmod: 2021-02-13T06:01:29+00:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["hugo","codespaces","github"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "GitHub Codespaces is all new way to coding"
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
`GitHub Codespaces`がβになってからしばらくたちました。βの間は無料のようなので、気軽に試すことができます。今回はGithub CodespacesでHugoを使ってみます。(この記事はGitHubCodespaces上で書いています。)

## Hugoで使う
GitHub Codespacesの基本的な使い方は省略します。Hugoの場合、いつものように`Hugo server -D`とすると、baseURLのページは見れるのですが、そこからページの移動ができません。リンク先が`localhost:1313/path`になっているためです。そこで、Hugoを起動する際、
```sh
hugo server -D --baseUrl="https://[your URL]-1313.apps.codespaces.githubusercontent.com/" --appendPort=false
```
のように実行することでリンクを機能させることができます。
一つ目はBaseURLの変更です。しかし、これだけだと1313ポートにアクセスしてしまうため、`--appendPort=false`でこれを修正します。これでリンク先が機能します。

## 感想
リモートにつないでいるにも関わらず、かなり快適に作業することができます。さらにVSCodeがエクステンションやテーマ、キーバインドも含めて完全に動いているのでリモートに接続していることを忘れてしまいそうです。  
リモートマシンはOS:Ubuntu18.04、CPU:Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GH、RAM 8GB、Stroge:32GBで動いているようです。Hugoを使うだけなら十分すぎます。最初から入っているため、Hugoのインストールなど煩わしいことも必要ありませんでした。しかし、ページはリロードを自分で行わなければ更新されませんでした。この点は微妙です。何か方法があるのかもしれませんが。  
Webブラウザでコードを書くのは、最近のトレンドになっていますが、GoogleのStdiaとか、Windows10のcloud PCのうわさとか、クラウド上で動かすのは当たり前になっていくのでしょうか。  
一つお願いがあるとすれば、GitHub Codespacesは有料化するまでにセルフホストできるようにしてほしいです。この点はVSCode Onlineから、後退してしまうので。