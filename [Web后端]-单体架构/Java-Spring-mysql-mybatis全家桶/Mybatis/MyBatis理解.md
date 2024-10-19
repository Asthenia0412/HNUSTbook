[toc]







# 零：

## 1.为什么要用Mybatis

在纯粹的JDBC开发中，存在大量冗余的模板代码，这些代码应该被抽象出来，而不是每写一次查询都重复一次：连接池的创建/连接的获取/mysql的登录

而Mybatis就是实现了这种抽取。我们只用专心于写实现功能的sql语句，并且在xml文件中呈现即可。仅仅需要再mybatis-config中配置一次要连接的数据库，以及账号与密码



# 一：Mybatis的结构

## 1.pom中maven坐标：

```xml
        <!--MyBatis的依赖-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>

        <!--MySql的依赖导入-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.46</version>
        </dependency>
```

## 2.整体pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.xiaoyongcai</groupId>
    <artifactId>MyBatisTEST</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>22</maven.compiler.source>
        <maven.compiler.target>22</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <dependencies>
        <!--MyBatis的依赖-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>

        <!--MySql的依赖导入-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.46</version>
        </dependency>
        <!--Junit单元测试-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13</version>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.20</version>
        </dependency>

        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.2.3</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-core</artifactId>
            <version>1.2.3</version>
        </dependency>

    </dependencies>








</project>
```

## 3.项目结构

```
|-main
|--java
	|--com.xiaoyongcai
		|---mapper
			|---UserMapper(Interface)
		|---pojo
			|---User(class)
		|--MyBatisDemo(测试类)
|--resources
	|--com.xiaoyongcai
		|---mapper
			|---UserMapper.xml
	|--logback.xml(日志输出配置文件)
	|--mybatis-config.xml
```

- 要保证UserMapper代理接口要与UserMapper.xml位置一致，比方说：都位于 com/xiaoyongcai/mapper中
  - 在target文件（编译后结果）：resources内容和java中文件会合并，从而实现UserMapper.xml与UserMapper.class位于同一级目录下

## 4.mybatis-config.xml分析

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <!--数据库连接信息-->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://192.168.11.128:3306/Mysql?useSSL=false"/>
                <property name="username" value="root"/>
                <property name="password" value="xiaoyongcai"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <!--加载Sql的映射文件-->
            <mapper resource="com/xiaoyongcai/mapper/UserMapper.xml"/>

    </mappers>
</configuration>
```

- `<configuration>`MyBatis配置文件的根元素，所有配置元素都包含在其中
- `<environments default="development">` 配置Mybatis环境,可以配置多个环境,此处定义名为development的环境,id用于标识这个环境
- `<transactionManager type="JDBC"/>` 配置事务管理器，且是JDBC类型的事务管理器
- `<dataSource type="POOLED">`使用带有连接池的数据源
- `<property name="" value="">`用于配置数据库具体内容
  - <property name="driver" value="com.mysql.jdbc.Driver"/>：配置数据库驱动类名
  - <property name="url" value="jdbc:mysql://192.168.11.128:3306/Mysql?useSSL=false"/>：指明链接何处的mysql.这里我们没有在本机部署mysql,而是在vmware中部署mysql.因此ip地址为192.168.11.128这个局域网地址，而非是127.0.0.1这个本机地址。而3306是虚拟机开放给外部的mysql端口。不同目的去访问虚拟机，获取的端口是不一样的，譬如：想要使用ssh连接虚拟机，就得开22端口
- `<mappers> <mapper>`用于加载本地的Sql映射文件,这里注意是resource=""

## 5.单个Sql映射文件分析

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!--
namespace:名称空间
select中的id:是这条sql的唯一标识
-->
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaoyongcai.mapper.UserMapper">
    <select id="selectAll" resultType="com.xiaoyongcai.pojo.User">
        select * from tb_user;
    </select>
</mapper>
```

- 命名空间：惯例为该映射的相对路径
- id:在代理接口里的方法名
- resultType:一定是某个实现类的全限定名

## 6.代理接口分析

```java
package com.xiaoyongcai.mapper;

import com.xiaoyongcai.pojo.User;

import java.util.List;

public interface UserMapper {
    List<User> selectAll(); //注意：返回的结果集一定要和xml文件中匹配
}

```

- 使用代理接口的目的：避免xml文件在test类中硬编码

## 7.代理接口使用对Mybatis使用体验的优化

### A.不使用代理接口

```java
public class MyBatisDemo {
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql
        List<User> users =sqlSession.selectList("test.selectAll");//传入的是命名空间+唯一标识id
        for(User user:users){
            System.out.println(user+"\n");
        }
        //4.释放资源
        sqlSession.close();
    }
}

```

### B.使用代理接口

```java
public class MyBatisDemo2 {
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql
        //List<User> users =sqlSession.selectList("test.selectAll");//传入的是命名空间+唯一标识id
        //3.1获取UserMapper接口的代理对象
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        List<User> users = userMapper.selectAll();
        for(User user:users){
            System.out.println(user+"\n");
        }
        //4.释放资源
        sqlSession.close();
    }
}

```

- ​      `  List<User> users =sqlSession.selectList("test.selectAll");`
  - //传入的是命名空间+.唯一标识id
- ​        `UserMapper userMapper = sqlSession.getMapper(UserMapper.class);`
  - 后者减少了SqlSession的参与量，让方法执行主体转化为UserMapper

二：MyBatisX插件

- 基于IDEA

- 功能

  - XML和接口方法相互跳转

  - 根据接口方法生成statement

    - statement就是在Mapper.xml中被<mapper>包裹的sql语句

      - ```xml
        <mapper namespace="com.xiaoyongcai.mapper.UserMapper">
            <select id="selectAll" resultType="user">
            select *
                from tb_user;
            </select>
        </mapper>
        ```

        这里的<select id="selectAll" resultType="user">

         select * from tb_user<resultType>就是我们的statement



# 二:Mybatis使用的常见问题：

## 1.数据没有正确被封装

- 在Java开发中，实体类名通常使用驼峰命名法，而Mysql中常用_分隔

  | Mysql的字段名    | Spring项目中的实体类字段名 |
  | :--------------- | -------------------------- |
  | id               | id                         |
  | **brand_name**   | **brandName**              |
  | **company_name** | **companyName**            |
  | ordered          | ordered                    |
  | description      | description                |
  | status           | status                     |

很明显，除了brand_name和company_name,其他字段都能被查询且被正确封装。

**——实体类中字段与mysql中字段不一致**

如何解决问题？

### A.在sql语句里使用as别名:

```xml
<mapper namespace="com.xiaoyongcai.mapper.BrandMapper">
    <select id="selectAll" resultType="com.xiaoyongcai.pojo.Brand">
        select id,brand_name as brandName,company_name as companyName,ordered,description,status
        from tb_brand;
    </select>
</mapper>
```

这里在名字后面使用as属性即可,对不同的类名起别名，让其与实体类的字段名一致

> 问题：每次查询都要写，不方便，太繁琐
>
> 策略：使用sql片段简化

#### A-优化:使用Sql片段来提高复用性

```xml
<mapper namespace="com.xiaoyongcai.mapper.BrandMapper">
    <!--数据库表的字段名称与实体类的属性名称不一样，则无法自动封装数据
    *起别名:

    -->
    <sql id="brand_column">
        id,brand_name as brandName,company_name as companyName,ordered,description,status
    </sql>
    <select id="selectAll" resultType="com.xiaoyongcai.pojo.Brand">
        select <include refid="brand_column"/>
        from tb_brand;

    </select>
</mapper>
```

> 使用<sql id="xxx"> </sql>实现sql片段
>
> 而select部分：在需要引用位置:<include refid="xxx"/>即可

> 缺点：不灵活，我如果想修改brand_column中的元素，把id改成qqId,那就得重新写一个sql片段。
>
> 策略：ResultMap灵活解决起缺点

### B.ResultMap(最常用做法)

```xml
<mapper namespace="com.xiaoyongcai.mapper.BrandMapper">
    <!--
1.标签<resultMap>的属性id="xxx" 这个xxx要关联到<select>的resultMap属性
2.<resultMap>中有若干<result> 且result实现映射 column对应mysql的字段 property对应Spring项目实体类的字段
3.什么是映射？将mysql中字段与spring项目实体类字段建立关联，就是映射
4.注意：一旦使用ResultMap,一定要注意select的属性resultMap,不可以用之前的resultType="实体类的全限定名"了
5.该方法是最常用的

    -->

    <resultMap id="brandResultMap" type="com.xiaoyongcai.pojo.Brand">
        <result column="brand_name" property="brandName"></result>
        <result column="company_name" property="companyName"></result>
    </resultMap>
    <select id="selectAll" resultMap="brandResultMap">
        select *
        from tb_brand;

    </select>
</mapper>
```

## 2.带参查询

```java
Brand selectById(int id);
```



```xml
<select id="selectById" parameterType="int" resultMap="brandResultMap">
select *
    from tb_brand id=#{id};
</select>
```

### A.参数占位符：

#### 1.#{}:会替换为?  `有利于防止SQL注入问题`

#### 2.${} 拼sql `存在SQL注入问题`

#### 3.使用时机：

- 99%情况下,参数传递：#{}
- 1%情况,表名或列名不固定:${}:实现字符串的拼接

### B.参数类型惯用省略

parameterType="int" 这个常常省略

### C.特殊字符处理：

`select * from tb_brand where id <#{id}`这里的<符号 就是特殊字符

#### 1.转义字符:

比如小于符号用`&lt;`替代

#### 2.CDATA区：

区域内正常写小于号即可

​			`<![CDATA[ < ]]>`

```xml
<select id="selectById" parameterType="int" resultMap="brandResultMap">
select *
    from ${tb_brand} id=#{id};
</select>
```

​		

## 3.条件查询

### A.多条件查询

- 多条件查询的问题：
  - 我有三个参数 id name age. 但是在测试类里仅仅用id来查,到xml中,sql语句里仅仅只有id,而没有name和age的数据，这样的查询是失败的,因为缺少了name和age两个参数,这样的查询很死板，一点都不灵活。
  - 所以我们要引入下面的动态查询

- 参数接收

  - 散装参数：方法中有多个参数，需要用@Param("SQL参数占位符名称 ")

  - 对象参数:SQL参数名与实体类属性名对上，即可设置成功

  - map集合函数:SQL参数名与map集合的键对上，即可设置成功

    - 这里设置的键,是Java实体类中的字段.而SQL参数名与键对上,应该是XML文件里配置ResultMap实现的

    **代码均为节选**

#### A.1散装参数

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!--

namespace:名称空间
select中的id:是这条sql的唯一标识
常见问题：
1.:
在Bean -User中 有String brandName 使用驼峰命名法 但是无法查询到mysql中的字段
发现原因:因为mysql中写的字段是 brand_name 数据类中的名称和mysql字段名称不一致，无法实现自动封装

-->
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaoyongcai.mapper.BrandMapper">
    <!--条件查询-->
    <select id="selectByCondition" resultMap="brandResultMap">
        select *
        from tb_brand
        where
            status= #{status}
        and company_name like #{companyName}
        and brand_name like #{brandName}
    </select>
</mapper>
```

```java
package com.xiaoyongcai.mapper;

import com.xiaoyongcai.pojo.Brand;
import com.xiaoyongcai.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface BrandMapper {
    List<Brand> selectByCondition(@Param("status")int status,
                                  @Param("companyName")String companyName,@Param("brandName")String brandName);
/*
*   List<Brand> selectByCondition(Brand brand);
    List<Brand> selectByCondition(Map map);
    散装参数格式
* */
}

```

```java
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="华为";
      String brandName="华为";
      //处理实现模糊匹配 -我们在sql的xml中写的是 like 是模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);
        //通过代理接口对象实现多条件查询
        brandMapper.selectByCondition(status, companyName, brandName);
        //4.释放资源
        sqlSession.close();
    }
```

#### A.2传入对象(仅修改代理接口与测试用例)

```java
public interface BrandMapper {
   List<Brand> selectByCondition(Brand brand);
}

```

```java
 public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="华为";
      String brandName="华为";
      //处理实现模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);
        
        //创建对象,参数的封装
        Brand brand = new Brand();
        brand.setStatus(status);
        brand.setCompanyName(companyName);
        brand.setBrandName(brandName);
        
        //通过代理接口对象实现多条件查询
        brandMapper.selectByCondition(brand);
        //4.释放资源
        sqlSession.close();
    }
```

#### A.3传入map集合(仅修改代理接口与测试用例)

```java
public interface BrandMapper {
   List<Brand> selectByCondition(Map map);
}
```

```java
public class MyBatisDemo {
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="华为";
      String brandName="华为";
      //处理实现模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);
        //设置map集合
        Map map = new HashMap();
        map.put("status",status);
        map.put("companyName",companyName);
        map.put("brandName",brandName);

        //通过代理接口对象实现多条件查询
        brandMapper.selectByCondition(map);
        //4.释放资源
        sqlSession.close();
    }
}

```

### B.多条件动态条件查询

#### B.1静态Sql与动态Sql区别

```xml
<select id="selectByCondition" resultMap="brandResultMap">
	select *
    from brand
    where
    	status = #{status}
    	and company_name like #{companyName}
    	and brand_name like #{brandName}
</select>
```

上图是经典的静态Sql,所有语句内容均是固定的。

动态Sql相较其：SQL语句会随着用户输入和外部条件变化而变化,这种动态Sql是Mybatis提供的支持

- if
- choose(when otherwise)
- trim(where set)
- foreach

#### B.2动态Sql实战

将上述静态Sql改造为动态Sql

```xml
    <select id="selectByCondition" resultMap="brandResultMap">
        select *
        from tb_brand
        where
        <if test="status!=null">
            status= #{status}
        </if>
        <if test="companyName!=null and companyName!='' ">
            and company_name like #{companyName}
        </if>
        <if test="brandName!=null and brandName!='' ">
            and brand_name like #{brandName}
        </if>
    </select>

```

- 问题：如果status为null 容易产生： select * from tb_brand **where and** company_name like #{companyName}
  - where和and相连——sql语法错误
- 解决策略：
  - (恒等式策略)在where后添加1=1 形成select * from tb_brand **where** 1=1 **and** company_name like #{companyName}规避where和and直接相连导致的语法错误
  - (where标签)用where标签来替代where关键字,将if都包裹在where中

```xml
<select id="selectByCondition" resultMap="brandResultMap">
select *
    from tb_brand
    <where>
    <if test="status!=null">
        and status like #{status}
    </if>
    <if test="companyName!=null and companyName != ' '">
        and brand_name like #{brandName}
    </if>
    </where>

</select>
```

### C.单条件动态条件查询

- 从多个条件中选择一个
  - choose(when/otherwise):类似java中的switch语句
- 注意：没有and了.因为你托管了代码给Mybatis框架 其帮助你完成工作

```xml
<select id="selectByConditionSingle" resultMap="brandResultMap">
select *
    from tb_brand
    where
    <choose><!--类似于switch-->
    <when test="status!=null">
        company_name like #{companyName}<!--类似于case-->
    </when>
    <when test="brandName!=null and brandName!="" ">
    brand_name like #{brandName}
    </when>
    <otherwise> <!--类似于default-->
    1=1;
    </otherwise>
    </choose>
</select>
<!--
在JavaSE中 我们用switch...case default表示
在Mybatis的动态Sql中 我们用<choose> <when> <otherwise>
-->
```

## 4.添加/修改

### A.添加-void返回

1. 编写接口方法：Mapper接口

   ```java
   void add(Brand brand);
   ```

   1. 参数：除了id之外所有的数据
   2. 结果：void

2. 编写Sql文件：Sql映射文件

   ```xml
   <insert id="add">
   insert into tb_brand (brand_name,company_name,ordered,description,status)
       values(#{brandName},#{companyName},#{ordered},#{description},3{status})
   </insert>
   ```

3. 执行方法：测试

- Mybatis事务：
  - openSession():默认开启，进行增删改查操作后，需要用sqlSession.commit();手动提交事务
  - openSession(true):可以设置为自动提交事务(关闭事务)

#### A.1:实战测试

```java
public interface BrandMapper {
   void add(Brand brand);
}
```

```java
public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="测试手机";
      String brandName="测试手机";
      String description = "手机中的战斗机";
      int ordered = 100;
      //处理实现模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);

        //创建对象,且让属性成为对象属性
        Brand brand = new Brand();
        brand.setStatus(status);
        brand.setCompanyName(companyName);
        brand.setBrandName(brandName);
        brand.setDescription(description);
        brand.setOrdered(ordered);
        //通过代理接口对象实现多条件查询
        brandMapper.add(brand);
    
    // 此处提交事务 否则会出现A.2的问题//
        // 4.释放资源
        sqlSession.close();
    }
```

```xml
    <insert id="add">
        insert into tb_brand (brand_name,company_name,ordered,description,status)
        values(#{brandName},#{companyName},#{ordered},#{description},3{status})
    </insert>

```

#### A.2:实战问题

上述代码可以执行，但是因为没有提交事务，因此回滚，无法造成影响

补充代码：

```java
sqlSession.commit(); 
```

如何一劳永逸解决该问题呢？

回顾到

```java
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession(true);//让空格为true，自动提交事务
```

### B.添加-主键返回

- 在数据添加成功后，需要获取插入数据库主键的值
  - 添加订单和订单项

1. 添加订单
2. 添加订单项,订单项中需要设置所属订单的id

```xml
<insert id="addOrder" useGenerateKeys="true" keyProperty="id">
insert into tb_order(payment,payment_type,status)
    values(#{payment},#{paymentType},#{status})
</insert>
```

```xml
<insert id="addOrderItem">
    insert into tb_order_item (goods_name,goods_price,count,order_id)
    values(#{goodsName},#{goodsPrice},#{count},#{orderId})
</insert>
```

### C.update

#### C.1修改固定字段

```java

public class MyBatisDemo {
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="测试手机";
      String brandName="测试手机";
      String description = "手机中的战斗机";
      int ordered = 100;
      int id = 100;
      //处理实现模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);

        //创建对象,且让属性成为对象属性
        Brand brand = new Brand();
        brand.setStatus(status);
        brand.setCompanyName(companyName);
        brand.setBrandName(brandName);
        brand.setDescription(description);
        brand.setOrdered(ordered);
        brand.setId(id);
        //通过代理接口对象实现多条件查询
        brandMapper.update(brand);
        // 4.释放资源
        sqlSession.close();
    }
}

```

```java
public interface BrandMapper {

    void update(Brand brand);
}

```

```xml
    <update id="update">
        update tb_brand
        set brand_name = #{brandName};
        set companyName = #{companyName};
        set ordered = #{ordered};
        set description = #{description};
        set status = #{status};
        where id=#{id};
    </update>
```

#### C.2修改动态字段：仅修改xml

- 引入了<set>

```xml
<update id="update">
    update tb_brand
    <set>
        <if test="brandName != null and brandName != ''">brand_name = #{brandName},</if>
        <if test="companyName != null and companyName != ''">companyName = #{companyName},</if>
        <if test="ordered != null">ordered = #{ordered},</if>
        <if test="description != null and description != ''">description = #{description},</if>
        <if test="status != null">status = #{status}</if>
    </set>
    where id=#{id}
</update>

```

## 5.删除

#### A.单个删除

- 编写接口方法：Mapper接口
- 参数:id
- 结果：void
- 编写Sql语句：Sql映射文件
- 执行方法：测试

```java
void deleteById(int id);
```

```xml
<delete id="deleteById">
    delete from tb_brand where id=#{id};
</delete>
```

```java
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession(true);//此时为true 事务默认关闭 不需要手动提交事务
        //3.执行sql

        //接受参数
        int status = 1;
      String companyName="测试手机";
      String brandName="测试手机";
      String description = "手机中的战斗机";
      int ordered = 100;
      int id = 100;
      //处理实现模糊匹配
        companyName = "%"+companyName+"%";
        brandName = "%"+brandName+"%";
        //实例化代理接口
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);

        //创建对象,且让属性成为对象属性
        Brand brand = new Brand();
        brand.setStatus(status);
        brand.setCompanyName(companyName);
        brand.setBrandName(brandName);
        brand.setDescription(description);
        brand.setOrdered(ordered);
        brand.setId(id);
        
        
        //通过代理接口单个数据删除
        brandMapper.deleteById(id);
        
        // 4.释放资源
        sqlSession.close();
    }
```



#### B.批量删除

- 编写接口方法：Mapper接口 

  ```java
  void deleteById(@Param("ids")int[] ids);
  ```

  - 参数:id数组
  - 结果：void

- 编写SQL语句

  - ```xml
    <delete id="deleteByIds">
    	delete from tb_brand
        where id in (?,?,?);
    </delete>
    ```

  - 上述无法静态表达，使用动态Sql

    ```xml
        <delete id="deleteByIds">
            delete from tb_brand
            where id in
            <foreach collection="ids" item="id" separator="," open="(" close=")">
            #{id};
            </foreach>
        </delete>
    ```

  - Mybatis默认会将数组参数，封装为一个Map集合

    - 默认：array是数组（但是在接口用@Param 可以改变 例如我们用ids不用array）
    - @Param在接口修饰参数，可以改变默认的array这个map中的key的名称,譬如@Param("ids")int[] ids 在接口中修饰

  - 实现测试类

    - ```java
      public class MyBatisDemo {
          public static void main(String[] args) throws IOException {
              //1.加载mybatis核心配置文件 获取SqlSessionFactory
              String resource = "mybatis-config.xml";
              InputStream inputStream = Resources.getResourceAsStream(resource);
              SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
              //2.获取SqlSession对象
              SqlSession sqlSession = sqlSessionFactory.openSession();
              //3.执行sql
      
              //接受参数
              int status = 1;
            String companyName="测试手机";
            String brandName="测试手机";
            String description = "手机中的战斗机";
            int ordered = 100;
            int id = 100;
            //处理实现模糊匹配
              companyName = "%"+companyName+"%";
              brandName = "%"+brandName+"%";
              //实例化代理接口
              BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);
              int[] ids = {1,2,3,4,5,6,7,8,9};
              brandMapper.deleteByIds(ids);
              // 4.释放资源
              sqlSession.close();
          }
      ```

      

## 6.参数传递详解

Mybatis接口方法中可以接收各种各样的参数，其底层对参数采取了不同的封装处理方式

- 单个参数
  - POJO类型:直接使用，**属性名**与**参数占位符**名称一致
  - Map集合：直接使用，**键名**与**参数占位符**名一致
  - Collection：封装为**map**集合
    - map.put("arg0",collection集合);
    - map.put("collection",collection集合)
  - List：封装为**map**集合
    - map.put("arg0",list集合);
    - map.put("collection",list集合)
    - map.put("list",list集合)
  - Array：封装为**map**集合
    - map.put("arg0",数组);
    - map.put("array",数组)
  - 其他类型
- 多个参数：
  - 将参数封装到**Map**集合
    - map.put("arg0",参数值1)
    - map.put("param1",参数值1)
    - map.put("arg1",参数值2)
    - map.put("param2",参数值2)
  - 其中arg0等key 都是默认值 以下面的例子：username是参数值1,因为有@Param("username") 所以username等价于arg0与param1

```java
User select(@Param("username")String username,@Param("password")String password);
```

```xml
<select id="select" resultType="user">
select * from tb_user
    where
    username=#{username}
    and password = #{password}l
</select>
```

Mybatis提供了ParamNameResolver类来进行参数封装	

## 7.注解简化开发

> 现在不需要写XML语句了,直接在代理接口上使用注解

| 注解     | 说明                           |
| -------- | ------------------------------ |
| @Insert  | 新增                           |
| @Update  | 实现更新                       |
| @Delete  | 实现删除                       |
| @Select  | 实现查询                       |
| @Result  | 实现结果集封装                 |
| @Results | 与@Result一起用 封装多个结果集 |
| @One     | 实现一对一结果集封装           |
| @Many    | 实现一对多结果集封装           |

### 7.1简单映射实例

> `@Before` 注解： `@Before` 是 JUnit 框架中的一个注解，用于标记一个方法，该方法将在当前测试类中的每个 `@Test` 注解方法执行之前执行。在给出的代码示例中，`@Before` 注解的方法 `before()` 的作用是在测试开始之前执行一些初始化操作。



> 在给出的代码示例中，`@Options` 注解用于 `add` 方法，其属性如下：
>
> - `useGeneratedKeys=true`：表示 MyBatis 应该使用 JDBC 的 `getGeneratedKeys` 方法来获取由数据库自动生成的键（比如自增主键的值）。
> - `keyProperty="id"`：指定自动生成的键应该被设置到 `UserTestDate` 类的 `id` 属性上。
> - `keyColumn="id"`：指定数据库中自动生成的键对应的列名。



接口及接口方法：

```java
package com.xiaoyongcai.mapper;

import com.xiaoyongcai.pojo.Brand;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface BrandMapper {
    @Select("select * from tb_brand")
    @Results(
            id = "BrandResultMap",
            value = {
                    @Result(column = "id", property = "id"),
                    @Result(column = "description", property = "description"),
                    @Result(column = "BrandName", property = "BrandName"),
                    @Result(column = "CompanyName", property = "CompanyName"),
                    @Result(column = "Rank", property = "Rank"),
                    @Result(column = "ordered", property = "ordered")
            }
    )
    List<Brand> selectAll();
}

```

测试方法:

```java
import com.xiaoyongcai.mapper.BrandMapper;
import com.xiaoyongcai.pojo.Brand;
import com.xiaoyongcai.pojo.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MyBatisDemo {
    public static void main(String[] args) throws IOException {
        //1.加载mybatis核心配置文件 获取SqlSessionFactory
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        //2.获取SqlSession对象
        SqlSession sqlSession = sqlSessionFactory.openSession();
        BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);
        for(Brand temp:brandMapper.selectAll()){
            System.out.println(temp.getBrandName()+temp.getCompanyName()+temp.getDescription()+temp.getOrdered()+temp.getId());
        }
        // 4.释放资源
        sqlSession.close();
    }
}

```

核心配置文件加载映射:

```xml
    <mappers>
        <!--加载Sql的映射文件-->
        <mapper class="com.xiaoyongcai.mapper.BrandMapper"></mapper>
    </mappers>
```

### 7.2复杂映射开发(原先的xml resultMap)

| 注解     | 说明                                                         |
| :------- | ------------------------------------------------------------ |
| @Results | 格式：@Results{{@Result()},{@Result()}}                      |
| @Result  | 替代了<id>标签和<result>标签：                               |
| @One     | 替代<assocation>标签，指定子查询返回的单一对象。多表查询关键：@Result(column="",property="",one=@One(select="")) |
| @Many    | 替代<collection>标签,多表查询关键，指定子查询返回的对象集合：@Result(property="",column="",many=@Many(select="")) |

> 这里的column是mysql中的字段 property是java中的占位符名

```java
public interface IAccountDao {

    /**
     * 查询所有账户，并且获取每个账户下的用户信息,一对一
     * @return
     */
    @Select("select * from account")
    @Results(id="accountMap",value = {
            @Result(id = true,column = "id",property = "id"),
            @Result(column = "uid",property = "uid"),
            @Result(column = "money",property = "money"),
            @Result(property = "user",column = "uid",one=@One(select="com.keafmd.dao.IUserDao.findById",fetchType= FetchType.EAGER))
    })
    List<Account> findAll();
}

```

### 7.3单表查询与多表查询

MyBatis的@One和@Many注解用于处理一对一和一对多的关联查询。这两个注解通常与@ResultMap一起使用，用于定义复杂的映射关系。下面我将分别解释这两个注解以及它们在单表查询和多表查询中的应用。
#### A.@One（一对一关联）
@One用于实现一对一的关联查询。当你需要在查询一个实体时，同时获取与之关联的另一个实体，可以使用@One注解。

##### 示例（单表查询）

假设我们有两个表：User（用户表）和Account（账户表），它们之间是一对一的关系。
```java
public class User {
    private Integer id;
    private String name;
    private Account account; // 用户关联的账户
}
public class Account {
    private Integer id;
    private String accountNumber;
}
```
在UserMapper接口中，我们可以这样定义查询：
```java
@Select("SELECT * FROM user WHERE id = #{id}")
@Results({
    @Result(property = "id", column = "id"),
    @Result(property = "name", column = "name"),
    @Result(property = "account", column = "id",
            one = @One(select = "selectAccountById"))
})
User selectUserWithAccountById(Integer id);
@Select("SELECT * FROM account WHERE user_id = #{id}")
Account selectAccountById(Integer id);
```
这里，`selectUserWithAccountById`方法会先查询User表，然后根据User表的id，调用`selectAccountById`方法查询Account表。
#### B.@Many（一对多关联）
@Many用于实现一对多的关联查询。当你需要在查询一个实体时，同时获取与之关联的多个实体，可以使用@Many注解。
##### 示例（多表查询）
假设我们有两个表：User（用户表）和Order（订单表），它们之间是一对多的关系。
```java
public class User {
    private Integer id;
    private String name;
    private List<Order> orders; // 用户关联的订单列表
}
public class Order {
    private Integer id;
    private String orderNumber;
}
```
在UserMapper接口中，我们可以这样定义查询：
```java
@Select("SELECT * FROM user WHERE id = #{id}")
@Results({
    @Result(property = "id", column = "id"),
    @Result(property = "name", column = "name"),
    @Result(property = "orders", column = "id",
            many = @Many(select = "selectOrdersByUserId"))
})
User selectUserWithOrdersById(Integer id);
@Select("SELECT * FROM order WHERE user_id = #{userId}")
List<Order> selectOrdersByUserId(Integer userId);
```
这里，`selectUserWithOrdersById`方法会先查询User表，然后根据User表的id，调用`selectOrdersByUserId`方法查询Order表。
### C.总结
- @One用于一对一关联查询，通常用于主表查询从表。
- @Many用于一对多关联查询，通常用于主表查询多个从表。
- 在实际应用中，单表查询通常不需要使用@One和@Many，因为单表查询不会涉及到关联关系。这两个注解主要用于处理多表关联查询。
- **主查询**：首先执行主查询，即查询主表（例如User表）。
- **收集主键**：在主查询的结果集中，MyBatis会收集主表记录的主键（或相关联的列）。
- **执行关联查询**：对于主查询结果集中的每一条记录，MyBatis会使用收集到的主键作为参数，调用`@One`注解中指定的方法（例如`selectAccountById`），进行关联查询。
- **结果映射**：将关联查询的结果（通常是单条记录）映射到主查询结果对象的相应属性上（例如User类的`account`属性）。

# 三.Mybatis-Plus
