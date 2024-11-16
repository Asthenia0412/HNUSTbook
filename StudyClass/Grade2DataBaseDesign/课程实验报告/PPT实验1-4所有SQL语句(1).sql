#ʵ��һ
create database school;#�������ݿ�
use school;#ʹ�øոմ��������ݿ�
create table `student`(#����student��
    `sno` varchar(10) not null,
    `sname` varchar(10) not null,
    `ssex` varchar(2) not null,
    `sage` int,
    `sdept` varchar(4) not null
);
create table `course`(#����course��
    `cno` varchar(3) not null,
    `cname` varchar(30) not null ,
    `credit` int,
    `pcno` varchar(3)
);
create table `sc`(#����sc��
    `sno` varchar(10) not null ,
    `cno` varchar(3) not null ,
    `grade` int
);
INSERT INTO student (sno, sname, ssex, sage, sdept) VALUES
(95001, '����', '��', 20, 'CS'),
(95002, '����', 'Ů', 19, 'IS'),
(95003, '����', 'Ů', 18, 'MA'),
(95004, '����', '��', 19, 'IS'),
(95005, '����', 'Ů', 18, 'CS');

INSERT INTO course (cno, cname, credit, pcno) VALUES
(1, '���ݿ�', 4, 5),
(2, '��ѧ', 6, NULL),
(3, '��Ϣϵͳ', 3, 1),
(4, '����ϵͳ', 4, 6),
(5, '���ݽṹ', 4, 7),
(6, '���ݴ���', 3, NULL),
(7, 'PASCAL����', 4, 6);
INSERT INTO sc (sno, cno, grade) VALUES
(95001, 1, 92),
(95001, 2, 85),
(95001, 3, 88),
(95002, 2, 90),
(95002, 3, 80),
(95003, 2, 85),
(95004, 1, 58),
(95004, 2, 85);

#������ѧ������������һ�꣺
 update student set sage=sage+1 ;
#��4�ſγ̵�ѧ�ָ�Ϊ4:
 update course set credit=4 where cno=4;
#����7�ſγ�û�����п�:
 update course set pcno=null where cno=7;
#��95001��ѧ����1�ſγ̵ĳɼ�����3��:
update sc set grade=grade+3 where sno=95001 and cno=1;





#ʵ���

# 1. ��ѯȫ��ѧ����ѧ�ź�����:
SELECT sno, sname FROM student;

# 2. ��ѯȫ��ѧ����������Ϣ:
SELECT * FROM student;
# ����
SELECT sno, sname, ssex, sage, sdept FROM student;

# 3. ��ѯȫ��ѧ��������, �������,������ϵ, ����Сд��ĸ��ʾ����ϵ��:
SELECT sname, '�������Ϊ: ', YEAR(GETDATE()) - sage, LOWER(sdept) FROM student;
# ע�⣺MySQL���ܲ�֧��GETDATE()��������2022 - sage�����

# 4. �������Ľ����ָ������:
SELECT sname, '�������Ϊ: ' AS ����, YEAR(GETDATE()) - sage AS ���, LOWER(sdept) AS ϵ�� FROM student;

# 5. ��ѯѡ���˿γ̵�ѧ����ѧ��:
SELECT DISTINCT sno FROM sc;
# �Ƚ�:
SELECT sno FROM sc;

# 6. ��ѯ������20�����µ�ѧ����������������:
SELECT sname, sage FROM student WHERE sage < 20;

# 7. ��ѯ���Գɼ��в������ѧ����ѧ��:
SELECT DISTINCT sno FROM sc WHERE grade < 60;
# �Ƚ�:
SELECT sno FROM sc WHERE grade < 60;

# 8. ��ѯ������20-30��֮���ѧ��������, �Ա�, ����ϵ:
SELECT sname, ssex, sdept FROM student WHERE sage BETWEEN 20 AND 30;

# 9. ��ѯIS, CS, MAϵ������ѧ�����������Ա�:
SELECT sname, ssex FROM student WHERE sdept IN ('IS', 'MA', 'CS');

# 10. ���������ա����ѧ��������, ѧ�ź��Ա�:
SELECT sname, sno, ssex FROM student WHERE sname LIKE '��%';
# �Ƚ�: ��ѧ�����еġ�95001����ѧ�������������¡���Ϊ�������¡�����ִ��:
SELECT sname, sno, ssex FROM student WHERE sname LIKE '��_';

# 11. ��ѯû�����пεĿγ̵Ŀγ̺�cno�Ϳγ���cname:
SELECT cno, cname FROM course WHERE pcno IS NULL;

# ��. ��ѯ�������

# 12. ��ѯѡ����3�ſγ̵�ѧ����ѧ�źͳɼ�, ����������������:
SELECT sno, grade FROM sc WHERE cno = '3' ORDER BY grade DESC;

# 13. ��ѯȫ��ѧ�������, ��ѯ���������ϵ����������, ͬһϵ�е�ѧ�������併������:
SELECT * FROM student ORDER BY sdept ASC, sage DESC;

# ��. ���Ӳ�ѯ:

# 14. ��ѯÿ��ѧ������ѡ�޿γ̵����:
SELECT student.*, sc.* FROM student, sc WHERE student.sno = sc.sno;
# �Ƚ�: �ѿ�����:
SELECT student.*, sc.* FROM student, sc;
# ��Ȼ����:
SELECT student.sno, sname, ssex, sdept, cno, grade FROM student, sc WHERE student.sno = sc.sno;

# 15. ��ѯÿһ�ſγ̵ļ�����п�(ֻ�����㼴���пε����п�):
SELECT First.cno, Second.pcno AS ������п� FROM course First, course Second WHERE First.pcno = Second.cno;
# �Ƚ�:
SELECT First.cno, Second.pcno AS ������п� FROM course First, course Second WHERE First.pcno = Second.cno AND Second.pcno IS NOT NULL;

# 16. �г�����ѧ���Ļ��������ѡ�����, ��û��ѡ��,��ֻ�г����������Ϣ:
# SQL Server ��ʹ��������
SELECT s.sno, sname, ssex, sdept, cno, grade FROM student s LEFT JOIN sc sc ON s.sno = sc.sno;

# 17. ��ѯÿ��ѧ����ѧ��, ����, ѡ�޵Ŀγ����ͳɼ�:
SELECT S.sno, sname, cname, grade FROM student S, course C, sc SC WHERE S.sno = SC.sno AND C.cno = SC.cno;


SELECT
    s.sno,           -- ѧ��ѧ��
    s.sname,         -- ѧ������
    c.cname,         -- �γ�����
    sc.grade         -- �ɼ�
FROM
    student s       -- ѧ����
JOIN
    sc              -- ѡ�α�
ON
    s.sno = sc.sno  -- ����ѧ������
JOIN
    course c        -- �γ̱�
ON
    sc.cno = c.cno  -- ���ݿγ̺�����
WHERE
    sc.grade < 60;  -- ɸѡ������ĳɼ�

-- һ. ʹ�þۼ�������

-- 1. ��ѯѧ����������
SELECT COUNT(*) AS ѧ������ FROM student;

-- 2. ��ѯѡ���˿γ̵�ѧ��������
SELECT COUNT(DISTINCT sno) AS ѡ��ѧ������ FROM sc;

-- 3. ��ѯ���пγ̵���ѧ������ƽ��ѧ����, �Լ����ѧ�ֺ����ѧ�֣�
SELECT SUM(credit) AS ��credit, AVG(credit) AS �γ�ƽ��ѧ��, MAX(credit) AS ���ѧ��,
MIN(credit) AS ���ѧ�� FROM course;

-- 4. ����1�ſγ̵�ѧ����ƽ���ɼ�, ��߷ֺ���ͷ�:
SELECT AVG(grade) AS ƽ���ɼ�, MAX(grade) AS ��߷�, MIN(grade) AS ��ͷ�
FROM sc WHERE cno='1';

-- 5. ��ѯ����Ϣϵ��(IS)ѧ�������ݽṹ���γ̵�ƽ���ɼ�:
SELECT AVG(grade) FROM student, course, sc
WHERE student.sno=sc.sno AND course.cno=sc.cno AND sdept='IS' AND cname='���ݽṹ';

-- ��. �����ѯ

-- 6. ��ѯ��ϵ��ѧ�����������������Ӷൽ������ :
SELECT sdept, COUNT(*) AS ���� FROM student GROUP BY sdept ORDER BY ���� DESC;

-- 7. ��ѯ��ϵ����Ů��ѧ������, ����ϵ��,��������, Ů������ǰ:
SELECT sdept, ssex, COUNT(*) AS ���� FROM student GROUP BY sdept, ssex ORDER BY sdept, ssex DESC;

-- 8. ��ѯѡ����3�ſγ����ϵ�ѧ����ѧ�ź�����:
SELECT sno, sname FROM student WHERE sno IN
(SELECT sno FROM sc GROUP BY sno HAVING COUNT(*) > 3);

-- 9. ��ѯÿ��ѧ����ѡ�γ̵�ƽ���ɼ�, ��߷�, ��ͷ�,��ѡ������:
SELECT sno, AVG(grade) AS ƽ���ɼ�, MAX(grade) AS ��߷�, MIN(grade) AS ��ͷ�,
COUNT(*) AS ѡ������ FROM sc GROUP BY sno;

-- 10. ��ѯ����ѡ����2�ſγ̵�ѧ����ƽ���ɼ�:
SELECT sno, AVG(grade) AS ƽ���ɼ� FROM sc GROUP BY sno HAVING COUNT(*) >= 2;

-- 11. ��ѯƽ���ֳ���80�ֵ�ѧ����ѧ�ź�ƽ����:
SELECT sno, AVG(grade) AS ƽ���ɼ� FROM sc GROUP BY sno HAVING AVG(grade) >= 80;

-- �Ƚ�: ���ѧ����60�����Ͽγ̵�ƽ����:
SELECT sno, AVG(grade) AS ƽ���ɼ� FROM sc WHERE grade >= 60 GROUP BY sno;

-- 12. ��ѯ����Ϣϵ��(IS)��ѡ����5�ſγ����ϵ�ѧ����ѧ��:
SELECT sno FROM sc WHERE sno IN (SELECT sno FROM student WHERE sdept='IS')
GROUP BY sno HAVING COUNT(*) >= 5;

-- ��. ���ϲ�ѯ

-- 13. ��ѯ��ѧϵ����Ϣϵ��ѧ������Ϣ;
SELECT * FROM student WHERE sdept='MA'
UNION
SELECT * FROM student WHERE sdept='IS';

-- 14. ��ѯѡ����1�ſγ̻�2�ſγ̵�ѧ����ѧ��:
SELECT sno FROM sc WHERE cno='1'
UNION
SELECT sno FROM sc WHERE cno='2';



-- 1. ��ѯƽ���ɼ�����70�ֵ�ѧ��ѧ��

-- ����һ��ʹ��GROUP BY��HAVING
SELECT sno
FROM sc
GROUP BY sno                -- ��ѧ��ѧ�ŷ���
HAVING AVG(grade) < 70;    -- ɸѡ��ƽ���ɼ�С��70�ֵ�ѧ��


-- ��������ʹ���Ӳ�ѯ
SELECT DISTINCT sno
FROM sc a
WHERE (SELECT AVG(grade)
       FROM sc
       WHERE sno = a.sno) < 70;  -- ɸѡ��ƽ���ɼ�С��70�ֵ�ѧ��


-- 2. ���ϵ�ġ����ݿ⡱�γ̵ĳɼ���ߵ�ѧ���������ͳɼ�
SELECT A.sname, B.grade
FROM student A, sc B
WHERE A.sno = B.sno
  AND B.grade IN (               -- ���ҳɼ��������Ӳ�ѯ����е�ѧ��
      SELECT MAX(B2.grade)
      FROM sc B2, course C, student S
      WHERE S.sno = B2.sno
        AND B2.cno = C.cno
        AND C.cname = '���ݿ�'
        AND S.sdept = A.sdept    -- ȷ����ѧ����ϵ��һ��
  );


##PPTʵ�������֣�
-- һ. ʹ�ô�INν�ʵ��Ӳ�ѯ

-- 1. ��ѯ�롯��������ͬһ��ϵѧϰ��ѧ������Ϣ:
SELECT * FROM student
WHERE sdept IN
    (SELECT sdept FROM student WHERE sname='����');

-- �Ƚ�: ʹ��=���Ӳ�ѯ
SELECT * FROM student
WHERE sdept =
    (SELECT sdept FROM student WHERE sname='����');

-- �Ƚ�: ������'����'
SELECT * FROM student
WHERE sdept =
    (SELECT sdept FROM student WHERE sname='����') AND sname <> '����';

-- �Ƚ�: ���Ӳ�ѯ
SELECT S1.*
FROM student S1, student S2
WHERE S1.sdept = S2.sdept AND S2.sname = '����';

-- 2. ��ѯѡ���˿γ���Ϊ����Ϣϵͳ�� ��ѧ����ѧ�ź�����:
SELECT sno, sname
FROM student
WHERE sno IN (
    SELECT sno FROM sc WHERE cno IN (
        SELECT cno FROM course WHERE cname = '��Ϣϵͳ'
    )
);

-- 3. ��ѯѡ���˿γ̡�1���Ϳγ̡�2����ѧ����ѧ��:
SELECT sno
FROM student
WHERE sno IN (
    SELECT sno FROM sc WHERE cno = '1'
) AND sno IN (
    SELECT sno FROM sc WHERE cno = '2'
);

-- �Ƚ�: ��ѯѡ���˿γ̡�1����γ̡�2����ѧ����sno:
SELECT sno
FROM sc
WHERE cno = '1' OR cno = '2';

-- �Ƚ�: ���Ӳ�ѯ
SELECT A.sno
FROM sc A, sc B
WHERE A.sno = B.sno AND A.cno = '1' AND B.cno = '2';

-- ��. ʹ�ô��Ƚ�������Ӳ�ѯ

-- 4. ��ѯ�ȡ�����������С������ѧ������Ϣ:
SELECT * FROM student
WHERE sage <
    (SELECT sage FROM student WHERE sname='����');

-- ��. ʹ�ô�Any, Allν�ʵ��Ӳ�ѯ

-- 5. ��ѯ����ϵ�б���Ϣϵ(IS)ĳһѧ������С��ѧ������������:
SELECT sname, sage
FROM student
WHERE sage < ANY
    (SELECT sage FROM student WHERE sdept = 'IS')
AND sdept <> 'IS';

-- 6. ��ѯ����ϵ�б���Ϣϵ(IS)ѧ�����䶼С��ѧ������������:
SELECT sname, sage
FROM student
WHERE sage < ALL
    (SELECT sage FROM student WHERE sdept = 'IS')
AND sdept <> 'IS';

-- 7. ��ѯ������ϵ(CS)ϵ����ѧ�����������ͬ��ѧ��ѧ��, ����������:
SELECT sno, sname, sage
FROM student
WHERE sage <> ALL
    (SELECT sage FROM student WHERE sdept = 'CS');

-- ��. ʹ�ô�Existsν�ʵ��Ӳ�ѯ������Ӳ�ѯ

-- 8. ��ѯ����������ѧ���������ͬ��ѧ��ѧ��, ����������:
SELECT sno, sname, sage
FROM student A
WHERE NOT EXISTS (
    SELECT * FROM student B
    WHERE A.sage = B.sage AND A.sno <> B.sno
);

-- 9. ��ѯ����ѡ����1�ſγ̵�ѧ������:
SELECT sname
FROM student
WHERE EXISTS (
    SELECT * FROM sc WHERE sno = student.sno AND cno = '1'
);

-- 10. ��ѯû��ѡ����1�ſγ̵�ѧ������:
SELECT sname
FROM student
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE sno = student.sno AND cno = '1'
);

-- 11. ��ѯѡ����ȫ���γ̵�ѧ������:
SELECT sname
FROM student
WHERE NOT EXISTS (
    SELECT * FROM course
    WHERE NOT EXISTS (
        SELECT * FROM sc WHERE sno = student.sno AND cno = course.cno
    )
);

-- 12. ��ѯ����ѡ����ѧ��95002ѡ�޵�ȫ���γ̵�ѧ����ѧ��:
SELECT DISTINCT sno
FROM sc A
WHERE NOT EXISTS (
    SELECT * FROM sc B
    WHERE sno = '95002' AND NOT EXISTS (
        SELECT * FROM sc C WHERE sno = A.sno AND cno = B.cno
    )
);

-- 13. ��û����ѡ�޵Ŀγ̺�cno��cname:
SELECT cno, cname
FROM course C
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE sc.cno = C.cno
);

-- 14. ��ѯ����������(sno,cno)��, ���и�ѧ�ŵ�ѧ��û��ѡ�޸ÿγ̺�cno�Ŀγ�:
SELECT sno, cno
FROM student, course
WHERE NOT EXISTS (
    SELECT * FROM sc WHERE cno = course.cno AND sno = student.sno
);

-- 15. ��ѯÿ��ѧ���Ŀγ̳ɼ���ߵĳɼ���Ϣ(sno,cno,grade):
SELECT * FROM sc A
WHERE grade = (
    SELECT MAX(grade) FROM sc WHERE sno = A.sno
);

-- ˼��:
-- ��β�ѯ����ѧ����ѡ���˵Ŀγ̵Ŀγ̺�cno?
-- ʹ�����д���:
SELECT cno
FROM course
WHERE NOT EXISTS (
    SELECT * FROM student WHERE NOT EXISTS (
        SELECT * FROM sc WHERE sc.cno = course.cno AND sc.sno = student.sno
    )
);

#ʵ���� ����1
-- һ����ͼ�Ĵ�����

-- 1. ������Ϣϵѧ����Ϣ����ͼ
CREATE VIEW IS_Student AS
SELECT sno, sname, ssex, sage
FROM student
WHERE sdept = 'IS';

-- 2. ������Ϣϵѡ����1�ſγ̵�ѧ������ͼ
CREATE VIEW IS_S1 AS
SELECT student.sno, cno, grade
FROM student, sc
WHERE student.sno = sc.sno AND sdept = 'IS' AND cno = '1';

-- 3. ������Ϣϵѡ����1�ſγ��ҳɼ���90�����ϵ�ѧ������ͼ
CREATE VIEW IS_S2 AS
SELECT *
FROM IS_S1
WHERE grade >= 90;

-- 4. ����һ����ӳѧ��������ݵ���ͼ
CREATE VIEW BT_S(sno, sname, �������) AS
SELECT sno, sname, YEAR(GETDATE()) - sage
FROM student;

-- 5. ������Ů���ļ�¼����Ϊһ����ͼ
CREATE VIEW F_student AS
SELECT *
FROM student
WHERE ssex = 'Ů';

-- 6. ������ѧ����ѧ�ź�����ƽ���ɼ�����Ϊһ����ͼ
CREATE VIEW S_G(sno, avg_grade) AS
SELECT sno, AVG(grade)
FROM sc
GROUP BY sno;

-- ������ͼ�ṹ���޸ģ�

-- 7. ����ͼF_student�޸�Ϊ��Ϣϵ������Ůʿ����ͼ
ALTER VIEW F_student AS
SELECT *
FROM student
WHERE ssex = 'Ů' AND sdept = 'IS';

-- ������ѯ��ͼ��

-- 8. ����Ϣϵ��ѧ����ͼ�в�ѯ����С��20���ѧ��
SELECT *
FROM IS_Student
WHERE sage < 20;

-- 9. ��ѯ��Ϣϵѡ����1�ſγ̵�ѧ��
SELECT sc.sno, sname
FROM IS_Student, sc
WHERE IS_Student.sno = sc.sno AND cno = '1';

-- 10. ����ͼS_G�в�ѯƽ���ɼ���90�����ϵ�ѧ����ѧ�ź�ƽ���ɼ�
SELECT *
FROM S_G
WHERE avg_grade >= 90;

-- �ġ�������ͼ��

-- 11. ����Ϣϵѧ����ͼIS_Student��ѧ��Ϊ��95002����ѧ��������Ϊ��������
UPDATE IS_Student
SET sname = '����'
WHERE sno = '95002';

-- �Ƚ�: ����䲻��ʵ�����ݵĸ���
-- UPDATE IS_Student SET sname = '����' WHERE sno = '95003';

-- 12. ����ͼF_Student�в���һ���µ�ѧ����¼
INSERT INTO F_student VALUES ('95029', '����', 'Ů', 20, 'IS');

-- 13. ɾ����ͼF_Student��ѧ��Ϊ95029��ѧ���ļ�¼
DELETE FROM F_student
WHERE sno = '95029';

-- �塢ɾ����ͼ��

-- 14. ɾ����ͼIS_S1
DROP VIEW IS_S1;

-- ˼��:
-- 1. ��������ѧ���Ļ�����Ϣ��ѡ����Ϣ����ͼ
CREATE VIEW All_Students_Info AS
SELECT student.sno, student.sname, student.ssex, student.sage, sc.cno, sc.grade
FROM student
JOIN sc ON student.sno = sc.sno;

-- 2. ����������ͼ��ѯ��ϵѧ�����Ź��ε�ƽ���ɼ�
SELECT sdept, cno, AVG(grade) AS avg_grade
FROM All_Students_Info
GROUP BY sdept, cno;

-- һ��ʵ��������

-- 1. ����student����ġ�sno���ֶ���Ϊ����
-- �������ڣ����������Լ��
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'student')
BEGIN
    ALTER TABLE student ADD CONSTRAINT pk_sno PRIMARY KEY (sno);
END
-- ��������ڣ��򴴽����趨����
ELSE
BEGIN
    CREATE TABLE student (
        sno CHAR(10) PRIMARY KEY, -- ѧ��
        sname CHAR(10),           -- ����
        ssex CHAR(2),             -- �Ա�
        sage INT,                 -- ����
        sdept CHAR(4)            -- ѧԺ
    );
END

-- 2. ������֤���ֶΣ���������Ψһ��
-- ����ǰӦɾ�����е����м�¼
DELETE FROM student; -- ɾ�����м�¼
ALTER TABLE student ADD id CHAR(18) UNIQUE; -- ������֤���ֶβ���ΪΨһ

-- 3. ����sc����ġ�sno���͡�cno������Ϊ����
-- �������ڣ�����Ӹ�������Լ��
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'sc')
BEGIN
    ALTER TABLE sc ADD CONSTRAINT PK_SnoCno PRIMARY KEY (sno, cno);
END
-- ��������ڣ��򴴽����趨��������
ELSE
BEGIN
    CREATE TABLE sc (
        sno CHAR(10),            -- ѧ��
        cno CHAR(3),             -- �γ̺�
        grade INT NULL,          -- �ɼ�
        CONSTRAINT PK_SnoCno PRIMARY KEY (sno, cno) -- ��������
    );
END

-- ������������

-- 4. ����ssex���ֶ�����Ϊֻ��ȡ���С�����Ů����ֵ
-- ����Ѵ��ڣ������Լ��
IF EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'student')
BEGIN
    ALTER TABLE student ADD CONSTRAINT CK_Sex CHECK (ssex IN ('��', 'Ů'));
END

-- 5. ����ѧ���ֶ�ֻ����������
ALTER TABLE student ADD CONSTRAINT CK_Sno_Format CHECK (sno NOT LIKE '%[^0-9]%'); -- ���ѧ�Ÿ�ʽ

-- 6. �������֤�ŵ������ʽ
ALTER TABLE student ADD CONSTRAINT CK_ID_Format CHECK (
    id LIKE '__________________' -- 18λ����
);

-- 7. ����18λ���֤�ŵĵ�7λ����10λΪ�Ϸ������(1900-2050)
ALTER TABLE student ADD CONSTRAINT CK_ID_Format2 CHECK (
    LEN(id) = 18 AND
    CAST(SUBSTRING(id, 7, 4) AS SMALLINT) BETWEEN 1900 AND 2050
);

-- ��������������

-- 9. ��������������������22��Ů��������������20
ALTER TABLE student ADD CONSTRAINT CK_age CHECK (
    (ssex = '��' AND sage > 22) OR (ssex = 'Ů' AND sage > 20)
);

-- �ġ���������֤
-- ʵ�������Ե���֤ͨ�����Բ����ظ�ѧ��������
-- ����������������ִ�����ʾ
-- insert into student values('95001','����','��',20,'CS');
-- insert into student values('95001','����','Ů',18,'CS');
