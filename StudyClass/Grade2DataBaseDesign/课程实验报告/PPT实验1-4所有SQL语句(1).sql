#实验一
create database school;#创建数据库
use school;#使用刚刚创建的数据库
create table `student`(#建立student表
    `sno` varchar(10) not null,
    `sname` varchar(10) not null,
    `ssex` varchar(2) not null,
    `sage` int,
    `sdept` varchar(4) not null
);
create table `course`(#建立course表
    `cno` varchar(3) not null,
    `cname` varchar(30) not null ,
    `credit` int,
    `pcno` varchar(3)
);
create table `sc`(#建立sc表
    `sno` varchar(10) not null ,
    `cno` varchar(3) not null ,
    `grade` int
);
INSERT INTO student (sno, sname, ssex, sage, sdept) VALUES
(95001, '李勇', '男', 20, 'CS'),
(95002, '刘晨', '女', 19, 'IS'),
(95003, '王敏', '女', 18, 'MA'),
(95004, '张立', '男', 19, 'IS'),
(95005, '刘云', '女', 18, 'CS');

INSERT INTO course (cno, cname, credit, pcno) VALUES
(1, '数据库', 4, 5),
(2, '数学', 6, NULL),
(3, '信息系统', 3, 1),
(4, '操作系统', 4, 6),
(5, '数据结构', 4, 7),
(6, '数据处理', 3, NULL),
(7, 'PASCAL语言', 4, 6);
INSERT INTO sc (sno, cno, grade) VALUES
(95001, 1, 92),
(95001, 2, 85),
(95001, 3, 88),
(95002, 2, 90),
(95002, 3, 80),
(95003, 2, 85),
(95004, 1, 58),
(95004, 2, 85);

#将所有学生的年龄增加一岁：
 update student set sage=sage+1 ;
#将4号课程的学分改为4:
 update course set credit=4 where cno=4;
#设置7号课程没有先行课:
 update course set pcno=null where cno=7;
#将95001号学生的1号课程的成绩增加3分:
update sc set grade=grade+3 where sno=95001 and cno=1;





#实验二

# 1. 查询全体学生的学号和姓名:
SELECT sno, sname FROM student;

# 2. 查询全体学生的所有信息:
SELECT * FROM student;
# 或者
SELECT sno, sname, ssex, sage, sdept FROM student;

# 3. 查询全体学生的姓名, 出生年份,和所在系, 并用小写字母表示所有系名:
SELECT sname, '出生年份为: ', YEAR(GETDATE()) - sage, LOWER(sdept) FROM student;
# 注意：MySQL可能不支持GETDATE()，可以用2022 - sage替代。

# 4. 给上例的结果集指定列名:
SELECT sname, '出生年份为: ' AS 出生, YEAR(GETDATE()) - sage AS 年份, LOWER(sdept) AS 系名 FROM student;

# 5. 查询选修了课程的学生的学号:
SELECT DISTINCT sno FROM sc;
# 比较:
SELECT sno FROM sc;

# 6. 查询年龄在20岁以下的学生的姓名及其年龄:
SELECT sname, sage FROM student WHERE sage < 20;

# 7. 查询考试成绩有不及格的学生的学号:
SELECT DISTINCT sno FROM sc WHERE grade < 60;
# 比较:
SELECT sno FROM sc WHERE grade < 60;

# 8. 查询年龄在20-30岁之间的学生的姓名, 性别, 所在系:
SELECT sname, ssex, sdept FROM student WHERE sage BETWEEN 20 AND 30;

# 9. 查询IS, CS, MA系的所有学生的姓名和性别:
SELECT sname, ssex FROM student WHERE sdept IN ('IS', 'MA', 'CS');

# 10. 查找所有姓’李’的学生的姓名, 学号和性别:
SELECT sname, sno, ssex FROM student WHERE sname LIKE '李%';
# 比较: 将学生表中的’95001’号学生的姓名’李勇’改为’李勇勇’，再执行:
SELECT sname, sno, ssex FROM student WHERE sname LIKE '李_';

# 11. 查询没有先行课的课程的课程号cno和课程名cname:
SELECT cno, cname FROM course WHERE pcno IS NULL;

# 二. 查询结果排序

# 12. 查询选修了3号课程的学生的学号和成绩, 并按分数降序排列:
SELECT sno, grade FROM sc WHERE cno = '3' ORDER BY grade DESC;

# 13. 查询全体学生的情况, 查询结果按所在系号升序排列, 同一系中的学生按年龄降序排列:
SELECT * FROM student ORDER BY sdept ASC, sage DESC;

# 三. 连接查询:

# 14. 查询每个学生及其选修课程的情况:
SELECT student.*, sc.* FROM student, sc WHERE student.sno = sc.sno;
# 比较: 笛卡尔集:
SELECT student.*, sc.* FROM student, sc;
# 自然连接:
SELECT student.sno, sname, ssex, sdept, cno, grade FROM student, sc WHERE student.sno = sc.sno;

# 15. 查询每一门课程的间接先行课(只求两层即先行课的先行课):
SELECT First.cno, Second.pcno AS 间接先行课 FROM course First, course Second WHERE First.pcno = Second.cno;
# 比较:
SELECT First.cno, Second.pcno AS 间接先行课 FROM course First, course Second WHERE First.pcno = Second.cno AND Second.pcno IS NOT NULL;

# 16. 列出所有学生的基本情况和选课情况, 若没有选课,则只列出基本情况信息:
# SQL Server 中使用外连接
SELECT s.sno, sname, ssex, sdept, cno, grade FROM student s LEFT JOIN sc sc ON s.sno = sc.sno;

# 17. 查询每个学生的学号, 姓名, 选修的课程名和成绩:
SELECT S.sno, sname, cname, grade FROM student S, course C, sc SC WHERE S.sno = SC.sno AND C.cno = SC.cno;


SELECT
    s.sno,           -- 学生学号
    s.sname,         -- 学生姓名
    c.cname,         -- 课程名称
    sc.grade         -- 成绩
FROM
    student s       -- 学生表
JOIN
    sc              -- 选课表
ON
    s.sno = sc.sno  -- 根据学号连接
JOIN
    course c        -- 课程表
ON
    sc.cno = c.cno  -- 根据课程号连接
WHERE
    sc.grade < 60;  -- 筛选不及格的成绩

-- 一. 使用聚集函数：

-- 1. 查询学生总人数：
SELECT COUNT(*) AS 学生总数 FROM student;

-- 2. 查询选修了课程的学生总数：
SELECT COUNT(DISTINCT sno) AS 选课学生总数 FROM sc;

-- 3. 查询所有课程的总学分数和平均学分数, 以及最高学分和最低学分：
SELECT SUM(credit) AS 总credit, AVG(credit) AS 课程平均学分, MAX(credit) AS 最高学分,
MIN(credit) AS 最低学分 FROM course;

-- 4. 计算1号课程的学生的平均成绩, 最高分和最低分:
SELECT AVG(grade) AS 平均成绩, MAX(grade) AS 最高分, MIN(grade) AS 最低分
FROM sc WHERE cno='1';

-- 5. 查询’信息系’(IS)学生”数据结构”课程的平均成绩:
SELECT AVG(grade) FROM student, course, sc
WHERE student.sno=sc.sno AND course.cno=sc.cno AND sdept='IS' AND cname='数据结构';

-- 二. 分组查询

-- 6. 查询各系的学生的人数并按人数从多到少排序 :
SELECT sdept, COUNT(*) AS 人数 FROM student GROUP BY sdept ORDER BY 人数 DESC;

-- 7. 查询各系的男女生学生总数, 并按系别,升序排列, 女生排在前:
SELECT sdept, ssex, COUNT(*) AS 人数 FROM student GROUP BY sdept, ssex ORDER BY sdept, ssex DESC;

-- 8. 查询选修了3门课程已上的学生的学号和姓名:
SELECT sno, sname FROM student WHERE sno IN
(SELECT sno FROM sc GROUP BY sno HAVING COUNT(*) > 3);

-- 9. 查询每个学生所选课程的平均成绩, 最高分, 最低分,和选课门数:
SELECT sno, AVG(grade) AS 平均成绩, MAX(grade) AS 最高分, MIN(grade) AS 最低分,
COUNT(*) AS 选课门数 FROM sc GROUP BY sno;

-- 10. 查询至少选修了2门课程的学生的平均成绩:
SELECT sno, AVG(grade) AS 平均成绩 FROM sc GROUP BY sno HAVING COUNT(*) >= 2;

-- 11. 查询平均分超过80分的学生的学号和平均分:
SELECT sno, AVG(grade) AS 平均成绩 FROM sc GROUP BY sno HAVING AVG(grade) >= 80;

-- 比较: 求各学生的60分以上课程的平均分:
SELECT sno, AVG(grade) AS 平均成绩 FROM sc WHERE grade >= 60 GROUP BY sno;

-- 12. 查询”信息系”(IS)中选修了5门课程以上的学生的学号:
SELECT sno FROM sc WHERE sno IN (SELECT sno FROM student WHERE sdept='IS')
GROUP BY sno HAVING COUNT(*) >= 5;

-- 三. 集合查询

-- 13. 查询数学系和信息系的学生的信息;
SELECT * FROM student WHERE sdept='MA'
UNION
SELECT * FROM student WHERE sdept='IS';

-- 14. 查询选修了1号课程或2号课程的学生的学号:
SELECT sno FROM sc WHERE cno='1'
UNION
SELECT sno FROM sc WHERE cno='2';



-- 1. 查询平均成绩少于70分的学生学号

-- 方法一：使用GROUP BY和HAVING
SELECT sno
FROM sc
GROUP BY sno                -- 按学生学号分组
HAVING AVG(grade) < 70;    -- 筛选出平均成绩小于70分的学生


-- 方法二：使用子查询
SELECT DISTINCT sno
FROM sc a
WHERE (SELECT AVG(grade)
       FROM sc
       WHERE sno = a.sno) < 70;  -- 筛选出平均成绩小于70分的学生


-- 2. 求各系的“数据库”课程的成绩最高的学生的姓名和成绩
SELECT A.sname, B.grade
FROM student A, sc B
WHERE A.sno = B.sno
  AND B.grade IN (               -- 查找成绩在以下子查询结果中的学生
      SELECT MAX(B2.grade)
      FROM sc B2, course C, student S
      WHERE S.sno = B2.sno
        AND B2.cno = C.cno
        AND C.cname = '数据库'
        AND S.sdept = A.sdept    -- 确保与学生的系别一致
  );


##PPT实验三部分：
-- 一. 使用带IN谓词的子查询

-- 1. 查询与’刘晨’在同一个系学习的学生的信息:
SELECT * FROM student
WHERE sdept IN
    (SELECT sdept FROM student WHERE sname='刘晨');

-- 比较: 使用=的子查询
SELECT * FROM student
WHERE sdept =
    (SELECT sdept FROM student WHERE sname='刘晨');

-- 比较: 不包括'刘晨'
SELECT * FROM student
WHERE sdept =
    (SELECT sdept FROM student WHERE sname='刘晨') AND sname <> '刘晨';

-- 比较: 连接查询
SELECT S1.*
FROM student S1, student S2
WHERE S1.sdept = S2.sdept AND S2.sname = '刘晨';

-- 2. 查询选修了课程名为’信息系统’ 的学生的学号和姓名:
SELECT sno, sname
FROM student
WHERE sno IN (
    SELECT sno FROM sc WHERE cno IN (
        SELECT cno FROM course WHERE cname = '信息系统'
    )
);

-- 3. 查询选修了课程’1’和课程’2’的学生的学号:
SELECT sno
FROM student
WHERE sno IN (
    SELECT sno FROM sc WHERE cno = '1'
) AND sno IN (
    SELECT sno FROM sc WHERE cno = '2'
);

-- 比较: 查询选修了课程’1’或课程’2’的学生的sno:
SELECT sno
FROM sc
WHERE cno = '1' OR cno = '2';

-- 比较: 连接查询
SELECT A.sno
FROM sc A, sc B
WHERE A.sno = B.sno AND A.cno = '1' AND B.cno = '2';

-- 二. 使用带比较运算的子查询

-- 4. 查询比’刘晨’年龄小的所有学生的信息:
SELECT * FROM student
WHERE sage <
    (SELECT sage FROM student WHERE sname='刘晨');

-- 三. 使用带Any, All谓词的子查询

-- 5. 查询其他系中比信息系(IS)某一学生年龄小的学生姓名和年龄:
SELECT sname, sage
FROM student
WHERE sage < ANY
    (SELECT sage FROM student WHERE sdept = 'IS')
AND sdept <> 'IS';

-- 6. 查询其他系中比信息系(IS)学生年龄都小的学生姓名和年龄:
SELECT sname, sage
FROM student
WHERE sage < ALL
    (SELECT sage FROM student WHERE sdept = 'IS')
AND sdept <> 'IS';

-- 7. 查询与计算机系(CS)系所有学生的年龄均不同的学生学号, 姓名和年龄:
SELECT sno, sname, sage
FROM student
WHERE sage <> ALL
    (SELECT sage FROM student WHERE sdept = 'CS');

-- 四. 使用带Exists谓词的子查询和相关子查询

-- 8. 查询与其他所有学生年龄均不同的学生学号, 姓名和年龄:
SELECT sno, sname, sage
FROM student A
WHERE NOT EXISTS (
    SELECT * FROM student B
    WHERE A.sage = B.sage AND A.sno <> B.sno
);

-- 9. 查询所有选修了1号课程的学生姓名:
SELECT sname
FROM student
WHERE EXISTS (
    SELECT * FROM sc WHERE sno = student.sno AND cno = '1'
);

-- 10. 查询没有选修了1号课程的学生姓名:
SELECT sname
FROM student
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE sno = student.sno AND cno = '1'
);

-- 11. 查询选修了全部课程的学生姓名:
SELECT sname
FROM student
WHERE NOT EXISTS (
    SELECT * FROM course
    WHERE NOT EXISTS (
        SELECT * FROM sc WHERE sno = student.sno AND cno = course.cno
    )
);

-- 12. 查询至少选修了学生95002选修的全部课程的学生的学号:
SELECT DISTINCT sno
FROM sc A
WHERE NOT EXISTS (
    SELECT * FROM sc B
    WHERE sno = '95002' AND NOT EXISTS (
        SELECT * FROM sc C WHERE sno = A.sno AND cno = B.cno
    )
);

-- 13. 求没有人选修的课程号cno和cname:
SELECT cno, cname
FROM course C
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE sc.cno = C.cno
);

-- 14. 查询满足条件的(sno,cno)对, 其中该学号的学生没有选修该课程号cno的课程:
SELECT sno, cno
FROM student, course
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE cno = course.cno AND sno = student.sno
);

-- 15. 查询每个学生的课程成绩最高的成绩信息(sno,cno,grade):
SELECT * FROM sc A
WHERE grade = (
    SELECT MAX(grade) FROM sc WHERE sno = A.sno
);

-- 思考:
-- 如何查询所有学生都选修了的课程的课程号cno?
-- 使用下列代码:
SELECT cno
FROM course
WHERE NOT EXISTS (
    SELECT * FROM student WHERE NOT EXISTS (
        SELECT * FROM sc WHERE sc.cno = course.cno AND sc.sno = student.sno
    )
);

#实验四 部分1
-- 一、视图的创建：

-- 1. 创建信息系学生信息的视图
CREATE VIEW IS_Student AS
SELECT sno, sname, ssex, sage
FROM student
WHERE sdept = 'IS';

-- 2. 创建信息系选修了1号课程的学生的视图
CREATE VIEW IS_S1 AS
SELECT student.sno, cno, grade
FROM student, sc
WHERE student.sno = sc.sno AND sdept = 'IS' AND cno = '1';

-- 3. 建立信息系选修了1号课程且成绩在90分以上的学生的视图
CREATE VIEW IS_S2 AS
SELECT *
FROM IS_S1
WHERE grade >= 90;

-- 4. 创建一个反映学生出生年份的视图
CREATE VIEW BT_S(sno, sname, 出生年份) AS
SELECT sno, sname, YEAR(GETDATE()) - sage
FROM student;

-- 5. 将所有女生的记录定义为一个视图
CREATE VIEW F_student AS
SELECT *
FROM student
WHERE ssex = '女';

-- 6. 将所有学生的学号和他的平均成绩定义为一个视图
CREATE VIEW S_G(sno, avg_grade) AS
SELECT sno, AVG(grade)
FROM sc
GROUP BY sno;

-- 二、视图结构的修改：

-- 7. 将视图F_student修改为信息系的所有女士的视图
ALTER VIEW F_student AS
SELECT *
FROM student
WHERE ssex = '女' AND sdept = 'IS';

-- 三、查询视图：

-- 8. 在信息系的学生视图中查询年龄小于20岁的学生
SELECT *
FROM IS_Student
WHERE sage < 20;

-- 9. 查询信息系选修了1号课程的学生
SELECT sc.sno, sname
FROM IS_Student, sc
WHERE IS_Student.sno = sc.sno AND cno = '1';

-- 10. 在视图S_G中查询平均成绩在90分以上的学生的学号和平均成绩
SELECT *
FROM S_G
WHERE avg_grade >= 90;

-- 四、更新视图：

-- 11. 将信息系学生视图IS_Student中学号为”95002”的学生姓名改为”刘辰”
UPDATE IS_Student
SET sname = '刘辰'
WHERE sno = '95002';

-- 比较: 此语句不能实现数据的更新
-- UPDATE IS_Student SET sname = '刘辰' WHERE sno = '95003';

-- 12. 向视图F_Student中插入一个新的学生记录
INSERT INTO F_student VALUES ('95029', '赵新', '女', 20, 'IS');

-- 13. 删除视图F_Student中学号为95029的学生的记录
DELETE FROM F_student
WHERE sno = '95029';

-- 五、删除视图：

-- 14. 删除视图IS_S1
DROP VIEW IS_S1;

-- 思考:
-- 1. 创建所有学生的基本信息和选课信息的视图
CREATE VIEW All_Students_Info AS
SELECT student.sno, student.sname, student.ssex, student.sage, sc.cno, sc.grade
FROM student
JOIN sc ON student.sno = sc.sno;

-- 2. 基于上述视图查询各系学生各门功课的平均成绩
SELECT sdept, cno, AVG(grade) AS avg_grade
FROM All_Students_Info
GROUP BY sdept, cno;

-- 一、实体完整性

-- 1. 将“student”表的“sno”字段设为主键
-- 如果表存在，则添加主键约束
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'student')
BEGIN
    ALTER TABLE student ADD CONSTRAINT pk_sno PRIMARY KEY (sno);
END
-- 如果表不存在，则创建表并设定主键
ELSE
BEGIN
    CREATE TABLE student (
        sno CHAR(10) PRIMARY KEY, -- 学号
        sname CHAR(10),           -- 姓名
        ssex CHAR(2),             -- 性别
        sage INT,                 -- 年龄
        sdept CHAR(4)            -- 学院
    );
END

-- 2. 添加身份证号字段，并设置其唯一性
-- 操作前应删除表中的所有记录
DELETE FROM student; -- 删除所有记录
ALTER TABLE student ADD id CHAR(18) UNIQUE; -- 添加身份证号字段并设为唯一

-- 3. 将“sc”表的“sno”和“cno”设置为主键
-- 如果表存在，则添加复合主键约束
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'sc')
BEGIN
    ALTER TABLE sc ADD CONSTRAINT PK_SnoCno PRIMARY KEY (sno, cno);
END
-- 如果表不存在，则创建表并设定复合主键
ELSE
BEGIN
    CREATE TABLE sc (
        sno CHAR(10),            -- 学号
        cno CHAR(3),             -- 课程号
        grade INT NULL,          -- 成绩
        CONSTRAINT PK_SnoCno PRIMARY KEY (sno, cno) -- 复合主键
    );
END

-- 二、域完整性

-- 4. 将“ssex”字段设置为只能取“男”，“女”两值
-- 如果已存在，则添加约束
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'student')
BEGIN
    ALTER TABLE student ADD CONSTRAINT CK_Sex CHECK (ssex IN ('男', '女'));
END

-- 5. 设置学号字段只能输入数字
ALTER TABLE student ADD CONSTRAINT CK_Sno_Format CHECK (sno NOT LIKE '%[^0-9]%'); -- 检查学号格式

-- 6. 设置身份证号的输入格式
ALTER TABLE student ADD CONSTRAINT CK_ID_Format CHECK (
    id LIKE '__________________' -- 18位数字
);

-- 7. 设置18位身份证号的第7位到第10位为合法的年份(1900-2050)
ALTER TABLE student ADD CONSTRAINT CK_ID_Format2 CHECK (
    LEN(id) = 18 AND
    CAST(SUBSTRING(id, 7, 4) AS SMALLINT) BETWEEN 1900 AND 2050
);

-- 三、参照完整性

-- 9. 设置男生的年龄必须大于22，女生的年龄必须大于20
ALTER TABLE student ADD CONSTRAINT CK_age CHECK (
    (ssex = '男' AND sage > 22) OR (ssex = '女' AND sage > 20)
);

-- 四、完整性验证
-- 实体完整性的验证通过尝试插入重复学号来测试
-- 下面的两条命令将会出现错误提示
-- insert into student values('95001','张三','男',20,'CS');
-- insert into student values('95001','李四','女',18,'CS');
