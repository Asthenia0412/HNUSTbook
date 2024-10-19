## 一.MySql底层原理

## 二.MySql特性

## 三.Mybatis底层原理

## 四.Mybatis用法特性

## 五.Mybatis-Plus用法特性

## 六.数据库的引申场景问题

### 1.分库分表

#### A.原因

作为一个数据库，作为数据库中的一张表，伴随用户的累积，数据会大到难以处理的地步。一张表的数据抄过千万，查询和修改，对于其操作都会很耗时，此时需要进行数据库切分操作

#### B.步骤

1. 模拟用户表数据>=千万

2. 原表名：user_tab，切分为user_tab_0与user_tab_1。于是就拆分成两个百万用户量的表了

3. 对表的操作：`userId%2==0`表示操作user_tab_0 ，同理：`userId%2==1`表示操作user_tab_1

4. 在Mybatis的Sql实现

   ```xml
   <select id="getUser" parameterType="java.util.Map" resultType="UserDO">
   	SELECT userId,name
       From user_tab_#{tabIndex}
       Where userId=#{userId}
   </select>
   <!--
   tabIndex和userId,tabIndex是操作表的标示值,如果操作UserId位为5。则是
   SELECT userId,name
   From user_tab_1
   Where userId=5
   -->
   ```

#### C.分离的方式