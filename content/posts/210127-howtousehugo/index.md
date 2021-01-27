---
title: "How to install and use Hugo"
date: 2021-01-27T13:33:06+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["hugo"]
showToc: true
TocOpen: false
hidemeta: false
comments: false
description: "Hugoを利用する際の忘備録"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---


## Hugo をインストールする
`homebrew`を利用した方法が、一般的なようでしたが、[Install hugo](https://gohugo.io/getting-started/installing#binary-cross-platform)を参考にGitHubからバイナリをダウンロードし、解凍したhugoの実行ファイルを`/usr/local/bin`に配置しました。

## テーマを決める
テーマは少し迷いましたが、`hugo-PaperMod`にしました。開発が活発に続けられていたこと、ドキュメントが整備されていたこと、デザインが気に入ったためです。  
gitのサブモジュールに登録します。
```shell
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
git submodule update --init --recursive
```
今後テーマをアップデートするためには、以下のコマンドを実行します。
```shell
git submodule update --remote --merge
```

## 新規記事を作成する
以下のコマンドを実行します。
```
hugo new posts/{path to new file}.md
```

## Hugo ローカルサーバーを立ち上げる
```
hugo server -D
```

## テーマを編集する
テーマをフォークし、次のような変更を行いました(行う予定です)。
- [x] 文字サイズの変更
- [x] google analytics の追加
- [x] klatexのサポート
- [ ] 前回の記事、次の記事へのリンクの追加

## GitHubにpushしたらdeployが行われるよう設定する
GitHub actionを利用して、自動的にgithub-pagesにdeployが行われるように設定します。
`peaceiris/actions-hugo@v2`と`peaceiris/actions-gh-pages@v3`を利用しました。

## Reference 
- https://gohugo.io/getting-started/quick-start/
- https://github.com/adityatelange/hugo-PaperMod