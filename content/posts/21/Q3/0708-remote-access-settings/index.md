---
title: "2段階SSH、VNC、RDPを行う方法"
date: 2021-07-08T23:27:45+09:00
lastmod: 2021-07-11T21:30:48+09:00
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
description: "2段階SSH、VNC(Vino)、RDP(xrdp)を行う方法や設定についてそれぞれ解説していきます"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---

## はじめに
コンピューターにリモートアクセスを行いたいことがあります。この際の方法やTipsをまとめてみました。扱う方法はSSH,VNC,RDPです。

## SSHでリモート接続を行う
SSHで外部からリモート接続を行う場合、セキュリティを考えると、多段階認証を行ったほうが良いです。多段階認証のサーバーは存在するとして、設定方法を記します。コンピュータの名前は以下のようにします。
- 踏み台サーバー
- ターゲット(SSHでアクセスされるコンピュータ) 
- クライアント(SSHでアクセスするコンピュータ)

下準備としてすべてのコンピュータにSSHをインストールし、ipアドレスの固定を行ってあるものとします。
またクライアント以外のOSは`Ubuntu 20.04`を前提としますがほかのOSでもほぼ同様に可能です。

### 鍵を生成する
SSHでは、パスワードによる認証もできますが、セキュリティを鑑みると公開鍵認証による認証を利用するべきです。そこで公開鍵認証を行うための鍵を生成していきます。`RSA`,`ed25519`が現在よく利用されています。`ed25519`は、楕円曲線を利用した暗号でとりあえずこれを利用しておけば問題ありませんが、レガシーな環境では`ed25519`に対応していない`Open ssh`を利用していることがあり、そのような際には`RSA`で鍵を作成します。`RSA`で鍵を生成する際には鍵長を4096以上に指定します。
```shell
# ed25519
$ ssh-keygen -t ed25519 -C "" -f ~/.ssh/id_ed25519

# RSA (legacy)
$ ssh-keygen -t rsa -b 4096 -C "" -f ~/.ssh/id_rsa
```
`-C`オプションはコメントです。これをつけないと自動的に鍵を作成したコンピュータの`username@hostname`とコメントが入ってしまいます。ユーザー名とホスト名が入ってしまっても問題はないケースがほとんどだと思いますが、個人的に気になるのでコメントを消しています。GitHubの[公式ドキュメント](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)では、メールアドレスをコメントにしています。`-f`オプションは、鍵の生成されるパスです。  
コマンドを実行するとパスワードを聞かれますが、そのままEnterキーを押します。
コマンドが完了したら、指定したパスに鍵があることを確認します。`*.pub`が公開鍵であり、拡張子がないものが秘密鍵です。秘密鍵は外部に漏れることのないように管理する必要があります。

### 鍵を踏み台サーバーに配置する
生成された公開鍵を踏み台サーバーの`~/.ssh/authorized_keys`に追記します。ファイルがなければ新たに作成します。公開鍵の内容をただコピー＆ペーストすればよいです。鍵を移動させる方法については、USBメモリなどで直接運ぶ方法、`scp`コマンドを利用する方法と`ssh-copy-id`を利用する方法があります。可能であれば、`ssh-copy-id`を利用したほうが簡単です。
```shell
# scp
scp [client pub key path] server_username@server_hostname:[path_on_host]
# ssh-copy-id
ssh-copy-id -i [client pub key path] server_username@server_hostname
```
鍵が、authorized_keysに書き込まれたことを確認しましょう。

鍵生成から、鍵を配置するまでの一連の流れをターゲットに対しても行います。

### Configに設定を追記する
クライアントの`~/.ssh/config`ファイルに設定を記述しておくことで短いコマンドでSSHを行うことができます。
```txt
ServerAliveInterval 120
ServerAliveCountMax 3

Host server
    Hostname [ip addr or hostname]
    User [server_username]
    Port [port number]
    IdentityFile [path to private ssh key for server]
Host terget
    Hostname [ip addr or hostname]
    User [terget_username]
    Port [port number]
    IdentityFile [path to private ssh key for terget]
    ProxyCommand ssh server -W %h:%p
```
`ServerAliveInterval`と`ServerAliveCountMax`は接続が切れないようにする設定です。sshでコマンドをしばらくたたかないと自動的に接続が切れてしまいます。それを防ぐためにsshd側が一定期間クライアントと通信していないときに、応答確認を行います。`ServerAliveInterval`はその確認する感覚の秒数であり、`ServerAliveCountMax`は試行回数です。

最終的に以下のコマンドでターゲットへのsshが完了すれば成功です。
```shell
$ ssh terget
```
### ターゲットのsshdの設定
`ServerAliveInterval`と`ServerAliveCountMax`のような設定をターゲットのsshd側ですることもできます。ターゲットの`/etc/ssh/sshd_config`を開き、
```txt
ClientAliveInterval 120
ClientAliveCountMax 3
```
を追記します。設定を反映するには、
```shell
sudo service sshd restart
```
でサービスを再起動します。

## VNCとRDP
晴れてSSHを行うことができるようになったわけですが、コマンドだけではなくディストップ環境が欲しい時もあります。そのようなときに活躍するものが、VNCとRDP(リモートデスクトッププロトコル)です。両方、リモートからデスクトップ環境を利用すために作られたものですが、実現する仕組みが異なっています。VNCは画面そのものを画像として送信しています。画像を送信する方法はRDPの方法より、重い一方、`Ubuntu`や`macOS`にはデフォルトでVNCを行うためのソフトが入っており、導入が比較的簡単です。RDPは`Microsoft`が開発した方法で、画面の描画情報を送信(ウインドウの場所などの構成情報を送るイメージ)します。そのため、VNCと比べて軽いです。

## VNCを利用する
`Ubuntu`には、`Vino`と呼ばれるVNCサーバーが入っています。設定方法は[ここ](https://blog2.k05.biz/2020/04/ubuntu-vnc.html)を参考にしました。
しかし、今回は2段階ssh環境でのVNCです。ターゲットに直接アクセスすることができません。そこでsshのポートフォワーディングを使います。これは、ターゲットの特定のポートをクライアントの任意のポートと接続できる機能です。先ほどのconfigファイルのtergetに以下を追記します。
```txt
    LocalForward 5900 localhost:5900
```
これでターゲットの5900ポートをクライアントの5900に接続することができました。
よって接続は`localhost:5900`に対して行います。
また、私の環境では、
```shell
$ gsettings set org.gnome.Vino require-encryption false
```
を行って暗号化の設定をoffにしても暗号化が解除されませんでした。
設定を変更する`dconf`をインストールします。
```shell
$ sudo apt install dconf-editor
```
ソフトを起動し、`org.gnome.desktop.remote-access require-encryption`を`false`に設定します。これでもう一度接続すると接続することができました。VNCの暗号化をoffにしてしまってもssh自体が暗号化されているため、安全に通信することができます。逆に言えば、sshを使っていなければ暗号化を止めてしまったため危険です。

## RDPを利用する
```shell
$ sudo apt install xrdp
```
2段階sshの環境でのRDPは上のVNCの場合と同様にポートフォワーディングが必要です。`xrdp`で利用するポートはデフォルトで、3389です。VNCの際と同じように設定を行います。
```txt
    LocalForward 3389 localhost:3389
```
`localhost:3389`にRDPクライアントを接続すれば、利用することができます。クライアントソフトについては、[ここ](https://qiita.com/kotadora/items/400eb48e15311c0eb5bd)が参考になります。
