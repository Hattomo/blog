---
title: "Auto HotkeyでMac風キーバインド！"
date: 2021-02-23T11:05:19+09:00
lastmod: 2021-05-27T23:13:24+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["windows",app]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "WindowsでmacOS風のキーバインドや便利なショートカットの設定をAutoHotKeyを利用して設定する方法"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
WindowsでもmacOS風のキーバインドを利用したいことがあると思います。そのための設定です。レジストリとAutoHotKeyを利用します。  
※レジストリをおかしくいじると最悪Windowsが起動しなくなります。自己責任でお願いします。

## レジストリでキーをリマップする
レジストリでキーをリマップするためには、`Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout`に`Scancode Map`という名称で設定を追加します。空白の場所で右クリックし、`New`→`Binary value`を選択、設定名を`Scancode Map`としてください。  
次に、設定を書き込みます。
今回設定するのは以下の項目です。
```txt 
Before   →　After
------------------
Capslock →   F13
LAlt     →   LCtrl
LWin     →   LAlt
LCtrl    →   LWin
RAlt     →   RCtrl
RCtrl    →   RAlt
```
これをレジストリで設定するためには以下のようにします。
```txt
00000000 00 00 00 00 00 00 00 00
00000008 07 00 00 00 64 00 3A 00
00000010 1D 00 38 00 5B E0 1D 00
00000018 38 00 5B E0 1D E0 38 E0
00000020 38 E0 1D E0 00 00 00 00
00000028
```
この設定がどのような構造になっているについてはたくさんのブログがあるのでそちらを見てください。  
再起動した際、設定が反映されていれば成功です。

## AutoHotKey を設定する
### mac風キーバインドの設定
AutoHotKeyをインストールし、`xxx.ahk`ファイルを作成します。  
私のAutoHotKeyのバージョンは1.1.33.02です。

ahkファイルに設定を記述します。
```ahk
;; Eamcs 風のキーバインド
F13 & B::Send,{Blind}{Left}
F13 & N::Send,{Blind}{Down}
F13 & P::Send,{Blind}{Up}
F13 & F::Send,{Blind}{Right}
F13 & H::Send,{Blind}{Backspace}
F13 & D::Send,{Blind}{Delete}
F13 & A::Send,{Blind}{Home}
F13 & E::Send,{Blind}{End}
F13 & K::Send,+{End}{Shift}+{Delete}
F13 & Enter::Send,{Alt Down}{Shift Down}{Enter}{Alt Up}{Shift Up}

;;バーチャルディスクトップ
F13 & Right::Send, {LCtrl up}{LWin down}{LCtrl down}{Right}{LWin up}{LCtrl up}
F13 & Left::Send, {LCtrl up}{LWin down}{LCtrl down}{Left}{LWin up}{LCtrl up}
F13 & Up::Send, {LWin down}{Tab}{LWin up}
F13 & Down::Send, {LWin down}{Tab}{LWin up}

;; アプリの終了
LCtrl & Q::Send, {LAlt down}{F4}{LAlt up}

;;chromeなどのタブの移動 →
LAlt & Right::	
  If GetKeyState("LCtrl", "P") {			
    Send,^{Tab}
  }
Return

;;chromeなどのタブの移動 ←
LAlt & Left::	
  If GetKeyState("LCtrl", "P") {		
    Send,+^{Tab}
  }
Return

;; アプリ(ウインドウ)の切り替え
LCtrl & Tab::AltTab

;; 無変換で英語入力
vk1C::
imeoff:
  Gosub, IMEGetstate
  If (vimestate=0) {
    Send, {vkf3}
  }
  return

;; 変換で日本語入力
vk1D::
imeon:
  Gosub, IMEGetstate
  If (vimestate=1) {
    Send, {vkf3}
  }
  return

;; 上の二つのために必要
IMEGetstate:
  WinGet, vcurrentwindow, ID, A
  vimestate := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", vcurrentwindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
  return

;; メディアコントロール(macのファンクションキー)
;; Insertと数字の同時押しで再現
;; 数字でなくファンクションにしてもよいのでは？
;; brightness up
;;Insert & 1
;;Insert & 2
;; task view
Insert & 3::Send {LWin down}{Tab}{LWin up}      
;; lanch pad
;;Insert & 4
;; keyboard brightness up
;;Insert & 5,6
;; play Back
Insert & 7::Send {Media_Prev}
;; pause & play
Insert & 8::Send {Media_Play_Pause}
;; play next
Insert & 9::Send {Media_Next}
;; volume mute
Insert & 0::Send {Volume_Mute}
;; volume Down
Insert & -::Send {Volume_Down}
;; volume up (if en chang e to =)
Insert & ^::Send {Volume_Up}
```
### その他便利な設定
どこかのサイトで見つけました。(忘れてしまいました)
```ahk
;;クリップボード内容をgoogle search
LAlt & s::
	If GetKeyState("Ctrl", "P") {
		send, ^c
		Clipboard := RegExReplace(Clipboard, "^ +|\r\n| +$", "")
		Run, http://www.google.co.jp/search?q=%Clipboard%
	}
Return

;;クリップボード内容をgoogle translate
LAlt & t::
	If GetKeyState("Ctrl", "P") {
		send, ^c
		Clipboard := RegExReplace(Clipboard, "^ +|\r\n| +$", "")
		Run, https://translate.google.com/#view=home&op=translate&sl=en&tl=ja&text=%Clipboard%
	}
Return
```