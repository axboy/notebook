# Jenkins

```sh
docker run -d --name jenkins \
    -p 8080:8080 \
    --restart=on-failure \
    jenkins/jenkins:lts-jdk11
```

## 其它
- [jenkins docker readme](https://github.com/jenkinsci/docker/blob/master/README.md)