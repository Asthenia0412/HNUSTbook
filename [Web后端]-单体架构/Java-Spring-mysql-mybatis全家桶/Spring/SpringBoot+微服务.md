```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.5.3</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <groupId>tech.pdai</groupId>
    <artifactId>101-springboot-demo-helloworld</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.30</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.3.1</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.2.10</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>2.9.2</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>2.9.2</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <!-- validation -->


    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```



[toc]









# 一：SpringBoot基础

- 能够创建独立的Spring应用程序
- 内嵌Tomcat,Jetty,Undertow服务器（无需单独部署WAR包，打包成JAR包即可使用）
- 提供一站式的"starter"依赖项,简化Maven配置(需要整合什么框架，就导入框架对应的starter依赖)
- 尽可能自动配置Spring与第三方库（除了特殊情况，不需要任何配置）
- 提供生产环境下功能：指标，运行状况检查，外部化配置
- 没有任何代码生成，不需要任何XML文件：我相信你写SpringIOC,AOP,MVC以及Mybatis的各种映射和SQL的xml已经非常的厌倦了，这种XML配置写起来太麻烦了,我们用springboot就不用再写xml了
- SSM阶段：
  - 需要搭建基于Spring全家桶的Web应用，不得不做大量依赖导入，框架整合，Bean定义。整合框架都花费大量时间，但是整合框架基本都是固定流程，所以我们可以抽象出这种固定流程，作为约定。只要框架遵守约定，为我们提供默认配置即可。
  - 上述的过程被抽象为了启动器(starter)依赖
  - Springboot提供自动扫描，你不再需要@ComponentScan



## 1.Springboot的创建

- 网页版本->官网下载
- IDEA中创建Springboot
- 常用依赖：
  - Lombok



> 观察SpringBoot的依赖项

```xml
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
```



> 观察启动类

```java
package org.xiaoyongcai.springboottest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringBootTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootTestApplication.class, args);
    }

}

```



> 观察测试类(不需要你像SSM开发一样自己手动安装测试依赖，然后自己打@Test)SpringBoot自动生成了

```java
package org.xiaoyongcai.springboottest;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SpringBootTestApplicationTests {

    @Test
    void contextLoads() {
    }

}

```

## 2.使用Springboot的经验教训

### A.在pojo类：使用@AllArgsConstructor前一定要加上@NoArgsConstructor

```java
@Data
@NoArgsConstructor
@Component
@AllArgsConstructor
public class Student {
    private String name;
    private int age;
}
```



```
 <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
```

### B.Lombok与JDK版本/Spring版本造成的异常

`Class com.sun.tools.javac.tree.JCTree$JCImport does not have member field 'com.sun.tools.javac.tree.JCTree qualid'`

问题原因是Lombok ，与 JDK 21 兼容的最低 Lombok 版本是 1.18.30，最小的 Spring Boot 版本是 3.1.4。



替换Lombok的版本,使用下面的依赖文件替换原来的

```xml
<dependency>
   <groupId>org.projectlombok</groupId>
   <artifactId>lombok</artifactId>
   <version>1.18.30</version>
</dependency>
```



## 3.入门详解

### A.启动类：

```java
@SpringBootApplication

public class SpringBootTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBootTestApplication.class, args);
    }
}
```

`SpringApplication.run(SpringBootTestApplication.class,args);`这里填入的class就是启动类的具体字节码文件

### B.最基础的映射测试

我们将Application类新建为@RestController:两层含义 A.不用走JSP道路，直接返回内容，是@ResponseBody B.@Controller说明作为视图层被添加到Spring容器中

```java
@SpringBootApplication
@RestController()
public class SpringBootTestApplication{
    public static void main(String[] args){SpringApplication.run(SpringBootTestApplication.class),args};
    
    @GetMapping("/hello")
    public ResponseEntity<String> hello(){
        return new ResponseEntity<>("Hello,Wolrd",HttpStatus.OK);
    }
    
}
```

**ResponseEntity类详解**：

- 是Spring Framework的部分，体现Http相应所有信息,例如:状态码，头信息，响应体。因此：我们不必手动创建ResponseEntity类.因为其为SpringMVC提供的现成的类
- ResponseBody是一个泛型类,表示整个HTTP响应，包括**状态码**，**头**，**正文**
  - ResponseBody<String>表示响应体将包含一个字符串
- ` new ResponseEntity<>("Hello,Wolrd",HttpStatus.OK);`其中参数：HttpStatus.OK是一个枚举类，对应状态码200
- ResponseEntity类是Spring Framework的spring-web模块的部分：只要pom.xml包含了`spring-boot-starter-web`依赖,SpringBoot会自动提供该功能

### C.MVC架构的单体测试

#### C.1三层架构具体代码:

```java
package org.xiaoyongcai.springboottest.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int id;
    private String userName;

}

```

```java
package org.xiaoyongcai.springboottest.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xiaoyongcai.springboottest.dao.UserRepository;
import org.xiaoyongcai.springboottest.entity.User;
import org.xiaoyongcai.springboottest.service.UserService;

import java.util.List;
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userDao;


    @Override
    public void addUser(User user) {
        userDao.save(user);
    }

    @Override
    public List<User> list() {
        return userDao.findAll();
    }
}

```

```java
package org.xiaoyongcai.springboottest.dao;

import org.springframework.stereotype.Repository;
import org.xiaoyongcai.springboottest.entity.User;

import java.util.ArrayList;
import java.util.List;

@Repository//等价于@Component 但是@Repository体现在Dao层。有的项目Dao层，也叫Mapper层
public class UserRepository {
    private List<User> userDemoList = new ArrayList<User>();
    public void save(User user){
        userDemoList.add(user);
    }
    public List<User> findAll(){
        return userDemoList;
    }
}

```

```java
package org.xiaoyongcai.springboottest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.xiaoyongcai.springboottest.entity.User;
import org.xiaoyongcai.springboottest.service.UserService;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController
{
    @Autowired
    private UserService userService;

    @RequestMapping("add")
    public User add(User user){
        userService.addUser(user);
        return user;
    }
    @GetMapping("list")
    public List<User> list(){
        return userService.list();
    }
}

```



#### C.2测试Web服务

**ADD添加方法**：

```
http://localhost:8080/user/add?id=5&userName="测试内容"
```

```json
{
    "id": 5,
    "userName": "\"测试内容\""
}
```

**查询所有已添加的内容**：

```
http://localhost:8080/user/list
```

```json
[
    {
        "id": 1,
        "userName": "\"测试\""
    },
    {
        "id": 0,
        "userName": "\"测试\""
    },
    {
        "id": 0,
        "userName": "\"测试\""
    },
    {
        "id": 1,
        "userName": "\"测试\""
    },
    {
        "id": 5,
        "userName": "\"测试\""
    },
    {
        "id": 5,
        "userName": "\"测试\""
    },
    {
        "id": 5,
        "userName": "\"测试内容\""
    }
]
```

## 4.添加LogBack日志

### A.在Pom中配置依赖

```xml
<dependency>
  <groupId>ch.qos.logback</groupId>
  <artifactId>logback-classic</artifactId>
  <version>1.2.10</version>
</dependency>

```

### B.在测试类中实现Logger

```java
package org.xiaoyongcai.springboottest;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SpringBootTestApplicationTests {
    @Test
    void contextLoads() {
        Logger logger = LoggerFactory.getLogger(SpringBootTestApplicationTests.class);
        logger.trace("这是trace日志...");
        logger.debug("这是debug日志...");
        logger.info("这是info日志...");
        logger.warn("这是warn日志...");
        logger.error("这是error日志");
    }




}

```

> 要关注：
>
> `import org.slf4j.Logger;
> import org.slf4j.LoggerFactory;`
>
> 不要导入如下：否则会导致String识别失败。
>
> `*import org.junit.platform.commons.logging.Logger;* `
>
> `*import org.junit.platform.commons.logging.LoggerFactory;*` 

## 5.热部署DevTools工具

> 在SpringBoot开发调试中，如果我每行代码的修改都需要重启启动再调试，可能比较费时间；SpringBoot团队针对此问题提供了spring-boot-devtools（简称devtools）插件，它试图提升开发调试的效率。

### A.热部署与热加载区别

- **热部署**
  - 在服务器运行时重新部署项目
  - 它是直接重新加载整个应用，这种方式会释放内存，比热加载更加干净彻底，但同时也更费时间。
- **热加载**
  - 在在运行时重新加载class，从而升级应用。
  - 热加载的实现原理主要依赖[java的类加载机制]()，在实现方式可以概括为在容器启动的时候起一条后台线程，定时的检测类文件的时间戳变化，如果类的时间戳变掉了，则将类重新载入。
  - 对比反射机制，反射是在运行时获取类信息，通过动态的调用来改变程序行为； 热加载则是在运行时通过重新加载改变类信息，直接改变程序行为。

### B.DevTools依赖

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
        </dependency>
```

### C.DevTools的优势

**使用 DevTools 的优势：**

1. **自动重启**：当你的应用代码发生变化时，DevTools 能够自动重启应用，这意味着你不需要手动停止和启动应用来看到更改的效果。
2. **自动刷新**：除了重启应用外，DevTools 还能自动刷新应用中的静态资源，例如 CSS 和 JavaScript 文件。
3. **LiveReload**：DevTools 集成了 LiveReload，可以在资源变化时自动刷新浏览器。
4. **开发时配置**：DevTools 提供了一些特定的配置，比如关闭模板缓存，使得开发体验更接近生产环境。
5. **属性默认值**：DevTools 修改了一些属性默认值，如日志级别和模板缓存，以适应开发环境。

**不使用 DevTools：**

1. **手动重启**：你需要手动重启应用来查看代码更改的效果。
2. **手动刷新**：静态资源的变化不会自动反映在浏览器中，需要手动刷新。
3. **配置管理**：可能需要更多的配置工作来确保开发环境和生产环境的一致性。

## 6.SpringBoot常用注解

### A.@SpringBootApplication

- 工作位置：main方法上

```java
@SpringBootApplication
public class SpringBootTestApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringBootTestApplication.class, args);
    }
}
```

### B.@EnableAutoConfiguration 

```java
@SpringBootApplication // 包含了 @EnableAutoConfiguration
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

```

### C.@ImportResource 

```java
@Configuration
@ImportResource("classpath:applicationContext.xml")
public class AppConfig {
    // 导入 XML 配置文件
}

```

- 虽然@SpringBootApplication可以自动扫描，但有时也需要配置类，在配置类使用@ImportResource导入外部xml

### D.@Value 

```java
@Component
public class ExampleComponent {
    @Value("${example.property}")
    private String exampleProperty;
}

```

在Spring Boot项目中，`@Value` 注解用来将外部配置的值注入到字段中。除了 `${}` 用于注入属性文件的值之外，还可以使用 `#{}` 来注入SpEL（Spring Expression Language，即Spring表达式语言）表达式。

以下是两者的主要区别：

1. `${}`：

   - 用于注入外部配置文件（如application.properties或application.yml）中的属性值。
   - 如果配置文件中找不到对应的值，将无法启动应用，除非你提供了默认值（例如：`${some.value:default}`）。
   - 主要用于静态的配置值。

   示例：

   ```java
   @Value("${server.port}")
   private int port;
   ```

2. `#{}`：

   - 用于执行SpEL表达式，可以在运行时计算值。
   - SpEL提供了更复杂的求值能力，比如条件判断、数学运算、调用方法、访问对象属性等。
   - 可以用来注入动态生成的值，或者对注入的值进行进一步的计算或转换。

   示例：

   ```java
   @Value("#{ T(java.lang.Math).random() * 100.0 }")
   private double randomNumber;
   ```

使用时需要注意的是，虽然SpEL非常强大，但过度使用可能会使代码变得难以理解和维护。因此，建议仅在需要动态计算值时使用 `#{}`，而对于简单的配置值注入，使用 `${}` 就足够了。

### E.@ConfigurationProperties(prefix=“person”) 

```java
@Component
@ConfigurationProperties(prefix = "person")
public class PersonProperties {
    private String name;
    private int age;
    // getters and setters
}

```

`@ConfigurationProperties` 注解在Spring Boot中用于将配置文件（如application.properties或application.yml）中的属性绑定到一个Java Bean上。在提供的代码片段中，`@ConfigurationProperties(prefix = "person")` 的作用如下：

1. **属性绑定**：它指示Spring Boot将配置文件中以"person"为前缀的属性绑定到`PersonProperties`类的字段上。例如，如果配置文件中有以下内容：

   

   ```
   person.name=John
   person.age=30
   ```

   那么，`PersonProperties`类的`name`字段将被设置为"John"，`age`字段将被设置为30。

2. **简化配置管理**：通过使用`@ConfigurationProperties`，你可以在一个集中的地方管理所有与某个特定领域相关的配置，而不是在代码中四处使用`@Value`注解。

3. **类型安全**：与使用`@Value`注解相比，`@ConfigurationProperties`提供了类型安全的配置。这意味着如果配置文件中的值类型不匹配，Spring Boot会在启动时抛出异常。

4. **松散绑定**：`@ConfigurationProperties`支持松散绑定，这意味着你可以使用不同的命名约定（如驼峰式、下划线、中划线）来指定配置属性，Spring Boot会自动处理这些命名差异。

以下是`@ConfigurationProperties`注解的一些关键点：

- `prefix`属性定义了配置文件中属性的前缀，它必须与配置文件中的属性前缀匹配。
- 为了使`@ConfigurationProperties`注解生效，你需要确保`PersonProperties`类被Spring容器管理。这通常通过在类上添加`@Component`注解来实现，正如代码片段所示。
- `PersonProperties`类应该提供标准的Java Bean getter和setter方法，以便Spring Boot可以通过这些方法进行属性绑定。
- `@ConfigurationProperties`可以与`@EnableConfigurationProperties`注解一起使用，后者可以放在任何配置类上，以启用对`@ConfigurationProperties`的支持。
- `@ConfigurationProperties`支持复杂的类型和嵌套属性，使得配置更加灵活。

使用`@ConfigurationProperties`的好处是它提供了更加强大和灵活的配置管理方式，尤其是在处理具有多个属性的复杂配置时。

### F.@EnableConfigurationProperties 

```java
@SpringBootApplication
@EnableConfigurationProperties(PersonProperties.class)
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

`@ConfigurationProperties` 注解在Spring Boot中用于将配置文件（如application.properties或application.yml）中的属性绑定到一个Java Bean上。在提供的代码片段中，`@ConfigurationProperties(prefix = "person")` 的作用如下：

1. **属性绑定**：它指示Spring Boot将配置文件中以"person"为前缀的属性绑定到`PersonProperties`类的字段上。例如，如果配置文件中有以下内容：

   ```
   person.name=John
   person.age=30
   ```

   那么，`PersonProperties`类的`name`字段将被设置为"John"，`age`字段将被设置为30。

2. **简化配置管理**：通过使用`@ConfigurationProperties`，你可以在一个集中的地方管理所有与某个特定领域相关的配置，而不是在代码中四处使用`@Value`注解。

3. **类型安全**：与使用`@Value`注解相比，`@ConfigurationProperties`提供了类型安全的配置。这意味着如果配置文件中的值类型不匹配，Spring Boot会在启动时抛出异常。

4. **松散绑定**：`@ConfigurationProperties`支持松散绑定，这意味着你可以使用不同的命名约定（如驼峰式、下划线、中划线）来指定配置属性，Spring Boot会自动处理这些命名差异。

以下是`@ConfigurationProperties`注解的一些关键点：

- `prefix`属性定义了配置文件中属性的前缀，它必须与配置文件中的属性前缀匹配。
- 为了使`@ConfigurationProperties`注解生效，你需要确保`PersonProperties`类被Spring容器管理。这通常通过在类上添加`@Component`注解来实现，正如代码片段所示。
- `PersonProperties`类应该提供标准的Java Bean getter和setter方法，以便Spring Boot可以通过这些方法进行属性绑定。
- `@ConfigurationProperties`可以与`@EnableConfigurationProperties`注解一起使用，后者可以放在任何配置类上，以启用对`@ConfigurationProperties`的支持。
- `@ConfigurationProperties`支持复杂的类型和嵌套属性，使得配置更加灵活。

### G.@RestController 

```java
@RestController
@RequestMapping("/api")
public class ExampleController {
    @GetMapping("/greeting")
    public String greeting() {
        return "Hello, World!";
    }
}

```

### H.@RequestMapping(“/api2/copper”) 

```java
@RestController
@RequestMapping("/api2/copper")
public class CopperController {
    // All endpoints in this controller will start with /api2/copper
}

```

### I.@RequestParam 

```java
@RestController// 127.0.0.1:8080/{test} {} @PathVariable
public class QueryParamController { 
    @GetMapping("/search")// 127.0.0.1:8080/add?id=1&name="测试名称"
    public String search(@RequestParam String query) {
        return "Search for: " + query;
    }
}

```

### J.@ResponseBody

```java
@Controller
public class SimpleController {
    @GetMapping("/simple")
    @ResponseBody
    public String simple() {
        return "Simple response";
    }
}

```

### K.@Bean 

```java
@Configuration
public class AppConfig {
    @Bean
    public ExampleBean exampleBean() {
        return new ExampleBean();
    }
}

```

### L.@Service 

```java
@Service
public class ExampleService {
    public String doWork() {
        return "Work done";
    }
}

```

### M.@Controller 

```java
@Controller
public class WebController {
    // MVC controller handling web requests
}

```

### N.@Repository 

```java
@Repository
public class ExampleRepository {
    // Persistence layer component
}
```

### O.@Component 

```java
@Component
public class ExampleComponent {
    // A generic component
}

```

### P.@PostConstruct 

```java
@Component
public class InitComponent {
    @PostConstruct
    public void init() {
        // Initialization code
    }
}

```

在 Spring 框架中，Bean 的生命周期指的是 Bean 从创建到销毁的过程。Spring 提供了多种注解来控制 Bean 的生命周期，包括创建、初始化和销毁。

相关注解：

1. **@PostConstruct**
    `@PostConstruct` 是一个 Java EE 规范注解，用于在 Bean 初始化后执行某些操作。当 Spring 容器创建 Bean 并将其注入到其他 Bean 或调用其方法时，它会调用 `@PostConstruct` 注解的方法。
    ```java
    @Component
    public class InitComponent {
        @PostConstruct
        public void init() {
            // Initialization code
        }
    }
    ```
    在这个例子中，`init()` 方法将在 Bean 创建并注入到其他 Bean 或调用其方法之后被调用。

生命周期相关注解：

1. **@PostConstruct**
    正如前面所述，`@PostConstruct` 用于在 Bean 初始化后执行某些操作。
2. **@PreDestroy**
    `@PreDestroy` 是一个 Java EE 规范注解，用于在 Bean 销毁之前执行某些操作。当 Spring 容器销毁 Bean 时，它会调用 `@PreDestroy` 注解的方法。
    ```java
    @Component
    public class InitComponent {
        @PreDestroy
        public void destroy() {
            // Cleanup code
        }
    }
    ```
    在这个例子中，`destroy()` 方法将在 Bean 销毁之前被调用。

生命周期管理：

Spring 提供了两种方式来管理 Bean 的生命周期：
1. **Java 配置**：通过使用 `@PostConstruct` 和 `@PreDestroy` 注解，你可以直接在 Bean 的方法中编写初始化和清理代码。
2. **XML 配置**：在 XML 配置文件中，你可以使用 `<bean>` 元素的 `init-method` 和 `destroy-method` 属性来指定初始化和清理方法。
   
    ```xml
    <bean id="initComponent" class="com.example.InitComponent"
          init-method="init" destroy-method="destroy">
        <!-- other bean properties -->
    </bean>
    ```
    在这个例子中，`initComponent` Bean 的初始化和清理方法分别是 `init` 和 `destroy`。
    通过这些注解和配置方式，你可以精确地控制 Bean 的生命周期，从而更好地管理你的应用程序。

### Q.@PathVariable 

```java
@RestController
@RequestMapping("/users")
public class UserController {
    @GetMapping("/{id}")
    public String getUserById(@PathVariable String id) {
        return "User ID: " + id;
    }
}

```

### R.@ComponentScan 

```java
@SpringBootApplication
@ComponentScan(basePackages = {"com.example"})
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

```

### S.@EnableZuulProxy 

```java
@SpringBootApplication
@EnableZuulProxy
public class ZuulApplication {
    public static void main(String[] args) {
        SpringApplication.run(ZuulApplication.class, args);
    }
}

```

### 
`@EnableZuulProxy` 是 Spring Cloud Netflix Zuul 的一个注解，用于启用 Zuul 代理功能。

**场景分析：**

- **API 网关**：在微服务架构中，Zuul 作为一个 API 网关，负责路由请求到不同的微服务实例，并提供诸如身份验证、监控、弹性、动态路由等边缘服务。`@EnableZuulProxy` 是在 Spring Boot 应用中启用这些功能的关键。
- **请求过滤**：Zuul 允许你定义前置和后置过滤器，这些过滤器可以修改请求和响应，或者根据某些条件拒绝请求。使用 `@EnableZuulProxy` 可以轻松配置这些过滤器。
- **服务聚合**：Zuul 可以将多个服务的结果聚合到一个响应中，这对于构建复合 API 非常有用。
- **动态路由**：如果你的微服务实例是动态变化的（例如，使用 Kubernetes 进行自动扩展），Zuul 可以与服务发现机制（如 Eureka）集成，以动态地路由请求到正确的实例。

注解使用：

在提供的代码示例中，`@SpringBootApplication` 和 `@EnableZuulProxy` 注解用于定义一个 Spring Boot 应用，该应用同时作为 Zuul 代理服务器。
```java
@SpringBootApplication
@EnableZuulProxy
public class ZuulApplication {
    public static void main(String[] args) {
        SpringApplication.run(ZuulApplication.class, args);
    }
}
```
这段代码定义了一个 Spring Boot 应用的入口点，并且启用了 Zuul 代理功能。当应用启动时，Spring Boot 的自动配置和 Zuul 的代理功能都会被激活，允许该应用作为一个 API 网关来服务客户端请求。



### T.@Autowired 

```java
@Service
public class ExampleService {
    @Autowired
    private ExampleRepository exampleRepository;
}

```

### U.@Configuration 

```java
@Configuration
public class AppConfig {
    // Configuration class
}

```

### V.@Import(Config1.class) 

`@Import` 注解用于导入其他的配置类。它允许你在当前配置类中引用其他配置类中定义的 Bean，而无需在 XML 文件中进行声明。

- **组合配置**：当你的应用由多个模块组成，每个模块都有自己的配置类时，可以使用 `@Import` 来组合这些配置类，使得它们在同一个应用上下文中协同工作。
- **简化依赖管理**：通过 `@Import`，你可以避免在 XML 文件中声明依赖，使配置更加集中和易于管理。
- **模块化架构**：在模块化架构中，`@Import` 可以用于将核心配置与应用特定的配置分离，便于维护和重用。

注解使用：

在提供的代码示例中，`@Configuration` 和 `@Import` 注解用于定义一个配置类，并导入另一个配置类。
```java
@Configuration
@Import(Config1.class)
public class AppConfig {
    // Import another configuration class
}
```
在这个例子中，`AppConfig` 是一个配置类，它使用 `@Import` 注解来导入 `Config1` 类。这意味着 `Config1` 类中定义的所有 `@Bean` 方法都会被处理，并且它们定义的 Bean 都会被注册到 Spring 容器中。
通过这种方式，`AppConfig` 类将 `Config1` 类的配置包含进来，允许 `Config1` 中定义的 Bean 在整个应用上下文中可用。这简化了配置的组装过程，并使得配置更加模块化。

### W.@Order 

```java
@Component
@Order(1)
public class FirstBean {
    // ...
}

```

`@Order` 注解在 Spring 框架中用于指定组件的加载顺序，特别是当有多个同类型的组件存在时。这个注解可以应用于任何 Spring 管理的组件，包括 `@Component`、`@Service`、`@Repository` 以及任何使用 `@Bean` 注解的方法。
以下是对 `@Order` 注解及其应用场景的分析：

场景分析：

1. **初始化顺序**：当你需要在应用启动时按照特定的顺序初始化 Bean 时，可以使用 `@Order` 注解来指定它们的加载顺序。这对于那些依赖于其他 Bean 初始化的 Bean 非常重要。
2. **过滤器顺序**：在 Spring MVC 或 Spring WebFlux 应用中，如果你定义了多个过滤器（`Filter`），可以使用 `@Order` 来指定它们的执行顺序。
3. **事件监听器顺序**：如果你有多个事件监听器（`ApplicationListener`），`@Order` 可以用来指定它们处理事件的顺序。
4. **拦截器顺序**：在 Spring MVC 应用中，如果你定义了多个拦截器（`HandlerInterceptor`），`@Order` 可以用来指定它们的执行顺序。
5. **自动配置顺序**：在 Spring Boot 应用中，如果你有多个自动配置类（`@AutoConfiguration`），`@Order` 可以用来指定它们的加载顺序。

注解使用：

在提供的代码示例中，`@Order(1)` 注解用于指定 `FirstBean` 的加载顺序。
```java
@Component
@Order(1)
public class FirstBean {
    // ...
}
```
在这个例子中，`FirstBean` 是一个 Spring 组件，`@Order(1)` 表示它应该在相同类型的其他组件之前被加载。`@Order` 的值是一个整数，值越小，加载的优先级越高。

注意事项：

- `@Order` 的值越小，组件的加载顺序越靠前。
- 如果多个组件具有相同的 `@Order` 值，它们的加载顺序可能会根据它们在配置类中的声明顺序来决定。
- `@Order` 注解仅在存在多个同类型组件的情况下才有意义，如果只有一个组件，那么 `@Order` 的值不会产生影响。
通过这种方式，`@Order` 提供了一种控制组件加载顺序的机制，这对于确保应用按预期工作至关重要。

### X.@ConditionalOnExpression 

`@ConditionalOnExpression` 是一个条件注解，它允许你基于一个 SpEL（Spring Expression Language）表达式的结果来决定是否应用某个配置。这个注解通常与 `@Configuration` 一起使用，以根据表达式的结果动态地启用或禁用某些功能。

场景分析：

以下是一些可能使用 `@ConditionalOnExpression` 注解的场景：
1. **动态条件判断**：你可以在应用的属性文件中设置复杂的条件表达式，根据这些表达式的结果来决定是否启用特定的功能。
2. **环境特定配置**：在不同的开发、测试和生产环境中，你可能需要根据特定的环境变量或配置来加载不同的配置。
3. **敏感配置管理**：对于敏感配置（如数据库连接字符串），你可以在属性文件中设置一个标志，只有在表达式的结果为 true 时才加载这些敏感配置。
4. **版本控制**：在发布新版本时，你可能想要根据版本号来启用新功能或禁用旧功能。
5. **条件性依赖**：根据应用的属性配置，你可能需要依赖不同的库或服务。

注解使用：

在提供的代码示例中，`@ConditionalOnExpression` 注解用于指定 `ExampleConfig` 类的 Bean 定义只有在 SpEL 表达式的结果为 true 时才会被处理。
```java
@Configuration
@ConditionalOnExpression("${feature.enabled:false}")
public class ExampleConfig {
    // Configuration only if feature.enabled is true
}
```
在这个例子中，`ExampleConfig` 类中的 Bean 定义将只在 `feature.enabled` 属性被设置为 `true` 时才会被注册到 Spring 容器中。如果该属性不存在或被设置为 `false`，那么 `ExampleConfig` 中的所有 Bean 定义都不会被创建。

注意事项：

- `@ConditionalOnExpression` 会在应用启动时进行评估，因此它不会在运行时重新评估条件。
- SpEL 表达式可以使用系统属性、环境变量、应用程序属性等作为变量。
- 你可以指定多个表达式，在这种情况下，只有当所有指定的表达式的结果都为 true 时，条件才会满足。
通过这种方式，`@ConditionalOnExpression` 提供了一种基于复杂表达式的结果来有条件地加载 Spring 配置的方法。这使得你的应用更加灵活，可以根据不同的环境或条件动态地配置。



### Y.@ConditionalOnProperty 

`@ConditionalOnProperty` 是一个条件注解，它允许你基于应用属性配置来决定是否应用某个配置。这个注解通常与 `@Configuration` 一起使用，以根据应用程序的属性值动态地启用或禁用某些功能。

场景分析：

以下是一些可能使用 `@ConditionalOnProperty` 注解的场景：
1. **动态功能开关**：你可以在应用的属性文件中设置一个开关，根据这个开关的值来决定是否启用特定的功能。
2. **多环境支持**：在不同的开发、测试和生产环境中，你可能需要不同的配置。`@ConditionalOnProperty` 可以帮助你根据环境属性来加载不同的配置。
3. **敏感配置管理**：对于敏感配置（如数据库连接字符串），你可以在属性文件中设置一个标志，只有在标志被设置为 true 时才加载这些敏感配置。
4. **版本控制**：在发布新版本时，你可能想要根据版本号来启用新功能或禁用旧功能。
5. **条件性依赖**：根据应用的属性配置，你可能需要依赖不同的库或服务。

注解使用：

在提供的代码示例中，`@ConditionalOnProperty(name = "feature.enabled", havingValue = "true")` 注解用于指定 `FeatureConfig` 类的 Bean 定义只有在 `feature.enabled` 属性被设置为 `true` 时才会被处理。
```java
@Configuration
@ConditionalOnProperty(name = "feature.enabled", havingValue = "true")
public class FeatureConfig {
    // Configuration only if property is set to true
}
```
在这个例子中，`FeatureConfig` 类中的 Bean 定义将只在 `feature.enabled` 属性被设置为 `true` 时才会被注册到 Spring 容器中。如果该属性被设置为 `false` 或不存在，那么 `FeatureConfig` 中的所有 Bean 定义都不会被创建。

注意事项：

- `@ConditionalOnProperty` 会在应用启动时进行评估，因此它不会在运行时重新评估条件。
- 你可以指定多个属性名和值，在这种情况下，只有当所有指定的属性都被设置为相应的值时，条件才会满足。
- 你可以使用 `ignoreResourceNotFound` 属性来控制当属性文件不存在时的行为。
通过这种方式，`@ConditionalOnProperty` 提供了一种基于应用程序属性配置来有条件地加载 Spring 配置的方法。这使得你的应用更加灵活，可以根据不同的环境或条件动态地配置。



### Z.@ConditionalOnClass 

`@ConditionalOnClass` 是一个条件注解，它允许你基于类路径上是否存在某个类来决定是否应用某个配置。当指定的类存在于类路径上时，配置类中的 Bean 定义才会被处理和注册到 Spring 容器中。

场景分析：

以下是一些可能使用 `@ConditionalOnClass` 注解的场景：
1. **依赖特定库的配置**：如果你的应用依赖于某个外部库，并且需要根据该库的存在来配置特定的 Bean，你可以使用 `@ConditionalOnClass` 来确保只有当库的某个关键类存在时，相关的配置才会被激活。
2. **自动配置**：在创建自动配置类时，你可能希望根据类路径上的类来启用或禁用某些自动配置项。例如，如果你的应用使用了特定的数据库驱动，你可能会根据驱动类的存在来配置数据源。
3. **集成第三方服务**：如果你的应用集成了第三方服务，并且这些服务的客户端类只有在特定条件下才可用，你可以使用 `@ConditionalOnClass` 来确保只有当这些客户端类存在时，相关的集成配置才会被加载。
4. **功能开关**：对于某些功能，你可能希望根据类路径上是否存在某个特定的类来决定是否启用该功能。
5. **模块化应用**：在模块化应用中，不同的模块可能有不同的依赖和配置需求。`@ConditionalOnClass` 可以用来根据模块的存在与否来加载相应的配置。

注解使用：

在提供的代码示例中，`@ConditionalOnClass(name = "com.example.ExampleClass")` 注解用于指定 `ExampleConfig` 类的 Bean 定义只有在类路径上存在 `com.example.ExampleClass` 类时才会被处理。
```java
@Configuration
@ConditionalOnClass(name = "com.example.ExampleClass")
public class ExampleConfig {
    // Configuration only if ExampleClass is present
}
```
在这个例子中，`ExampleConfig` 类中的 Bean 定义将只在类路径上存在 `com.example.ExampleClass` 类时才会被注册到 Spring 容器中。如果该类不存在，那么 `ExampleConfig` 中的所有 Bean 定义都不会被创建。

注意事项：

- `@ConditionalOnClass` 会在应用启动时进行评估，因此它不会在运行时重新评估条件。
- 你可以指定多个类名，在这种情况下，只要其中任何一个类存在，条件就会满足。
- 如果条件不满足（即类不存在），则配置类及其内部的所有 `@Bean` 方法都不会被处理。
通过这种方式，`@ConditionalOnClass` 提供了一种灵活的方法来根据类路径的内容有条件地加载 Spring 配置。这在处理依赖性配置和创建可插拔的应用架构时非常有用。

### AA.@ConditionalOnMissingClass 

```java
@Configuration
@ConditionalOnMissingClass("com.example.ExampleClass")
public class Example
```

`@ConditionalOnMissingClass` 是一个 Spring Boot 条件注解，用于在配置类上指定条件。当指定的类在类路径上不存在时，该配置类中的 Bean 定义才会被处理和注册到 Spring 容器中。

**场景分析：**

以下是一些可能使用 `@ConditionalOnMissingClass` 注解的场景：
1. **模块化配置**：如果你的应用是多模块的，并且某些模块的配置依赖于特定类是否存在，你可以使用 `@ConditionalOnMissingClass` 来确保只在相关模块被包含在应用中时才加载这些配置。
2. **可选依赖**：当你的应用有可选的依赖时，你可能想要在依赖不存在的情况下提供替代配置。使用 `@ConditionalOnMissingClass` 可以检查可选依赖的类是否存在，从而决定是否应用特定的配置。
3. **版本兼容性**：如果你的应用需要支持多个版本的外部库，你可以根据类路径上是否存在某个特定版本的类来加载不同的配置。
4. **实验性功能**：对于实验性功能，你可能只希望在类路径上没有特定的标记类时才启用这些功能。

**注解使用：**

以下是如何使用 `@ConditionalOnMissingClass` 注解的示例：
```java
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingClass;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
@ConditionalOnMissingClass("com.example.ExampleClass")
public class ExampleConfig {
    // 这个 Bean 只有在 com.example.ExampleClass 不存在时才会被创建
    @Bean
    public SomeBean someBean() {
        return new SomeBean();
    }
}
class SomeBean {
    // Bean 的实现细节
}
```
在这个例子中，`ExampleConfig` 类中的 `someBean()` 方法将只在类路径上没有 `com.example.ExampleClass` 类时被调用。如果该类存在，那么 `ExampleConfig` 中的所有 Bean 定义都不会被创建。

**注意事项：**

- `@ConditionalOnMissingClass` 会在应用启动时进行评估，因此它不会在运行时重新评估条件。
- 如果条件不满足（即类存在），则配置类及其内部的所有 `@Bean` 方法都不会被处理。
- 你可以指定多个类名，在这种情况下，所有指定的类都必须不存在，条件才会满足。
通过这种方式，`@ConditionalOnMissingClass` 提供了一种灵活的方法来根据类路径的内容有条件地加载 Spring 配置。

### AB.@ConditionalOnMissingBean(name = “example”)

以下是一个使用 `@ConditionalOnMissingBean(name = "example")` 注解的场景代码示例。这个注解用于确保只有在容器中没有名为 "example" 的 Bean 时，才会创建和使用这个配置类中的 Bean。
在这个例子中，我们将创建一个配置类，其中包含一个条件性的 Bean 定义。如果 Spring 容器中已经有一个名为 "example" 的 Bean，则不会创建这个 Bean。

```java
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
public class ConditionalBeanConfig {
    // 这个 Bean 只有在容器中没有名为 "example" 的 Bean 时才会被创建
    @Bean(name = "example")
    @ConditionalOnMissingBean(name = "example")
    public ExampleBean exampleBean() {
        return new ExampleBean();
    }
}
// 示例 Bean 类
class ExampleBean {
    // Bean 的实现细节
}
```
在这个例子中，`ExampleBean` 类是一个简单的 Bean，我们希望它只在没有其他同名的 Bean 存在时被注册到 Spring 容器中。通过使用 `@ConditionalOnMissingBean(name = "example")` 注解，我们可以确保这一点。
假设在你的应用上下文中，你还没有定义任何名为 "example" 的 Bean，那么 `ConditionalBeanConfig` 中的 `exampleBean()` 方法将会被调用，并且 `ExampleBean` 实例将被创建并注册到 Spring 容器中。
如果你在其他地方已经定义了一个名为 "example" 的 Bean，例如：

```java
@Configuration
public class OtherBeanConfig {
    @Bean(name = "example")
    public OtherExampleBean otherExampleBean() {
        return new OtherExampleBean();
    }
}
// 另一个示例 Bean 类
class OtherExampleBean {
    // 另一个 Bean 的实现细节
}
```
在这种情况下，由于已经存在一个名为 "example" 的 Bean (`OtherExampleBean`)，Spring 容器将不会调用 `ConditionalBeanConfig` 中的 `exampleBean()` 方法来创建 `ExampleBean` 实例。

## 7.接口的统一封装

### A.什么是RESTful

Representational State Transfer:表现层状态转化：**REST是所有Web应用都应该遵守的架构设计指导原则**

### B.什么是RESTful API

**符合REST设计标准的API**

### C.为什么要统一封装接口

> 大部分项目采取前后端分离的模式开发，统一返回有利于前端进行开发和封装

以查询某个用户接口为例子

**如果没有封装，如下是返回结果**

```json
{
    "userId":1,
    "userName":"赵一"
}
```

**如果封装了，则正常返回结果为**

```json
{
    "timestamp":1111111,
    "status":200,
    "message":"success",
    "data":{
        "userId":1,
        "userName":"赵一"
    }
}
```

**如果封装了，异常返回结果为**

```json
{
    "timestamp":1111111,
    "status":10001,
    "message":"User not exist",
    "data":null
}
```

### D.如何实现封装

#### D.1状态码封装

```java
package org.xiaoyongcai.springboottest.api;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Getter
@AllArgsConstructor
public enum ResponseStatus {
    //ResponseStatus 是一个枚举类，
    // 其中包含了几个枚举常量，如 SUCCESS、FAIL 等。
    // 这些枚举常量是类的成员，而不是方法。它们被定义为常量是因为它们是固定的值，不会在运行时改变。
    SUCCESS("200","success"),
    FAIL("500","failed"),

    HTTP_STATUS_200("200","ok"),
    HTTP_STATUS_400("400","request error"),
    HTTP_STATUS_401("401","no authentication"),
    HTTP_STATUS_403("403","No authorities"),
    HTTP_STATUS_500("500","server error");

    public static final List<ResponseStatus> HTTP_STATUS_ALL = Collections.unmodifiableList(
            Arrays.asList(HTTP_STATUS_200,HTTP_STATUS_400,HTTP_STATUS_401,HTTP_STATUS_403,HTTP_STATUS_500)
    );//这个列表是 Collections.unmodifiableList 类型的，这意味着它不能被修改，这有助于防止在代码中意外地修改枚举常量。



    //这里的success等枚举是方法么？为什么要放在字段之前？
    private final String responseCode;
    private final String description;

}

```



#### D.2返回内容封装

```java
package org.xiaoyongcai.springboottest.api;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
//Builder注解来自于Lombok，用于自动生成构建器类(builder可以)：一个类有许多属性，为他们生成构造函数，getter和setter和构建器方法。使用@Builder可减少工作量

//ResponseResult<T> :<T>表示其为泛型类名，T表示该类接受任意类型数据作为泛型参数。好处在于：无论成功还是失败，都可以处理
public class ResponseResult<T> {
    private long timestamp;
    private String status;
    private String message;
    private T data;

    //为什么有<T>和ResponseResult<T> 方法返回值不应该只有一个么？<T>是方法的类型参数，声明方法是泛型方法。 ResponseResult<T>才是真正的返回类型
    public static <T> ResponseResult<T> success() {
        return success(null);
    }
    public static <T> ResponseResult<T> success(T data) {
        return ResponseResult.<T>builder().data(data)
                .message(ResponseStatus.SUCCESS.getDescription())
                .status(ResponseStatus.SUCCESS.getResponseCode())
                .timestamp(System.currentTimeMillis())
                .build();
    }

    //<T extends Serializable>是一个泛型限定 表明参数T必须得实现Serializable接口 也就是传入的T必须是可序列化的，这在分布式系统中非常重要
    public static <T extends Serializable> ResponseResult<T> fail(String message) {
        return fail(null, message);
    }
    
    //给方法加上static有什么用？方法可以通过类名调用，不需要先创建该类的实例。
    public static <T> ResponseResult<T> fail(T data, String message) {
        return ResponseResult.<T>builder().data(data)
                .message(message)
                .status(ResponseStatus.FAIL.getResponseCode())
                .timestamp(System.currentTimeMillis())
                .build();
    }

}
```

#### D.3Controller返回封装类型

```JAVA
package org.xiaoyongcai.springboottest.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.xiaoyongcai.springboottest.api.ResponseResult;
import org.xiaoyongcai.springboottest.entity.User;
import org.xiaoyongcai.springboottest.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
public class UserController
{
    @Autowired
    private UserService userService;

//将返回类型在原来的List<User>和User外面套一层ResponseResult<>
    @RequestMapping("add") 
    public ResponseResult<User> add(User user){
        userService.addUser(user);
        return ResponseResult.success(user);
    }
    @GetMapping("list")
    public ResponseResult<List<User>> list(){

        return ResponseResult.success(userService.list());
    }
}
```

## 8.对前端传来参数的校验

### A.不优雅的校验(在Controller中大量if与else)

```java
@RestController
@RequestMappping("/user")
public class UserController{
    @PostMapping("add")
    public ResponseEntity<String> add(User user){
        if(user.getName()==null){
            return ResponseResult.fail("user name should not be empty");
        }else if(user.getName()<5||user.getName.length()>50){
            return ResponseResult.fail("user name length should between 5-50");
        }
        if(user.getAge()<1||user.getName()>150){
            return ResponseResult.fail("invalid age");
        }
        return ResponseEntity.ok("success");
    }
    
}
```

针对这个普遍的问题，Java开发者在Java API规范 (JSR303) 定义了Bean校验的标准**validation-api**，但没有提供实现。

**hibernate validation是对这个规范的实现**，并增加了校验注解如@Email、@Length等。

**Spring Validation是对hibernate validation的二次封装**，用于支持spring mvc参数自动校验。

接下来，我们以springboot项目为例，介绍Spring Validation的使用。

### B.使用spring validation实现优雅校验

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

#### B.1请求参数封装

```java
package org.xiaoyongcai.springboottest.validator;

import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.Range;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.Email;
import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
@Data
@Builder
public class UserParam implements Serializable {
    private static final long SerialVersionUID = 1L;

    @NotEmpty(message = "could not be empty")
    @Max(value = 10086,message = "The id is wrong")
    @Length(min = 1, max = 10, message = "nick name should be 1-10")
    @Range(min = 0, max = 1, message = "id should be 0-10086")
    private int id;

    @NotEmpty(message = "could not be empty")
    private String userName;

    @NotEmpty(message = "could not be empty")
    private String message;

    @Email(message = "valid email")
    private String email;

}

```

#### B.2Controller层校验

```java

    @RequestMapping ("add")
    public ResponseResult<User> add(@Valid User user){
        userService.addUser(user);
        return ResponseResult.success(user);
    }
```

#### B.3分组校验

> 上面的例子中，其实存在一个问题，UserParam既可以作为addUser的参数（id为空），又可以作为updateUser的参数（id不能为空），这时候怎么办呢？分组校验登场。

- **先定义分组**（无需实现接口）

```java
public interface AddValidationGroup {
}
public interface EditValidationGroup {
}
```

- **在UserParam的userId字段添加分组**

```java
@Data
@Builder
@ApiModel(value = "User", subTypes = {AddressParam.class})
public class UserParam implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotEmpty(message = "{user.msg.userId.notEmpty}", groups = {EditValidationGroup.class}) // @NotEmpty(message="{},groups={xxx.class}")
    private String userId;

}
```

- **controller中的接口使用校验时使用分组**

```java

@RestController
@RequestMapping("/user")
public class UserController {

    @PostMapping("add")
    public ResponseEntity<UserParam> add(@Validated(AddValidationGroup.class) @RequestBody UserParam userParam) {//(@Validated(.class))
        return ResponseEntity.ok(userParam);
    }

    @ApiOperation("Edit User")
    @ApiImplicitParam(name = "userParam", type = "body", dataTypeClass = UserParam.class, required = true)
    @PostMapping("edit")
    public ResponseEntity<UserParam> edit(@Validated(EditValidationGroup.class) @RequestBody UserParam userParam) {
        return ResponseEntity.ok(userParam);
    }
}
```

在检验Controller的入参是否符合规范时，使用@Validated或者@Valid在基本验证功能上没有太多区别。但是在分组、注解地方、嵌套验证等功能上两个有所不同：

- **分组**

@Validated：提供了一个分组功能，可以在入参验证时，根据不同的分组采用不同的验证机制，这个网上也有资料，不详述。@Valid：作为标准JSR-303规范，还没有吸收分组的功能。

- **注解地方**

@Validated：可以用在类型、方法和方法参数上。但是不能用在成员属性（字段）上

@Valid：可以用在方法、构造函数、方法参数和成员属性（字段）上

#### C.在参数有@RequestBody修饰时,切记要写json的数据在postman中

在body->raw->json中

不要使用Params标签中的key-value组合了。

```json
{
    "id":"0",
    "userName":"测试信息",
    "message":"测试信息：判断add是否能以@Valid @RequestBody的参数接受",
    "email":"22654763232@qq.com"
}
```



## 9.参数校验的国标化

> 暂时先不学习

## 10.统一异常处理

### A.不统一的后果(controller层大量异常处理代码)

```java
public class UserController{
    @PostMapping("add")
    public ResponseEntity<String> add(@Valid @RequestBody UserParam userParam)
        //大量的 try - catch 异常处理
        try{
            //do something
        }catch(Exception e){
            return ResponseEntity.fail("error");
        }
    return ResponseEntity.ok("success")
}
```

### B.通过@ControllerAdvice异常统一处理

```java
package org.xiaoyongcai.springboottest.exception; // 定义异常处理类所在的包

import lombok.extern.slf4j.Slf4j; // 引入日志注解，用于简化日志记录
import org.springframework.beans.propertyeditors.CustomDateEditor; // 引入自定义日期编辑器类
import org.springframework.http.HttpStatus; // 引入HTTP状态码枚举类
import org.springframework.validation.BindException; // 引入绑定异常类
import org.springframework.validation.BindingResult; // 引入绑定结果类
import org.springframework.validation.FieldError; // 引入字段错误类
import org.springframework.web.bind.MethodArgumentNotValidException; // 引入方法参数无效异常类
import org.springframework.web.bind.WebDataBinder; // 引入Web数据绑定器类
import org.springframework.web.bind.annotation.*; // 引入Spring MVC相关注解

import javax.validation.ConstraintViolationException; // 引入约束违反异常类
import javax.validation.ValidationException; // 引入验证异常类
import java.text.SimpleDateFormat; // 引入简单日期格式化类
import java.util.Date; // 引入日期类

@Slf4j // 使用Slf4j注解，自动创建日志对象
@RestControllerAdvice // 表示这是一个控制器通知类，用于处理全局异常
public class GlobalExceptionHandler {

    @InitBinder // 初始化绑定器，用于注册自定义编辑器
    public void handleInitBinder(WebDataBinder dataBinder) { // 方法用于注册自定义日期编辑器
        dataBinder.registerCustomEditor(Date.class, // 注册自定义编辑器，用于转换日期类型
                new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), false)); // 日期格式为"yyyy-MM-dd"，不允许空值
    }

    @ResponseStatus(code = HttpStatus.BAD_REQUEST) // 设置响应状态码为400（Bad Request）
    @ExceptionHandler(value = {BindException.class, ValidationException.class, MethodArgumentNotValidException.class}) // 处理绑定异常、验证异常和方法参数无效异常
    public ExceptionData handleParameterVerificationException(Exception e) { // 方法用于处理参数验证异常
        ExceptionData.ExceptionDataBuilder exceptionDataBuilder = ExceptionData.builder(); // 创建异常数据构建器
        log.error("Exception: ", e); // 记录异常信息
        if (e instanceof BindException) { // 如果异常是绑定异常
            BindingResult bindingResult = ((MethodArgumentNotValidException) e).getBindingResult(); // 获取绑定结果
            bindingResult.getAllErrors() // 获取所有错误
                    .forEach(a -> exceptionDataBuilder.error(((FieldError) a).getField() + ": " + a.getDefaultMessage())); // 将错误信息添加到异常数据构建器
        } else if (e instanceof ConstraintViolationException) { // 如果异常是约束违反异常
            if (e.getMessage() != null) { // 如果异常消息不为空
                exceptionDataBuilder.error(e.getMessage()); // 将异常消息添加到异常数据构建器
            }
        } else { // 其他类型的异常
            exceptionDataBuilder.error("invalid parameter"); // 设置通用错误信息
        }
        return exceptionDataBuilder.build(); // 构建并返回异常数据
    }

}

```

当然，理解代码的关键在于理解其中的注解和代码执行的逻辑顺序。下面我将按照代码的结构，列出需要学习的注解、代码的阅读顺序以及具体的逻辑链条。

#### B.1需要学习的注解

1. `@Slf4j`：来自Lombok库，用于自动创建日志对象，方便日志记录。
2. `@RestControllerAdvice`：Spring MVC注解，用于定义全局异常处理器。
3. `@InitBinder`：Spring MVC注解，用于初始化WebDataBinder，可以自定义数据绑定规则。
4. `@ResponseStatus`：Spring MVC注解，用于定义响应的状态码。
5. `@ExceptionHandler`：Spring MVC注解，用于处理特定类型的异常。
#### B.2代码阅读顺序
1. **类声明和注解**：
   - `@Slf4j`：为类自动生成日志对象。
   - `@RestControllerAdvice`：标识此类为全局异常处理器。
2. **成员变量和方法**：
   - `handleInitBinder` 方法：注册自定义日期编辑器。
   - `handleParameterVerificationException` 方法：处理参数验证异常。
#### B.3逻辑链条
1. **异常处理初始化**：
   - 当Spring Boot应用启动时，`@RestControllerAdvice`注解会使得Spring识别`GlobalExceptionHandler`类为全局异常处理器。
2. **数据绑定初始化**：
   - 当请求到达控制器之前，`@InitBinder`注解标记的`handleInitBinder`方法会被调用，注册一个自定义日期编辑器，用于将请求参数中的日期字符串转换为`Date`对象。
3. **异常处理逻辑**：
   - 当控制器方法抛出异常时，Spring会根据异常类型寻找匹配的`@ExceptionHandler`方法。
   - `handleParameterVerificationException`方法会处理`BindException`、`ValidationException`和`MethodArgumentNotValidException`类型的异常。
   - 在该方法中，首先创建一个`ExceptionData`对象的构建器。
   - 使用`log.error`记录异常信息。
   - 根据异常类型，获取错误信息并添加到`ExceptionData`构建器中：
     - 如果异常是`BindException`或`MethodArgumentNotValidException`，获取`BindingResult`并遍历所有错误，将字段名和错误信息添加到`ExceptionData`。
     - 如果异常是`ConstraintViolationException`，直接将异常消息添加到`ExceptionData`。
     - 对于其他类型的异常，添加一个通用的错误信息。
   - 最后，构建并返回`ExceptionData`对象。
#### B.4具体逻辑
- **异常捕获**：当发生异常时，Spring会捕获异常并查找匹配的`@ExceptionHandler`方法。
- **错误信息收集**：通过`BindingResult`或异常消息，收集错误信息。
- **响应构建**：使用收集的错误信息构建一个响应对象。
- **返回响应**：将构建的响应对象返回给客户端。
通过上述步骤，你可以更好地理解代码的结构和逻辑。记住，理解代码的关键在于理解每个部分的作用以及它们是如何相互作用的。

## 11.多版本接口测试(verson&&APITestController)

多版本接口的执行逻辑通常涉及版本控制、请求映射和请求条件。下面我将根据提供的类和注解，构建一个逻辑链条，帮助您更好地理解多版本接口的执行过程。
### A.逻辑链条
1. **用户发起请求**：客户端向服务器发起一个HTTP请求。
2. **请求到达服务器**：服务器接收到请求，开始处理。
3. **查找请求映射**：`RequestMappingHandlerMapping` 负责查找与请求匹配的控制器和方法。
4. **检查类型注解**：`ApiVersionRequestMappingHandlerMapping` 继承自 `RequestMappingHandlerMapping`，并在 `getCustomTypeCondition` 方法中查找控制器类上的 `@ApiVersion` 注解。
5. **创建条件对象**：如果找到 `@ApiVersion` 注解，则创建一个 `ApiVersionCondition` 对象。
6. **检查方法注解**：在 `getCustomMethodCondition` 方法中，`ApiVersionRequestMappingHandlerMapping` 查找方法上的 `@ApiVersion` 注解。
7. **创建条件对象（方法级别）**：如果找到 `@ApiVersion` 注解，则创建一个 `ApiVersionCondition` 对象。
8. **比较版本**：在 `ApiVersionCondition` 类中，使用 `compareVersion` 方法比较请求中的版本号与API的版本号。
9. **匹配版本**：如果请求中的版本号与API的版本号匹配或更高，则使用该版本的条件对象。
10. **处理请求**：使用匹配的版本条件对象处理请求，并执行相应的控制器方法。
11. **返回响应**：控制器方法执行完毕后，返回相应的响应。
### B.示例代码说明
- `ApiVersion`：这是一个自定义注解，用于标记API的不同版本。
- `ApiVersionCondition`：这是一个实现 `RequestCondition` 接口的类，用于定义请求条件。它包含一个 `apiVersion` 字段，用于存储API的版本号。
- `ApiVersionRequestMappingHandlerMapping`：这是一个继承自 `RequestMappingHandlerMapping` 的类，用于扩展请求映射处理。它重写了 `getCustomTypeCondition` 和 `getCustomMethodCondition` 方法，以支持 `@ApiVersion` 注解。
- `APITestController`：这是一个示例控制器类，用于测试多版本接口。它包含一个带有 `@ApiVersion` 注解的方法。
### C.总结
多版本接口的执行逻辑涉及请求映射、版本控制和请求条件。通过使用 `@ApiVersion` 注解，可以标记API的不同版本，并在处理请求时比较请求中的版本号与API的版本号，以确定使用哪个版本来处理请求。

## 12.接口文档生成之Swagger技术栈

### A.OpenAPI规范(OAS)

- 语言无关的
- RESTful风格的
- 无需访问源代码，文档，网络流量检查的

#### A.1Swagger

- 生成，描述，调用RESTful接口的Web服务
- 将希望暴露的项目接口展示在页面上，且提供接口调用和调试的服务

#### A.2Knife4J与Swagger

- Knife4J是为Java MVC框架生成API文档的方案
- 集成了Swagger
- 前身是Swagger-bootstrap
- kni4j的名字是希望她能像匕首一样小巧轻量且功能强悍

### B.依赖导入

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>

```

### C.创建Config类来配置Swagger

```java
package org.xiaoyongcai.springboottest.config;

import io.swagger.annotations.ApiOperation;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.xiaoyongcai.springboottest.api.ResponseStatus;
import springfox.documentation.builders.*;
import springfox.documentation.oas.annotations.EnableOpenApi;
import springfox.documentation.schema.ScalarType;
import springfox.documentation.service.*;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * swagger配置类，用于开启和配置Open API（Swagger）。
 *
 * @author xiaoyongcai
 */
@Configuration
@EnableOpenApi//@EnableOpenApi
public class SwaggerConfig {

    /**
     * 配置Docket Bean，用于生成API文档。
     *
     * @return Docket对象
     */
    @Bean
    public Docket openApi() {
        // 创建Docket对象，指定OpenAPI规范版本为3.0
        return new Docket(DocumentationType.OAS_30)
                // 设置API分组名称
                .groupName("Test group")
                // 设置API的基本信息
                .apiInfo(apiInfo())
                // 构建API选择器
                .select()
                // 选择带有ApiOperation注解的方法作为API
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                // 任何路径都符合条件
                .paths(PathSelectors.any())
                // 构建完成
                .build()
                // 添加全局请求参数
                .globalRequestParameters(getGlobalRequestParameters())
                // 添加全局响应消息
                .globalResponses(HttpMethod.GET, getGlobalResponse());
    }

    /**
     * 获取全局响应消息。
     *
     * @return 全局响应消息列表
     */
    private List<Response> getGlobalResponse() {
        // 将ResponseStatus中的状态码和描述映射为Response对象，并返回列表
        return ResponseStatus.HTTP_STATUS_ALL.stream().map(
                        a -> new ResponseBuilder().code(a.getResponseCode()).description(a.getDescription()).build())
                .collect(Collectors.toList());
    }

    /**
     * 获取全局请求参数。
     *
     * @return 全局请求参数列表
     */
    private List<RequestParameter> getGlobalRequestParameters() {
        List<RequestParameter> parameters = new ArrayList<>();
        // 添加一个名为AppKey的请求参数，类型为字符串，非必须
        parameters.add(new RequestParameterBuilder()
                .name("AppKey")
                .description("App Key")
                .required(false)
                .in(ParameterType.QUERY)
                .query(q -> q.model(m -> m.scalarModel(ScalarType.STRING)))
                .required(false)
                .build());
        return parameters;
    }

    /**
     * 获取API的基本信息。
     *
     * @return ApiInfo对象
     */
    private ApiInfo apiInfo() {
        // 构建API的基本信息
        return new ApiInfoBuilder()
                .title("Swagger API") // 标题
                .description("test api") // 描述
                .contact(new Contact("xiaoyongcai", "http://xiaoyongcai.tech", "suzhou.daipeng@gmail.com")) // 联系人信息
                .termsOfServiceUrl("http://xxxxxx.com/") // 服务条款URL
                .version("1.0") // 版本号
                .build();
    }
}

```

场景：假设你正在开发一个在线书店API，你需要为这个API提供文档以便其他开发者能够了解如何使用它。你决定使用Swagger来生成和展示这些文档。
以下是分析这段代码如何工作的步骤：
1. **启动Swagger**：
   - 在`SwaggerConfig`类上，`@Configuration`注解表明这是一个配置类，它会被Spring容器处理，用于配置应用。
   - `@EnableOpenApi`注解启用了Swagger的OpenAPI 3.0规范支持，它告诉Spring框架这个应用将使用Swagger来生成API文档。
2. **配置Docket Bean**：
   - `@Bean`注解的`openApi`方法创建了一个`Docket`对象，这是Swagger的核心配置对象。
   - `DocumentationType.OAS_30`指定了使用OpenAPI 3.0规范。
   - `.groupName("Test group")`将API分组，这有助于在Swagger UI中组织API文档。
   - `.apiInfo(apiInfo())`调用`apiInfo`方法来设置API的基本信息，如标题、描述、版本等。
   - `.select()`开始构建API的选择器。
   - `.apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))`指定只生成带有`@ApiOperation`注解的方法的API文档。
   - `.paths(PathSelectors.any())`指定所有路径都符合条件，即所有路径都将被包含在文档中。
   - `.build()`完成Docket的构建。
3. **添加全局请求参数**：
   - `.globalRequestParameters(getGlobalRequestParameters())`调用`getGlobalRequestParameters`方法来添加所有API都需要使用的全局请求参数，例如`AppKey`。
4. **添加全局响应消息**：
   - `.globalResponses(HttpMethod.GET, getGlobalResponse())`调用`getGlobalResponse`方法来添加所有GET请求可能返回的全局响应消息，例如HTTP状态码和描述。
5. **API基本信息**：
   - `apiInfo`方法返回一个`ApiInfo`对象，它包含了API的标题、描述、版本、服务条款和联系信息。
6. **全局响应消息列表**：
   - `getGlobalResponse`方法使用流操作从`ResponseStatus.HTTP_STATUS_ALL`（假设这是一个枚举，包含了所有可能的HTTP状态码和描述）中构建响应消息列表。
7. **全局请求参数列表**：
   - `getGlobalRequestParameters`方法创建一个请求参数列表，当前只有一个`AppKey`参数，它是一个非必须的查询参数。
   **工作流程**：
- 当Spring Boot应用启动时，它会加载`SwaggerConfig`配置类。
- `openApi`方法被调用，创建并返回一个配置好的`Docket`实例。
- Swagger使用这个`Docket`实例来扫描应用中的控制器和方法，并生成对应的API文档。
- 文档中会包含由`apiInfo`方法提供的基本信息。
- 文档中所有API的请求都会包含由`getGlobalRequestParameters`方法定义的`AppKey`参数。
- 文档中所有API的响应都会包含由`getGlobalResponse`方法定义的全局响应消息。
最终，开发者可以通过访问Swagger UI（通常是`/swagger-ui/index.html`）来查看和测试API。

## 13.Mysql-JPA封装
