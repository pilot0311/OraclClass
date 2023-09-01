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
SELECT FLOOR( dbms_random.value( 100000,1000000 ) )
FROM dual;

--[12]
SELECT d.deptno
     , LISTAGG( NVL(ename,'사원없음') , '/') WITHIN GROUP ( ORDER BY ename )AS ename    
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno;

--[13]
SELECT MAX(sal),MIN(sal)
FROM emp
WHERE deptno = 30;

SELECT deptno,MAX(sal),MIN(sal)
FROM emp
GROUP BY deptno
HAVING deptno = 30;
--[13-2]
SELECT *
FROM emp
WHERE sal IN ((SELECT MAX(sal)FROM emp WHERE deptno = 30),(SELECT MIN(sal)FROM emp WHERE deptno = 30)) AND deptno =30;

WITH t AS (
SELECT MAX(sal)max,MIN(sal)min
FROM emp
WHERE deptno = 30
)
SELECT e.*
FROM emp e,t
WHERE sal IN(t.max,t.min) AND deptno = 30;

--[14]
SELECT *
FROM(
SELECT d.deptno,d.dname,COUNT(e.empno)사원수, RANK()OVER(ORDER BY COUNT(*) desc)rank
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno,d.dname
)t
WHERE rank IN(1,(SELECT COUNT(*) FROM dept));
--[1]
WITH temp AS (
 SELECT d.deptno,dname,COUNT(empno)cnt
 FROM emp e, dept d
 WHERE e.deptno(+) = d.deptno
 GROUP BY d.deptno,dname
)
SELECT *
FROM temp
WHERE cnt IN((SELECT MAX(cnt)FROM temp),(SELECT MIN(cnt)FROM temp));
--[2]
WITH a AS (
SELECT d.deptno,dname,COUNT(empno)cnt
FROM emp e, dept d
 WHERE e.deptno(+) = d.deptno
 GROUP BY d.deptno,dname
 ), b AS (
 SELECT MIN(cnt)mincnt,MAX(cnt)maxcnt
 FROM a
 )
 SELECT a.*
 FROM a,b
 WHERE a.cnt IN(b.maxcnt,b.mincnt);
 
 --[3]분석 함수 : FIRST, LAST
 -- 집계함수와 함께 사용되어 주어진 그룹에 대해 내부 적으로 순위를 매겨 결과를 산출
 WITH a AS (
 SELECT d.deptno,dname,COUNT(empno)cnt
 FROM emp e, dept d
 WHERE e.deptno(+) = d.deptno
 GROUP BY d.deptno,dname
 )
 SELECT 
    MIN(deptno)KEEP(DENSE_RANK FIRST ORDER BY cnt) AS deptno
    ,MIN(cnt)
    ,MAX(deptno)KEEP(DENSE_RANK LAST ORDER BY cnt) AS deptno
    ,MAX(cnt)
 FROM a;
 
SELECT COUNT(*)
FROM dept;

-------------------------
--[분석함수]: 테이블에 있는 행에 대해 특정 그룹별로 집계 값을 산출 할때 사용하는 함수
1) ROW_NUMBER()
2) RANK()
3) DENSE_RANK()
4) CUME_DIST(): 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
                분포도값(비율): 0<실수<=1
    예) 부서별 급여에 따른 누적 분포도 값 조회
    SELECT deptno, ename, sal
        , CUME_DIST()OVER(PARTITION BY deptno ORDER BY sal) dept_dist
    FROM emp;
5) PERCENT_RANK(): 해당 그룹 내의 백분위 순위
                    0<= 실수 <=1
                    백분위순위: 그룹 안에서 해당 로우(행)의 값보다 [작은 값의 비율]    
    SELECT deptno, ename, sal
        , PERCENT_RANK()OVER(PARTITION BY deptno ORDER BY sal) dept_per
    FROM emp;
    -- 비교
    SELECT deptno, ename, sal
        , PERCENT_RANK()OVER(PARTITION BY deptno ORDER BY sal) dept_per
        , CUME_DIST()OVER(PARTITION BY deptno ORDER BY sal) dept_dist
    FROM emp
    WHERE deptno = 30;
                PERCENT_RANK     CUME_DIST    
30	JAMES	950	    0	0.1666666666666666666666666666666666666667 (1/6)
30	WARD	1250	0.2(1/5)	0.5     (3/6)
30	MARTIN	1250	0.2(1/5)	0.5
30	TURNER	1500	0.6(3/5)	0.6666666666666666666666666666666666666667 (4/6)
30	ALLEN	1600	0.8(4/5)	0.8333333333333333333333333333333333333333 (5/6)
30	BLAKE	2850	1	1

6) NTILE(expr): 파티션 별로 expr에 명시된 만큼 분할한 결과를 반환 하는 함수
    분할 하는 수를 버킷(bucket)이라고 한다
    
    SELECT deptno,ename,sal
        , NTILE(4)OVER (ORDER BY sal)ntiles
    FROM emp;
    
    SELECT buseo,name,basicpay
        , NTILE(2)OVER(PARTITION BY buseo ORDER BY basicpay)
    FROM insa;
    
7) WIDTH_BUCKET(expr, min_value, max_value, num_bucket)
    NTILE() 함수와 유사한 함수
    차이점: (최소값, 최대값 설정가능)
    예)
    SELECT deptno, ename,sal
        , NTILE(4)OVER (ORDER BY sal ASC)ntiles
        , WIDTH_BUCKET(sal, 0, 5000, 4)withbuckets
    FROM emp;
    
8) LAG(expr, offset, default_value)
    : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조 할 때 사용하는 함수
    앞(선행 행)
   LEAD(expr, offset, default_value)
    : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조 할 때 사용하는 함수
    뒤 (후행 행)
    SELECT ename,hiredate,sal
        , LAG(sal,1,0)OVER(ORDER BY hiredate)AS prev_sal
        , LAG(sal,2,-1)OVER(ORDER BY hiredate)AS prev_sal
        , LEAD(sal,1,-1)OVER(ORDER BY hiredate)AS next_sal
    FROM emp
    WHERE deptno =30;

--
SELECT '***ADMIN***'
    ,REPLACE('***ADMIN***','*','')
    ,REPLACE('***AD**MIN***','*','')
    ,TRIM('*' FROM '***AD**MIN***')
    ,TRIM(' ' FROM '   AD**MIN   ')
FROM dual;

-- 오라클 자료형 --
1) CHAR[size[BYTE|CHAR]]
    CHAR == CHAR(1)
    CHAR(10)
    CHAR(10 byte)
    CHAR(10 char)    
    기본값 : 1
    size크기의 고정길이 문자 데이터
    1바이트 ~ 2000바이트
    
    이름 문자열: ename CHAR -> 1바이트라 3바이트인 한글 입력 불가
                ename CHAR(10) -> 10바이트 -> 만약 3바이트 만사용해도 남은 크기는 공백으로 가지고있음
                주민등록 번호같이 고정된 길이 입력시 사용
                ename CHAR(10 char)-> 영어 한글 관계 없이 10[문자] 입력가능
                
create table test (aa char, bb char(3), cc char(3 char));
DESC test;
AA    CHAR(1)      --1바이트
BB    CHAR(3)      --3바이트 
CC    CHAR(3 CHAR) -- 문자 3개

insert into test (aa,bb,cc) values('a','aaaa','aaaa'); --1바이트 4바이트 4바이트
--ORA-12899: value too large for column "SCOTT"."TEST"."BB" (actual: 4, maximum: 3) bb칼럼 최대 크기 3인데 4바이트 입력함
insert into test values('a','aaa','aaaa');
-- ORA-12899: value too large for column "SCOTT"."TEST"."CC" (actual: 4, maximum: 3)cc칼럼 최대 크기 3문자인데 4문자 입력함
insert into test values('a','aaa','aaa'); -- 정상 입력
insert into test values('b','욜','우리'); -- 정상 입력
insert into test values('c','우리','우리'); -- 한글은 한글자당 3바이트
--ORA-12899: value too large for column "SCOTT"."TEST"."BB" (actual: 6, maximum: 3) bb칼럼 크기 3바이트 입력문자 6바이트

COMMIT;
SELECT *
FROM test;
