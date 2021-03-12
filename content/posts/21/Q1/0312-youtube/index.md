---
title: "Youtubeの動画をダウンロードするyoutube-dlを試す"
date: 2021-03-12T09:20:07+09:00
lastmod: 2021-03-12T09:20:07+09:00
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
description: "Youtubeの動画をダウンロードするyoutube-dlを試す"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
# はじめに
YouTubeの動画をダウンロードする`youtube-dl`[(GitHub)](https://github.com/ytdl-org/youtube-dl/)を試してみました。

# インストール方法
GitHubの[README.md](https://github.com/ytdl-org/youtube-dl/)で最新の方法を確認してください。現時点では、バイナリをダウンロードする方法、`pip`でインストールする方法、`brew`などがあるようです。インストールした後、パスを通してください。

# youtube-dlの使い方
youtube-dlは、
```sh
$ youtube-dl [URL]
```
で簡単に使うことができます。しかし、保存場所や画質のオプションも含めると何度もコマンドを記述するのは大変なのでシャルスクリプトを作成します。今回利用するオプションは保存場所の指定、画質設定、字幕とサムネイルをダウンロードするの4つです。

### 保存場所の指定のオプション
保存場所を指定するには`-o [path to file]`を利用します。下のように指定することでファイルのタイトル、チャンネル名、動画のidなどの情報をファイル名に含めることができます。
```
-o $D_PATH'/%(title)s-%(uploader)s-%(id)s.%(ext)s' $URLs
```

### 画質と音質のオプション
画質と音質はデフォルトでは`best`がダウンロードされます。これは、720pであることが多いようです。しかし、画質と音声を指定した質でダウンロードすることもできます。この場合画質と音声は、それぞれ別にダウンロードすることになり、あとで自動的に結合されます。結合には`ffmpeg`か`avconv`が必要です。今回は`ffmpeg`を`apt insatall ffmpeg`によってインストールしました。画質のと音声のオプションは以下のように`-f`オプションで行いました。
```
-f bestvideo[height=$Image_Quality][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height=720][ext=mp4]+bestaudio[ext=m4a]/best
```

### 字幕をダウンロードするオプション
```
--write-sub 
```
### サムネイルをダウンロードするオプション
```
--write-thumbnail
```
# シェルスクリプト

全体のシェルスクリプトです。URLと画質をコマンドライン引数として指定して、ダウンロードすることができます。

```sh
URLs=$1
if [ "$2" != "" ]; then
    Image_Quality=$2
else
    Image_Quality=1080
fi
echo "Image_Quality : "$Image_Quality
echo -e "URLs : "$URLs"\n"
D_PATH=[file save path]

### downloads
youtube-dl -f bestvideo[height=$Image_Quality][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height=720][ext=mp4]+bestaudio[ext=m4a]/best \
--merge-output-format mp4 \
--write-sub \
--write-thumbnail \
-o $D_PATH'/%(title)s-%(uploader)s-%(id)s.%(ext)s' $URLs

### check update and update if update available
echo -e "\nchecking update ..."
youtube-dl -U
```

# 時刻を指定してyoutubeをダウンロードする
ライブストリーミングや動画がプレミア公開された直後にダウンロードしたいときもあるでしょう。時刻を指定してダウンロードするためには、`at`コマンドを利用します。1行目でatコマンドを利用するためのデーモンを起動します。2行では、日時を指定しており、3行目はスクリプトを実行しています。`at`コマンドからは、`ctrl+D`で脱出することができ、`<EOT>`と表示されます。この際、標準出力やエラーをターミナルにリダイレクトするための設定が、`> /dev/pts/0 2>&1`の部分です。`/dev/pts/0`はご利用の境に合わせて、`tty`コマンドなどで確認してください。設定を確認するためには、`at -l`を利用します。
```sh
$ sudo /etc/init.d/atd start
$ at 17:05 03/11/2021
at> youtube.sh URL > /dev/pts/0 2>&1
at> <EOT>
$ at -l
```