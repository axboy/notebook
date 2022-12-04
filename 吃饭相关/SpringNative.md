# Spring Native

## 准备

- 安装sdkman

```sh
## 非必须，主要用来安装GraalVM
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

- 安装[GraalVM](https://www.graalvm.org/downloads/)

```sh
## 通过其它方式安装也可
sdk install java 21.3.2.r11-grl
sdk use java 21.3.2.r11-grl
```

- 使用GraalVM命令安装原生镜像

```sh
gu install native-image
```

##  Hello World

```java:HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Native World!");
    } 
}
```

```sh
javac HelloWorld.java    # 编译java
native-image HelloWorld  # 编译native镜像
./helloWorld
```

## 项目改造
一个简单的web项目，几个api，几个定时任务
只修改了pom文件，项目无其他修改。添加了一些配置.

```xml:pom.xml
<?xml version="1.0" encoding="UTF-8"?>  
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  
    <modelVersion>4.0.0</modelVersion>  
    <parent>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-parent</artifactId>  
        <version>2.7.1</version>  
        <relativePath/> <!-- lookup parent from repository -->  
    </parent>  
    <!-- 省略一些属性 -->
    <properties>  
        <java.version>11</java.version>  
        
        <!-- 下面两个配置新加的 -->
        <repackage.classifier/>  
        <spring-native.version>0.12.1</spring-native.version>  
    </properties>  
    <dependencies>  
        <dependency>  
            <groupId>org.springframework.boot</groupId>  
            <artifactId>spring-boot-starter-data-redis-reactive</artifactId>  
        </dependency>  
        <dependency>  
            <groupId>org.springframework.boot</groupId>  
            <artifactId>spring-boot-starter-webflux</artifactId>  
        </dependency>
        
        <!-- 新添加的依赖 -->
        <dependency>  
            <groupId>org.springframework.experimental</groupId>  
            <artifactId>spring-native</artifactId>  
            <version>${spring-native.version}</version>  
        </dependency>
        
        <!-- 省略一些 -->
    </dependencies>  
  
    <build>  
        <plugins>  
            <plugin>  
                <groupId>org.springframework.boot</groupId>  
                <artifactId>spring-boot-maven-plugin</artifactId>
                <!-- configuration 是新添加的 -->
                <configuration>  
                    <classifier>${repackage.classifier}</classifier>  
                    <image>  
                        <builder>paketobuildpacks/builder:tiny</builder>  
                        <env>  
                            <BP_NATIVE_IMAGE>true</BP_NATIVE_IMAGE>  
                        </env>  
                    </image>  
                    <excludes>  
                        <exclude>  
                            <groupId>org.projectlombok</groupId>  
                            <artifactId>lombok</artifactId>  
                        </exclude>  
                    </excludes>  
                </configuration>  
            </plugin>  
            
            <!-- 新添加的 -->
            <plugin>  
                <groupId>org.springframework.experimental</groupId>  
                <artifactId>spring-aot-maven-plugin</artifactId>  
                <version>${spring-native.version}</version>  
                <executions>  
                    <execution>  
                        <id>test-generate</id>  
                        <goals>  
                            <goal>test-generate</goal>  
                        </goals>  
                    </execution>  
                    <execution>  
                        <id>generate</id>  
                        <goals>  
                            <goal>generate</goal>  
                        </goals>  
                    </execution>  
                </executions>  
            </plugin>  
        </plugins>  
    </build>  

    <!-- 新添加的 -->
    <repositories>  
        <repository>  
            <id>spring-releases</id>  
            <name>Spring Releases</name>  
            <url>https://repo.spring.io/release</url>  
            <snapshots>  
                <enabled>false</enabled>  
            </snapshots>  
        </repository>  
    </repositories>  
    <pluginRepositories>  
        <pluginRepository>  
            <id>spring-releases</id>  
            <name>Spring Releases</name>  
            <url>https://repo.spring.io/release</url>  
            <snapshots>  
                <enabled>false</enabled>  
            </snapshots>  
        </pluginRepository>  
    </pluginRepositories>  

    <!-- 新添加的 -->
    <profiles>  
        <profile>  
            <id>native</id>  
            <properties>  
                <repackage.classifier>exec</repackage.classifier>  
                <native-buildtools.version>0.9.13</native-buildtools.version>  
            </properties>  
            <dependencies>  
                <dependency>  
                    <groupId>org.junit.platform</groupId>  
                    <artifactId>junit-platform-launcher</artifactId>  
                    <scope>test</scope>  
                </dependency>  
            </dependencies>  
            <build>  
                <plugins>  
                    <plugin>  
                        <groupId>org.graalvm.buildtools</groupId>  
                        <artifactId>native-maven-plugin</artifactId>  
                        <version>${native-buildtools.version}</version>  
                        <extensions>true</extensions>  
                        <executions>  
                            <execution>  
                                <id>test-native</id>  
                                <phase>test</phase>  
                                <goals>  
                                    <goal>test</goal>  
                                </goals>  
                            </execution>  
                            <execution>  
                                <id>build-native</id>  
                                <phase>package</phase>  
                                <goals>  
                                    <goal>build</goal>  
                                </goals>  
                            </execution>  
                        </executions>  
                    </plugin>  
                </plugins>  
            </build>  
        </profile>  
    </profiles>  
  
</project>
```

## 打包
```sh
## jar包，rdc是私服配置
mvn clean package -Dmaven.test.skip=true -Prdc

## native包，-Pnative指定使用pom文件中的native配置
mvn clean package -Dmaven.test.skip=true -Prdc -Pnative
```

- 打包过程的cpu、内存截图
![progress](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202207/3c371f16548393719e39c935f1a737cc-3e6cef.png)

- 结果图
![](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202207/8862d09d9afbb0b6eecabeb95910dd55-4d7f60.png)

- 运行效果
![result](https://axboy-picgo-sz.oss-cn-shenzhen.aliyuncs.com/picgo/202207/22b68db75a4956910ceb3724a0bdef0a-3c80cd.png)

 关于定时任务问题：打包时，代码需要启用了定时任务，打包时什么参数运行时就是什么参数，外部参数无效。
 
 我这里@EnableScheduling有@Conditional控制，默认不生效，主要由外部参数控制。
 
 这样测试包、生产包不通用了，不能通过**--spring.profiles.active=prod** 这类参数来切换了。

## 异常
```plain
# 错误1，缺少gcc
Error: Default native-compiler executable 'gcc' not found via environment variable PATH
A: sudo apt install gcc

# 错误2，缺少lstdc++
/usr/bin/ld: cannot find -lstdc++: No such file or directory
A: apt install g++  # ubuntu
A: yum install -y libstdc++*   # centos

# 错误3，缺少lz
/usr/bin/ld: cannot find -lz: No such file or directory
A: apt install libz-dev

# 这是win10下的报错
Error: Default native-compiler executable 'cl.exe' not found via environment variable PATH
A: 缺少环境，先不折腾了，本来想看下win10下的本地包是什么样的
```

## 其它
- ubuntu解决/usr/bin/ld: cannot find lxxxx一般思路

 ```sh
# 把l换成lib搜索看看
apt-cache search libxxxx
```

## TODO
- 迁移问题

  本地虚拟机构建的包，放到阿里云服务器上，启动失败，都是ubuntu系统，配置不同，阿里云的配置是1c1g，正常java -jar 启动，只需要500m内存。

- 其它打包命令

  理论上是可以用native-image命令把springboot jar文件转换成本地镜像的，目前还没试成功。

## 参考
- [知乎 - SpringNative实战](https://zhuanlan.zhihu.com/p/432141194)
- [spring.io - Docs](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/#_sample_project_setup)
- [graalvm.org - native image](https://www.graalvm.org/22.2/reference-manual/native-image/)
- [阿里镜像源](https://developer.aliyun.com/mirror/)
- [CSDN - # maven中mirror镜像和repository仓库配置](https://blog.csdn.net/A434534658/article/details/122484501)
- [博客园 - ubuntu中解决/usr/bin/ld: cannot find -lxxx](https://www.cnblogs.com/lanjianhappy/p/10647099.html))
