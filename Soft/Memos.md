# [Memos](https://usememos.com/)
> A lightweight, self-hosted memo hub. Open Source and Free forever.

#### Docker run
```sh
docker run -d --name memos \
    -p 5230:5230 \
    -v ~/.memos/:/var/opt/memos \
    neosmemo/memos:latest
```