

# 0.需要注意

**Client接口和熔断器实现类是一一对应的**

- DemoClient这个Client接口与DemoDefaultFallback这个熔断器实现类就是对应的
- 熔断器的实现类需要被@Component修饰从而加入IOC容器

# 1.maven依赖配置

下面是一个基本的 Maven `pom.xml` 文件示例，其中包含了 OpenFeign 和 Eureka Client 的依赖。您可以根据需要进行调整：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>client-service</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <properties>
        <java.version>17</java.version>
        <spring-cloud.version>3.1.0</spring-cloud.version>
    </properties>

    <dependencies>
        <!-- Spring Boot Starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <!-- Spring Cloud Starter for Eureka Client -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>

        <!-- Spring Cloud OpenFeign -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>

        <!-- Spring Boot Starter Test (for testing purposes) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

### 说明

1. **依赖项**：
   - `spring-boot-starter`：基础的 Spring Boot 启动器。
   - `spring-cloud-starter-netflix-eureka-client`：Eureka 客户端支持。
   - `spring-cloud-starter-openfeign`：支持 OpenFeign 的启动器。
   - `spring-boot-starter-test`：用于单元测试的依赖。

2. **属性**：
   - `java.version`：设置 Java 版本（根据您的实际情况进行调整）。
   - `spring-cloud.version`：指定 Spring Cloud 的版本。

3. **构建插件**：
   - `spring-boot-maven-plugin`：用于简化 Spring Boot 应用的构建和运行。

根据需要，您可以添加更多的依赖或配置。确保在使用前将版本号更新到适合您的项目需求的最新版本。

# 二.文件架构展示

![image-20241102220011260](D:\Github\HNUSTbook\[Web后端]-单体架构\Java-Spring-mysql-mybatis全家桶\JavaSE\JavaSE之源码拾遗\随笔\client项目的涵盖图.png)

> 其中每一个Client都要和FallBack对应
>
> Client为接口
>
> fallBack为实现了接口的类

# 三.Client细节分析

```java
package com.crazymaker.springcloud.seckill.remote.client;

import com.alibaba.fastjson.JSONObject;
import com.crazymaker.springcloud.common.result.RestOut;
import com.crazymaker.springcloud.seckill.remote.fallback.DemoDefaultFallback;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @description:远程服务的本地声明式接口
 */

@FeignClient(
        value = "demo-provider", path = "/demo-provider/api/demo/",
        fallback = DemoDefaultFallback.class
)
public interface DemoClient
{
    /**
     * 远程调用接口的方法:
     * 调用   demo-provider 的  REST 接口  api/demo/hello/v1
     * REST 接口 功能：返回 hello world
     * @return JSON 响应实例
     */
    @GetMapping("/hello/v1")
    RestOut<JSONObject> hello();

    /**
     * 远程调用接口的方法:
     * 调用   demo-provider 的  REST 接口  api/demo/echo/{0}/v1
     * REST 接口 功能： 回显输入的信息
     * @return echo 回显消息 JSON 响应实例
     */
    @RequestMapping(value = "/echo/{word}/v1",
            method = RequestMethod.GET)
    RestOut<JSONObject> echo(
            @PathVariable(value = "word") String word);

}

```

在您的代码中，`@FeignClient` 注解用于声明一个 Feign 客户端，它允许您通过简单的接口调用远程服务。以下是 `@FeignClient` 注解的各个属性的解释：

### `@FeignClient` 属性

1. **`value`**：
   - **含义**：指定远程服务的名称（通常是在服务注册中心中注册的服务名）。
   - **示例**：在这里是 `"demo-provider"`，表示要调用名为 `demo-provider` 的服务。

2. **`path`**：
   - **含义**：指定基础路径，所有接口的请求路径都会在此基础上加上。
   - **示例**：`"/demo-provider/api/demo/"`，表示所有请求将以这个路径为基础。

3. **`fallback`**：
   - **含义**：指定一个类作为熔断器（fallback），当调用失败或服务不可用时将回退到该类中的逻辑。
   - **示例**：`DemoDefaultFallback.class`，表示如果远程服务不可用，则会调用 `DemoDefaultFallback` 类中的方法。

### 例子中的方法

- **`hello()`**：
  - **请求方式**：GET
  - **路径**：`/hello/v1`
  - **功能**：调用远程服务的接口，返回一个 JSON 响应。

- **`echo(String word)`**：
  - **请求方式**：GET
  - **路径**：`/echo/{word}/v1`
  - **功能**：调用远程服务的接口，将输入的 `word` 作为路径变量传递，并返回一个 JSON 响应。

### 总结

`@FeignClient` 注解通过这些属性使得微服务之间的调用变得简洁和直观。您只需定义接口及其方法，Feign 会处理 HTTP 请求的生成和响应的解析。同时，指定的 fallback 类能够有效地增强服务的鲁棒性。

# 四.针对Client无法工作时,提供熔断返回结果FallBack

这个 `DemoDefaultFallback` 类是一个 Feign 客户端的熔断器实现，用于处理远程服务调用失败时的逻辑。下面是对该类及其注解的详细分析：

### 类级别分析

```java
@Component
public class DemoDefaultFallback implements DemoClient
```

- **`@Component`**：
  - **含义**：该注解标识该类为 Spring 的组件，Spring 会自动扫描并注册为一个 Bean。
  - **用途**：使得这个类能够被 Spring 上下文管理，并可以被依赖注入。

- **`implements DemoClient`**：
  - **含义**：这个类实现了 `DemoClient` 接口，表明它是这个接口的一个具体实现。
  - **用途**：在 Feign 调用失败时，Spring Cloud 会自动使用这个类中的方法替代远程调用。

### 方法分析

1. **`hello()` 方法**

```java
@GetMapping("/hello/v1")
public RestOut<JSONObject> hello()
{
    return RestOut.error("远程调用失败,返回熔断后的调用结果" );
}
```

- **`@GetMapping("/hello/v1")`**：
  - **含义**：这个注解定义了该方法对应的 HTTP GET 请求路径。
  - **用途**：尽管这个方法作为熔断器，实际并不执行远程调用，但为了保持接口的一致性，仍然可以保留 HTTP 请求映射。

- **方法功能**：
  - 返回一个 `RestOut` 对象，表示调用失败的信息。这个响应包含错误信息，说明远程调用失败并返回了熔断后的结果。

2. **`echo(String word)` 方法**

```java
@Override
public RestOut<JSONObject> echo(String word)
{
    return RestOut.error("远程调用失败,返回熔断后的调用结果" );
}
```

- **`@Override`**：
  - **含义**：表示该方法重写了 `DemoClient` 接口中的同名方法。
  - **用途**：确保实现的逻辑符合接口定义。

- **方法功能**：
  - 同样返回一个 `RestOut` 对象，表示调用失败，并返回相应的错误信息。

### 总结

- `DemoDefaultFallback` 类提供了对 `DemoClient` 接口的熔断器实现。在远程调用失败时，这个类中的方法会被调用，返回的错误信息可以帮助调用方识别问题。
- 使用 `@Component` 注解确保该类能够被 Spring 管理，使得熔断逻辑能够在 Feign 客户端调用时自动生效。
