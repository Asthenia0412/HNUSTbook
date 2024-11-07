# 一：使用静态代理完成

### 1. 定义 HTTP 接口

首先，定义一个接口，表示要通过 HTTP 调用的远程服务。

```java
public interface UserService {
    String getUserById(String userId);
}
```

### 2. 实现服务接口

实现类中使用 `RestTemplate` 来进行 HTTP 请求，这样可以更好地与 Spring 生态系统集成。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

// 实现类
@Service
public class UserServiceImpl implements UserService {
    
    private static final String BASE_URL = "http://example.com/api/users/";

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public String getUserById(String userId) {
        return restTemplate.getForObject(BASE_URL + userId, String.class);
    }
}
```

### 3. 创建静态代理

创建一个代理类，用于增强接口的调用。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

// 代理类
@Component
public class UserServiceProxy implements UserService {
    
    private final UserService userService;

    @Autowired
    public UserServiceProxy(UserService userService) {
        this.userService = userService;
    }

    @Override
    public String getUserById(String userId) {
        System.out.println("Before calling getUserById()");
        String result = userService.getUserById(userId);
        System.out.println("After calling getUserById()");
        return result;
    }
}
```

### 4. 配置 RestTemplate

确保在 Spring Boot 的配置类中配置 `RestTemplate` Bean。

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig {
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```

### 5. 使用代理类

在主程序或控制器中使用这个代理类来调用服务。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

// 控制器
@RestController
public class UserController {
    
        private final UserService userService;

    @Autowired
    public UserController(UserServiceProxy userService) {
        this.userService = userService;
    }

    @GetMapping("/users/{userId}")
    public String getUser(@PathVariable String userId) {
        return userService.getUserById(userId);
    }
}
```

> 在 Spring 中，`UserServiceProxy` 被注入到 `UserController` 的原因主要涉及到 Spring 的依赖注入和代理机制。以下是具体的解释：
>
> 1. **接口与实现**：
>    - `UserService` 通常是一个接口，而 `UserServiceProxy` 是这个接口的实现或代理类。Spring 会创建一个实现了 `UserService` 接口的具体类的实例，可能是 `UserServiceProxy`，用于处理额外的逻辑（如事务、缓存、日志等）。
>
> 2. **代理模式**：
>    - Spring AOP（面向切面编程）可以生成代理对象，这样在调用接口方法时，可以在执行方法前后加入其他逻辑。`UserServiceProxy` 可能是这样一个代理，它实现了 `UserService` 接口并增加了一些额外功能。
>
> 3. **依赖注入**：
>    - 在 `UserController` 中，构造函数使用了 `@Autowired` 注解。Spring 会自动查找与构造函数参数 `UserServiceProxy` 兼容的 bean。
>    - 如果你有多个实现类，Spring 会根据类型匹配来决定注入哪个具体的实现。如果只有一个实现（如 `UserServiceProxy`），Spring 就会将其注入到 `userService` 中。
>
> 4. **Spring 的配置**：
>    - 确保 `UserServiceProxy` 被标注为一个 Spring 组件（如使用 `@Service` 或 `@Component` 注解），这样 Spring 才能识别并管理它的生命周期。
>
> 5. **实际注入过程**：
>    - 当 Spring 创建 `UserController` 的实例时，它会通过构造函数调用，传入相应的 `UserServiceProxy` 实例，确保 `userService` 引用的是这个代理对象。
>
> 总结来说，`UserServiceProxy` 被注入到 `UserController` 是因为 Spring 的依赖注入机制根据类型找到合适的 bean，而这个 bean 是通过 Spring AOP 生成的代理类，添加了所需的额外功能。
> 

### 6. 解释

1. **接口**：`UserService` 定义了远程服务调用的方法。
2. **实现类**：`UserServiceImpl` 使用 `RestTemplate` 进行 GET 请求，从远程服务获取用户信息。
3. **代理类**：`UserServiceProxy` 增强了方法调用，打印调用前后的日志。
4. **配置类**：通过 Spring 的 `@Configuration` 注解定义 `RestTemplate` Bean。
5. **控制器**：`UserController` 提供了一个 RESTful API，使用代理类进行服务调用。

### 7. 运行项目

运行 Spring Boot 项目后，你可以通过访问 `http://localhost:8080/users/{userId}` 来获取用户信息，代理类将在控制台打印调用日志。



### 注意事项

- 确保在 `application.properties` 或 `application.yml` 中配置了适当的外部服务 URL。
- 在实际开发中，建议添加异常处理和日志记录，以提高代码的健壮性。

如果有其他问题或者需要进一步的帮助，请随时告诉我！

# 二：使用JDK动态代理实现

要使用 JDK 动态代理来实现 `UserService` 的代理功能，你需要遵循以下步骤。JDK 动态代理要求被代理的对象必须实现一个或多个接口，因此我们将创建一个 `UserService` 接口及其实现，并通过动态代理为其增加功能。以下是完整的步骤和示例代码：

### 1. 定义接口和实现类

首先，定义 `UserService` 接口和其实现类 `UserServiceImpl`：

```java
public interface UserService {
    String getUserById(String userId);
}

public class UserServiceImpl implements UserService {
    @Override
    public String getUserById(String userId) {
        return "User data for userId: " + userId;
    }
}
```

### 2. 创建动态代理处理器

接下来，创建一个动态代理处理器 `UserServiceProxy`，它实现 `InvocationHandler` 接口：

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class UserServiceProxy implements InvocationHandler {
    private final UserService userService;

    public UserServiceProxy(UserService userService) {
        this.userService = userService;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 在方法调用前添加逻辑
        System.out.println("Before method: " + method.getName());
        
        // 调用实际的方法
        Object result = method.invoke(userService, args);
        
        // 在方法调用后添加逻辑
        System.out.println("After method: " + method.getName());
        
        return result;
    }
}
```

### 3. 创建代理对象

在 Spring 的配置类中或其他适当的位置创建动态代理对象：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.lang.reflect.Proxy;

@Configuration
public class AppConfig {

    @Bean
    public UserService userService() {
        return new UserServiceImpl(); // 创建真实对象
    }

    @Bean
    public UserService userServiceProxy() {
        UserService realUserService = userService();
        return (UserService) Proxy.newProxyInstance(
                realUserService.getClass().getClassLoader(),
                realUserService.getClass().getInterfaces(),
                new UserServiceProxy(realUserService)
        );
    }
}
```

### 4. 修改控制器

最后，修改 `UserController` 以使用代理对象：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {
    
    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService; // 这里注入的是代理对象
    }

    @GetMapping("/users/{userId}")
    public String getUser(@PathVariable String userId) {
        return userService.getUserById(userId);
    }
}
```

### 总结

通过以上步骤，你已经成功使用 JDK 动态代理实现了对 `UserService` 的代理。`UserServiceProxy` 在方法调用前后可以添加逻辑，比如日志记录、权限检查等，而 `UserController` 只需依赖 `UserService` 接口，无需关心具体实现。这样设计的好处是遵循了面向接口编程的原则，增加了代码的灵活性和可维护性。

# 三.动态代理相较静态代理的优越性

当然可以，以下是一个示例来说明静态代理和动态代理在处理多个方法时的不同。

### 静态代理示例

假设我们有一个简单的 `UserService` 接口，包含多个方法：

```java
public interface UserService {
    String getUserById(String userId);
    void createUser(String userName);
    void deleteUser(String userId);
}
```

静态代理类可能看起来像这样：

```java
@Component
public class UserServiceProxy implements UserService {
    private final UserService userService;

    @Autowired
    public UserServiceProxy(UserService userService) {
        this.userService = userService;
    }

    @Override
    public String getUserById(String userId) {
        System.out.println("Before calling getUserById()");
        String result = userService.getUserById(userId);
        System.out.println("After calling getUserById()");
        return result;
    }

    @Override
    public void createUser(String userName) {
        System.out.println("Before calling createUser()");
        userService.createUser(userName);
        System.out.println("After calling createUser()");
    }

    @Override
    public void deleteUser(String userId) {
        System.out.println("Before calling deleteUser()");
        userService.deleteUser(userId);
        System.out.println("After calling deleteUser()");
    }
}
```

随着方法的增加，代理类的代码将变得冗长，特别是当多个方法需要相似的前后逻辑时。

### 动态代理示例

使用 Java 的动态代理，可以更加简洁。我们可以使用 `InvocationHandler` 来处理所有方法：

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class UserServiceDynamicProxy implements InvocationHandler {
    private final UserService userService;

    public UserServiceDynamicProxy(UserService userService) {
        this.userService = userService;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("Before calling " + method.getName());
        Object result = method.invoke(userService, args);
        System.out.println("After calling " + method.getName());
        return result;
    }

    public static UserService createProxy(UserService userService) {
        return (UserService) Proxy.newProxyInstance(
                userService.getClass().getClassLoader(),
                new Class<?>[]{UserService.class},
                new UserServiceDynamicProxy(userService)
        );
    }
}
```

在使用动态代理时，只需实现一次 `invoke` 方法，就可以处理 `UserService` 接口中的所有方法，减少了冗余的代码。

说白了就是，像是前置通知后置通知这样的重复很多遍的代码，在动态代理中因为是只执行一个invoke,所以就只用写一遍。至于动态代理如何实现多样的操作`deleteUser` `createUser`。method.invoke()会自动处理。就比方说你是通过deleteUser进入的代理类，这里的method.invoke()就是调用的Impl中的deleteUser.如果你是通过createUser进行的代理类，那你的method.invoke()调用的就是Impl中的createUser

# 四.JDK动态代理的形象展示

~~~java
以下是使用 Markdown 代码块的图示，展示了使用 JDK 动态代理时，如何通过不同的方法进入同一个 `InvocationHandler`，并通过 `method.invoke()` 调用实现类的不同方法。

```plaintext
┌──────────────────────┐
│       Client        │
│                      │
│ userService.doSomething()  │
│                      │
└───────────┬──────────┘
            │
            ▼
┌──────────────────────┐
│        Proxy        │
│  (Dynamic Proxy)    │
│                      │
│   InvocationHandler  │
│                      │
└───────────┬──────────┘
            │
            ▼
┌──────────────────────┐
│  InvocationHandler   │
│                      │
│   invoke(Object proxy,│
│         Method method,│
│         Object[] args)│
│                      │
└───────────┬──────────┘
            │
            ├───────────────────────────────────┐
            │                                   │
            ▼                                   ▼
┌──────────────────────┐                ┌──────────────────────┐
│  method.invoke()     │                │  method.invoke()     │
│                      │                │                      │
│  target.doSomething()│                │  target.doSomethingElse()│
│                      │                │                      │
└──────────────────────┘                └──────────────────────┘
            │                                   │
            ▼                                   ▼
┌──────────────────────┐                ┌──────────────────────┐
│        Target        │                │        Target        │
│    (UserServiceImpl) │                │    (UserServiceImpl) │
│                      │                │                      │
│  public void doSomething()  │        │  public void doSomethingElse() │
│                      │                │                      │
└──────────────────────┘                └──────────────────────┘
```

~~~

### 说明

- **Client**: 客户端调用接口方法。
- **Proxy**: 通过 JDK 动态代理生成的代理对象。
- **InvocationHandler**: 所有接口方法的调用会进入同一个 `InvocationHandler`。
- **method.invoke()**: 使用 `method.invoke()` 调用目标实现类的具体方法，根据不同的方法调用，会执行不同的实现逻辑。