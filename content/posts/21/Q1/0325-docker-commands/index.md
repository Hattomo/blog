---
title: "Useful Docker Commands"
date: 2021-03-25T15:10:58+09:00
lastmod: 2021-03-25T13:55:03+09:00
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
description: "Useful Docker Commands"
# cover:
#     image: "<image path/url>" # image path/url
#     alt: "<alt text>" # alt text
#     caption: "<text>" # display caption under cover
#     relative: true # when using page bundles set this to true
#     hidden: false # only hide on current single page
---
# Doker

## Docker command

```bash
# show container list
docker container ls -a

# get image from docker hub repo 
docker pull ubuntu:20.04

# show image list
docker images

# create container
# -v (v option) mount host directory
# -h (h option) set host name 
docker run -it -d -v /mnt/c/Users/ringp:/for_docker -h "host name" --privileged --name RISCVemu-u2004 ubuntu:20.04

# start container
docker start [container name/ID]

# stop container
docker stop [container name/ID]

# delete container
docker rm [container name/ID]

# delete container
docker rmi (-f) [container name/ID]

# delete build cache
docker builder prune

# open shell
docker exec -it RISCVemu-u20.04 /bin/bash -l

# build dockerfile
docker build -t hattomo/ubuntu2004 .
```

## docker-compose

```bash
# run
docker-compose up

# connent terminal
docker-compose exec RISCV-dev bash
```
# Reference
[https://unskilled.site/使い方基本版dockercomposeでコンテナ立ち上げ・連携を楽/](https://unskilled.site/%E4%BD%BF%E3%81%84%E6%96%B9%E5%9F%BA%E6%9C%AC%E7%89%88dockercompose%E3%81%A7%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E7%AB%8B%E3%81%A1%E4%B8%8A%E3%81%92%E3%83%BB%E9%80%A3%E6%90%BA%E3%82%92%E6%A5%BD/)