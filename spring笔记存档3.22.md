

[TOC]

# 一:技术体系架构

# 二:SpringFramework介绍

# 三:Spring loC容器和核心概念

## 3.1 组件和组件管理的概念

### 3.1.1什么是组件:

![image-20240316092807876](D:\desklop\md笔记\spring\pic\image-20240316092807876.png)

### 3.1.2:我们的期待

- 有人替我们创建 **组件**的 **对象**
- 有人帮我们保存 **组件**的 **对象**
- 有人帮我们自动组成
- 有人替我们管理事务
- 有人协助我们整合其他的框架

### 3.1.3Spring充当组件管理角色(IOC)

那么谁来帮我们完成这些期待呢?

是Spring框架来实现的

**组件**可以完全交给Spring框架来进行管理,Spring框架替代了程序员原有的new对象,和对象属性赋值的动作

Spring**具体组件管理动作包含**:

- 组件的对象实例化

- 组件属性属性赋值

- 组件对象之间的引用

- 组件对象的存活周期的管理

  我们只需要编写 **元数据**(配置文件->xml/注解配置/java类来配置) 告知spring哪些是需要它管理的

  **组件:可以复用的java对象**    

  **组件一定是对象,对象不一定是组件**

  

### 3.1.4 Spring优势

1. 降低组件之间的糅合性:Spring IOC通过依赖注入机制,将组件之间的管理依赖削弱,减少程序组件之间的耦合性
2. 提高了代码的可重用性和可维护性:组件的实例化过程/依赖关系的管理/交给spring ioc去处理,使得组件代码更加模块化,可重用,更易于维护
3. 方便了配置和管理:Spring IOC通过xml文件或者注解来对组件进行配置和管理,将组件的切换,替代操作更加便捷
4. 交给Spring管理的对象(组件),可以享受享受Spring框架的其他功能(AOP事务管理)

## 3.2 Spring Ioc容器和容器实现

### 3.2.1普通和复杂容器

**普通容器**:**普通容器只能储存**

程序中的普通容器:

- 数组

- 集合:List:元素有序放入,元素可以重复

- 集合:Set:元素无序放入,元素不可重复,无索引->检索效率低,crud效率高

  | 名称          | 特点                   | 原理                                                         |
  | ------------- | ---------------------- | ------------------------------------------------------------ |
  | HashSet       | 无序,不重复,无索引     | 底层是基于哈希表来储存的数据 JDK8以前,hashtable是由数组和链表组成的,在JDK8以后,是由数组+链表+红黑树组成的/哈希值:是jdk根据**对象的地址**,按照规则算出的**int类型**的数值->同一个对象,多次调用hashCode()方法返回的哈希值是相同的 String address = "岳阳市"; address.hashcode();获取到25299637(通过字符串的地址算出来的int类型的值)/哈希算法: 元素的哈希值和数组的长度求余数算出应该存入的位置,比如数组长度是 16,哈希值和16取余数,就一定是0到15之间的数字->JDK7新元素占用老元素的位置,并且新元素会指向老元素.JDK8以后:新元素挂载在老元素的后面 |
  | LinkedHashSet | 有序,不重复,无索引     | 在哈希表的原理基础上,为每一个元素又额外的多了一个双链表的机制记录储存的顺序 |
  | TreeSet       | 默认升序,不重复,无索引 | 根据红黑树来实现的                                           |

  

**复杂容器:复杂容器可以储存,还可以管理其中的对象**

程序中的复杂容器:

Servlet容器可以管理Servlet(init/service/destory) Filter,Listener这样组件的一生,所以是一个复杂容器

| 名称       | 时机                      | 次数 |
| ---------- | ------------------------- | ---- |
| 创建对象   | 默认时机:接收到第一次请求 | 一次 |
| 初始化操作 | 创建对象之后              | 一次 |
| 处理请求   | 接收到请求                | 多次 |
| 销毁操作   | Web应用卸载之前           | 一次 |

我们将要学习的SpringIOC容器是一个复杂容器,它不仅会负责创建组件的对象,储存组件的对象,而且负责调用组件的方法让它们工作,最终在特定情况下销毁组件

**总结:Spring管理的容器:就是一个复杂组件,不仅储存组件,而且可以管理组件之间的依赖关系,并且可以创建和销毁组件**

### 3.2.2 SpringIOC的容器介绍

![image-20240316101558408](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316101558408.png)

### 3.2.3 Spring IOC具体的接口和实现类

**A.SpringIOC接口**:

**BeanFactory**接口提供了高级配置机制:可以管理任何类型的对象

**ApplicationContext**是**Beanfactory**子接口,扩展了如下功能:

- 更容易与Spring的AOP功能集成
- 资源消息处理
- 特定于应用程序给予这个接口的实现,例如Web应用程序的WebApplicationContext	

**BeanFactory**提供了配置框架和基本功能,而 **ApplicationContext**添加更多特定于企业的功能.**ApplicationContext**是**BeanFactory**的超集

**B.ApplicationContext实现类**:

| 类型名                             | 简介                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| ClassPathXmlApplicationContext     | 通过读取类路径下的XML格式的配置文件来创建IOC的容器对象       |
| FileSystemXmlApplicationContext    | 通过文件系统路径,来读取XML格式的配置文件创建IOC容器对象      |
| AnnotationConfigApplicationContext | 通过读取Java的配置类创建IOC的容器对象                        |
| WebApplicationContext              | 专门为Web应用准备,基于Web环境,常见IOC容器对象,并且将其存入 **ServletContext**中 |

![image-20240316105824559](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316105824559.png)

**我们主推的是 注解+配置类的方式**:迎合Springboot不用Xml,并且xml这种配置方式逐渐被淘汰了

### 3.2.4 SpringIOC容器配置方式

A.xml配置

B.注解配置

C.java的配置类

## 3.3 Spring Ioc/DI 概念总结

#### **3.3.1 IOC容器**

Spring IOC容器:负责实例化,配置和组装bean(组件).容器通过读取配置元数据来获取有关重要实例化,配置和组装组件的指令

#### 3.3.2 IOC(inversion of Control)控制反转

IOC主要是针对对象的创建和调用来说的,也就是说,当程序需要使用一个对象的时候,不再是应用程序直接创建该对象,而是让IOC容器来创建和管理对象,也就是说控制权从应用程序转移到了IOC容器中,也就是"反转了"控制权,这种方法一般上是通过依赖查找的方式实现的,也就是说IOC容器维护着构成应用程序的对象,并且负责创建这些对象

#### 3.3.3 DI(Dependency Injection)依赖注入

DI是指在组件之间传递依赖关系的过程中,将**依赖关系在容器内部处理**,这样就不必在应用程序代码中硬编码对象之间的依赖关系,实现了对象之间的**解耦合**,在Spring中,DI是通过**XML**配置文件或**注解**的方式实现的,它提供了三种形式的依赖注入:**构造函数注入**,**Setter方法注入**,**接口注入**

# 四:Spring Ioc的实践和应用

![image-20240316161128017](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316161128017.png)



## 4.1SpringIOC/DI实现步骤

**1.配置元数据(配置)**

```xml
<?xml version="1.0" encoding="UTF-8"?>
//此处添加一些约束
<beans xmlns=""
       xnlns:xs1:""
       xsi:schemaLocation=""></beans>
<bean id="" class=""></bean>
//一个bean就是一个属性信息 id是组件对象的标识 class是你要实例化的类
```

**2.实例化IOC容器**

提供给ApplicationContext构造函数的路径是资源字符串地址,允许容器从外部资源(本地文件系统/Java class/)加载文件数据

我们应该选择一个合适的容器实现类,来进行Ioc的实例化工作

```java
//实例化ioc容器,读取外部配置文件,最终在容器内进行ioc和di动作
ApplicationContext context = 
    new ClassPathXmlApplicationContext("services.xml","daos".xml);
//接口+实现类来实现多态

```

**3.获取组件**

ApplicationContext是一个高级工厂的接口,可以维护不同的bean以及依赖项的注册表,通过使用方法 T getBean(Stringname,Class<T>requriedType),您可以检索bean的实例

```java
//创建ioc的容器对象,指定配置文件,ioc也开始实例组件对象
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml","daos.xml");
//获取ioc容器的组件对象
PetStoreService service = context.getBean("petStore",PetStoreService.class);
//使用组件对象
List<String> userList = service.getUsernameList();
```



## 4.2基于XML配置方式组件管理

### 4.2.1 实验一:组件(Bean)信息声明配置(IOC)

##### **1.目标:**

SpringIOC容器管理一个或多个Bean,这些Bean是使用配置文件创建的

我们学习,如何定义XML配置文件,声明组件类信息,交给SpringIOC的容器进行组件管理

##### **2.思路**

![image-20240316165515420](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316165515420.png)



​	实例化一个类的方案:

| 实例化的类型   | 细节分布                            |
| -------------- | ----------------------------------- |
| 构造函数实例化 | 无参数构造函数/有参数构造函数实例化 |
| 工厂模式实例化 | 静态工厂/非静态工厂                 |

不同的实例化方式对象和组件ioc配置方式是不同的

![image-20240316170446609](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316170446609.png)

##### **3.无参构造函数的声明方法**

```java
package com.atguigu.ioc_01;

public class HappyComponent {
    public void doWork(){
        System.out.println("HappyComponent doWork");
    }
}

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- 配置一个无参数的构造函数
      <bean 一个组件信息 一个组件对象
        id:组件的标识-要唯一,方便后期读取
        class:组件的类的权限定符 >
     下面实际是将一个组件声明了两个组件信息
     因为默认会单例模式,因此会实例化两个组件对象
     相当于就是new了两个对象
     -->
    <bean id="happyComponent" class="com.atguigu.ioc_01.HappyComponent">

    </bean>
    <bean id="happyComponent2" class="com.atguigu.ioc_01.HappyComponent"></bean>
</beans>
```

##### 4.静态工厂类

```java
package com.atguigu.ioc_01;

public class ClientService {
    private static ClientService clientService = new ClientService();
    private ClientService(){};
    public static ClientService createInstance(){
        return clientService;
    }
    //因为静态方法可以直接调用 不需要实例化
}

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- 2.静态工厂类如何声明工厂方法进行ioc的配置
     id=
     class="工厂类的全限定符"
     factory-method="工厂类中的静态方法名"
    -->
    <bean id="clientService" class="com.atguigu.ioc_01.ClientService" factory-method="createInstance">

    </bean>
</beans>
```

##### 5.非静态工厂模式如何创建

```java
package com.atguigu.ioc_01;

public class DefaultServiceLocator {
    private static clientServiceImpl clientService = new clientServiceImpl();
    public clientServiceImpl createServiceInstance(){
        return clientService;
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--3.非静态工厂如何声明ioc配置-->
    <!--3.1配置工厂类的组件信息-->
    <bean id="defaultServiceLocator" class="com.atguigu.ioc_01.DefaultServiceLocator"></bean>
    <!--3.2通过指定非静态工厂对象和方法名来配置生成的ioc信息-->
    <bean id="clientService2" factory-bean="defaultServiceLocator" factory-method="createServiceInstance"></bean>
</beans>
```

##### 6.静态工厂类和非静态类的区分

| 设计模式->工厂模式 | 特点                                          |
| ------------------ | --------------------------------------------- |
| 静态工厂           | 1.不需要实例化工厂类 2.类的方法用static修饰   |
| 实例工厂           | 1.需要实例化工厂类 2.类的方法不需要static修饰 |

```java
public class Car {
    private String brand;

    private Car(String brand) {
        this.brand = brand;
    }

    public String getBrand() {
        return brand;
    }

    public static Car createCar(String brand) {
        return new Car(brand);
    }
}

public class Main {
    public static void main(String[] args) {
        Car myCar = Car.createCar("Toyota");
        System.out.println("My car brand is: " + myCar.getBrand());
    }
}
/*上方是静态工厂 下方是实例工厂*/
public class CarFactory {
    private String brand;

    public CarFactory(String brand) {
        this.brand = brand;
    }

    public Car createCar() {
        return new Car(brand);
    }
}

public class Main {
    public static void main(String[] args) {
        CarFactory factory = new CarFactory("Toyota");
        Car myCar = factory.createCar();
        System.out.println("My car brand is: " + myCar.getBrand());
    }
}

```



### 4.2.2 实验二:组件(Bean)依赖注入配置(DI)

#### 1.目标

通过配置文件,实现IOC容器中Bean之间的引用(依赖注入DI配置)

主要涉及的注入场景:基于**构造函数**的依赖注入和**基于Setter**的依赖注入

#### 2.思路

![image-20240316184402730](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316184402730.png)

#### 3.基于构造函数的依赖注入(单个构造函数)

a.介绍:

基于构造函数的DI是通过容器调用具有多个参数的构造函数来完成的,每一个参数就是一个依赖项,下面事例演示一个只能通过构造函数注入进行依赖注入的类

b.准备组件类

```java
package com.atguigu.ioc_02;

public class UserDao {
}

```

```java
package com.atguigu.ioc_02;

public class UserService {
    private UserDao userDao;
    public UserService(UserDao userDao){
        this.userDao = userDao;
    }
}

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
<!--引用和被引用的组件 必须全部都在ioc容器中-->
    <!--SpringIOC是一个高级容器,内部会有缓存动作,线创建对象ioc-->
    <!--1.单个构造参数注入-->
    <!--步骤1.将它们都放在ioc容器中-->
    <bean id="userDao" class="com.atguigu.ioc_02.UserDao"></bean>
    <!--<constructor-arg
    构造参数传值
    value = 直接属性值 String name="二狗子" int age =18
    ref = 引用其他bean 其他bean的id值
    -->
    <bean id="userService" class="com.atguigu.ioc_02.UserService">
        <constructor-arg ref="userDao"></constructor-arg>
    </bean>
</beans>

```



#### 4.基于构造函数的依赖注入(多个构造函数)

a.介绍:

基于构造函数的DI是通过容器调用具有多个参数的构造函数来完成的 每个参数表示一个依赖项

b.准备组件类

```java
package com.atguigu.ioc_02;

public class UserService {
    private UserDao userDao;
    private int age;
    private String name;

    public UserService(int age,String name,UserDao userDao){
        this.userDao = userDao;
        this.age=age;
        this.name=name;
    }
}

```

```java
package com.atguigu.ioc_02;

public class UserDao {
}

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
<!--引用和被引用的组件 必须全部都在ioc容器中-->
    <!--SpringIOC是一个高级容器,内部会有缓存动作,线创建对象ioc-->
    <!--2.多个构造参数注入-->
    <bean id="userService1" class="com.atguigu.ioc_02.UserService">
        <!--方案1:value是直接赋值 ref是引用 这里是按顺序来的-->
        <constructor-arg value="18"/>
        <constructor-arg value="张三"/>
        <constructor-arg ref="userDao"/>
    </bean>
    <bean id="userService2" class="com.atguigu.ioc_02.UserService">
        <!--方案2推荐:value是直接赋值 ref是引用 构造参数的名字注明-->
        <constructor-arg name="name" value="张三"/>
        <constructor-arg name="age" value="18"/>
        <constructor-arg ref="userDao"/>
    </bean>
    <bean id="userService3" class="com.atguigu.ioc_02.UserService">
        <!--方案3:value是直接赋值 ref是引用 参数的下角标从左到右从0开始
        age=0 name=1 userDao=2-->
        <constructor-arg index="1" value="张三"/>
        <constructor-arg index="0" value="18"/>
        <constructor-arg index="2" ref="userDao"/>
    </bean>
</beans>

```



#### 5.基于Setter方法来依赖注入(重点中的重点)

```java
package com.atguigu.ioc_02;

public class SimpleMovieLister {
    private movieFinder movieFinder;
    private String moiveName;
    public void setMoiveFinder(movieFinder movieFinder){
        this.movieFinder=movieFinder;
    }
    public void setMoiveName(String moiveName){
        this.moiveName=moiveName;
    }
}

```

```java
package com.atguigu.ioc_02;

public class movieFinder {
}

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
<!--引用和被引用的组件 必须全部都在ioc容器中-->
    <!--SpringIOC是一个高级容器,内部会有缓存动作,线创建对象ioc-->
    <!-- 3.触发Set方法进行注入-->
    <bean id="movieFinder" class="com.atguigu.ioc_02.movieFinder"></bean>
    <bean id="simpleMovieLister" class="com.atguigu.ioc_02.SimpleMovieLister">
        <property name="moiveName" value="消失的她"/>
        <property name="moiveFinder" ref="movieFinder"></property>
    </bean>
    <!--
    name->属性名 setter方法 去set和首字母小写的值!
    setMovieFinder -> movieFinder
    values和ref是二选一的-->
</beans>

```



### 4.2.3 实验三:IOC容器的创建和使用

#### A.IOC容器的创建

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="HappyComponent" class="com.atguigu.ioc_03.HappyComponent"></bean>
</beans>

```

```java
package com.atguigu.test;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringIoCtest {
    //讲解如何创建Ioc容器并且读取配置文件
    /*
     * 接口:
     *   BeanFactory
     *   ApplicationContext
     * 实现类:
     * ClassPathXmlApplicationContext 读取类路径下的xml配置方式 读class文件
     * FileSystemXmlApplicationContext 读取指定文件位置的xml配置方式
     * AnnotationConfigApplicationContext  读配置类
     * WebApplicationContext 读取Web项目专属的配置ioc容器
     * 可以通过构造函数实例化
     * */
    public void createIoc(){
        //ioc和di
        //方案1:
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring-03.xml");

        //方案2:先创建ioc创建,再指定配置文件,再刷新
        //创建容器 和配置文件指定分开
        ClassPathXmlApplicationContext applicationContext1 = new ClassPathXmlApplicationContext();
        applicationContext1.setConfigLocations("spring-03.xml");
        applicationContext1.refresh();
    }
    public void getBeanFromIOC(){
        //讲解如何在Ioc容器中获取组件
    }
}

```



#### B.IOC容器的使用

```java
package com.atguigu.test;

import com.atguigu.ioc_03.HappyComponent;
import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringIoCtest {
    //讲解如何创建Ioc容器并且读取配置文件
    /*
     * 接口:
     *   BeanFactory
     *   ApplicationContext
     * 实现类:
     * ClassPathXmlApplicationContext 读取类路径下的xml配置方式 读class文件
     * FileSystemXmlApplicationContext 读取指定文件位置的xml配置方式
     * AnnotationConfigApplicationContext  读配置类
     * WebApplicationContext 读取Web项目专属的配置ioc容器
     * 可以通过构造函数实例化
     * */
    public void createIoc(){
        //ioc和di
        //方案1:
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring-03" +
                ".xml");

        //方案2:先创建ioc荣建,再指定配置文件,再刷新
        //创建容器 和配置文件指定分开
        ClassPathXmlApplicationContext applicationContext1 = new ClassPathXmlApplicationContext();
        applicationContext1.setConfigLocations("spring-03.xml");
        applicationContext1.refresh();
    }
    @Test
    public void getBeanFromIOC(){
        //讲解如何在Ioc容器中获取组件

        //1.创建ioc容器
        ClassPathXmlApplicationContext applicationContext = new ClassPathXmlApplicationContext();
        applicationContext.setConfigLocations("spring-03.xml");
        applicationContext.refresh();
        //2.读取ioc容器的组件
        //方案1.直接根据beanId获取(需要强转 不推荐)
        HappyComponent happyComponent = (HappyComponent) applicationContext.getBean("HappyComponent");
        //方案2:根据beanId,同时指定bean的类型 Class
        HappyComponent happyComponent1 = applicationContext.getBean("HappyComponent",HappyComponent.class);
        //方案3:根据Bean的类型获取
        //TODO 根据bean的类型获取,同一个类型,在ioc容器中只有一个bean
        //TODO 如果ioc容器存在多个同类型的bean,会出现NoUniqueDefinitionException
        //TODO ioc的配置一定是实现类,但是可以根据接口来获取值 getBeans
        HappyComponent happyComponent3 = applicationContext.getBean(HappyComponent.class);
        System.out.println(happyComponent3==happyComponent1);
    }
}

```



### 4.2.4 实验四:高级特性: 组件(Bean)作用域和周期方法配置

![image-20240316215546375](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316215546375.png)

#### 4.2.4.1.组件周期方法配置

##### **a.周期方法概念**

我们可以在组件内定义方法,然后当IOC容器实例化和销毁对象组件的时候调用,这两个方法是我们成为生命周期方法

类似于Servlet的Init/destory方法

##### **b.周期方法声明**

```java
package com.atguigu.ioc_04;

public class JavaBean {
    /*

    必须是public/必须是void/必须是无参数/命名随意
    初始化方法->初始化业务逻辑
    void是为了方便反射
    */
    public void init(){
        System.out.println("JavaBean.init");
    }
    public void clear(){
        System.out.println("JavaBean clear");
    }
}

```



```java
@Test
    public void test_04(){
        //创建IOC容器
        ClassPathXmlApplicationContext test04 = new ClassPathXmlApplicationContext("spring-04.xml");
        //ioc 容器去调用destroy
        //ioc会立刻释放 死了

        //2.正常结束ioc容器

        test04.close();
    }
}
```

##### **c.周期方法配置**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--
    init-method= "初始化方法名"
    destory-method="销毁方法名"
    spring ioc容器就会在对应的时间节点回调对应的方法
    我们在其中些对应的业务就可以了

    -->
    <bean id="javaBean" class="com.atguigu.ioc_04.JavaBean"
    init-method="init" destroy-method="clear"></bean>
</beans>
```

#### 4.2.4.2.组件作用域配置

##### **a.Bean作用域**

<Bean 标签只是声明Bean 只是将Bean的信息配置给Springioc容器

在ioc容器中,这些<bean标签就会转化为Spring内部的BeanDefinition对象,在Beandefinition对象中,就包含了定义的信息,比如id class等等

这意味着,BeanDefinition与类的概念一样,SpringIOC容器可以根据BeanDefinition对象去反射创建多个Bean对象实例

具体创建多少个Bean的对象实例,由Scope属性指定

![](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240316221340410.png)

##### **b.作用域可选值:**

| 取值      | 含义                                 | 创建对象的时机  | 默认值 |
| --------- | ------------------------------------ | --------------- | ------ |
| singleton | 在IOC容器中,这个bean对象始终为单实例 | IOC容器初始化时 | 是     |
| prototype | 这个bean在IOC容器中有多个实例        | 获取bean的时候  | 否     |

| 取值     | 含义                 | 创建对象的时机 | 默认值 |
| -------- | -------------------- | -------------- | ------ |
| requrest | 请求范围内有效的实例 | 每次请求       | 否     |
| session  | 会话范围内有效的实例 | 每次会话       | 否     |

##### **c.作用域的配置**

其实就是修改xml中bean的scope

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--
    init-method= "初始化方法名"
    destory-method="销毁方法名"
    spring ioc容器就会在对应的时间节点回调对应的方法
    我们在其中些对应的业务就可以了

    -->
    <bean id="javaBean" class="com.atguigu.ioc_04.JavaBean"
    init-method="init" destroy-method="clear"></bean>
    <!--声明一个组件信息!默认就是单例模式 一个bean对应一个beanDefinition-->
    <bean id="javaBean2" class="com.atguigu.ioc_04.JavaBean2" scope="prototype"></bean>


</beans>


```



```java
 @Test
    public void test_04(){
        //创建IOC容器
        ClassPathXmlApplicationContext test04 = new ClassPathXmlApplicationContext("spring-04.xml");
        //ioc 容器去调用destroy
        //ioc会立刻释放 死了

        //2.正常结束ioc容器
         JavaBean2 bean1 = test04.getBean(JavaBean2.class);
        JavaBean2 bean2 = test04.getBean(JavaBean2.class);
        System.out.println(bean1==bean2);//这里是在判断是否为单例模式,如果是单例模式 bean1和bean2是完全一样的

    }
}
```



### 4.2.5 实验五:高级特性: FactoryBean特性和使用

![image-20240317174911832](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240317174911832.png)

##### **4.2.5.1.FactoryBean的认知**

FactoryBean用于配置复杂的Bean对象,可以将创建过程储存在FactoryBean的getObject方法中

FactoryBean<T>提供三种方法

- T getObject();返回此工厂创建对象的实例,这个返回值会被储存到IOC容器

- boolean isSingleton()l如果返回单例,则返回true,否则返回false.默认实现返回true

- Class<?>getObjectType();返回getObject()方法返回的对象类型,如果事先不知道类型,则返回Null

  

##### 4.2.5.**2.FactoryBean运用**

a.代理类的创建

b.第三方框架整合:Mybatis的内容

c.复杂对象实例化

##### 4.2.5.**3.FactoryBean实际情况**

```java
package com.atguigu.ioc_05;

public class JavaBean {
    private String getName;

    public JavaBean() {
    }

    public JavaBean(String getName) {
        this.getName = getName;
    }

    /**
     * 获取
     * @return getName
     */
    public String getGetName() {
        return getName;
    }

    /**
     * 设置
     * @param getName
     */
    public void setGetName(String getName) {
        this.getName = getName;
    }

    public String toString() {
        return "JavaBean{getName = " + getName + "}";
    }
}

```

```java
package com.atguigu.ioc_05;

import org.springframework.beans.factory.FactoryBean;
/*
* 步骤1:实现FactoryBean接口<返回值类型>
*
*
*
*
* */
public class JavaBeanFactoryBean implements FactoryBean<JavaBean> {


    @Override
    public JavaBean getObject() throws Exception {
        //使用你自己的方式实例化对象
        JavaBean javaBean = new JavaBean();
        return javaBean;
    }

    @Override
    public Class<?> getObjectType() {
        return JavaBean.class;
    }
}

```



```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--
    id - > getObject方法返回的对象标识
    Class->FactoryBean的工厂类


    -->
    <bean id="javaBean" class="com.atguigu.ioc_05.JavaBeanFactoryBean"></bean>
</beans>
```

```java
    @Test
    public void test_05(){
        //1创建IOC容器
        ClassPathXmlApplicationContext test05 = new ClassPathXmlApplicationContext("spring-05/.xml");
        //2.读取组件
        JavaBean Javabean = test05.getBean("Javabean",JavaBean.class);
        System.out.println("JavaBean="+Javabean);
        //TODO FactoryBean工厂也会加入到IOC容器中
        Object bean = test05.getBean("&JavaBean");
        System.out.println("bean"+bean);
    }
}
```



### 4.2.6 实验六:基于XML方式整合三层架构组件

![image-20240317181531945](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240317181531945.png)

```sql


CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    age INT,
    class VARCHAR(50)
);


drop table students;


INSERT INTO students (id, name, gender, age, class) VALUES (1, 'Alice Smith', 'Female', 22, 'Class A');
INSERT INTO students (id, name, gender, age, class) VALUES (2, 'Bob Johnson', 'Male', 21, 'Class B');
INSERT INTO students (id, name, gender, age, class) VALUES (3, 'Cathy Brown', 'Female', 23, 'Class C');
INSERT INTO students (id, name, gender, age, class) VALUES (4, 'David Wilson', 'Male', 20, 'Class A');
INSERT INTO students (id, name, gender, age, class) VALUES (5, 'Eva Davis', 'Female', 22, 'Class B');
INSERT INTO students (id, name, gender, age, class) VALUES (6, 'Frank White', 'Male', 21, 'Class C');
INSERT INTO students (id, name, gender, age, class) VALUES (7, 'Grace Lee', 'Female', 23, 'Class A');
INSERT INTO students (id, name, gender, age, class) VALUES (8, 'Henry Clark', 'Male', 20, 'Class B');

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <context:property-placeholder location="classpath:jdbc.properties"/>
    <!--druid-->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
        <property name="url" value="${atguigu.url}"></property>
        <property name="driverClassName" value="${atguigu.driver}"></property>
        <property name="username" value="${atguigu.username}"/>
        <property name="password" value="${atguigu.password}"></property>
    </bean>
    <!--jdbcTemplate-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource"></property>

    </bean>
    <!--dao配置di jdbcTemplate-->
    <bean id="studentDao" class="com.atguigu.dao.impl.StudentDaoImpl">
        <property name="jdbcTemplate" ref="jdbcTemplate"></property>"
    </bean>
    <!--service配置di dao-->
    <bean id="studentService" class="com.atguigu.service.impl.StudentServiceImpl">
    <property name="studentDao" ref="studentDao" />
    </bean>
    <!--controller配置di service-->
    <bean id="studentController" class="com.atguigu.controller.StudentController">
    <property name="studentService" ref="studentService"></property>
    </bean>


</beans>
```

![image-20240318111017518](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240318111017518.png)

## 4.3基于 注解 方式管理Bean

#### 4.3.1 实验一: Bean注解标记和扫描(IOC)

##### **4.3.1.1.注解是什么:**

和XML配置文件一样,注解本身不能执行,注解只是提供一个标记,具体的功能是框架检测到注解标记的位置,然后针对这个位置按照注解标记的功能来进行具体操作

本质上:一切的操作都是由Java代码来完成的,XML和注解只是告诉框架中的Java代码,如何去运行

举例:元旦联欢会要布置教室,蓝色的地方要贴上元旦快乐,红色的地方贴上拉花,黄色的地方贴上气球.班长做了所有的标记,同学们来完成具体工作,墙上的标记就相当于我们做的注解,同学们做的工作,就是框架执行的内容

##### **4.3.1.2扫描理解**

Spring为了知道程序员在哪些地方做了哪些注解,就需要通过扫描功能来实现

![image-20240318124338395](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240318124338395.png)

##### **4.3.1.3.准备Spring项目的组件**:

##### **4.3.1.4.组件标记注解和区别:**

| 注解        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| @Component  | 该注解用于描述Spring中的Bean,它是一个泛化的概念,仅仅表示容器中的一个组件(Bean),并且可以作用在任何层次,比如Service层,Dao层.使用时只需要将该注解标注在相应类上即可 |
| @Repository | 该注解用于将数据访问层(Dao层)的类标识为Spring中的Bean,其功能与@Component相同 |
| @Service    | 此注解通常作用在业务层(Service层)用于将业务层的类标识为Spring中的Bean,其功能与Component相同 |
| @Controller | 此注解通常作用在控制层(如SpringMVC中的controller)用于将控制层的类标识为Spring中的Bean,其功能与@Component相同 |

常用的配置Spring的xml文档

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>spring-xml-practice-02</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <!-- Spring的核心工具包-->
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>

        <!--在基础IOC功能上提供扩展服务，还提供许多企业级服务的支持，有邮件服务、 任务调度、远程访问、缓存以及多种视图层框架的支持-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>


        <!-- Spring IOC的基础实现，包含访问配置文件、创建和管理bean等 -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>

        <!-- Spring context的扩展支持，用于MVC方面 -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context-support</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>
        <!-- Spring表达式语言 -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-expression</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>
        <!-- Java注解包提供@Resource注解 -->
        <dependency>
            <groupId>javax.annotation</groupId>
            <artifactId>javax.annotation-api</artifactId>
            <version>1.2</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.46</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-tx</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.0.8.RELEASE</version>
        </dependency>

        <dependency>
            <groupId>com.mchange</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.5.2</version>
        </dependency>

    </dependencies>


</project>
```

![image-20240318134918901](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240318134918901.png)

**实质上:**Controller/Service/Repository的本质就是Component注解基础上起了三个新的名字

**组件深层解析:**对于Spring使用IOC容器管理这些组件,其实没有本质区别,也就是在语法层面上不存在区别.所以说@Controller,@Service,@Repository三个注解本质是给开发人员看的,让我们能便于分辨组件的使用

```java
//@Component == <bean id="" class="CommonComponent"></bean>
//我们不难发现 @Component组件是为了简化Xml操作的,实际上底层还是用的Xml操作

//1.标记注解 @Component
//2.配置xml来指定包
```

##### 4.3.1.**5.配置文件确定扫描范围**

###### A情况:基本扫描配置

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 这里使用了正确的 context 命名空间 -->
    <!--1.普通配置包扫描-->
    <!--base-package 指定ioc容器去哪些包下查找注解类
        可以是单个包或者多个包 com.atguigu,com.atguigu.xxx 包,包
        指定包:指定包中的所有类
        指定包及其子包:指定包及其子包中的所有类-->
    <context:component-scan base-package="com.atguigu"/>

    <!-- 其他的bean配置 -->

    <!-- 更多的bean配置 -->

</beans>

```



###### B情况:指定排除组件

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd">
    <!--2.指定包排除注解-->
    <!--
         我们有三层架构:Controller Service Repository
         webioc会储存Controller 例如com.atguigu.controller
         rootioc会储存Service和Repository
         所以rootioc可以排除@Controller注解,因为这个ioc容器里面不会放和web相关的内容
         我们为了节约内存,所以需要排除包
         
          <context:exclude-filter type= expression= >
          就是用于排除的方法

    -->
    <context:component-scan base-package="com.atguigu">
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>
</beans>

```



###### C情况:指定包含组件

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd">
    <!--3.指定包一定包含注解-->
    <!--
         basePackage->包下全部都成立
         但是include->只包含,因此我们要关闭默认的过滤器 我们2.中就是在默认过滤器的基础上,去选择不扫描Repository和Controller
         但是在3中,我们是只要,因此我们就关闭默认的过滤器,然后把Repository设定为我们要包含的组件标签

    -->
    <context:component-scan base-package="com.atguigu" use-default-filters="false">
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
    </context:component-scan>
</beans>

```



#### 4.3.2 实验二: 组件(Bean)作用域和周期方法注解

##### 4.3.2.1组件周期方法的配置

**a.**周期方法的概念

我们可以在组件类中定义方法,然后当ioc容器实例化和销毁组件对象时候进行调用,这两个方法我们称为声明周期方法

**b.**周期方法的声明

```java
public class BeanOne{
    //生命周期方法要求:命名随意的 但是要求必须是public void的无参列表
    @PostConstruct //初始化方法注解
    public void init(){
    //初始化逻辑
    }
    }
public class BeanTwo{
    @PreDestroy//注解指定销毁方法
    public void cleanup(){
        //释放资源逻辑
    }
}
//相较于纯xml配置,你不必在spring-ioc.xml这类文件中写<bean>来声明

```

##### **4.3.2.2组件作用域配置**

**a.Bean作用域的概念:**

<bean标签声明Bean,只是将Bean的信息传递给SpringIOC容器

在IOC容器中,这些<bean标签对应的信息,会转化成BeanDefinition对象,而在BeanDefinition对象中,包含定义的信息(id class)

这意味着,BeanDefinition就和类概念一样,SpringIOC容器可以根据BeanDefinition对象反射创建多个Bean对象实例

具体创建多少个Bean,由Bean作用域Scope决定

**b.作用域可选值**

| 取值      | 含义                               | 创建对象的时机      | 默认值 |
| --------- | ---------------------------------- | ------------------- | ------ |
| singleton | 在IOC容器中,bean的对象始终为单实例 | IOC容器初始化的时候 | 是     |
| prototype | 这个Bean在IOC容器中有多个实例      | 获取Bean的时候      | 否     |

如果在WebApplicationContext下,会有另外两个作用域(不常用)

| 取值    | 含义                 | 创建对象的时机 | 默认值 |
| ------- | -------------------- | -------------- | ------ |
| request | 请求范围内有效的实例 | 每次请求       | 否     |
| session | 会话范围内有效的实例 | 每次对话       | 否     |

**c.作用域配置**

```java
@Scope(ScopeName= ConfigurableBeanFactory.SCOPE_SINGLETON)//单例默认值
@Scope(ScopeName= ConfigurableBeanFactory.SCOPE.PROTOTYPE)//多例 二选一
public class BeanOne{
    //周期方法要求:命名随意,但是方法一定是返回值为空的public方法
    @PostConstruct
    public void init(){
        //初始化逻辑
    }
}
```



#### 4.3.3 实验三: Bean属性赋值: 引用类型自动装配(DI)

```java
@Controller
public class UserController {
    /**
     * 复习使用xml方式插入注解
     注意 property这个成立的前提是name指的那个set方法存在,并且name值为set方法去掉set和余下首字母小写的结果
     ref是引用类型 value是值类型,引用类型填的是已经声明的bean的id 
     * <bean id="UserService" class="class地址"></bean>
     * <bean id="UserController" class="class地址">
     *     <property name="userService(set方法的名字去掉set和首字母小写)" ref="UserService"></property>
     *     </bean>
     *我们用@AutoWwired实际上就是替代了上述的操作 简化了xml操作 实现了自动化的di
     *
     * */
    @Autowired//这里等价于<property userService ->对应类型的bean装配
    //所以说 autowired叫做注解的自动装配
    private UserService userService;
    public void show(){
        //调用业务层的show方法
    }
}
```

**@Autowired注解细节**:

**a.标记位置:**

​	1.成员变量:

​	这也是主要的使用方式 与xml进行bean ref不同, 使用@Autowired不必有set方法

```java
@Service("smallDog")
public class SoldierService{
    @Autowired
    private SoldierDao soldierDao;
    public void getMessage(){
        soldierDao.getMessage();
    }
}
```

​	2.构造器:

```java
@Controller(value="tianDog")
public class SoldierController{
    private SoldierService soldierService;
    @Autowired
    public SoldierController(SoldierService soldierService){
        this.soldierService = soldierService;
    }
}

```

​	3.setXxx方法

```java
@Controller(value="tiangou")
public class SoldierController{
    private SoldierService soldierService;
    @Autowired
    public void setSoldierService(SoldierService soldierService){
        this.soldierService = soldierService;
    }
}
```

**b.工作流程**

![image-20240319115225879](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319115225879.png)

- 首先根据所需要的组件类型在IOC容器中寻找

  - 能找到唯一的bean:直接执行装配

  - 如果完全找不到匹配的这个bean:装配失败

  - 和所需类型匹配的bean不止一个

    - 没有@Qualifier注解: 根据@Autowired标记位置成员变量名作为bean的id进行匹配

      - 能找到:执行装配
      - 找不到:装配失败

    - 有@Qualifier注解:根据@Qualifier注解中指定的名称作为bean的id进行匹配

      - 能找到:执行装配

      - 找不到:装配失败

        

        

```java
package com.atguigu.ioc_03;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;

@Controller
public class UserController {
    @Autowired
    @Qualifier("userServiceImpl")
    /*
    * 1.Qualifier对Autowired是依赖的
    * 在 Spring 中，@Qualifier 注解用于指定具体要注入的 Bean，
    * 解决自动装配时的歧义性。当一个接口有多个实现类时，
    * Spring 无法确定要注入哪个 Bean，这
    * 时就可以使用 @Qualifier 注解来指定具体要注入的 Bean。
    * */
    private UserService userService;

    public void show() {
        // 调用业务层的show方法
        userService.show();
    }
}

```



#### 4.3.4 实验四: Bean属性赋值: 基本类型属性赋值(DI)

@Value通常用于注入外部化属性

**声明外部配置**

application.properties

```properties
catalog.name=MovieCatalog
```

**xml引入外部配置**

```xml
<context:property-placeholder location="application.properties"></context:property-placeholder>
```

**@Value注解读取配置**

```java
@Component
public class CommonComponent{
    @Value(${catalog:hahaha})//这个:之后是默认值
    private String name;
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name=name;
    }
}
```



#### 4.3.5 实验五: 基于注解+XML方式 整合三层架构组件

## 4.4基于 配置类 方式管理Bean

### 4.4.1 完全注解开发理解

![image-20240319141737835](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319141737835.png)

![image-20240319144233058](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319144233058.png)

### 4.4.2 实验一: 配置类和扫描注解

```java
package com.atguigu.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

/**
 * @program: spring-ioc-java-06
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 14:25
 * 1.包扫描注解配置
 * 2.引用外部的配置文件
 * 3.声明第三方依赖的bean组件
 * 步骤:
 * 1.添加@Configuration 代表我们是配置类
 * 2.实现上述功能注解
 **/
@ComponentScan(value="com.atguigu.ioc_01")
@PropertySource(value="classpath:jdbc.properties")
@Configuration//证明你是配置类
public class JavaConfiguration {

}



```



### 4.4.3 实验二: @Bean定义组件

```java
/**
 * @program: spring-ioc-java-06
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 14:25
 * 1.包扫描注解配置
 * 2.引用外部的配置文件
 * 3.声明第三方依赖的bean组件
 * 步骤:
 * 1.添加@Configuration 代表我们是配置类
 * 2.实现上述功能注解
 **/
@ComponentScan(value="com.atguigu.ioc_01")
@PropertySource(value="classpath:jdbc.properties")
@Configuration//证明你是配置类
public class JavaConfiguration {
    @Value("$atguigu.url")
    private String url;
    @Value("$atguigu.driver")

    private String driver;
    @Value("$atguigu.username")

    private String uesename;
    @Value("$atguigu.password")

    private String password;
    @Bean//证明其是一个添加第三方变量的bean组件
    /*
    * 这里实际上与
    * <bean id class =>
    <property name = "" value=;
    *
    * </bean>
    * 效果是一致的,只是避免了Xml的繁琐配置,精简为配置类实现
    *
    * */
    public DruidDataSource dataSource(){
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setUrl(url);
        dataSource.setDriverClassName(driver);
        dataSource.setUsername(uesename);
        dataSource.setPassword(password);
        return dataSource;
    }
}
```



### 4.4.4 实验三: 高级特性: @Bean注解细节

问题1:BeanName的问题->默认是方法名 指定:name/value属性来起名 覆盖方法名

问题2:周期方法如何指定->原有解决方案:PostConstruct+PreDestroy注解指定

​						->Bean注解指定:initMethod/destoryMethod指定

问题3:作用域:

​	还有用 @Scope指定,只是默认单例

```java
@Scope(scopeName=ConfigurableBeanFanctory.SCOPE.SINGLETON)
@Bean(name="ergouzi1",initMethod = "",destroyMethod = "")
```



### 4.4.5 实验四: 高级特性: @Import扩展

@Import注释允许从另一个配置类中加载@Bean定义

```java
@Configuration 
public class ConfigA{
    @Bean
    public A a(){
        return new A();
    }
}

@Configuration
@Import(ConfigA.class)
public class ConfigB{
    @Bean
    public B b(){
        return new B();
    }
}
```

现在,实例化上下文时不需要同时指定ConfigA.class与ConfigB.class 只需要显式提供ConfigB

```java
package com.atguigu.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class JavaConfigurationB {
}
/**
 * @program: spring-ioc-java-06
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 16:20
 **/

```

```java
package com.atguigu.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Import( value = JavaConfigurationB.class)
@Configuration
public class JavaConfigurationA {
}
/**
 * @program: spring-ioc-java-06
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 16:19
 **/

```

![image-20240319163400934](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319163400934.png)

### 4.4.6 实验五: 基于注解+配置类整合方式 整合三层架构组件

## 4.5三种配置方式总结

**4.5.1 XML方式配置总结**

1.所有内容都写到xml格式配置文件中

2.声明bean通过<bean标签

3.<bean标签包含基本信息(id,class)和属性信息<property name value/ref>

4.引入外部的properties文件可以通过<context:property-placeholder

5.IOC具体容器实现选择ClassPathXmlApplicationContext对象

**4.5.2 XML+注解方式配置总结**

1.注解负责标记IOC的类和进行属性装配

2.xml文件依然重要,需要通过<context:component-scan标签来指定注解范围

3.标记IOC注解 @Component @Service @Controller @Repository

4.标记DI注解 @Autowired @Qualifier @Resource @Value

5.具体容器选择ClassPathXmlApplicationContext对象

**4.5.3完全注解方式配置总结**

1.完全注解方式是指去掉xml文件,使用配置类+注解来实现

2.xml文件替换成使用Configuration注解标记的类

3.标记IOC注解:@Component @Service @Controller @Repository

4.标记DI注解:@Autowired @Qualifier @Resource @Value

5.<context:component-scan 标记指定注解范围用

@ComponentScan替代

6.<context:property-placeholder 引入外部配置文件

7.<bean标签可以用@bean替代

8.IOC具体容器选择AnnotationApplicationContext对象

## 4.6整合Spring5-Test5搭建测试 环境

# 五:SpringAOP面向切面编程

## 5.1 场景设定和问题复现

![](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319215400371.png)

```java
package com.atguigu;

public interface Calculator {
    int add(int i,int j);
    int sub(int i,int j);
    int mul(int i,int j);
    int div(int i,int j);
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 21:30
 **/

```

```java
package com.atguigu;

public class CalculatirPureImpl implements Calculator{
    @Override
    public int add(int i,int j){
        System.out.println("i = " + i + ", j = " + j);
        int result = i+j;

        System.out.println("result = " + result);
        return result;
    }

    @Override
    public int sub(int i,int j){
        System.out.println("i = " + i + ", j = " + j);
        int result = i-j;
        System.out.println("result = " + result);
        
        return j;
    }
    @Override
    public int mul(int i,int j){
        System.out.println("i = " + i + ", j = " + j);
        int result = i*j;
        System.out.println("result = " + result);
        return result;
    }
    @Override
    public int div(int i,int j){
        System.out.println("i = " + i + ", j = " + j);
        int result = i/j;
        System.out.println("result = " + result);
        return result;
    }
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 21:31
 **/

```

**代码问题分析:**

**a.代码缺陷:**

- 对核心业务功能有干扰,程序员在开发核心人物功能时分散了精力

- 附加功能代码重复,分散在各个业务功能方法中,冗余并且不方便统一维护

  

**b.解决思路:**

核心是:解耦:我们需要把附加功能从业务功能代码中抽取出来

将重复的代码统一提取,并且[动态插入]到每个业务方法中

**c.技术困难:**

解决问题的困难:提取重复的附加功能到一个类中可以实现

但是如何将代码插入到各个方法中,我们不会的,我们需要新的技术->AOP技术

![image-20240319215816869](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319215816869.png)

## 5.2 解决技术代理模式(AOP)

### 1.代理模式

二十三中设计模式中的一种,属于结构型模式.它的作用是通过提供一个代理类,让我们在调用目标方法时,不再直接对目标方法进行调用,而是通过代理类间接调用.让不属于目标方法核心逻辑的代码从目标方法中抽离出来--解耦,调用目标方法时,先调用代理对象的方法,减少对目标方法的调用和打扰,同时让附加功能能够集中在一起,也有利于统一维护

![image-20240319220053429](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319220053429.png)

![image-20240319220129033](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319220129033.png)

![image-20240319220340699](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319220340699.png)

### 2.静态代理技术

![image-20240319220623548](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319220623548.png)

代理类(中介):

```java
package com.atguigu.statics;

import com.atguigu.Calculator;

public class StaticProxyCalculator implements Calculator {

    private Calculator calculator;
    public StaticProxyCalculator(Calculator calculator){
        this.calculator = calculator;
    }
    @Override
    public int add(int i, int j) {
        //使用构造函数传入的信息
        System.out.println("i = " + i + ", j = " + j);
        //调用目标
        int result = calculator.add(1, 1);
        return result;
    }

    @Override
    public int sub(int i, int j) {
        return 0;
    }

    @Override
    public int mul(int i, int j) {
        return 0;
    }

    @Override
    public int div(int i, int j) {
        return 0;
    }
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 22:11
 **/

```

核心逻辑(房东):

```java
package com.atguigu;

public interface Calculator {
    int add(int i,int j);
    int sub(int i,int j);
    int mul(int i,int j);
    int div(int i,int j);
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 21:30
 **/

```

```java
package com.atguigu;

public class CalculatirPureImpl implements Calculator{
    @Override
    public int add(int i,int j){

        int result = i+j;


        return result;
    }

    @Override
    public int sub(int i,int j){

        int result = i-j;

        
        return j;
    }
    @Override
    public int mul(int i,int j){

        int result = i*j;

        return result;
    }
    @Override
    public int div(int i,int j){

        int result = i/j;

        return result;
    }
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 21:31
 **/

```

使用AOP:

```java
package com.atguigu;

import com.atguigu.statics.StaticProxyCalculator;

public class UseAOP {

    public static void main(String[] args){
        //房东 目标
        Calculator target = new CalculatirPureImpl();
        //中介 代理
        Calculator proxy = new StaticProxyCalculator(target);
        //调用中介方法
        proxy.add(1,2);
    }
}
/**
 * @program: Spring-aop-annotation-09
 * @description:
 * @author: XiaoYongCai
 * @Goal:
 * @create: 2024-03-19 22:15
 **/

```



### **3.动态代理技术**(实际开发使用)

![image-20240319220712448](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319220712448.png)

**动态代理技术分类**:

- JDK动态代理:JDK原生的实现方式,需要被代理的目标类必须要实现接口,他会基于目标类的接口自动生成一个代理对象,代理对象和目标对象有相同的接口(拜把子)
- cglib:通过继承被代理的目标类来实现代理,所以不需要目标类来实现接口(认干爹)
- ![image-20240319224259744](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240319224259744.png)



## 5.3 面向切面编程思维

![image-20240322192951077](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240322192951077.png)

## 5.4 Spring AOP框架介绍和关系梳理

1.AOP是一种区别于OOP编程思维,用来完善和解决**OOP的非核心代码冗余和不方便统一维护**问题

2.代理技术(动态代理|静态代理)是实现AOP思维编程的具体技术,但是自己用动态代理实现代码比较繁琐

3.Spring AOP框架,基于AOP思维,封装了动态代理技术,简化了动态代理技术实现的框架!Spring AOP内部帮助我们实现动态代理,我们只需要写少量的配置,指定生效范围.即可完成面向切面思维编程实现

## 5.5 Spring AOP基于注解方式实现和细节

### 5.5.1 Spring AOP底层技术组成

![image-20240322195838947](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240322195838947.png)

**动态代理(InvocationHandler):J**DK原生的实现方式,需要被代理的目标类必须实现接口,因为这个技术要求代理对象和目标对象实现同样的接口(拜把子模式)

**cglib:**通过继承被代理的目标类,实现代理,不需要目标类的实现类

**AspectU:**早期的AOP实现的框架,SpringAOP借用了AspectJ中的AOP注解

无非是借用AspectU提供的注解,但是由动态代理和cglib实现,这个是历史问题,因为程序员已经习惯使用AspectJ的注解来开发了,所以SpringAOP直接用了AspectJ的注解



### 5.5.2 初步实现

1.加入依赖

```xml
<dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>6.1.4</version>
</dependency>
<dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aspects</artifactId>
            <version>6.0.6</version>

</dependency>
```

2.准备接口

3.

### 5.5.3 获取通知细节信息'

### 5.5.4 切点表达式语法

### 5.5.5 重用(提取)切点表达式

### 5.5.6 环绕通知

### 5.5.7 切面优先级设置

### 5.5.8 CGLib动态代理生效

### 5.5.9 注解实现小结

## 5.6 Spring AOP基于XML方式实现和准备工作

## 5.7 SpringAOP对获取Bean的影响理解



# 六:Spring声名式事务

# 七:Spring核心掌握总结