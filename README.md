# Hattomo Blog
This content is for my blog which URL is https://hattomo.github.io  
Built content is [Hattomo/Hattomo.github.io](https://github.com/Hattomo/Hattomo.github.io)

## Setup
To setup new device, please execute commands below.
```
$ git clone https://github.com/Hattomo/blog.git
$ git submodule update --init --recursive
$ cp tools/pre-commit .git/hooks/pre-commit
$ chmod +x .git/hooks/pre-commit
$ chmod +x new.sh
```

## Update
To update submodule, please execute commands below.
```
$ git submodule update --remote --merge
```

To update archetypes/default.md
```
$ git commit -n -m "comments"
```

## Create new posts
```
$ new.sh posts/{title}.md
```
