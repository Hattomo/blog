---
title: "PythonでLINEトークの履歴を解析し、グラフを生成する"
date: 2021-03-12T00:11:07+09:00
lastmod: 2021-03-13T13:56:47+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["python"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
math: false
ShowBreadCrumbs: true
description: "PythonでLINEトークの履歴を解析し、グラフを生成する"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
# はじめに
Lineには、トーク履歴をエクスポートする機能が付いています。これをPythonを使って解析し、合計メッセージ数、それぞれのメッセージ数、合計文字数、それぞれのメッセージ数、Line電話の時間の合計をそれぞれの月について算出する方法です。筆者は、電子機器の言語を英語に設定しているため、日本語を使用されている方は、履歴のファイル名や内容が日本語表記になっていることが予想されます。適宜読み替えてください。

# Lineからトーク履歴をエクスポートする
これは、PCでもスマホでもできますが、PCとスマホでは、エクスポートされたトーク履歴のフォーマットが微妙に違うことやPCでは、エクスポートできるトーク履歴が会話全体の一部でしかないため、今回はスマホでエクスポートし、PCに送りました。

# トーク履歴をCSVに変換する
エクスポートされたファイルは、`[LINE] Chat with [friend name].txt`となっていました。フォーマットは以下のようでした。うーん、このフォーマットは使いにくい気が...
```txt
~略~
2021/03/03 Wed
10:15	frinds account name 	次の電話は明日の18時半がいいです。
11:37	my account name 	[Sticker]
~略~
```
日時、タブ、アカウント名、タブ、メッセージとなっています。
Lineには様々な機能が付いています。テキストメッセージ、写真、動画、スタンプ、電話、アルバム、メッセージの取り消しなどのシステムメッセージ...。これらは履歴の中では、特定の形で表現されているので、それぞれの履歴がどの種類のメッセージであるかを正規表現を使って分け、csvに変換していきます。csvの形式は`年,月,日,時,分,送信者,内容,flag`とします。`flag`については後述します。

### 履歴ファイルを読み込む
履歴ファイルを読み込みます。
```python
file_path = "[LINE] Chat with [freind name].txt"
with open(file_path, 'r', encoding="utf-8") as f:
    log_text = f.read()
```

### 正規表現を設定する
それぞれのメッセージ種別について正規表現を設定していきます。
```python
# 日時データ
date_pattern = r"20\d{2}/\d{2}/\d{2} (Mon|Tue|Wed|Thu|Fri|Sat|Sun)"
# テキストメッセージデータ
message_pattern = r"\d{2}:\d{2}\t.*\t.*"
# 写真のデータ
photo_pattern = r"\d{2}:\d{2}\t.*\t\[Photo]"
# スタンプのデータ
sticker_pattern = r"\d{2}:\d{2}\t.*\t\[Sticker]"
# ビデオデータ
video_pattern = r"\d{2}:\d{2}\t.*\t\[Video]"
# ファイルのデータ
file_pattern = r"\d{2}:\d{2}\t.*\t\[File]"
# アルバム作成、名前変更、削除のデータ
album_build_pattern = r"\d{2}:\d{2}\t.*\t\[Albums].*"
album_rename_pattern = r"\d{2}:\d{2}\t.* changed the name of the album.*"
album_delete_pattern = r"\d{2}:\d{2}\t.* delete the album.*"
# 電話のデータ関係
missed_call_pattern = r"\d{2}:\d{2}\t.*\t☎ Missed call"
canceled_call_pattern = r"\d{2}:\d{2}\t.*\t☎ Canceled call"
no_answer_call_pattern = r"\d{2}:\d{2}\t.*\t☎ No answer"
call_pattern = r"\d{2}:\d{2}\t.*\t☎ Call time (\d{1,2}:\d{2}|\d{1,2}:\d{2}:\d{2})"
# システムのデータ、送信取り消し
sys_unsent_pattern = r"\d{2}:\d{2}\t.* unsent a message."
```
### データを正規表現に沿って解析する
`re.match()`で正規表現に当てはまっているかを確認し、当てはまっていたら、タブでデータを分割したのち、Data型にデータを格納し、リストlogに追加していきます。データ型の`flag`という変数はデータの種類を示しており、以下のように設定しています。
```txt
# flag
    # 0 : talk meassge
    # 10 : call
    # 11 : missed call
    # 12 : canceled call
    # 13 : no answer call
    # 2 : photo
    # 3 : video
    # 4 : sticker
    # 50 : system message unsent
    # 60 : file
    # 70 : create and add album
    # 71 : changed the name of the album
    # 72 : deleted the album
```
```python
class Data():
    def __init__(self, year, month, day, hour, minute, person, payload, flag):
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.person = person
        self.payload = payload
        self.flag = flag

date_ = datetime.datetime.now()
logs = []

# 履歴の最初の2行はエクスポートした時間と空白の行なのでとばし、3行目から解析する
for i, log in enumerate(log_text.splitlines()[3:]):
    #print(f"{log} : ", end='')
    if log == '':
        #print("no data")
        continue
    date_stamp = ""
    if re.match(date_pattern, log):
        #print("day data")
        date_stamp = log.replace('/', ',').replace(' ', ',')[0:10]
        date_ = datetime.datetime.strptime(date_stamp, '%Y,%m,%d')
    elif re.match(photo_pattern, log):
        #print("photo data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 2))
    elif re.match(video_pattern, log):
        #print("Video data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 3))
    # ~略~
```
### csvを保存する
以下のコードでcsvファイルを保存します。`line.csv`というファイルに保存されます。
```python
with open('line.csv', 'w', encoding="utf-8", newline="") as f:
    for content in logs:
        writer = csv.writer(f)
        writer.writerow([str(content.year), str(content.month), str(content.day), str(content.hour),str(content.minute), str(content.person), str(content.payload), str(content.flag)])
```

### トーク履歴をCSVに変換するコードの全体
ここまでのコードの全体です
```python
# -*- coding: utf-8 -*-

import re
import csv
import datetime
import os
import sys


class Data():
    # flag
    # 0 : talk meassge
    # 10 : call
    # 11 : missed call
    # 12 : canceled call
    # 13 : no answer call
    # 2 : photo
    # 3 : video
    # 4 : sticker
    # 50 : system message unsent
    # 60 : file
    # 70 : create and add album
    # 71 : changed the name of the album
    # 72 : deleted the album
    def __init__(self, year, month, day, hour, minute, person, payload, flag):
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.person = person
        self.payload = payload
        self.flag = flag


# disable #print
# sys.stdout = open(os.devnull, 'w', encoding="utf-8")

file_path = "[LINE] Chat with friend.txt"

date_ = datetime.datetime.now()
logs = []

# open file and load data
with open(file_path, 'r', encoding="utf-8") as f:
    log_text = f.read()

date_pattern = r"20\d{2}/\d{2}/\d{2} (Mon|Tue|Wed|Thu|Fri|Sat|Sun)"
message_pattern = r"\d{2}:\d{2}\t.*\t.*"
photo_pattern = r"\d{2}:\d{2}\t.*\t\[Photo]"
sticker_pattern = r"\d{2}:\d{2}\t.*\t\[Sticker]"
video_pattern = r"\d{2}:\d{2}\t.*\t\[Video]"
file_pattern = r"\d{2}:\d{2}\t.*\t\[File]"
album_build_pattern = r"\d{2}:\d{2}\t.*\t\[Albums].*"
album_rename_pattern = r"\d{2}:\d{2}\t.* changed the name of the album.*"
album_delete_pattern = r"\d{2}:\d{2}\t.* delete the album.*"
missed_call_pattern = r"\d{2}:\d{2}\t.*\t☎ Missed call"
canceled_call_pattern = r"\d{2}:\d{2}\t.*\t☎ Canceled call"
no_answer_call_pattern = r"\d{2}:\d{2}\t.*\t☎ No answer"
call_pattern = r"\d{2}:\d{2}\t.*\t☎ Call time (\d{1,2}:\d{2}|\d{1,2}:\d{2}:\d{2})"
sys_unsent_pattern = r"\d{2}:\d{2}\t.* unsent a message."

for i, log in enumerate(log_text.splitlines()[3:]):
    #print(f"{log} : ", end='')
    if log == '':
        #print("no data")
        continue
    date_stamp = ""
    if re.match(date_pattern, log):
        #print("day data")
        date_stamp = log.replace('/', ',').replace(' ', ',')[0:10]
        date_ = datetime.datetime.strptime(date_stamp, '%Y,%m,%d')
    elif re.match(photo_pattern, log):
        #print("photo data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 2))
    elif re.match(video_pattern, log):
        #print("Video data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 3))
    elif re.match(sticker_pattern, log):
        #print("Sticker data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 4))
    elif re.match(call_pattern, log):
        #print("call data")
        splited_log = re.split('\t', log)
        time_data = splited_log[2][12:]
        time_data = re.split(':', time_data)
        time_length = 0
        for i in range(len(time_data)):
            time_length += int(time_data[len(time_data) - i - 1]) * (60 ** i)
        # print(time_length)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], time_length, 10))
    elif re.match(missed_call_pattern, log):
        #print("Missed call data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 11))
    elif re.match(canceled_call_pattern, log):
        #print("Canceled call data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 12))
    elif re.match(no_answer_call_pattern, log):
        #print("no answer call data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], "", 13))
    elif re.match(sys_unsent_pattern, log):
        #print("sys unsent data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], "", "", 50))
    elif re.match(file_pattern, log):
        #print("file data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], "", "", 60))
    elif re.match(album_build_pattern, log):
        #print("create album data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], "", "", 70))
    elif re.match(album_rename_pattern, log):
        #print("rename album data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], "", "",71))
    elif re.match(album_delete_pattern, log):
        #print("delete album data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], "", "", 72))
    elif re.match(message_pattern, log):
        #print("message data")
        splited_log = re.split('\t', log)
        logs.append(Data(date_.year, date_.month, date_.day,
                         splited_log[0][0:2], splited_log[0][3:5], splited_log[1], splited_log[2], 0))
    elif (len(re.split('\t', log)) == 1):
        splited_log = re.split('\t', log)
        #print("returned data")
        logs[-1].payload += log
    else:
        pass
        #print("\nNo classified data\n")

with open('line.csv', 'w', encoding="utf-8", newline="") as f:
    for content in logs:
        writer = csv.writer(f)
        writer.writerow([str(content.year), str(content.month), str(content.day), str(content.hour),str(content.minute), str(content.person), str(content.payload), str(content.flag)])

print("Success🎉")

```

# CSVを解析するし、グラフを生成する
CSVの解析には`pandas`、グラフの生成には`matplotlib`を`pandas`のラッパーを通して利用してます。ラッパーなので生成されるグラフは`matplotlib`そのものです。
### CSVを読み込む
CSVを`pandas`を利用して読み込みます
```python
file_path = "line.csv"
df = pd.read_csv(file_path, names=('year', 'month', 'day',
                                   'hour', 'minute', 'person', 'payloads', 'flag'), encoding="UTF-8")
```
### 全体の月別メッセージ数
`pandas`の`groupby`機能によって月ごとのメッセージ数を数えます。これをグラフにします。ほかのデータを解析する場合も基本は同様です。これを少し変えることで、曜日別や時間別なども簡単に作ることができそうです。
```python
month_message = df[["year", "month", "flag"]
                   ].groupby(['year', 'month']).count()

month_message.plot(y='flag', kind='bar', label="count", figsize=figsize)
plt.ylabel("message count")
plt.legend()
plt.ylim(0,)
plt.title('message')
plt.savefig('message_count.png')
```
### 人ごとの月別メッセージ数
`pandas`では、クロスタブを利用することで、簡単にクロス集計分析を行うことができます
```python
person_month_message = pd.crosstab([df['year'], df["month"]], df['person'])
person_month_message.plot(kind='line', figsize=figsize)
plt.title("message count by person")
plt.ylabel("count")
plt.ylim(0,)
plt.savefig('message_count_by_person.png')
```
### 月別電話時間
電話の`flag`は10なのでまずは、csvからそのデータを取り出します。さらに電話時間はCSVに秒で記録されておりそのままでは、値が大きく理解しずらいため、3600でわり、時間にしました。
```python
call_time = df[df['flag'] == 10]
call_time = call_time[["year", "month", "payloads"]]
call_time = call_time.astype('int64').groupby(['year', 'month']).sum() / 3600
call_time.plot(y='payloads', kind='bar', label='time', figsize=figsize)
plt.ylabel("time(hours)")
plt.legend()
plt.ylim(0,)
plt.title('Call Time')
plt.savefig('call_time.png')
```

### 月別メッセージの文字数の合計
charというcolumnを作成し、そこにメッセージの文字数を入れたあとメッセージ数を数えた時と同じように、集計を行いました。
```python
# メッセージを取り出す
char_count_data = df[df['flag'] == 0]
# charというcolumnを作成し、そこにメッセージの文字数を入れる
char_count_data["char"] = char_count_data["payloads"].apply(lambda x: len(x))
char_count = char_count_data[["year", "month", "char"]]
char_count = char_count.astype('int64').groupby(['year', 'month']).sum()
char_count.plot(y='char', kind='bar', label='char', figsize=figsize)
plt.ylabel("char")
plt.legend()
plt.ylim(0,)
plt.title('char data')
plt.savefig('char_count.png')
```

### 人べつ月ごとの文字数の合計
月別メッセージの文字数の合計で作成したデータフレームを再利用し人べつのデータを作成します。
```python
char_count_by_person = char_count_data[["year", "month", "person", "char"]]
char_count_by_person["char"].astype('int64')
char_count_by_person = pd.pivot_table(
    char_count_by_person,
    values="char",
    index=["year", "month"],
    columns="person",
    aggfunc="sum"
)
char_count_by_person.plot(kind='line', figsize=figsize)
plt.ylabel("char")
plt.title('Char by person')
plt.ylim(0,)
plt.legend()
plt.savefig('char_count_by_person.png')
```

### 解析するコードの全体
```python
# -*- coding: utf-8 -*-

import pandas as pd
import matplotlib.pyplot as plt

file_path = "line.csv"

figsize = (12, 8)
df = pd.read_csv(file_path, names=('year', 'month', 'day',
                                   'hour', 'minute', 'person', 'payloads', 'flag'), encoding="UTF-8")
month_message = df[["year", "month", "flag"]
                   ].groupby(['year', 'month']).count()

month_message.plot(y='flag', kind='bar', label="count", figsize=figsize)
plt.ylabel("message count")
plt.legend()
plt.ylim(0,)
plt.title('message')
plt.savefig('message_count.png')

person_month_message = pd.crosstab([df['year'], df["month"]], df['person'])
person_month_message.plot(kind='line', figsize=figsize)
plt.title("message count by person")
plt.ylabel("count")
plt.ylim(0,)
plt.savefig('message_count_by_person.png')

call_time = df[df['flag'] == 10]
call_time = call_time[["year", "month", "payloads"]]
newdf = pd.DataFrame([[2018, 3, 0], [2018, 10, 0], [2018, 12, 0], [2019, 1, 0], [2019, 3, 0], [2019, 5, 0], [2020, 10, 0], [2020, 11, 0], [2021, 2, 0], ],
                     columns=["year", "month", "payloads"])
call_time.append(newdf, ignore_index=True)
call_time = call_time.append(newdf)
call_time = call_time.astype('int64').groupby(['year', 'month']).sum() / 3600
call_time.plot(y='payloads', kind='bar', label='time', figsize=figsize)
plt.ylabel("time(hours)")
plt.legend()
plt.ylim(0,)
plt.title('Call Time')
plt.savefig('call_time.png')

char_count_data = df[df['flag'] == 0]
char_count_data["char"] = char_count_data["payloads"].apply(lambda x: len(x))
char_count = char_count_data[["year", "month", "char"]]
char_count = char_count.astype('int64').groupby(['year', 'month']).sum()
char_count.plot(y='char', kind='bar', label='char', figsize=figsize)
plt.ylabel("char")
plt.legend()
plt.ylim(0,)
plt.title('char data')
plt.savefig('char_count.png')

char_count_by_person = char_count_data[["year", "month", "person", "char"]]
char_count_by_person["char"].astype('int64')
char_count_by_person = pd.pivot_table(
    char_count_by_person,
    values="char",
    index=["year", "month"],
    columns="person",
    aggfunc="sum"
)
char_count_by_person.plot(kind='line', figsize=figsize)
plt.ylabel("char")
plt.title('Char by person')
plt.ylim(0,)
plt.legend()
plt.savefig('char_count_by_person.png')

```

以上でグラフを作成することができました。一度作ってしまえば実行するだけなので、定期的に実行して変化を試したいと思います。

# Reference
以下のページを参考にしました  
- https://qiita.com/shimajiroxyz/items/9a06a086ee9730ee3d55