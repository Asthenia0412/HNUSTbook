# 1.二者的区别：

### 1. 接口 vs. 类

- **JDK 动态代理**：
  - 只支持**接口代理**，目标类必须实现一个或多个接口。
  - 通过 `java.lang.reflect.Proxy` 类创建代理实例。
- **CGLIB 动态代理**：
  - 支持**类代理**，可以代理没有实现任何接口的普通类。
  - 通过**字节码生成技术**生成目标类的子类来实现代理。

### 2. 性能

- **JDK 动态代理**：
  - 相对来说性能较**低**，因为调用时需要通过**反射机制**。
- **CGLIB 动态代理**：
  - 通常性能更**高**，因为它直接生成**子类的字节码**，减少了反射带来的开销。

### 3. 生成的代理对象

- **JDK 动态代理**：
  - 生成的代理对象是**基于接口的**，因此只能通过接口调用方法。
- **CGLIB 动态代理**：
  - 生成的代理对象是**目标类的子类**，可以直接访问目标类的非公共方法和属性。

### 4. 适用场景

- **JDK 动态代理**：
  - 更适合于接口设计良好的项目，尤其是在 Spring 框架中，通常使用 JDK 动态代理处理具有接口的服务。
- **CGLIB 动态代理**：
  - 在没有接口的情况下，或者需要代理具体类的场景下使用更为合适，比如需要对某些框架类进行增强时。

### 5. 复杂性

- **JDK 动态代理**：
  - 使用相对简单，只需实现接口和相应的 `InvocationHandler`。
- **CGLIB 动态代理**：
  - 设置和使用相对复杂，需要依赖外部库（如 ASM）进行字节码操作。

### 6. 继承限制

- **JDK 动态代理**：
  - 不存在继承问题，只要实现接口即可。
- **CGLIB 动态代理**：
  - 由于是通过继承生成子类，若目标类是 `final` 或者有 `final` 方法，则无法代理。

### 总结

选择使用 JDK 动态代理还是 CGLIB 动态代理取决于具体需求。如果目标类实现了接口并且希望简化使用，JDK 动态代理是一个不错的选择；如果需要代理没有实现接口的类，或者希望提高性能，CGLIB 动态代理更为合适。每种方式都有其适用场景，开发者应根据具体情况进行选择。

# 2.代码实战

### 1.JDK动态代理实战

**接口与实现类**

```java
// UserService.java
public interface UserService {
    void addUser(String username);
}

// UserServiceImpl.java
public class UserServiceImpl implements UserService {
    @Override
    public void addUser(String username) {
        System.out.println("User added: " + username);
    }
}

```

**JDK动态代理实现**

```java
// MyInvocationHandler.java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class MyInvocationHandler implements InvocationHandler {
    private final Object target;

    public MyInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("Before method: " + method.getName());
        Object result = method.invoke(target, args); // 调用目标方法
        System.out.println("After method: " + method.getName());
        return result;
    }
}

// Main.java
import java.lang.reflect.Proxy;

public class Main {
    public static void main(String[] args) {
        UserService userService = new UserServiceImpl();
        UserService proxy = (UserService) Proxy.newProxyInstance(
                userService.getClass().getClassLoader(),
                userService.getClass().getInterfaces(),
                new MyInvocationHandler(userService)//放入Handler的是一个接口,这个接口做为target对象
        );

        proxy.addUser("Alice");
    }
}

```

### 2.CGLib实现

```java
// UserServiceImpl.java (same as above)
public class UserServiceImpl {
    public void addUser(String username) {
        System.out.println("User added: " + username);
    }
}

```

```java
// MyMethodInterceptor.java
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

public class MyMethodInterceptor implements MethodInterceptor {
    @Override
    public Object intercept(Object obj, java.lang.reflect.Method method, Object[] args, MethodProxy proxy) throws Throwable {
        System.out.println("Before method: " + method.getName());
        Object result = proxy.invokeSuper(obj, args); // 调用目标方法
        System.out.println("After method: " + method.getName());
        return result;
    }
}

// Main.java
public class Main {
    public static void main(String[] args) {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(UserServiceImpl.class);//此时拿的是实现类，而非是接口
        enhancer.setCallback(new MyMethodInterceptor());

        UserServiceImpl proxy = (UserServiceImpl) enhancer.create();
        proxy.addUser("Bob");
    }
}

```

