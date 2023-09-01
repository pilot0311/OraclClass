--[1]
SELECT t.*
FROM (
        SELECT e.*, RANK()OVER(ORDER BY sal DESC)rank FROM emp e
)t
WHERE rank <=(SELECT COUNT(*) FROM emp)*0.2;
--[2]
WITH a AS (
SELECT SUM(sal+nvl(comm,0))sum
FROM emp
)
SELECT e.ename ,e.sal+nvl(comm,0) pay,sum TOTALPAY,TO_CHAR(ROUND(((sal+nvl(comm,0))/sum)*100,2),'99.00')||'%' 비율
FROM emp e, a;
--[3]
WITH birth AS(
SELECT name,ssn, CASE 
                    WHEN SUBSTR(ssn, -7, 1) IN (1,2,5,6) THEN '19'||SUBSTR(ssn,1,6)
                    WHEN SUBSTR(ssn, -7, 1) IN (3,4,7,8) THEN '20'||SUBSTR(ssn,1,6)
                    ELSE '18'||SUBSTR(ssn,0,6)
                 END yyyymmdd
FROM insa
)
SELECT name,ssn, FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(yyyymmdd))/12) age
FROM birth b;
--[3] + 연나이
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
-- [4]
SELECT COUNT(*)총사원수,COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,1))남자사원수 ,
        COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,1))여자사원수,
        SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay))남사원들의_총급여합,
        SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay))여사원들의_총급여합,
        MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay))"남자-max",
        MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay))"여자-max"
FROM insa;

SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자',0,'여자','전체사원수')gender,COUNT(*)
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2))
UNION
SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자급여합',0,'여자급여합','전체사원수급여합'),SUM(basicpay)
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));

    
--[5]
SELECT t.*
FROM (
    SELECT  DEPTNO, ENAME,sal+NVL(comm,0)pay, RANK()OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0)desc)rank FROM emp e
)t
WHERE rank =1;

SELECT e.deptno, e.ename, e.sal+NVL(e.comm,0)pay
FROM(
SELECT deptno, MAX(sal+NVL(comm,0))max_pay
FROM emp
GROUP BY deptno
)t , emp e
WHERE t.deptno = e.deptno 
        AND t.max_pay= e.sal+NVL(e.comm,0)
ORDER BY e.deptno;
--[6]
SELECT deptno,COUNT(*),SUM(sal+NVL(comm,0)),ROUND(AVG(sal+NVL(comm,0)),2)
FROM emp
GROUP BY deptno
ORDER BY deptno;

--[7]

SELECT t.*
          , ROUND((부서사원수/총사원수)*100, 1) || '%' "부/전%"
          , ROUND((성별사원수/총사원수)*100, 1) || '%' "부성/전%"
          , ROUND((성별사원수/부서사원수)*100, 1) || '%' "성/부%"
   FROM (
          SELECT buseo
                 , (SELECT COUNT(*) FROM insa) "총사원수"
                 , (SELECT COUNT(*) FROM insa WHERE i.buseo=buseo) "부서사원수"
                 , DECODE(MOD(SUBSTR(ssn, 8, 1), 2), '1', 'M', 'F') "성별"
                 , COUNT(*) "성별사원수"
          FROM insa i
          GROUP BY buseo, MOD(SUBSTR(ssn, 8, 1), 2)
          ORDER BY buseo
   ) t;
   --
   SELECT temp.*
         , ROUND((부서사원수/총사원수)*100, 1) || '%' "부/전%"
         , ROUND((성별사원수/총사원수)*100, 1) || '%' "부성/전%"
         , ROUND((성별사원수/부서사원수)*100, 1) || '%' "성/부%"
   FROM(
   SELECT buseo 부서명
          ,(SELECT COUNT(*) FROM insa)총사원수
          ,(SELECT COUNT(*) FROM insa WHERE buseo = t.buseo)부서사원수
          ,gender 성별
          ,COUNT(*)성별사원수
          
   FROM(
   SELECT buseo, name, ssn, DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'M','F')gender
   FROM insa
   )t
   GROUP BY buseo,gender
   ORDER BY buseo
   )temp;
   
  --[8]
  WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(buseo)
FROM insa i PARTITION BY (i.buseo) RIGHT OUTER JOIN c   ON i.city = c.city
GROUP BY buseo, c.city
ORDER BY buseo,c.city; 
--
SELECT buseo, t.city, COUNT(*)
FROM insa i PARTITION BY (BUSEO) RIGHT JOIN (SELECT DISTINCT city FROM insa )t ON i.city = t.city
GROUP BY buseo,t.city
ORDER BY buseo, t.city;
 
 SELECT DISTINCT city
 FROM insa;
 
 --emp 테이블 job별 사원수 조회
 SELECT deptno,t.job, COUNT(empno)
 FROM  emp e  PARTITION BY (deptno) RIGHT JOIN (SELECT DISTINCT job FROM emp)t ON t.job = e.job
 GROUP BY e.deptno,t.job
 ORDER BY e.deptno,t.job;
-- [9-1] 
      SELECT
             COUNT (DECODE( job, 'CLERK', 1) ) CLERK
            ,COUNT (DECODE( job, 'SALESMAN', 1) ) SALESMAN
            ,COUNT (DECODE( job, 'PRESIDENT', 1) ) PRESIDENT
            ,COUNT (DECODE( job, 'MANAGER', 1) ) MANAGER
            ,COUNT (DECODE( job, 'ANALYST', 1) ) ANALYST
        FROM emp;
        
--[9-2]
SELECT *
FROM(SELECT job FROM emp
)
PIVOT(COUNT(*)
        FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST' )
);

--[10]
 SELECT *
 FROM(SELECT job,TO_CHAR(hiredate,'YYYY')h_year, TO_CHAR(hiredate,'MM')h_month FROM emp
 )
 PIVOT( COUNT(*)
  FOR h_month IN ( 1,2,3,4,5,6,7,8,9,10,11,12 ) 
 )ORDER BY job ASC;
--[11]
SELECT dbms_random.value
       , FLOOR( dbms_random.value( 100000,1000000 ) )
       , dbms_random.string('L', 5)
   FROM dual;