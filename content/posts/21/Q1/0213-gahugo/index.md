---
title: "HugoでLastmodが同一時刻になる"
date: 2021-02-13T12:46:03+09:00
lastmod: 2021-02-13T06:01:29+00:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["hugo","githubactions","github"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "LastmodがGitHub Actionで同一時刻になる"
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
`Hugo`では、記事の最終更新時刻を`Lastmod`を利用して表すことができます。configファイルで`enableGitInfo: true`と記入しておくとgitのlogをもとにHugoが自動的にLastmodを設定しくれます。しかし、GitHub ActionsでHugoをビルドしたところ、すべてのLastmodが同じ時間(pushした時刻)になってしまっていました。
lastmod: 
## 解決法
GitHub Actionsのファイルは以下のようでした。
```yml
name: Build GH-Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: macos-latest
    steps:
      - name: Git checkout
        uses: actions/checkout@v2
        with:
          submodules: recursive  # Fetch Hugo themes (true OR recursive)

      - name: Setup hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'

      - name: Build
        run: hugo --gc --verbose --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          deploy_key: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          external_repository: Hattomo/Hattomo.github.io
          publish_branch: main
          publish_dir: ./public

```
問題は、ソースをダウンロードする際、`fetch-depth`がデフォルトで1になっていることでした。`fetch-depth`が1の場合、最新のコードのみを持ってくるようです。そのため、履歴がなくLastmodが同一時刻になっていたのでした。以下のように、`fetch-depth`に0を設定したところ正しく動くようになりました。
```yml
    steps:
      - name: Git checkout
        uses: actions/checkout@v2
        with:
          submodules: recursive
          fetch-depth: 0 # Add
```