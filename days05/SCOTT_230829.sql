-- 각 사원들의 급여
-- 각 사원들의 총 급여 합
-- 각 사원들 수
-- 각 사원들의 평균
SELECT SUM(sal + NVL(comm,0))pay
        , COUNT(sal + NVL(comm,0))count
        , SUM(sal + NVL(comm,0))/COUNT(sal + NVL(comm,0)) avg
        , AVG(sal + NVL(comm,0))avg_pay
        , MAX(sal + NVL(comm,0))max_oay
        , MIN(sal + NVL(comm,0))min_pay
        , STDDEV(sal + NVL(comm,0))stddev_pay --표준편차 : 분산의 제곱근
        , VARIANCE(sal + NVL(comm,0))variance_pay -- 분산 : (각사원 pay - avg_pay)^2 의평균
FROM emp;
-- [1]
SELECT name, ssn, NVL2(NULLIF(SUBSTR(SSN,8,1),'2'),'O','X')gender
FROM insa;
--[1-2]
WITH t AS (
SELECT name, ssn , MOd(SUBSTR(SSN,-7,1),2)gender
FROM insa
)
SELECT t.name, t.ssn, REPLACE(REPLACE(t.gender,1,'X'),0,'O')gender
FROM t;
--[1-3]
SELECT name, ssn, 'X'gender
FROM insa
WHERE SUBSTR(SSN,8,1) = '2'
UNION
SELECT name, ssn, 'O'gender
FROM insa
WHERE SUBSTR(SSN,8,1) = '1';
--[2]
SELECT name, ibsadate
FROM insa
WHERE EXTRACT(YEAR FROM ibsadate)=2000;
WHERE TO_CHAR(ibsadate,'YYYY')='2000';
WHERE ibsadate >= '2000.1.1';
--[4]
SELECT  ename, sal+NVL(comm,0)pay 
        , ROUND(avg_pay,2)avg_pay
        , CEIL((sal+NVL(comm,0)-avg_pay)*100)/100 AS "차 올림" 
        , ROUND(sal+NVL(comm,0)-avg_pay,2) AS "차 반올림"
        , TRUNC(sal+NVL(comm,0)-avg_pay,2) AS "차 내림"
FROM emp, (SELECT AVG(sal+NVL(comm,0))avg_pay FROM emp)e;

--[4-1]
WITH e AS (
SELECT ename,sal+NVL(comm,0)pay,(SELECT AVG( sal+NVL(comm,0)) FROM emp)avg_pay FROM emp
)
SELECT  ename,pay 
        , ROUND(avg_pay,2)avg_pay
        , CEIL((pay-avg_pay)*100)/100 AS "차 올림" 
        , ROUND(pay-avg_pay,2) AS "차 반올림"
        , TRUNC(pay-avg_pay,2) AS "차 내림"
FROM  e;

--[4-2]집합함수
SELECT  ename, sal+NVL(comm,0)pay 
        , ROUND(avg_pay,2)avg_pay
        , '많다'
FROM emp, (SELECT AVG(sal+NVL(comm,0))avg_pay FROM emp)e
WHERE sal+NVL(comm,0) > ROUND(avg_pay,2)
UNION
SELECT  ename, sal+NVL(comm,0)pay 
        , ROUND(avg_pay,2)avg_pay
        , '적다'
FROM emp, (SELECT AVG(sal+NVL(comm,0))avg_pay FROM emp)e
WHERE sal+NVL(comm,0) < ROUND(avg_pay,2);
--[4-2]
SELECT  ename, sal+NVL(comm,0)pay 
        , ROUND(avg_pay,2)avg_pay
        , NVL2(TO_CHAR(NULLIF(SIGN((sal+NVL(comm,0)-avg_pay)),-1)),'많다','적다')AS "급여-평균급여"
FROM emp, (SELECT AVG(sal+NVL(comm,0))avg_pay FROM emp)e;

--[4-2-1]
SELECT ename, pay, ROUND(avg_pay)avg_pay, NVL2(NULLIF(SIGN(pay-avg_pay),-1),'많다','적다') as "pay-avg_pay"
FROM (SELECT ename,sal+NVL(comm,0)pay,(SELECT AVG( sal+NVL(comm,0)) FROM emp)avg_pay FROM emp)e;
--[5]
SELECT CEIL(154/15)
FROM dual;
--[5-2]
SELECT CEIL(COUNT(*)/14)
FROM insa;
--[6] max() min()
SELECT empno,ename,job,MGR,hiredate, nvl(sal+comm,sal)PAY,deptno 
FROM emp 
where nvl(sal+comm,sal)IN((SELECT MAX(nvl(sal+comm,sal)) FROM emp), (SELECT MIN(nvl(sal+comm,sal)) FROM emp));
--[6] union 사용해서 하기

--[6] all연산자
SELECT empno,ename,job,MGR,hiredate, nvl(sal+comm,sal)PAY,deptno 
FROM emp 
WHERE nvl(sal+comm,sal) >= ALL(SELECT nvl(sal+comm,sal) FROM emp)
OR  nvl(sal+comm,sal) <= ALL(SELECT nvl(sal+comm,sal) FROM emp);
--[7]
SELECT ENAME, SAL,COMM
FROM emp
WHERE NVL(comm,0)<=400;
--[7-2] LNNVL() LNNVL(condition)
--Where 절의 조건이 true이거나 UNKNOWN이면 FALSE를 반환하고 조건이 false이면 TRUE를 반환한다

true -> false
null -> false
false -> true
;
SELECT ENAME, SAL,COMM
FROM emp
WHERE LNNVL(comm>400);

--[8]
select dname, ename, sal
from emp e, dept d
where (e.deptno, sal) in((select deptno, max(sal)
                            from emp e1
                            group by deptno))
and  e.deptno = d.deptno;

SELECT MAX(sal+NVL(comm,0))max_pay
FROM emp
GROUP BY deptno
ORDER BY deptno;

--[8-1]
SELECT *
FROM emp
WHERE sal in((SELECT max(sal)FROM emp GROUP BY deptno));
--[8-3] 상관서브 쿼리
SELECT *
FROM emp e
WHERE sal + NVL(comm,0) = (SELECT MAX(sal + NVL(comm,0)) FROM emp WHERE e.deptno = deptno);


--[8-2]groub by 안쓰고? union이나 and or 많이 쓰면 될듯?

--[9]
SELECT SUBSTR('031)1234-5678',INSTR('031)1234-5678',')')+1,INSTR('031)1234-5678','-')-INSTR('031)1234-5678',')')-1)
FROM dual;
--[12]
SELECT deptno, ENAME, sal+NVL(comm,0)PAY, ROUND(sal+NVL(comm,0),-2)/100 BAR_LENGTH,
        LPAD(' ',ROUND(sal+NVL(comm,0),-2)/100+1,'#')
FROM emp
WHERE deptno = 30
ORDER BY pay desc;
--[13]
SELECT name, ssn, RPAD(SUBSTR(ssn,1,8),length(ssn),'*')
FROM insa;
--[14]
SELECT SYSDATE -- 오라클 날짜 DATE   23/08/29
      , SYSTIMESTAMP -- 오라클 날짜 TIMESTAMP    23/08/29 14:29:49.396000000 +09:00
      , TRUNC( SYSDATE, 'YEAR' ) -- 23/01/01
      , TRUNC( SYSDATE, 'MONTH' )      --23/08/01
      , TRUNC( SYSDATE  ) --23/08/29 : 시간,분,초 절삭
FROM dual;
--TRUNC() : 절삭 함수, 숫자, 날짜, 특정 위치에서 절삭
--FLOOR() : 절삭 함수, 숫자, 소수점 1번째 자리에서 절삭

--[15]
WITH e AS (
SELECT ename,sal,comm,sal+NVL(comm,0)pay,(SELECT AVG( sal+NVL(comm,0)) FROM emp)avg_pay FROM emp
)
SELECT  SUM(pay)
FROM e
WHERE pay>=avg_pay;
--[16]
WITH e AS (
SELECT ename,sal+NVL(comm,0)pay ,5000 max_pay FROM emp
)
SELECT  ename,pay, max_pay, TO_CHAR(pay/max_pay*100)||'%' AS "퍼센트"
        , ROUND(pay/max_pay*100,-1)/10"별 갯수"
       , LPAD(' ',ROUND(pay/max_pay*100,-1)/10+1,'*')"별찍기"
FROM e;
----- 수정
WITH e AS (
SELECT  ename,sal+NVL(comm,0)pay 
        ,(SELECT MAX(sal+NVL(comm,0))FROM emp) max_pay
        , ((sal+NVL(comm,0))/5000)*100 AS percent 
FROM emp
)
SELECT  ename,pay, max_pay, TO_CHAR(percent)||'%' AS "퍼센트"
        , ROUND(percent,-1)/10"별 갯수"
        , LPAD(' ',ROUND(percent,-1)/10+1,'*')"별찍기"
        , RPAD( ROUND(percent,-1)/10,ROUND(percent,-1)/10+length(ROUND(percent,-1)/10),'*')"별갯수+별찍기"
FROM e;

--문제 : emp테이블의 pay 순으로 등수 매기기
SELECT t.*, (SELECT count(*)+1 FROM emp e where t.pay < e.sal+NVL(e.comm,0))pay_rank
FROM (SELECT ename, sal+NVL(comm,0)pay FROM emp)t
ORDER BY pay_rank;

----------------
--날짜 함수
--[1]SYSDATE : 년/월/일 시간/분/초 반환 기본출력은 일까지 TO_CHAR(date,'형식')를 사용해 시간/분/초 출력
SELECT SYSDATE  --23/08/29
    , TO_CHAR(SYSDATE,'YYYY/MM/DD AM HH24:MI:ss (DAY)')  -- 22023/08/29 오후 15:40:22 (화요일)
    , TO_CHAR(SYSDATE,'DS TS')  -- 2023/08/29 오후 3:32:35
     , TO_CHAR(SYSDATE,'DL')    -- 2023년 8월 29일 화요일
FROM dual;
-- 년 중 몇번 째 주 ww,  월 중 몇번 째 주 w,  년 중 몇번 째 주 : iw
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'WW') --  35 7일단위
    , TO_CHAR(SYSDATE, 'IW') -- 35  요일 단위
    , TO_CHAR(SYSDATE, 'W') -- 5
FROM dual;
-- [2]ROUND(날짜,[형식]) : 일을 반올림할 때 정오를 넘으면 다음날 자정을 출력하고, 넘지 않 으면 그 날 자정을 출력한다. 
--                    월을 반올림하는 경우는 15일 이상이면 다음 달 1일을 출력하고, 넘지 않으면 현재 달 1일을 출력한다. 
--                    년을 반올림하는 경우에는 6월을 넘으면 다음해 1월1일을 출력하고, 넘지 않으면 그 해 1월1일을 출력한다 .
SELECT SYSDATE
        , TO_CHAR(SYSDATE,'DL TS')  -- 2023년 8월 29일 화요일 오후 3:46:32
        ,ROUND(SYSDATE) -- 23/08/30  12시(정오)가 지나서 반올림하여 30일 
        ,ROUND(SYSDATE,'DD')    -- 23/08/30
        ,ROUND(SYSDATE,'MONTH') --23/09/01
        ,ROUND(SYSDATE,'YEAR') --24/01/01
FROM dual;

--[2]TRUNC(date) 날을 절삭하면 그날 자정을 출력하고, 월을 절삭하면 그 달 1일을 출력하고, 년을 절삭하면, 금년 1월1일을 출력한다.
-- 사용법은 ROUND와 동일
SELECT SYSDATE
        , TO_CHAR(SYSDATE,'DL TS')  -- 2023년 8월 29일 화요일 오후 3:46:32
        ,TRUNC(SYSDATE) -- 23/08/29
        ,TRUNC(SYSDATE,'DD')    -- 23/08/29
        ,TRUNC(SYSDATE,'MONTH') --23/08/01
        ,TRUNC(SYSDATE,'YEAR') --23/01/01
FROM dual;
--[3]MONTHS_BETWEEN(date1,date2) 두 개의 날짜간의 개월수를 리턴
    연산       결과      의 미 
날짜 + 숫자  =  날짜 날짜에 일수를 더하여 날짜 계산 
날짜 - 숫자  =  날짜 날짜에 일수를 감하여 날짜 계산 
날짜 + 숫자/24 = 날짜 날짜에 시간을 더하여 날짜 계산 
날짜 - 날짜  =  일수  날짜에 날짜를 감하여 일수 계산 
;
-- emp 사원들의 근무일수, 근무개월수, 근무년수
SELECT ename, hiredate
        , SYSDATE
        , ROUND(SYSDATE - hiredate)근무일수 -- 날짜 - 날짜 = 일수
        , ROUND(MONTHS_BETWEEN(SYSDATE,hiredate),1)근무개월
        , ROUND(MONTHS_BETWEEN(SYSDATE,hiredate)/12,1) 근무년수
FROM emp;
 -- 1시간후
 SELECT SYSDATE
        , TO_CHAR(SYSDATE, 'TS') --오후 4:15:25
        , SYSDATE +1  --하루 후
        , SYSDATE + 10 -- 23/09/08 10일 후
        , TO_CHAR(SYSDATE + 1/24,'TS') --오후 5:15:25
 FROM dual;
 -- [4]ADD_MONTHS(date, month) :  특정 개월 수를 더한 날짜를 출력하는 함수
SELECT SYSDATE --23/08/29
        , ADD_MONTHS(SYSDATE,3) -- 23/11/29 3개월 후
        , ADD_MONTHS(SYSDATE,-1) -- 23/07/29 1개월 전
FROM dual;
 --[5]LAST_DAY(date) : 해당 날짜가 속한 달의 마지막 날짜를 반환
 SELECT SYSDATE a--23/08/29
        , LAST_DAY(SYSDATE) -- 23/08/31 현재 날짜가 있는달의 마지막 날짜
        , TO_CHAR(LAST_DAY(SYSDATE),'DD DY') -- 31 목 이번 달의 마지막 날짜와 요일
        , TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DY') -- 이번달 1일의 요일 화
        --, TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1,'DY')
 FROM dual;
 -- [6]NEXT_DAY(date,char) date로부터 그 다음주 char로 명시한 요일을 출력
 SELECT TO_CHAR(SYSDATE,'DL') -- 2023년 8월 29일 화요일
        , NEXT_DAY(SYSDATE,'금요일') --23/09/01
 FROM dual;
 --datetime 종류
 --CURRENT_DATE
 SELECT SYSDATE --23/08/29
        , CURRENT_DATE  --23/08/29
 FROM dual;
 
 
 
 --변환 함수의 종류 : 사용자에 의해서 명시적으로 데이터 타입을 변환해주는 함수
--[1] TO_NUMBER() 문자 타입을 숫자 타입으로 변환
SELECT '100', TO_NUMBER('100')
FROM dual;
--[2] TO_CHAR() : 숫자, 날짜 타입을 문자 타입으로 변환
-- TO_CHAR( n [,'fmt' [,'nlsparam']])
--[3] TO_DATE() : 숫자, 문자 타입을 날짜 타입으로 변환
-- TO_DATE( char [,'fmt' [,'nlsparam']])
-- 문제: 개강일(23.7.13(목)) 로부터 100일 되는날
 SELECT  TO_CHAR(TO_DATE('23.7.13(목)','YY.MM.DD(DY)')+100,'DL')
 FROM dual;
 
 --시험
 --일반함수
 -- DECODE() == if()
 -- DECODE(expr,  search1,result1 [,search2,result2,...] [,default] );
 -- 여러개의 조건을 주어 조건에 맞을 경우 해당 값을 반환
 -- 비교 연산은 '='만 가능하다.
 -- select시의 decode 사용은 from 절만 빼고 어디에서나 사용할 수 있다.
 -- PL/SQL 안에서 사용 할 수 있는 함수
 -- 자바
 /*
 IF (x == 10){ 
  RETURN C;
}else{
  return D
  }
오라클 DECODE() 함수
DECODE(x,10,C,D)
 
 자바 else if
 if( A == B){
    return T;
 }else if(A == C){
    return F;
 }else {
    return X;
 }
 오라클 DECODE() 함수
 DECODE(A,B,T,C,F,X)
 */
 -- insa 테이블의 주민등록 번호를 가지고 "남자" "여자" 출력
 SELECT name,ssn, DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자','여자')gender
 FROM insa;
 -- 문제 emp테이블에서 10번 부서원 급여 15%인상, 20번 부서는 급여 30% 인상, 그외부서는 5%인상 출력 : 부서번호 사원명 급여 인상급여 인상액
 SELECT e.*, DECODE(deptno,10,pay*1.15,20,pay*1.3,pay*1.05)인상급여, DECODE(deptno,10,pay*0.15,20,pay*0.3,pay*0.05)인상액
 FROM (SELECT deptno, ename, sal+NVl(comm,0)pay FROM emp)e;
 
  
 -- WW/W/IW차이   WW = 7일 기준 IW = 일~월 기준 