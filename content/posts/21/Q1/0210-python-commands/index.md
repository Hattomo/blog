---
title: "Useful Python commands"
date: 2021-02-10T00:48:03+09:00
draft: false
# weight: 1
# aliases: ["/first"]
tags: ["python"]
categories: ["computer"]
showToc: true
TocOpen: true
hidemeta: false
comments: false
ShowBreadCrumbs: true
description: "Memolize Python useful tools"
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

## Python Environment
`Python`便利なコマンドのメモです。

## venv
```bash
# if you do not have venv
# linux
$ sudo apt install python3-venv

# create virtual environment
$ python3 -m venv [/path/to/new/virtual/environment]

# activate
$ cd [environment name]
$ source [environment name]/bin/activate

# deactivate
$ deactivate
```

## Module input & output
```bash
$ pip3 freeze > requirements.txt
$ pip3 install -r requirements.txt
```

## Install and Run Jupyter Notebook
```bash
# install
$ pip3 install jupyter

#Run
$ jupyter notebook
# or
$ python3 -m notebook
# After seconds, Press Ctrl+C to show URL
```

## OpenCV
```bash
# install
$ pip3 install opencv-python
```

```python
# python
# useage
import cv2 
```
