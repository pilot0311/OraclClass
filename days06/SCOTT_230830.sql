--[1]
SELECT buseo, COUNT(*)c  
FROM insa e
GROUP BY buseo
ORDER BY c;
--GROUP BY에 없는 함수는 집계함수 외에는 올수 없다.
--[1-2]
SELECT distinct buseo,(SELECT COUNT(*)FROM insa s WHERE i.buseo=s.buseo)c
FROM insa i
ORDER BY c;

WITH m AS(
SELECT distinct buseo
FROM insa i
)
SELECT buseo,(SELECT COUNT(*)FROM insa s WHERE buseo=m.buseo)c
FROM m;
-- 추가 문제: insa테이블 에서 남자사원수, 여자 사원수 조회
-- 집계함수는 null 제외하고 계산, COUNT(*)만 null포함 계산
SELECT COUNT(DECODE(MOD(SUBSTR(ssn,-7,1),2),1,1))남자,
        SUM(DECODE(MOD(SUBSTR(ssn,-7,1),2),0,1))여자,
        COUNT(*)전체
FROM insa;
-- GROUP BY 사용
SELECT DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남자','여자')gender,COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn,-7,1),2);
-- 추가 풀이: emp테이블의 각 부서별 사원수
-- 1 GROUP BY deptno
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno
UNION
SELECT null, COUNT(*)
FROM emp;

--[2-3]
SELECT i.*, BASICPAY+SUDANG pay
FROM insa i
WHERE BASICPAY+SUDANG =((SELECT MAX(BASICPAY+SUDANG)FROM insa WHERE i.buseo = buseo));
--[2-2]
SELECT buseo, MAX(BASICPAY+SUDANG)
FROM insa
GROUP BY buseo;
--[2-1]
SELECT BUSEO,NAME,BASICPAY+SUDANG pay
FROM insa 
WHERE buseo = '총무부' AND BASICPAY+SUDANG >= (SELECT max(BASICPAY+SUDANG)FROM insa WHERE  buseo = '총무부')
UNION ALL
SELECT BUSEO,NAME,BASICPAY+SUDANG pay
FROM insa 
WHERE BASICPAY+SUDANG = (SELECT max(BASICPAY+SUDANG)FROM insa WHERE  buseo = '기획부')
UNION ALL
SELECT BUSEO,NAME,BASICPAY+SUDANG pay
FROM insa 
WHERE BASICPAY+SUDANG = (SELECT max(BASICPAY+SUDANG)FROM insa WHERE  buseo = '영업부');
--[3]
SELECT TO_CHAR(LAST_DAY(SYSDATE),'DD')
        , EXTRACT(DAY FROM LAST_DAY(SYSDATE))
FROM dual;
--[4]
SELECT NEXT_DAY(SYSDATE,'월')
FROM dual;
--[5]
SELECT HIREDATE, ADD_MONTHS(hiredate,125)+20  ADD_MONT
FROM emp
ORDER BY  ADD_MONT;

--[6]
UPDATE insa
SET ssn = SUBSTR(ssn,1,2)||TO_CHAR(SYSDATE,'MMDD')||SUBSTR(ssn,7)
WHERE num in(1001,1002);
commit;
ROLLBACK;

SELECT *
FROM insa;

SELECT name, ssn, ibsadate
FROM insa
WHERE num in(1001,1002);
--[6-2]
SELECT name, ssn, 
DECODE(SIGN(MONTHS_BETWEEN(TO_DATE(TO_CHAR(SYSDATE,'YY')||SUBSTR(SSN,3,4)),SYSDATE)),-1,'생일 후',1,'생일 전','생일')birth
FROM insa;

SELECT name, ssn, 
       SUBSTR(ssn,3,4)birth,
       TO_CHAR(SYSDATE,'MMDD')today,
       DECODE(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)),1,'생일 후',-1,'생일 전','생일')as "t-b"
FROM insa;


--[6-3]
SELECT 
    SUM(DECODE(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)), 1, 1)) AS "생일 후",
    SUM(DECODE(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)), 0, 1)) AS "오늘 생일",
    SUM(DECODE(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)), -1, 1)) AS "생일 전"
FROM insa i;
WITH temp AS(
SELECT SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4))s FROM insa
)
SELECT 
    COUNT(DECODE(s, 1, 1)) AS "생일 후",
    COUNT(DECODE(s, 0, 1)) AS "오늘 생일",
    COUNT(DECODE(s, -1, 1)) AS "생일 전",
    COUNT(*)"전체 수"
FROM temp;
    
SELECT 
    COUNT(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)))
FROM insa
GROUP BY SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4));
--[9]
SELECT 
         SYSDATE, TO_DATE('98/03/11')생년월일
        , ROUND(SYSDATE - TO_DATE('98/03/11'))일수
        , ROUND(MONTHS_BETWEEN(SYSDATE,TO_DATE('98/03/11')),1)개월수
        , ROUND(MONTHS_BETWEEN(SYSDATE,TO_DATE('98/03/11'))/12,1)년수
FROM dual;
--[10]
SELECT  SYSDATE,
        TO_CHAR(SYSDATE,'W'),
        TO_CHAR(SYSDATE,'WW'),
        TO_CHAR(TO_DATE('2022/1/1'),'IW'),
        TO_CHAR(TO_DATE('2022/1/1'),'WW'),
        TO_CHAR(TO_DATE('2022/1/2'),'IW'),
        TO_CHAR(TO_DATE('2022/1/2'),'WW'),
        TO_CHAR(TO_DATE('2022/1/3'),'IW'),
        TO_CHAR(TO_DATE('2022/1/3'),'WW'),
        TO_CHAR(TO_DATE('2022/1/8'),'IW'),
        TO_CHAR(TO_DATE('2022/1/8'),'WW')
FROM dual;
--[11]
SELECT  TO_CHAR(LAST_DAY(SYSDATE),'DD'),
        ADD_MONTHS(SYSDATE,1),
        TRUNC(ADD_MONTHS(SYSDATE,1),'MONTH')-1
FROM dual;

SELECT  TO_DATE('2022','YYYY'), --22/08/01
        TO_DATE('2022.02','YYYY.MM'), --22/02/01
        TO_DATE('03','MM') --23/03/01
FROM dual;
--[11-2]
SELECT TO_CHAR(SYSDATE, 'IW'),TO_CHAR(SYSDATE, 'W')
FROM dual;
--[12]
SELECT ename, NVL(sal+comm,sal), NVL2(comm,sal+comm,sal), COALESCE(sal+comm,sal)
FROM emp;
--[12-2]
SELECT ename, NVL(mgr,-1), NVL2(mgr,mgr,-1), COALESCE(mgr,-1)
FROM emp;
--[13]
SELECT name,ssn, DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자','여자')gender
 FROM insa;
 -- DECODE()확장 -> CASE
 /* 형식
 CASE 컬럼명|표현식 WHEN 조건1 THEN 결과1
			  [WHEN 조건2 THEN 결과2
                                ......
			   WHEN 조건n THEN 결과n
			  ELSE 결과4]
	END
*/
 --여러 개의 조건을 주어 조건에 맞을 경우 해당 값을 리턴하는 함수(DECODE의 확장임)
 -- CASE 함수에서는 산술연산, 관계연산, 논리연산과 같은 다양한 비교가 가능하다. 또한 WHEN 절에서 표현식을 다양하게 정의할 수 있다.
 -- CASE 표현식은 ANSI SQL 형식도 지원한다.
 -- 조건문가 조건문 사이에는 컴마를 사용하지 않는다.
 -- CASE 문은 반드시 END로 끝내야 한다.
 -- 결과를 기술해야 하는 부분은 NULL을 사용해서는 않된다.
 -- CASE 명령어 다음에 기술하는 컬럼명/표현식과 조건, 결과에 표현되는 데이터들은 모두 데이터 타입이 동일해야 한다
 SELECT name, ssn,
        CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '남자'
                                    --WHEN 0 THEN '여자'
                                    ELSE '여자'
        END gender,
        CASE
            WHEN  MOD(SUBSTR(ssn,8,1),2) = 1 THEN '남자'
            ELSE '여자'
        END gender
FROM insa;
-- 6-2번 문제 CASE 함수로 바꾸기     /6-3도 해보기
SELECT name, ssn, 
       TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4),
       CASE
            WHEN (TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)) >0 THEN '생일 후' 
            WHEN (TO_CHAR(SYSDATE,'MMDD') - SUBSTR(ssn,3,4)) <0 THEN '생일 전'
            ELSE '오늘 생일'
       END 
FROM insa;

 --[14]
 --전체 사원들의 급여 총합
 SELECT TO_CHAR(SUM(sal+NVL(COMM,0)),'L999,999')pay
 FROM emp;
 -- 평균 급여
 SELECT TO_CHAR(AVG(sal+NVL(comm,0)),'9999.00')avg_pay
 FROM emp;
 --평균 급여 이상인 사원들의 급여 총합(인라인 + 중첩 서브쿼리 사용)
 SELECT SUM(t.pay)
 FROM(
        SELECT empno,ename,sal+NVl(comm,0)pay
        FROM emp
        WHERE sal+NVl(comm,0) >= (
                                    SELECT AVG(sal+NVL(comm,0)) 
                                    FROM emp)
    )t;
 --평균 급여 이상인 사원들의 급여 총합(DECODE 사용)
 WITH temp AS (
 SELECT empno, ename , sal+NVl(comm,0)pay
        , (SELECT AVG(sal+NVl(comm,0)) FROM emp)avg_pay
 FROM emp
 )
 SELECT SUM(DECODE(SIGN(t.pay - t.avg_pay),-1,null,t.pay))avg_pay_total
 FROM temp t;
 --평균 급여 이상인 사원들의 급여 총합(CASE 사용)
 WITH temp AS (
 SELECT empno, ename , sal+NVl(comm,0)pay
        , (SELECT AVG(sal+NVl(comm,0)) FROM emp)avg_pay
 FROM emp
 )
 SELECT SUM(CASE
                WHEN t.pay - t.avg_pay >=0 THEN t.pay             
            END
            )avg_pay_total
 FROM temp t;
 
 --평균 급여 이상인 사원들의 급여 총합(join 안배움)
 WITH a AS(
 SELECT TO_CHAR(AVG(sal+NVL(comm,0)),'9999.00')avg_pay
 FROM emp
 ),
 b AS (
 SELECT empno,ename,sal+NVl(comm,0)pay
 FROM emp
 )
 SELECT *
 FROM b JOIN a   -- join
 ON b.pay >= a.avg_pay;
 
 --[15]
 SELECT deptno
 FROM dept d
 WHERE (SELECT COUNT(*) FROM emp WHERE deptno = d.deptno) != 0;
 --[15-1]
 SELECT deptno
 FROM dept d
 WHERE (SELECT COUNT(*) FROM emp WHERE deptno = d.deptno) = 0;
 
 SELECT deptno
 FROM dept
 MINUS
 SELECT DISTINCT deptno
 FROM emp;
 --JOIN : 같거나 서로 다른 두 개 이상의 테이블에서 컬럼을 검색할 때 사용한다. 이때, where절에 join 조건을 작성하여 테이블을 연결한다.
 --예 부서번호,부서명,사원번호,사원명,입사일자 조회(emp)
 SELECT e.deptno,d.dname, e.empno,e.ename,e.hiredate
 FROM emp e, dept d
 WHERE e.deptno = d.deptno;
 --GROUP BY e.deptno,d.dname;
 -- JOIN ON 구문 수정
 SELECT e.deptno,d.dname ,e.empno,e.ename,e.hiredate
 FROM emp e JOIN dept d
 ON e.deptno = d.deptno;

 SELECT d.deptno,d.dname ,e.empno,e.ename,e.hiredate
 FROM emp e JOIN dept d
 ON e.deptno = d.deptno;
 --[15] join으로 풀기
 --  EQUI(INNER) JOIN : 두 개 이상의 테이블에 관계되는 컬럼들의 값들이 일치하는 경우에 사용하는 가장 일반적인 join 형태임
 -- OUTER JOIN : 
 SELECT d.deptno,d.dname, COUNT(e.deptno)
 FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
 GROUP BY d.deptno,d.dname
 ORDER BY d.deptno;
 --
 SELECT d.deptno,d.dname, COUNT(e.deptno)
 FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
 GROUP BY d.deptno, d.dname
 HAVING COUNT(e.deptno)=0
 ORDER BY d.deptno;
 
 
 SELECT buseo, jikwi,DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자','여자')gender, COUNT(*)
 FROM insa
 GROUP BY buseo, jikwi, MOD(SUBSTR(ssn,8,1),2)
 ORDER BY buseo,jikwi;
 
 --[17] DECODE()
 SELECT e.*, DECODE(deptno,10,pay*1.15,20,pay*1.1,30,pay*1.05,pay*1.2)인상급여
 FROM (SELECT deptno, ename, sal+NVl(comm,0)pay FROM emp)e;
 -- CASE()
 SELECT e.*, CASE deptno
                WHEN 10 THEN pay*1.15
                WHEN 20 THEN pay*1.1
                WHEN 30 THEN pay*1.05
                ELSE pay*1.2
           END 인상급여
 FROM (SELECT deptno, ename, sal+NVl(comm,0)pay FROM emp)e;
 
 --[18]
 SELECT COUNT(DECODE(deptno,10,1)),COUNT(DECODE(deptno,20,1)),COUNT(DECODE(deptno,30,1)),COUNT(DECODE(deptno,40,1))
 FROM emp;
 
 