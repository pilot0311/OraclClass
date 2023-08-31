--[1]
SELECT TO_CHAR(SYSDATE,'YYYY"년"MM"월"DD"일" AM HH24:MI:SS (DY)')
FROM dual;

--[2]
SELECT TO_DATE('2023.12.27')-TRUNC(SYSDATE),
       ABS(TRUNC(SYSDATE)-TO_DATE('2023.12.27'))
FROM dual;
--[3]
SELECT empno, TO_CHAR(empno,'099999'),
        LPAD(empno,6,0)
FROM emp;
--[4]
WITH temp AS (
SELECT deptno,empno, ename, sal+NVL(comm,0)pay 
FROM emp e
)
SELECT t.*,DECODE(t.deptno,10,pay*1.15,20,pay*1.3,pay*1.05)인상된급여
FROM temp t;
--[4-2]
WITH temp AS (
SELECT deptno,empno, ename, sal+NVL(comm,0)pay 
FROM emp e
)
SELECT t.*,CASE deptno
                WHEN 10 THEN pay*1.15
                WHEN 20 THEN pay*1.3
                ELSE pay*1.05
            END 인상된_급여
FROM temp t;

--[5]
SELECT d.deptno, COUNT(e.deptno)
FROM dept d LEFT JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno
HAVING COUNT(e.deptno)<=3;

SELECT d.deptno, COUNT(e.deptno)
FROM dept d , emp e
WHERE d.deptno = e.deptno(+)
GROUP BY d.deptno
HAVING COUNT(e.deptno)<=3;

--[5-2]
SELECT COUNT(DECODE(deptno,10,1)),
        COUNT(DECODE(deptno,20,2)),
        COUNT(DECODE(deptno,30,3)),
        COUNT(DECODE(deptno,40,4))
FROM emp;
--[7]
SELECT deptno, job, SUM(NVL(sal+comm,sal))sum_pay 
FROM emp
GROUP BY deptno,job
ORDER BY deptno;
--[8]
SELECT deptno, SUM(NVL(sal+comm,sal))sum_pay 
FROM emp
GROUP BY deptno
ORDER BY deptno;
--[8-2]
WITH temp AS (
SELECT deptno, sal+NVL(comm,0)pay 
FROM emp e
)
SELECT SUM(DECODE(t.deptno,10,pay)),
        SUM(DECODE(t.deptno,20,pay)),
        SUM(DECODE(t.deptno,30,pay))
FROM temp t;

--[9]
SELECT D.DEPTNO, J.JOB, COALESCE(SUM(E.SAL), 0) AS TOTAL_SALARY
FROM (SELECT  DISTINCT DEPTNO FROM EMP) D
CROSS JOIN (SELECT DISTINCT JOB FROM EMP) J
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO AND J.JOB = E.JOB
GROUP BY D.DEPTNO, J.JOB
ORDER BY D.DEPTNO, J.JOB;
--[9-t] ORACLE 10g [patition BY outer join] 구문
WITH j AS(
SELECT DISTINCT job
FROM emp
)
SELECT deptno,j.job, NVL(SUM(NVL(sal+comm,sal)),0)sum_pay
FROM j LEFT OUTER JOIN emp e PARTITION BY (e.deptno) ON j.job = e.job
GROUP BY deptno,j.job
ORDER BY deptno;


--[10]
SELECT empno, dname, ename, hiredate
FROM emp e JOIN dept d ON e.deptno=d.deptno;

--[11]
 SELECT buseo,COUNT(*)gender
 FROM insa
 WHERE MOD(SUBSTR(ssn,8,1),2)=0
 GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2)
 HAVING COUNT(*)>=5
 ORDER BY buseo;
 
 -----------------------------------------------------
 SELECT *
 FROM emp;
 
 SELECT *
 FROM salgrade;
 
 SELECT deptno,ename,sal,
        CASE
            WHEN sal>= 700 AND sal<=1200 THEN 1
            WHEN sal BETWEEN 1201 AND 1400 THEN 2
            WHEN sal BETWEEN 1401 AND 2000 THEN 3
            WHEN sal BETWEEN 2001 AND 3000 THEN 4
            WHEN sal BETWEEN 3001 AND 9999 THEN 5
        END grade
 FROM emp;
 -- join
 -- NON-EQUI JOIN : JOIN ∼ ON BETWEEN a AND b
 -- 관계되는 컬럼이 정확히 일치하지 않는 경우에 사용되는 JOIN의 형태이다.
 -- WHERE 절에 BETWEEN ... AND ... 연산자를 사용한다.
 -- 오라클에서는 ON 절을 이용하여 NON-EQUI JOIN과 동일한 역할을 수행한다.

-- NON-EQUI JOIN
 SELECT deptno, ename, sal, 
        losal||'~'||hisal
        ,grade
 FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
 
 SELECT deptno, ename
 FROM emp
 ORDER BY deptno;
 
 --LISTAGG()
 SELECT d.deptno,
        LISTAGG(NVL(ename,'사람없음'),'/') WITHIN GROUP(ORDER BY sal)AS enmae
 FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
 GROUP BY d.deptno;
 
 -- GROUPING SETS 절
 -- 예) GROUP BY exp1
 --     UNION ALL
 -- 예) GROUP BY exp2
 --> GROUPING SETS(exp1,exp2)
 
 SELECT deptno, COUNT(*)
 FROM emp
 GROUP BY deptno;
 --UNION ALL
 SELECT job, COUNT(*)
 FROM emp
 GROUP BY job;
 
 --GROUPING SETS 절
 SELECT deptno, job,COUNT(*)
 FROM emp
 GROUP BY GROUPING SETS(deptno, job);
 
 -- emp테이블에서 급여를 가장 많이 받는 사원 정보 조회
 SELECT deptno,empno,ename,sal+NVL(comm,0)pay
 FROM emp
 WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) FROM emp);
 WHERE sal+NVL(comm,0) >= ALL(SELECT sal+NVL(comm,0) FROM emp);
 
 
 --RANK 순위 함수
 -- TOP-N 분석 : top-N 분석은 최대값이나 최소값을 가진 컬럼을 질의할 때 유용하게 사용되는 분석방법이다.
 -- inline view에서 ORDER BY 절을 사용할 수 있으므로 데이터를 원하는 순서로 정렬도 가능하다.
 -- ROWNUM 컬럼은 subquery에서 반환되는 각 행에 순차적인 번호를 부여하는 pseudo(의사, 가짜) 컬럼이다.
 -- n값은 < 또는 >=를 사용하여 정의하며, 반환될 행의 개수를 지정한다.
 -- 1) ORDER BY 정렬된 인라인뷰
 -- 2) ROWNUM 의사칼럼: 행마다 순서대로 번호를 부여하는 칼럼
 -- 3) WHERE 조건절 <, <=  

 SELECT rowid,rownum,ename
 FROM emp;
 -- emp테이블에서 급여를 가장 많이 받는 사원 정보 조회
 --TOP-5
 SELECT ROWNUM, e.*
 FROM (
        SELECT deptno,ename,hiredate, sal+NVL(comm,0)pay
        FROM emp
        ORDER BY pay DESC
 ) e
 WHERE ROWNUM >= 1;
  --WHERE ROWNUM BETWEEN 3 AND 5;  xx 주의 : 무조건 첫번쨰 부터 출력하기에 중간 부터 가져올수없음 
  
 --RANK()
 -- 이 함수는 그룹 내에서 위치를 계산하여 반환한다.
 -- 해당 값에 대한 우선순위를 결정(중복 순위 계산함)
 -- 반환되는 데이터타입은 NUMBER이다.
 -- 종류
 --1) RANK()
 --2) DENSE_RANK
 --3) PERCENT_RANK
 --4) FIRST, LAST
 --5) ROW_NUMBER :  ROW_NUMBER () OVER ([query_partition_clause] order_by_clause )                
 --     ㄴ   이 함수는 분석(analytic) 함수로서, 분할별로 정렬된 결과에 대해 순위를 부여하는 기능이다.
 --         분할은 전체 행을 특정 컬럼을 기준으로 분리하는 기능으로 GROUP BY 절에서 그룹화하는 방법과 같은 개념이다.
 --HR 계정
 SELECT ROW_NUMBER() OVER (ORDER BY salary DESC),first_name,salary
 FROM  employees;
-- SCOTT계정 
SELECT e.*
FROM(
SELECT deptno, ename, sal+NVL(comm,0)pay,
        ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC)rank
FROM emp
) e
WHERE rank BETWEEN 3 AND 5;
WHERE rank <=3;
WHERE rank =1;

-- emp 테이블에서 각 부서별 최고 급여 받는 사원의 정보를 조회

SELECT e.*, d.dname
FROM(
SELECT deptno, ename, sal+NVL(comm,0)pay,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC)rank
FROM emp

) e JOIN dept d ON e.deptno = d.deptno
WHERE rank = 1;
--
SELECT t.*
FROM (
SELECT d.deptno,dname,ename,sal+NVL(comm,0)pay,hiredate,grade,
        ROW_NUMBER() OVER(PARTITION BY d.deptno ORDER BY sal+NVL(comm,0) DESC)rank
FROM dept d JOIN emp e ON d.deptno = e.deptno JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
)t
WHERE rank = 1;
--
-- RANK(), DENSE_RANK() 중복순위 계산O/중복순위 계산X
-- RANK() OVER( [query_partition_clause] order_by_clause)
--그룹 내에서 차례로 된 행의 rank를 계산하여 NUMBER 데이터타입으로 순위를 반환한다.
--해당 값에 대한 우선순위를 결정

SELECT empno,ename,sal,
        ROW_NUMBER()OVER(ORDER BY sal DESC)rn_rank,
        RANK()OVER(ORDER BY sal DESC)r_rank,
        DENSE_RANK()OVER(ORDER BY sal DESC)dr_rank
FROM emp;

SELECT empno,ename,sal,
        ROW_NUMBER()OVER(PARTITION BY deptno ORDER BY sal DESC)rn_rank,
        RANK()OVER(PARTITION BY deptno ORDER BY sal DESC)r_rank,
        DENSE_RANK()OVER(PARTITION BY deptno ORDER BY sal DESC)dr_rank
FROM emp;

-- [내일 문제] emp 테이블에서 각 사원 급여를 부서 순위, 사원 전체의 순위
SELECT e.deptno,ename,NVL(sal+comm,sal)pay,
        RANK()OVER(PARTITION BY e.deptno ORDER BY NVL(sal+comm,sal) DESC)r_rank,
        RANK()OVER( ORDER BY NVL(sal+comm,sal) DESC)all_rank
FROM emp e
ORDER BY deptno;

-- insa 사원수 출력
-- 남자 사원수 : 31
-- 여자 사원수 : 29
-- 전체 사원수 : 60

SELECT  DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남자','여자')||'사원수' gender,
        COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1),2);

--ROLLUP, CUBE 함수 : ROLLUP은 GROUP BY 절의 그룹 조건에 따라 전체 행을 그룹화 하고, 각 그룹에 대해 부분합을 구하는 연산자이다.
-- GROUP BY [ROLLUP ? CUBE]그룹핑하고자하는 컬럼명,...
-- GROUPING SETS 도 GROUP BY 절에 사용
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남자',0,'여자','전체')||'사원수' gender,
        COUNT(*)
FROM insa
GROUP BY CUBE(MOD(SUBSTR(ssn,-7,1),2));
GROUP BY ROLLUP(MOD(SUBSTR(ssn,-7,1),2));

SELECT buseo,jikwi, sum(basicpay)sum_pay
FROM insa
GROUP BY CUBE(buseo, jikwi)
--GROUP BY buseo, ROLLUP(jikwi)
--GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo;

--문제 emp 테이블에서 가장빨리 입사한 사원과 가장 늦게 입사한 사원의 차이 일수
WITH h AS(
SELECT ename,hiredate,
    RANK()OVER(ORDER BY hiredate)rank
FROM emp
)
SELECT MAX(hiredate)-MIN(hiredate)
FROM h
WHERE rank = 1 OR rank = (SELECT COUNT(*) FROM emp);

--문제 : insa테이블에서 각 사원들의 만나이를 계산 해서 이름 ssn 만나이 출력
-- 1) ssn 주민등록 번호
-- 2) 올해년도 - 생일 생일 지났으면 -1
WITH birth AS(
SELECT name,ssn, CASE 
                    WHEN REGEXP_LIKE(SUBSTR(ssn,-7,1),'^[1256]') THEN '19'||SUBSTR(ssn,1,6)
                    WHEN REGEXP_LIKE(SUBSTR(ssn,-7,1),'^[3478]') THEN '20'||SUBSTR(ssn,1,6)
                    ELSE '18'||SUBSTR(ssn,0,6)
                 END yyyymmdd
FROM insa
)
SELECT name,ssn, FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(yyyymmdd))/12) age
FROM birth b;
-- 내가 한것 + 연나이 수정
WITH birth AS(
SELECT name,ssn, CASE 
                    WHEN REGEXP_LIKE(SUBSTR(ssn,-7,1),'^[1256]') THEN '19'||SUBSTR(ssn,1,6)
                    WHEN REGEXP_LIKE(SUBSTR(ssn,-7,1),'^[3478]') THEN '20'||SUBSTR(ssn,1,6)
                    ELSE '18'||SUBSTR(ssn,0,6)
                 END yyyymmdd
FROM insa
)
SELECT name,ssn, FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(yyyymmdd))/12) american_age,
        CASE
            WHEN SYSDATE - TO_DATE(SUBSTR(ssn,3,4),'MMDD') <0 THEN FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(yyyymmdd))/12)+1
            ELSE  FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(yyyymmdd))/12)
        END COUNT_age
FROM birth b;

SELECT SYSDATE - TO_DATE('0311','MMDD')
FROM dual;


-- 강사님이 하신것
SELECT t.name, t.ssn
    , t.now_year - t.birth_year + 
      CASE is_birth_check
        WHEN -1 THEN -1
        ELSE 0
      END american_age
    , t.now_year - t.birth_year + 1 counting_age
FROM (
    SELECT name, ssn
        , TO_CHAR(SYSDATE, 'YYYY') now_year
        , CASE  
             WHEN  SUBSTR(ssn, -7, 1) IN ( 1,2,5,6 ) THEN 1900
             WHEN  SUBSTR(ssn, -7, 1) IN ( 3,4,7,8 ) THEN 2000
             ELSE 1800
           END + SUBSTR(ssn, 0, 2) birth_year
        , SIGN( TRUNC(SYSDATE) - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD') ) is_birth_check
    FROM insa
) t;

--임의의 수
-- ORACLE : dbms_random 패키지
SELECT
        --SYS.dbms_random.value,  --0<=실수<1
        --SYS.dbms_random.value(0,100), --0<= 실수 <100
        --SYS.dbms_random.string('U',5), -- 대문자 5글자
        --SYS.dbms_random.string('L',5),   -- 소문자 5글자
        --SYS.dbms_random.string('A',5), -- 알파벳 대소문자 5
        --SYS.dbms_random.string('X',5), -- 알파벳 대문자 + 숫자 5
        SYS.dbms_random.string('T',5) --알파벳 대문자 + 특수 문자 5
FROM dual;

-- 0<=정수 <=100
-- 1<= lotto <=45
-- 150<= v 정수 <=200

SELECT
        FLOOR(SYS.dbms_random.value(0,101)),
        FLOOR(SYS.dbms_random.value(0,45))+1,
         FLOOR(SYS.dbms_random.value(150,200))
FROM dual;

-- 피봇(pivot)설명
-- ㄱ.
SELECT DISTINCT job
FROM emp;
--ㄴ. 각 job 몇명
SELECT  COUNT(DECODE(job,'CLERK',1))CLERK,
        COUNT(DECODE(job,'SALESMAN',1))SALESMAN,
        COUNT(DECODE(job,'PRESIDENT',1))PRESIDENT,
        COUNT(DECODE(job,'MANAGER',1))MANAGER,
        COUNT(DECODE(job,'ANALYST',1))ANALYST,
        COUNT(*)
FROM emp;

--ㄹ. PIVOT 사용
--      ㄴ(축을 중심으로 회전 시키다)
/* 형식
SELECT * 
  FROM (피벗 대상 쿼리문)
 PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))
*/
SELECT * 
  FROM (SELECT job  
         FROM emp
       )
   PIVOT(
         count(*)
          FOR job IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST'));
          
--예)
SELECT * 
  FROM (SELECT 
        job ,
        TO_CHAR(hiredate, 'FMMM') || '월' hire_month
         FROM emp
       )
   PIVOT(
         count(*)
          FOR hire_month IN ('1월', '2월')
        );

-- emp 테이블에서 (각부서별)각 job별로 인원수를 가로 출력

SELECT * 
  FROM (SELECT deptno,job  
         FROM emp
       )
   PIVOT(
         count(job)
          FOR job IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST'))
          ORDER BY deptno;

--40 ,0,0,0,0
SELECT *
  FROM (SELECT d.deptno,job  
         FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
       )
   PIVOT(
         count(job)
          FOR job IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST'))
          ORDER BY deptno;
                  
SELECT * 
FROM (
    SELECT 
    -- job, 
    deptno , sal, ename   
    FROM emp 
    )
PIVOT(
    MAX(sal) AS 최고액, MAX(ename) AS 최고급여자  FOR deptno IN ('10', '20', '30')
);