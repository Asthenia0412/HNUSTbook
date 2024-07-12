# 1.关系型数据库和非关系型数据库

A.关系型数据库(RDBMS):复杂查询和事务支持

B.非关系型数据库(DBMS):是关系型数据库功能的阉割版本,基于**键值对**来储存数据,不需要经过SQL层的解析,性能**非常高**,同时削减了不常用的功能,进一步提高性能

# 2.非关系型数据库的分类

**键值型数据库:**通过key-value来储存数据,比如redis.键值数据库通过Key-Value来储存数据,其中Key和Value可以是简单的对象,也可以是复杂的对象.key作为唯一的标识符,优点在于查找速度很快,这方面明显优于关系型数据库,缺点是无法像关系型数据库一样使用条件过滤,比如where,如果不知道从哪里找数据,就要遍历所有的键,这样会消耗大量的计算能力

**文档型数据库**:可以存放XML,JSON格式的文档.在数据库中,文档作为处理信息的基本单位,一个文档就相当于一条记录.文档数据库所存放的文档,就相当于键值数据库存放的值.比如MongoDB就是最流行的文档型数据库,此外还有CouchDB

**搜索引擎数据库**:核心原理:倒排索引 例如Solr,Elasticsearch,Splunk

**列式数据库**:相对于行式数据库:Oracle,Mysql,SQL server,列式数据库是将数据,可以降低IO,就比方说,你有20个字段在一行,但是你只想查两个字段,那么你用行式数据库就不得不查询许多冗余的字段,增大IO查询的消耗

# 3.ER模型与表记录的四种关系

关系型数据库的典型数据结构是 **数据表**,这些数据表都是结构化的(Structured).

将数据放到表中,然后把表放到库中

一个数据库可以有多个表,每一个表都有一个名字,用来标识自己,表名具有唯一性

表具有一些特性,这些特性定义了数据在表中如何储存,类似Java和Python中"类"的设计

## 3.1表,记录,字段

E-R(Entry-Relationship,实体-联系)模型中有三个概念:**实体集 属性 联系集**

一个**实体集**(class)对应数据库中的一个表(table),一个**实体**(instance)则对应于数据库表中的**一行**(row),也称为**一条记录**(record).**一个属性**(Attribute)对应数据库表中的**一列**(column),也称为一个**字段**(field)

**ORM思想(Object Relational Mapping)**

## 3.2表的关联关系

表与表之前的数据记录是有关系的,我们介绍四种关系模型

### A.一对一关联(one to one):

例子:设计 **学生表**:学号,姓名,手机号码,班级...

拆分为两个表: 两个表记录是一一对应关系:

​	**基础信息表**:学号,姓名,手机号码

​	**档案信息表**:学号,身份证号码,家庭住址,籍贯,紧急联系人

**两种建表原则**:

​	1.外键唯一:主表的主键和外表的外键都是唯一的,行从主外键关系,外键唯一

​	2.外键是主键,主表的主键和从表的主键,形成主外键关系

### B.一对多关联(one to many)

客户表和订单表

分类表和商品表

部门表和员工表

### C.多对多关联(many to many)

学生信息表:

课程信息表:

选课信息表:一个学生可以选多门课,一门课可以被多个学生选

### D.自我引用(self reference)

比方说每个员工都有一个编号

其中101是主管,其中有一个字段是描述该员工隶属的主管的编号,也就是在谁手下干活

那么这里就要用到自我引用,将主管的编号添加到其他row的隶属column一栏中

# 4.SQL语句分类

DDL:**数据定义语言**:CREATE/ALERT/DROP/RENAME/TRUNCATE

DML:**数据操作语言**: INSERT/DELETE/UPDATE/SELECT **增删改查** 使用频率很高

DCL:**数据控制语言** COMMIT(提交数据库)/ROLLBACK(回滚数据)/SAVEPOINT(保存点)/GRANT(赋予权限)/REVOKE(回收权限)

```sql
USE dbtest2;//使用dbtest2这个库
SELECT * FROM emp;//选择dbtest2库中emp表中所有的内容
```



# 5.SQL基本规范

1.SQL可以写在一行,或者多行,提高可读性->就写多行+缩进

2.每条命令结束使用;或者\g或者是\G结束

3.关键字不能缩写,也不能分行

4.关于标点符号

​	A.所有的(),单引号,双引号是**成对**结束的

​	B.必须使用**英文**状态下的半角输入

​	C.字符串型和**日期时间**可以用单引号

​	D.**列的别名**,尽量用双引号,**而且不建议省略as**

5.MySQL在Windows环境下是大小写不敏感的

**6.MySQL在Linux环境下是大小写敏感的**

​	数据库名,表名,表别名,字段名,字段别名都是小写

​	SQL关键字,函数名,绑定变量都是大写的

# 6.基本的SELECT语句相关

select 字段1,字段2,字段3 from 表名

```sql
SELECT age,name,sex from dual
##age name sex都是字段名(field) employees是表名
##dual:伪表名,两个作用:A.维持结构严谨 select from B.用于取字段计算的结果
SELECT 1+1 FROM DUAL ##执行一个常量计算

```

## 6.1SELECT语句细节

```sql
SELECT employee_id,last_name,department_id
FROM employees
##查询返回的结果叫 结果集
##下面开始做列的别名

SELECT employee_id emp_id,last_name AS lname,department_id "dept_id"
FROM employees;

##这里as:是(ALias别名) 可以省略
##归纳三种给类写别名的方法:
#1.在字段后直接写别名 如employee_id emp_id
#2.在字段后AS 别名 如last_name AS lname
#3.在字段后用引号包裹别名 department_id "dept_id"
```

去除重复行的做法

```sql
##查询员工表中存在哪些部门id

#这里是没有去重的情况 结果集中重复的行会被保存
SELECT department_id
FROM employees; 

#这里是去重的情况 结果集中重复的行会被删除
SELECT DISTINCT department_id "员工ID"
FROM employees;

#现在补充一个多字段去重的写法 注意DISTINCT会同时给department_id和salary去去重
SELECT DISTINCT department_id "员工ID",salary AS 薪水
FROM employees

#空值参与运算 空值的定义:NULL
#空值:null
#null不等同于0

#空值参与运算 空值参与运算结果一定为空值
SELECT employee_id,salary "月工资",salary*(1+commisson_pct) *12 "年工资"
FROM
employees;

#如何修正null的值运算后为0呢
SELECT employee_id,salary "月工资",salary*(1+IFNULL(commission_pct,0))*12 "年工资"
FROM employyes;
#很明显,这里引入了IFNULL函数来判断,如果commission的值真的为null,那么这个运算结果就是0,这里也反证了null和0并非相等

#``着重号问题
SELECT * FROM `order`##关键是order是一个关键字 用着重号来避免其被识别为关键字

#查询常数
SELECT '常数测试',employee_id,last_name;
FROM employees;
#结果集中都会给每一个row附上一个常数内容
```

## 6.2显示表结构

```sql
DESCRIBE employees;#显示表中字段的详细信息
#Field TYPE(值的类型) NULL(是否可以取值为空) KEY(刻画约束) DEFAULT 等类型

```

# 7.基本的Where过滤数据

```sql
#筛选90号部门员工的信息
SELECT *
FROM employees
#过滤条件
where department_id = 90;

#练习:查询last_name为'King'的员工信息
SELECT *
FROM employees
WHERE last_name= 'King';#这里是小写的k,也可以查询,不是sql语言问题,而是mysql这个DataBase不够严谨导致的,如果换成Oracle的话,必须是要大小写匹配的

```

## 7.1课后练习题:

```sql
#查询员工
#1.查询员工12个月的工资总和,并且起别名为ANNUAL SALARY
SELECT employee_id,last_name,salary*12 "ANNUAL SALARY"
FROM employees;
#但是我希望把奖金放进来,又因为奖金可能是null导致无法参与运算,所以null要换成0
SELECT employee_id,last_name,salary*12*(1+IFNULL(commission,0)) "ANNUAL SALARY"
FROM employees;

#2.查询employees表中除去重复的job_id以后的数据
SELECT distinct job_id
FROM employees;

#查询工资大于12000的员工姓名和工作
SELECT last_name,salary
FROM employees
WHERE salary>12000

#查询员工工号为176的员工姓名和部门号
SELECT last_name,department_id
FROM employees
WHERE employee_id = 176;
#显示departments的结构,并且查询其中的全部数据
DESCRIBE departments;
SELECT * FROM departments;


```

# 8.算术运算符的使用

## 8.1.算术运算符

```sql
SELECT 100,100+0,100-0,100+50-30
FROM DUAL;

SELECT 100+'1' #在JAVA中是1001,但是sql会做自动转化
FROM DUAL
#在sql中+没有连接的作用,就单纯表示一个加法运算,此时,会将字符串转化为数值(隐式转换)

#加法运算
SELECT 100+'a'#算出来还是100 因为a是看作0处理
FROM DUAL;
SELECT 100+NULL
FROM DUAL ##这里返回就是NULL,因为NULL和任何数据联系,都会产生NULL

#除法运算:/div
SELECT 100 DIV 0
FROM DUAL;#如果出现了div(除法)0的时,直接给NULL

#取模运算:%mod:模数的符号与被模数的符号是相同的
#如何理解: -12%5 被模数是-12 模数是其运算结果 -2 则-2的值和-12是符号相同的
SELECT 12%3,-12%5,-12%-5
FROM DUAL;

#小练习:员工id为偶数的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE employee_id % 2 = 0;
```



## 8.2.比较运算符

比较运算符会对左右两个操作数进行比较,如果说比较结果为真,则返回1.如果比较结果为假,则返回0,其他情况返回NULL

```SQL
#1.= 等于运算符
SELECT C
FROM TABLE
WHERE A=B


#一些异常测试
SELECT 'a' = 'a','ab'='ab','a'='b'
FROM DUAL;
# 'a'='b'不是0 而是拿二者ascii码来比较 
#但是'a'='a'结果是0 0='a'的结果也是0

#2.安全等于运算符
#查询表中commission_pct为Null的数据有哪些
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct <=> null;
#<=>相对与=,不会因为存在NULL就返回NULL,而是可以兼容NULL的存在,把Null作为一个普通的变量来进行处理,因此是安全等于
#q1:如果我不希望用<=>来处理null 那么有什么别的替代品么?当然有!
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct is NULL;
#我们在这里用is NULL来替代 <=>null
```

**等号运算符规则**:

1.如果等号两边的值,字符串,表达式都为字符串,那么MySQL会按字符串进行比较,比较的是每一个字符串中字符的Ascii编码是不是相等

2.如果等号两边都是整数,那么MySQL按照整数来比较两个值大小

3.如果两边的值一个是整数,一个是字符串,那么MySQL会把字符串化为数字来比较

4.如果等号两边有一遍是NULL,那么比较结果就是NULL

5.SQL中的赋值使用     **:=**

```SQL
#1.最大值和最小值LEAST() GREATEST()
SELECt LEAST('g','b','t','m'),GREATEST('g','b','t','m')
FROM DUAL;
#最小的话返回的就是t,最大的返回的就是g


#业务场景:找出员工的姓和名较短的那一个
SELECT LEAST(LENGTH(fisrt_name),LENGTH(last_name));
FROM employees


#2.BETWEEN 条件1 AND 条件2(查询条件1和条件2范围内的数据,包含边界)
#条件1:下界,条件2:上界
#查询工资在6000,8000之间的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE salary >=6000 && salary <=8000;
#可以用下面的between and来覆盖#
SELECT employee_id,last_name,salary
FROM employees
WHERE salary BETWEEN 6000 AND 8000
#如果我希望是不在6000到8000呢#
SELECT employee_id,last_name,salary
FROM employees
WHERE salary NOT BETWEEN 6000 AND 8000;#用NOT BETWEEN 下界 AND 上界

#3.in的使用
#练习:查询部门为10,20,30部门的员工信息
SELECT last_name,salary,department_id
FROM employees
WHERE department_id = 10 OR department_id = 20 department_id = 30
#用in来修改
SELECT last_name,salary,department_id
FROM employees
WHERE department_id in (10,20,30);#not in 也就是不在部门当中

#4.模糊查询
#练习:查询Last_name中包含字符'a'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%'##这里的%是不确定个数的字符,0个 1个 或者多个
#练习:查询Last_name中包含字符'a'与包含字符'b'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%'
#练习:查询第二个字符是a的元素,在last_name中 _一个下划线代表一个不确定的字符
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';
#练习:查询第二个字符是_并且第三个字符是a的员工信息
	#这里用到了\让_转义
SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%'
	#这条where语句可以替换为 用escape函数 实现$对/的替换
	WHERE last_name LIKE '_$_a%' escape '$'
```

# 9.排序与分页

## 9.1.排序规则:

```sql
#1.排序操作 

#如果没有使用排序操作,默认情况查询返回的数据是按照添加数据的顺序显示的
#升序: asc ascend(升序)
#降序 desc descend(降序)

#按照salary从低到高来进行排序 如果没有注明是ASC还是DESC,那么默认是ASC
SELECT * 
FROM employees
ORDER BY salary ASC;
#按照salary从高到低来进行排序
SELECT *
FROM employees
ORDER BY salary DESC;

#可以用列的别名来进行排序:列的别名只能在ORDER BY中使用
SELECT employee_id,salary,salary*12 annual_sal
FROM employees
ORDER BY annual_sal ASC

SELECT employee_id,salary
FROM employees
WHERE department_id IN (50,60,70)
ORDER BY department_id DESC;

#2.二级排序 对department_id进行降序排列,对salary进行升序排列.也就是当都是80号部门的时候,会按薪资水平来进行排序
SELECT employee_id,salary,department_id
FROM employees
ORDER BY department_id DESC,salary ASC;
```

## 9.2分页的操作

分页注意:LIMIT一定是放在最后的

```sql
#分页
#需求1:每一页显示20条记录 此时显示第一页
SELECT employee_id,last_name
FROM employees
LIMIT 0,20; #偏移量是0,有20条

#需求2:每一页显示20条记录 此时要显示第二页
SELECT employee_id,last_name
FROM employees
LIMIT 20,20#偏移量是从20开始,也就是从20开始要提取数据库的20条数据

SELECT employee_id,last_name
FROM employees
LIMIt 40,20;

#WHERE...ORDER BY...LIMIt顺序
SELECT employee_id,last_name,salary
FROM employees
WHERE salary>6000
ORDER BY salary DESC
LIMIT 10;#这里其实就是省略 0,10 的偏移量0

#练习:表里有107条数据,我们只想显示第32条,33条数据怎么办
SELECT employee_id,last_name,salary
FROM employees
WHERE salary>6000
ORDER BY salary DESC

LIMIT 31,2;#也就是偏移量从31开始,并且获取其后一个 等价于LIMIT 2 OFFSET 31

```

# 10.使用多表查询的缘由

```sql
#案例引入 查询员工'Abel'的人在哪个城市工作
#实际上 我们是通过EMPLOYEES表来找到DEPARTMENTS表,然后再找到LOCATIONS表
#这个过程实际上就是在进行多表查询
SELECT *
FROM employees
WHERE last_name = 'Abel'; 

SELECT *
FROM departments
WHERE department_id = 80;

SELECT *
FROM locations
WHERE location_id = 2500;
```

# 11.多表查询细节

## 11.1笛卡尔积的错误与正确的多表查询

```sql
#错误的实现方式
SELECT employee_id,department_name
FROM employees,departments;#这里就是在from有两个不同表 查询出了2800多条记录 但是总共就100多个员工啊,仿佛员工在每个部门都工作过!为什么会这样呢:
#这个问题就是 每个员工与每个部门匹配了一遍-这种错误叫:出现了笛卡尔积的错误

```

**笛卡尔积(交叉连接-CROSS JOIN)**:有集合X与集合Y,那么第一个对象来自于X,第二个对象来自于Y的所有可能,组合的个数就是两个集合中元素个数的乘积数

> **正确的多表查询方式**

```sql
SELECT employee_id,department_name
FROM employees,departments
#两个表的连接条件,有了条件就可以避免笛卡尔积的影响了
WHERE employees.`department_id` = department.`department_id`;

#下面我们列举一个错误的情况:department_id同时存在于employees和departments表中
SELECT employee_id,department_name,department_id#这里就会报错ambiguous,因为mysql不清楚你的department_id属于employees还是departments,那么如何修正这个问题呢?
FROM employees,departments
WHERE employees.`department_id` = department.`department_id`

#这里是修正的部分:
SELECT employee_id,department_id,employees.department_id #我们在department_id前面添加了所属的表employees,因此就不会报ambiguous的错误了
FROM employees,departments
WHERE employees.`department_id` = department.`department_id`;

#可以给表起别名来优化流程:严谨来说,每一个select的对象都要有表的别名
#当使用了别名后,必须要使用别名,不能使用原名了
SELECT emp.employee_id,dept.department_name,emp.department_id
FROM employees emp,departments dept
WHERE emp.`department_id` = dept.`department_id`;
```

## 11.2等值连接vs非等值连接|自连接vs非自连接

### 角度1:等值连接 vs 非等值连接

```sql
#这里看到了工资和等级的对应关系
SELECT *
FROM job_grades;
#非等值连接:也就是查询在下限和上限之间的员工薪资,名字,以及薪资等级
SELECT e.last_name,e.salary,j.grade_level
FROM employees e,job_grades j
WHERE e.`salary` BETWEEN j.`lowest_sal` AND j.`highest_sal`;


```



### 角度2:自连接 vs 非自连接

```sql
#自连接

#练习:查询员工id,员工姓名及其管理者的id和姓名
SELECT emp.employee_id,emp.last_name,mgr.employee_id,mgr.last_name
FROM employees emp,employees mgr
WHERE emp.`manager_id` = mgr.`employee_id`
#分析:所谓的自连接,就是把同一个表copy一份,然后给两个表不同的名字
#然后就可以拿同一个表的copy部分的字段来和原先表的某个字段来比较
#这个需求里面:就是员工的经理id要和经理的员工id匹配
```



### 角度3:内链接 vs 外连接(较难)

**内连接:**合并具有同一列的两个以上表的行,结果集**只包含匹配的行**

**外连接**:合并具有同一列的两个以上表的行,结果集中**包含匹配的行**,也**包含不匹配的行**

​	左外连接:有左表和右表中匹配的行,以及左表中不匹配的行(左表是主表,右表是从表)

​	右外连接:有左表和右表中匹配的行,以及右表中不匹配的行(右表是主表,左表是从表)

​	满外连接:有左表和右表中匹配的行,以及左表和右表不匹配的行

```sql
#练习:所有的(看到所有的,就是外连接)查询员工的last_name,department_name信息
#SQL99语法来实现多表的查询
SELECT last_name,department_name
FROM employee e JOIN department d
ON e.`department_id` = d.`department_id`;
#拓展练习:
SELECT last_name,department_name,city
FROM employees e  INNER JOIN departments d
ON e.`department_id` = d.`department_id`
JOIN location l
ON d.`location_id`=l.`location_id`;
#解析,也就是employees表内连接departments表,然后再内连接location表
#FROM A表 JOIN B表 ON A表.xxx = B表.xxx 这就是内连接的写法

#左外连接的写法:
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.`department_id` = d.`department_id`; #现在就包含左表中的不匹配情况了

#右外连接的写法:
SELECT last_name,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`;#现在就包含了右表的不匹配的情况了
#满外连接有FULL JOIN 但是mysql不支持这种语法
```

总结一下:

看到**join on**:就是内连接,实质上是 INNER JOIN ON

看到**left join on** 就是左外连接 实质上是 LEFT OUTER JOIN ON

看到**right join on**就是右外连接 实质上是 RIGHT OUTER JOIN ON

**full join on**这种满连接写法 mysql不支持哈

# 12.使用SQL99实现7种JOIN操作

## 12.1 UNION关键字的使用

UNION操作符会返回两个查询的结果集的并集,去除重复记录

UNION ALL操作符:返回两个查询的结果集的并集.对于两个结果集的重复部分,不去重

![image-20240309165059841](C:\Users\xiao\AppData\Roaming\Typora\typora-user-images\image-20240309165059841.png)

```sql
#中图 内链接:
SELECT employee_id,department_name
FROM employees e JOIN departments d
ON e.`department_id` = d.`department_id`;

#左外连接 左上
SELECt employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`;

#右外连接 右上
SELECT employee_id,department_name
FROM employee e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`;

#左中:左外连接删除包含右的部分
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE d.`department_id` IS NULL;

#右中:右外连接删除包含右的部分
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

#左下图:满外连接 左上图 UNION ALL右中图,列要求一样,field也要求一样
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
UNION ALL
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

#右下图:左中union右中图
SELECT employee_id,department_name
FROM employees e LEFT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE d.`department_id` IS NULL;
UNION ALL
SELECT employee_id,department_name
FROM employees e RIGHT JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`department_id` IS NULL;

```

## 12.2SQL的新特性:自然连接+using使用

```sql

#这里是等值连接,但是发现需要写两个,比较麻烦
SELECT employee_id,last_name,department_name
FROM employees e JOIN departments d
ON e.`department_id` = d.`department_id` AND
e.`manager_id`=d.`manager_id`;

#自然连接会自动寻找两个表中相同的字段,并且要求其二者相等
SELECT employee_id,last_name,department_name
FROM employees e NATURAL JOIN departments d
```

```sql
#这里是sql92的常规使用
SELECT employee_id,last_name,department_name
FROM employee e JOIN departments d
ON e.department_id = d.department_id;

#所谓的using,就是让你不必care on条件中的某张表中的某个字段
#using会自动填充{}到on中去,因此也不必写On了
SELECT employee_id,last_name,department_name
FROM employees e JOIN departments d
USING {department_id};
```

# 13.单行函数

不同的DBMS的函数差异是很大的

**单行函数:只对一行进行变换,每行返回一个结果**

```sql
#数值函数:
SELECT
ABS(-123),ABS(32),SIGN(-23),SIGN(43),PI(),CEIL(32.32),CEILING(-43.23),FLOOR(32.32)
FROM DUAL
#ABS绝对值 SIGN返回符号(正数1 负数-1 0返回0) PI圆周率 CEIL/CEILING求这个数天花板,FLOOR求地板,LEAST(a,b,c)求最小值,GREATEST(a,b,c)最大值 MOD(X,Y)X/Y的余数,RAND(x)0-1的随机数,ROUND(x,y)四舍五入最接近x的值,有y位,TURNCATE(x,y)返回x截断y位小数的结果 SQRT(x)返回X的平方根,x为负数,返回NULL

#三角函数
#角度换弧度 RANDIAN(X) 弧度换角度DEGREES(X)
#常用三角函数:
#SIN(x) ASIN(x) COS(x) ACOS(x) TAN(x) ATAN(x) ATAN2(m,n) COT(x)
```

```sql
#字符串函数
ASCII(x)返回字符串s的第一个字符的ascii码值
CHAR_LENGTH(S)返回s字符串的字符数量
LENGTH(s)返回s字符串的字符数
CONCAT(s1,s2,s3)连接s1,s2,s3为一个字符串
CONCAT_WS(x,s1,s2,s3)连接s1,s2,s3中间要用x分隔符
INSERT(str,index,len,replacestr)字符串str从idx位置开始,len长的字符串替换为字符串replacestr
UPPER(s)或者UCASE(s)都是将s的字母换成大写字母
LOWER(s)都是将s的字母换成小写字母
LEFT(str,n)返回str左边n个字符
RIGHT(str,n)返回str右边的n个字符
LPAD(str,len,pad)使用pad字符串对str的左边填充,直到str长度为len
RPAD(str,len,pad)使用pad字符串对str的右边填充,直到str的长度为len

LTRIM(s)去除字符串s左边的空格
RTRIM(s)去除字符串s右边的空格
TRIM(s)去除字符串s开头和结尾的空格
REPEAT(str,n)返回str重复n次的结果
SPACE(n)返回n个空格
STRCMP(s1,s2)比较s1,s2的ASCII码值的大小

```

```SQL
#日期函数

#获取日期和时间
SELECT CURDATE(),CURRENDT_DATE(),CURTIME(),NOW(),SYADATE(),UTC_DATE()
FROM DUA
```

```sql
#控制流程函数
IF(value,value1,value2)类似三目运算符,true value1 false value2
IFNULL(value1,value2)不是null为1,是null为2

SELECT last_name,salary,CASE WHEN salary>=15000 THEN '高工资'
							 WHEN salary>=10000 THEN '潜力股'
							 WHEN salary>=8000 THEN '不太行'
							 ELSE '草根' END 'details'
FROM employees;

```

```sql
#加密和解密函数
SELECT MD5('mysql'),SHA('MYSQL')
FROM DUAL;#涉及到加密算法,MD5和SHA 但是这个是不可逆的

```

# 14.聚合函数

```sql
#AVG/SUM 均值和总和
SELECT AVG(salary),SUM(salary),AVG(salary)*107

#COUNT查的是出现字段的行数
SELECT COUNT(employee_id),COUNT(salary)
FROM employees;
```

# 15.GROUP BY/HAVING

## 15.1GROUP BY使用

需求:需要求出员工表中各个部门的平均工资->引入group by

```sql
SELECT department_name,AVG(salary)
FROM employees
GROUP BY department_id

#更新复杂的需求:各个department_id,job_id的平均工资
SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY  department_id,job_id;
```

## 15.2HAVING子句

**需求:**

​	1.行已经被group BY处理

​	2.使用了聚合函数

**作用:**

​	用于过滤数据,用来替换where

```sql
#查询各个部门中最高工资比10000高的部门信息
SELECT department_id,MAX(salary)
FROM employees
GROUP BY employees
HAVING MAX(salary)>10000

```

# 16.子查询(嵌套查询)

```sql
#需求,谁的薪资比Abel高
SELECT salary
FROM employees
WHERE last_name = 'Abel';

SELECT last_name,salary
FROM employees
WHERE salary>11000

#将以上的内容用自连接来实现
SELECT e2.last_name,e2.salary
FROM employees e1,employees e2
WHERE e2.`salary`>e1.`salary`#多表的连接条件
AND e1.last_name = 'Abel'

#将以上内容用子查询来实现
SELECT last_name,salary
FROM employees
WHERE salary >(
		SELECT salary
    	FROM employees
		WHERE last_name = 'Abel'
)
```

**子查询的规范**:

​	外查询(主查询) 内查询(或子查询)

## 16.1单行子查询

```sql
#查询工资大于149号员工工资的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
SELECT salary,
    FROM employees
    WHERE employee_id=149
	);
	
#返回job_id与141号员工相同,salary比143号员工多的员工姓名,job_id和工资
SELECT last_name,job_id,salary
FROM employees
WHERE job_id = (SELECT job_id
               FROM employees
               WHERE employee_id=141) 
AND salary > (
				SELECT salary
    			FROM employees
    			WHERE job_id=143;
);

#返回公司工资最少的员工的last_name,job_id,salary
SELECT last_name,job_id,salary
FROM employees
WHERE salary = (
				SELECT MIN(salary)
    			FROM employees
);
```

## 16.2多行子查询(返回多行的数据)

```sql
IN 是列表中的任意一个
ANY 需要和单行比较操作符一起使用,和子查询的一个返回值比较
ALL 需要和单行比较操作符一起使用,和子查询返回的所有值比较
SOME 是ANY的别名
```

```sql
SELECT employee_id,last_name
FROM employees
WHERE salary IN
			(
            SELECT MIN(salary)
            FROM employees
            GROUP BY department_id
			);

```

```sql
#返回其他job_id中比job_id为'IT_PROG'部门任意工资低的员工的员工号
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < ANY (
SELECT salary
FROM employees
WHERE job_id = 'IT_PROG');
#返回所有job_id中比job_id为'IT_PROG'部门任意工资低的员工的员工号
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < ALL (
SELECT salary
FROM employees
WHERE job_id = 'IT_PROG');
```

## 16.3相关子查询

说白了,就是外查询中的量也可以放到内查询中去用

```sql
SELECT last_name,salary,department_id
FROM employees el
WHERE salary > (
	SELECT AVG(salary)
	FROM employees e2
	WHERE department_id = e1.`department_id`
);
```

# 17.创建表和管理表

## 17.1DDL:数据定义语言:CREATE/ALERT/DROP/RENAME/TRUNCATE

**储存数据是处理数据的第一步**

创建数据库->确认字段->创建数据表->插入数据

标识符命名原则:

- DB名,table名,不得超过30个字符
- 只能包含A-Z a-z 0-9 _ 一共63个字符
- DB名,table名,field名,对象名中间不能有空格
- 同一个MySQL中,以上各种不能重名
- 尽量保证不与保留字冲突,如果冲突,那么请用``引起来

```sql
#创建数据库
#方式1
CREATE DATABASE mytest1;

#展示这个数据库
SHOW DATABASES

#显式的指明了数据库的字符集 方式2
CREATE DATABASE mytest2 CHARACTER SET ''

#(推荐的方法)如果要创建的数据库已经存在,则创建不成功但是不会报错 方式3
CREATE DATABASE IF NOT EXISTS mytest2 CHARACTER SET 'utf8'

#r
```

如果不指定字符集的话,那么默认的字符集就是utf8nb4

## 17.2数据库的管理

```sql
#展示数据库 查看当前连接中的数据库都有哪些
SHOW DATABASES;

#指定要使用某一个数据库/切换数据库
USE mytest2;

#查看当前数据库有哪些表
SHOW TABLES

#查看当前使用的数据库
SELECT DATABASE()
FROM DUAL;

#查看指定数据库下保存的数据表
SHOW TABLES FROM mysql
```

## 17.3修改数据库

```sql
#慎重修改数据库

#查询已经创建的数据库的一些属性
SHOW CREATE DATABASE mytest2;
#更改这个数据库的字符集
ALTER DATEBASE mytest2 CHARACTER SET 'utf8'
#数据库是不能改名的->可视化工具改名是创建新的库,把表复制一份

#删除数据库
#方式1
DROP DATABASE mytest1;
SHOW DATABASES;

#方式2:比较推荐的删库的方法
DROP DATABASE IF EXISTS mytest1;
```

## 17.4创建表

| 数据类型      | 描述                                                        |
| ------------- | ----------------------------------------------------------- |
| INT           | 从2^-31到2^31-1.储存大小为四个字节                          |
| CHAR（size）  | 定长字符数据,没有指定就是1个字符,最大长度255                |
| VARCHAR(size) | 可变长字符数据,根据字符串实际长度保存,必须指定长度          |
| FLOAT(M,D)    | 单精度,占用4个字节 M:整数+小数 D<=M<=255 0<=D<=30 默认M+D=6 |
| DOUBLE(M,D)   | 双精度,占用8个字节 D<=M<=255,0<=D<=30,默认M+D<=15           |
| DECIMAL(M,D)  | 高精度小数,最大取值范围DOUBLE相同                           |
| DATE          | 日期型数据 格式 'YYYY-MM-DD'                                |
| BLOB          | 二进制形式长文本 最大是4G                                   |
| TEXT          | 长文本-最大是4G                                             |
|               |                                                             |

```SQL
#如何创建一个表?
USE atguigudb;
SHOW CREATE DATABASE atguigudb;
SHOW TABLES

#方式1:
CREATE TABLE IF NOT EXISTS myemp1(
id INT,
emp_name VARCHAR(15),
hire_date DATE
);
#查看一下方式1创建的表结构
DESC myemp1;
SHOW CREATE TABLE myemp1;

#方式2:
#基于已有的表的部分来创建,同时导入数据,并且用AS来引入
CREATE TABLE myemp2
AS
SELECT employee_id,last_name,salary
FROM employees;

#方式2的练习
CREATE TABLE myemp3
AS
SELECT e.employee_id emp_id,e.last_name lname,d.department_name
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

#练习1:创建于个表employees_copy 实现对employees表的复制
CREATE TABLE employees_copy
AS
SELECT *
FROM employees

#练习2:创建一个表employees_blank,实现对employees表的复制,但是没有内容只有字段
CREATE TABLE employees_blank
AS
SELECT *
FROM employees
WHERE deparment_id=9999;#通过控制筛选条件,可以让select出来的结果为空,然后这个空的结果再通过as来创建一个新的表

```

## 17.5修改表(modify),重命名表(rename),删除表(drop table),清空表

```sql
#修改表->ALTER TABLE
DESC myemp1;
	#添加一个字段
		#在最后添加
		ALERT TABLE myemp1
		ADD salary DOUBLE(10,2)#一共有10位,其中小数占2位
		#在...后添加字段
		ALERT TABLE myemp1
		ADD email VARCHAR(45) AFTER emp_name;
		#在最前添加字段
		ALERT TABLE myemp1
		ADD phone_number VARCHAR(20) FIRST;
	#修改一个字段
		ALERT TABLE myemp1
		MODIFY emp_name VARCHAR(25)
	#重命名字段
		ALERT TABLE myemp1
		CHANGE salary monthly_salary DOUBLE(10,2);
	#删除一个字段
		ALERT TABLE myemp1
		DROP COLUMN my_email
#重名表
	#方法1
	ALERT TABLE myemp2
	RENAME TO myemp12;
	#方法2
	RENAME TABLE myemp1
	TO myemp2

#删除表:删除结构与数据
DROP TABLE IF EXISTS myemp2
#清空表:保留结构,删除数据
TRUNCATE TABLE employees_copy
```

# 18.COMMIT和ROLLBACK

一旦执行commit,数据就被永久保存在了数据库中,数据不可以回滚

TRUNCATE TABLE和DELETE FROM都可以删除数据并且保存表结构

差异性:

​	TRUNCATE TABLE,数据是不可以回滚的

​	DELETE FROM执行操作后可以回滚

补充信息:

1. ​	DDL一旦执行,不可以回滚,

2. DML一旦执行,不可以回滚,但是如果在执行DML之前,执行了SET autocommit=false;就可以实现回滚

   

   ```sql
   COMMIT
   SELECT *
   FROM myemp3;
   SET autocommit = false;
   
   DELETE FROM myemp3;
   SELECT *
   FROM myemp3;
   ROLLBACK
   
   ```

   # 19.增删改查DML

   ```sql
   #插入语句:
   INSERT INTO emp1(id,hire_date,salary,`name`)
   VALUES
   (2,`1999-09-09`,4000,'Jerry')#没有赋值的部分为Null
   (3,`1989-09-09`,4000,'TOM')#没有赋值的部分为Null
   
   ```

   ```sql
   #修改数据
   UPDATE employees
   SET department_id = 10000
   WHERE employee_id = 102;
   
   ```

   ```sql
   #删除数据
   DELETE departments
   WHERE department_id = 50;
   ```

   

   

# 20约束(constraint)

## 20.1为什么需要约束

数据的完整性(Data Integrity)是指数据的Accuracy和Reliability.是防止数据库中存在不符合语义规定的数据和防止错误信息输出造成无效操作提出的

我们从以下四个方面来考虑约束

- **实体完整性** 同一个表,不能存在子两条完全相同无法区分的记录
- **域完整性** 年龄0-120 性别范围 男/女
- **引用完整性** 员工所在部门,部门表要找到这个部门
- **用户自定义完整性** 用户名唯一,密码不为空

注明:**约束**是一种**表级限制**,是对表中字段的限制

- not null(非空约束)
- unique(唯一性约束)
- primary key(主键约束)
- foreign key(外键约束)
- check(检查约束)
- default(默认值约束)

如何添加约束?

​	1.CREATE TABLE时添加

​	2.ALERT TABLE补充/删除约束

​	

## 20.2常用的约束

```sql
#如何查看表中的约束
SELECT *
FROM information_schema.table_constraints
WHERE table_name = 'employees';
```



### 20.2.1not null(非空约束)

假设employees表中,有last_name age 这种field的值是不可以为空的

```sql
#建立表时候
CREATE TABLE test1(
	id INT NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    email VARCHAR(25),
    salary DECIMAL(10,2)
)
#在ALERT TABLe时候添加约束
SELECT * FROM test1
MODIFY email VARCHAR(250) NOT NULL;#也就是通过modify这个方法来实现

```

在添加了not null之后,当你试图添加一个为null值的内容进去时,会提示失败

这样可以避免null对计算的影响,因为在sql当中:null和其他的数字处理会导致结果为null,而不是0,因此我们要避免null



### 20.2.2unique(唯一性约束)

```sql
#学生表
CREATE TABLE student(
	sid INT,
    sname VARCHAR(20),
	tel CHAR(11) UNIQUE KEY,#电话
    cardid CHAR(18) UNIQUE KEY#身份证号码
)
#课程表
CREATE TABLE course(
	cid INT,
    cname VARCHAR(20)#课程的名称
)

#选课表
CREATE TABLE student_course(
	id INT,
    sid INT,
    cid INT,
    score INT,
    UNIQUE KEY(sid,cid) #复合唯一性约束


)
```



### 20.2.3 primary key(主键约束)

作用:唯一地标注表中的 **唯一性** **非空约束** 

一个table只能有一个primary key

系统会在primary key上生成主键索引,使用了B+树

```sql
#如何删除唯一性的索引
ALERT TABLE test2
DROP INDEX last_name;

#在CREATE TABLE时添加约束
	#一个table中最多有一个主键约束
CREATE TABLE tesrt3(
	id INT,
	last_name VARCHAR(15) PRIMARY KEY#列级约束,
	salary DECIMAL(10,2),
	email VARCHAR(25)
);
```

自增列:AUTO_INCREMENT(**自动增长**)



### 20.2.4 foreign key(外键约束)

从表添加的值,应该是主表已存在的值

比如你希望在employees中添加一个在9号部门的员工,但是在departments这个表中,没有9号这个值,因为在departments中有外键,在employees有主键,因此无法添加

1. 从表的外键列,必须引用主表的主键列 为什么?因为被依赖的值必须是唯一的

2. 在创建外键约束时,如果不给外键约束命名,那么,默认名不是列名,而是自动生成一个外键名,例如(student_ibfk_1)

3. CREATE表,现创建主表,再创建从表

4. DELETE TABLE/ALERT TABLE DROP TABLE先删除从表,再删除主表

5. 当主表的记录被从表参照,主表的记录无法被删除,如果要删除,就得线删除从表中依赖该记录的数据

6. 在从表中删除指定外键的约束,并且一个表可以建立多个外键约束

7. 从表的外键列与主表被参照的列的名字可以不同,但是数据类型必须相同

8. 在创建外键约束的时,系统会默认在所在的列上建立对应的普通索引

9. 删除外键约束,必须手动删除对应的索引

   

   ```sql
   #设计主表
   CREATE TABLE departments(
       department_id INT PRIMARY KEY,
       department_name VARCHAR(50),
       manager_id INT,
       location_id INT);
       
   ```

   ```sql
   #设计从表
   CREATE TABLE employees(
       employee_id INT PRIMARY KEY,
       department_id INT;
       CONSTRAINT fk_constraint_name FOREIGN KEY(department_id) REFERENCES deparments(department_id)
   );
   ```

   切记:

   - 外键是在从表设置的,并且以当前表为从表
   - 固定格式: FOREIGN KEY(xxxxx) REFERENCES 表名(column)
   - 

### 20.2.5 check(检查约束)

```SQL
#检查约束
CREATE TABLE employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    salary DECIMAL(10,2)
    commisson_pct DECIMAL(4,2)
    CONSTRAINT positive_salary CHECK(salary>0),
    CONSTRAINT valid_commission_pct CHECK (commission_pct >=0 AND commission<=1)
);
```



### 20.2.6 default(默认值约束)

```sql
#比如说对users表,的status列添加默认约束
ALTER TABLE users
ADD CONSTRAINT DF_users_status DEFAULT 'active' FOR status;

```

