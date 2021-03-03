---
title: "VSCodeのデフォルトフォントを確認する方法"
date: 2021-02-13T10:41:23+09:00
lastmod: 2021-02-13T11:46:42+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["vscode"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "VSCodeのデフォルトのフォントはOSごとに何が設定されているか調査する"
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
`Microsoft`の`VSCode`でデフォルトのフォントを確認する方法です。先日、このサイトのほかのページにコードを書いたところ、macOSではきれいに表示されていましたが、Windowsでは汚いフォントで表示されていました。もちろんCSSをいじってFont-Familyを設定すればいいわけですが、どれを設定すればいいかわからない！ってことで`VSCode`のデフォルトのフォントと同じフォントを設定すればきれいではないかと思い調べました。

## 方法
シンプルにソースコードを見に行くのが早いでしょう(たぶん)。ソースコードは、GitHubの[microsoft/vscode](https://github.com/microsoft/vscode)で公開されており、そのなかでフォントを指定している部分は[ここ](https://github.com/microsoft/vscode/blob/master/src/vs/workbench/browser/media/style.css)です。27~29行目を見ると、以下のような記述があります。
```css
.mac { --monaco-monospace-font: "SF Mono", Monaco, Menlo, Courier, monospace; }
.windows { --monaco-monospace-font: Consolas, "Courier New", monospace; }
.linux { --monaco-monospace-font: "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace; }
```
どうやら、OSによって異なるフォントを使っているようです。macOSでは`SF Mono`、Windowsでは`Consolas`、Linuxでは`Ubuntu Mono`のようです。Linuxの最初が`Ubuntu Mono`なので、LinuxでVSCodeを利用する人は、Ubuntuが一番多そうです。このサイトのCSSにも、これらのフォントを指定しておきました。