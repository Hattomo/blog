---
title: "Chrome Extensionでメディアコントローラーを作る"
date: 2021-03-13T13:04:08+09:00
lastmod: 2021-03-13T13:04:08+09:00
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
description: "Chrome Extensionでローカルにあるビデオや音声ファイルのメディアコントローラーの拡張を作成していきます!"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
# はじめに
Chromeでローカルにあるビデオや音声ファイルを開くと再生することができます。しかし、一時停止、再生、音量の変更、Picture in Pictureしかできません。再生速度とか変えたいですよね。そこで、Chrome Extensionを作って機能を拡張してみました。作成するエクステンションはスピードの変更(0.1倍速から16倍速まで)、5秒進む、5秒戻る、ループ設定(ON,OFF)、音量の変更、ミュート(ON,OFF)をキーボードショートカットで行えるようにするものです。やってみると意外と簡単でした。

# chrome extension を作成する
エクステンションを作成していきます。ディレクトリを作成し、その中にファイルを作成していってください。
### manifest.jsonの作成
chromeのextensionを作るためには、まず`manifest.json`を作成する必要があります。これは、エクステンションの名称やバージョン、実行するファイルなどの設定を記述します。現在の`manifest_version`の最新は3なので`manifest_version`を3としました。`permissions`はエクステンションが必要な権限を記載します。`content_scripts.matches`では、このエクステンションがいつ有効になるかを設定します。URLがこれによって設定されているパターンとマッチしたときにエクステンションが有効になります。今回は`file://`で始まると有効化されます。`content_scripts.js`で実際に実行するファイルを指定します。`icons`には、アイコンのパスを設定します。
```json
{
    "manifest_version": 3,
    "name": "Hattomo chrome media controller",
    "version": "0.0.1",
    "description": "Chrome video media controller!",
    "author": "Hattomo",
    "permissions": [
        "declarativeContent"
    ],
    "content_scripts": [
        {
            "matches": [
                "file://*"
            ],
            "js": [
                "content.js"
            ]
        }
    ],
    "icons": {
        "32": "icons/favicon-32x32.png",
        "128": "icons/apple-icon-180x180.png"
    }
}
```
### content.jsの設定
`content.js`では、videoタグがあるかを確認し、videoタグがあった場合、videoタグのidとして`video_id`を指定します。videoタグがあるかを確認するのは画像などを開いた場合ビデオタグが見つからずのちの操作でエラーが出てしまうためです。その後、キーイベントのリスナーを登録し、イベントの発生を待ちます。動画や音声の操作は先ほど設定したidを使って行います。動画の速度や音量については、取れる値の幅に制限があるため、その制限を超えないよう実装します。また、`i`を押すとアラートダイアログがでて現在の速度などが表示されるようにしました。

```js
let video_element = document.querySelector('video');
if (video_element.id != null) {

    video_element.id = 'video_id';
    media = document.getElementById("video_id");

    document.body.addEventListener('keydown',
        event => {
            playbackRate = 0.1;
            volumeRate = 0.05;
            if (event.key === 'f') {
                // fast 
                if (media.playbackRate + playbackRate < 16) {
                    media.playbackRate += 0.1
                } else {
                    media.playbackRate = 16
                }
                console.log("fast : " + media.playbackRate);
            } else if (event.key === 's') {
                // slow
                if (0.1 < media.playbackRate - playbackRate) {
                    media.playbackRate -= 0.1;
                } else {
                    media.playbackRate = 0.1;
                }
                console.log("slow : " + media.playbackRate);
            } else if (event.key === 'l') {
                // loop
                if (media.loop) {
                    media.loop = false;
                } else {
                    media.loop = true;
                }
                console.log("loop : " + media.loop);
            } else if (event.key === 'm') {
                // mute
                if (media.muted) {
                    media.muted = false;
                } else {
                    media.muted = true;
                }
                console.log("muted : " + media.loop);
            } else if (event.key === 'ArrowRight') {
                // skip
                media.currentTime += 5;
            } else if (event.key === 'ArrowLeft') {
                // skip
                media.currentTime -= 5;
            } else if (event.key === 'ArrowUp') {
                // volume
                if (media.volume + volumeRate < 1) {
                    media.volume += 0.05;
                } else {
                    media.volume = 1;
                }
                console.log("volume : " + media.volume);
            } else if (event.key === 'ArrowDown') {
                if (0 < media.volume - volumeRate) {
                    media.volume -= 0.05;
                } else {
                    media.volume = 0
                }
                console.log("volume : " + media.volume);
            } else if (event.key === 'i') {
                msg = "Playback Speed " + media.playbackRate + "x\nLoop : " + media.loop;
                alert(msg);
            }
        });
}

```
### エクステンションを読み込み使ってみる
`chrome://extensions/`にアクセスし、開発者モードを有効にした後、エクステンションを読み込むことで使い始めることができます。例えば、`f`を押して再生速度が速くなっていけば成功です。  
Chromeには、現在英語のみですが、字幕の自動生成機能も新しくついたので、専用のビデオ再生ソフトよりもこれを使ったほうが便利になりそうです。