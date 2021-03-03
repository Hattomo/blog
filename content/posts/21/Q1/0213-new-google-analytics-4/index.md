---
title: "HugoでGoogle Analytics 4を利用する"
date: 2021-02-13T11:48:30+09:00
lastmod: 2021-02-13T12:28:08+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["hugo","googleanalytics"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "Hugoで新しくなったGoogleAnalyticsを使う"
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
様々なサイトに導入されているGoogle Analyticsですが、2020年より新たにGoogle Analytics 4(以下GA4)が、導入されました。しかし`Hugo`では、標準ではまだ対応していません。(これを書いているときの最新バージョンは0.80です)しかし、`Hugo`ではGA4を簡単に利用することができます。

## GA4を導入する
GoogleAnalytics にアクセスし、GA4のIDを取得します。その方法はここでは省略します。GA4のIDは`G-xxxxxxxxxx`のようにGから始まります。UAから始まっている場合は、従来のIDです。  
IDが取得出来たら、Hugoのフォルダ`theme/layout`の適当なところに新規HTMLファイルを作成し、以下のように追記します。  
- analytics-gtag.html
```html
<!-- Global site tag (gtag.js) - Google Analytics 4-->
<script async src="https://www.googletagmanager.com/gtag/js?id={{ .Site.GoogleAnalytics }}"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    gtag('js', new Date());

    gtag('config', '{{ .Site.GoogleAnalytics }}');
</script>
```
次に、configファイルに移動し、GoogleAnalyticsのIDを設定します。ymlの場合は、以下のようになります。
```yml
GoogleAnalytics: G-xxxxxxxx
```
最後にこれらの設定を読み込みます。`theme/layouts/partials/head.html`のファイルの一番下のほうにある外部ファイルの読み込みを修正します。`google_analytics_async`は従来のgoogle analyticsなので消します。逆に、先ほど作成したファイルのパスを下のように追記します。
```html
～省略～
{{- template "_internal/google_analytics_async.html" . }} <!--Delete-->
{{- template "{path to file}/analytics-gtag.html" . }} <!--Add GA4-->
{{- template "_internal/google_news.html" . }}
{{- template "partials/templates/opengraph.html" . }}
{{- template "partials/templates/twitter_cards.html" . }}
{{- template "partials/templates/schema_json.html" . }}
～省略～
```
以上で完了です。  
適当なページを作り、アクセスした状態で、Google Analyticsのリアルタイムを確認して下さい。ユーザーが確認できれば、成功です。