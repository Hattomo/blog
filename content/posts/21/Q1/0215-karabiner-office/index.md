---
title: "macOSのOfficeでEmacsキーバインド"
date: 2021-02-15T16:47:52+09:00
lastmod: 2021-02-28T21:29:13+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["mac","app"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "macOSのMicrosoft OfficeでEmacs風キーバインドを設定する"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
## はじめに
macOS上では、`emacs`のキーバインドが一部利用できて便利です。このキーバインドは大抵のテキストエデットアプリには、対応しているのですが、MicrosoftのOffice系アプリでは、これを使うことができません。うっかり慣れで、<kbd>Ctrl</kbd>+<kbd>H</kbd>などを押してしまうと、他の機能が動いてしまいます。

## OfficeでEmacs
macOSで、キーバインドのカスタマイズを行おうと思った際に`karabiner-elements`というアプリが有名です。これを使ってOfficeでemacsを利用できるようにしていきます。  
設定は、`~/.config/karabiner/assets/complex_modifications/xxxxxx.json`(xは数字)にファイルを作成し、以下のように記述します。尚この設定は、Ctrl+H,B,N,P,E,A,Dをサポートしていますが必要に応じて書き換えてください。

```json
{
	"title": "MS-Office de Emacs key",
	"rules": [
		{
			"description": "MS-Office de Emacs key",
			"manipulators": [
				{
					"type": "basic",
					"from": {
						"key_code": "b",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "left_arrow"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "f",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "right_arrow"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "p",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "up_arrow"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "n",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "down_arrow"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "a",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "home"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "e",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "end"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "h",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "delete_or_backspace"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				},
				{
					"type": "basic",
					"from": {
						"key_code": "d",
						"modifiers": {
							"mandatory": [
								"control"
							]
						}
					},
					"to": [
						{
							"key_code": "delete_forward"
						}
					],
					"conditions": [
						{
							"type": "frontmost_application_if",
							"bundle_identifiers": [
								"^com\\.microsoft\\.Word$",
								"^com\\.microsoft\\.Excel$",
								"^com\\.microsoft\\.Powerpoint$"
							]
						}
					]
				}
			]
		}
	]
}
```