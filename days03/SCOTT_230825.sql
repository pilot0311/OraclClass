SELECT
    job,
    COUNT(job)
FROM
    emp
GROUP BY
    job;

SELECT
    deptno,
    ename,
    hiredate,
    sal,
    comm,
    nvl(sal + comm, sal) AS pay
FROM
    emp
WHERE
    comm IS NULL
ORDER BY
    deptno,
    pay DESC;

SELECT
    buseo,
    name,
    ssn,
    city
FROM
    insa
WHERE
    city NOT IN ( '서울', '경기', '인천' )
ORDER BY
    buseo,
    city;

SELECT
    deptno,
    ename,
    hiredate
FROM
    emp
WHERE
    deptno IN ( 10, 20 )
ORDER BY
    deptno;

SELECT
    buseo,
    name,
    basicpay + sudang AS pay
FROM
    insa
WHERE
    basicpay + sudang BETWEEN 2000000 AND 2500000
ORDER BY
    buseo,
    pay DESC;

WITH e AS (
    SELECT
        buseo,
        name,
        basicpay + sudang AS pay
    FROM
        insa
    WHERE
        basicpay + sudang BETWEEN 2000000 AND 2500000
)--, d AS
--(
--SELECT deptno, dname
--FROM dept
--)
SELECT
    buseo,
    name,
    pay
FROM
    e
ORDER BY
    buseo,
    pay DESC;
--인라인 뷰(INLINE VIEW) + with 시험
--FROM 절에서 서브쿼리를 사용하여 생성한 임시 뷰이다
-- 뷰: 일종의 가상 테이블
SELECT
    e.buseo,
    e.name,
    e.pay
FROM
    (
        SELECT
            buseo,
            name,
            basicpay + sudang AS pay
        FROM
            insa
    ) e --> 인라인 뷰 
WHERE
    e.pay BETWEEN 2000000 AND 2500000
ORDER BY
    e.buseo,
    e.pay DESC;

-- dual ?  power컬럼 1개, 레코드x
-- 오늘 날짜를 조회
SELECT
    sysdate
FROM
    dual;

SELECT
    EXTRACT(YEAR FROM sysdate),
    EXTRACT(MONTH FROM sysdate),
    EXTRACT(DAY FROM sysdate),
    to_char(sysdate, 'yy')
FROM
    dual;

SELECT
    empno,
    ename,
    hiredate,
    EXTRACT(YEAR FROM hiredate)
FROM
    emp;

-- 2사원 삭제
--DML : INSERT, UPDATE, DELETE + TCL : COMMIT, ROLLBACK
/*
DELETE 
FROM 테이블명
[WHERE 조건절]
*/
SELECT
    *
FROM
    emp;

DELETE FROM emp
WHERE
    empno IN ( 7876, 7788 );
--: 조건문 없으면 emp의 모든 절 삭제
COMMIT; -- 커밋시 롤백 불가
ROLLBACK;

SELECT
    empno,
    ename,
    hiredate
FROM
    emp
WHERE
    to_char(hiredate, 'yy') = '81'
ORDER BY
    hiredate;

SELECT
    empno,
    ename,
    hiredate
FROM
    emp
WHERE
    EXTRACT(YEAR FROM hiredate) = 1981
ORDER BY
    hiredate;

SELECT
    empno,
    ename,
    hiredate
FROM
    emp
WHERE
    substr(hiredate, 1, 2) = '81'
ORDER BY
    hiredate;
-- SUBSTR(문자열, 시작위치, 길이)
SELECT
    substr('abcdesfg', 3, 2), --3번째 글자부터 2글자
    substr('abcdefg', 3),   --  3번째 글자부터 끝까지
    substr('abcdefg', - 3, 2) --  뒤에서 3번째 글자부터 2글자
FROM
    dual;

-- 문제 insa 테이블에서 이름, 주민번호, 년도,월,일,성별,검증 조회 조회 주민번호가 721237-1*****
--replace(first_name, 'e', '*')
-- date 예약어 별칭으로 사용불가
SELECT
    name,
    ssn,
    concat(substr(ssn, 1, 8),
           translate(substr(ssn, 9),
                     '1234567890',
                     '**********')) AS rrn,
    substr(ssn, 1, 2)               AS year,
    substr(ssn, 3, 2)               AS month,
    substr(ssn, 5, 2)               AS "date",
    substr(ssn, 8, 1)               AS gender,
    substr(ssn, - 1, 1)
FROM
    insa;
-- 771212-[1]022432 출생년도 1900,1800,2000 + 77 --> 1977

--키워드(예약어) 테이블
SELECT
    *
FROM
    dictionary
WHERE
    table_name LIKE 'V$WORDS%';

SELECT
    *
FROM
    emp
WHERE
    mgr IS NULL;

SELECT
    *
FROM
    emp
WHERE
    mgr IS NOT NULL;

SELECT
    'AbCdE',
    upper('AbCdE'),
    lower('AbCdE'),
    initcap('AbCdE')
FROM
    dual;
--TO_CHAR(날짜)
--TO_CHAR(숫자)                   숫자가 문자열로 바뀜
SELECT
    name,
    basicpay + sudang                          AS pay,
    ibsadate,
    to_char(basicpay + sudang, 'L999,999,999') pay  -- 2810000 -> 2,810,000
FROM
    insa;

SELECT
    empno,
    ename,
    job,
    nvl(CAST(mgr AS VARCHAR(4)),
        'CEO') AS mgr,
    hiredate
FROM
    emp
WHERE
    mgr IS NULL;

SELECT
    empno,
    ename,
    job,
    nvl(to_char(mgr),
        'CEO') AS mgr,
    hiredate
FROM
    emp
WHERE
    mgr IS NULL;
    
    -- 오라클 자료형
    -- 오라클 연산자
        1) 산술 연산자: + - * /  나머지 구하는 연산자X 함수: mod()
SELECT
    1 + 2  -- 3
    ,1 - 2  -- -1
    ,1 * 2  -- 2
    ,1 / 2 d  -- 0.5
    --,2/0     -- 실수 divisor is equal to zero
    --,3.14/0  -- 정수 divisor is equal to zero
    --, 1%2   -- 나머지%X invalid characte
    ,MOD(1,2)as d   -- 1
FROM
    dual;
    
    --dual? -> PUBLIC SYNONYM    sys.객체명 == dual
--SCOTT 사용자가 소유하고 있는 테이블 조회
--dba_xxx, all_xxx, user_xxx 차이점 
SELECT *
FROM user_tables; -- 현재 사용자가 소유한 테이블 정보만 조회
FROM dba_tables;    -- DBA가 사용할 수 있는 모든 테이블 정보 조회
FROM all_tables;    -- 현재 사용자가 소유한 테이블 + 권한 부여된 테이블 정보를 조회
FROM user_tables;
    
SELECT SYSDATE, CURRENT_DATE
FROM dual;
    

--sys 시노님 생성에서 넘어옴
--3) 생성된 시노님에 대해 객체 소유자로 접속한다. - scott
--4) 시노님에 권한을 부여한다.

GRANT SELECT ON emp TO HR;

SELECT *
FROM arirnag;

2) ?? 연결 문자열
DROP TABLE 테이블명 CASCADE;    DDL 구문 자동생성 후 실행, PL/SQL 동적 쿼리

SELECT 'DROP TABLE ' || table_name || ' CASCADE'  -- 모든 테이블 삭제 동적 쿼리
FROM user_tables;
/*
DROP TABLE DEPT CASCADE
DROP TABLE EMP CASCADE
DROP TABLE BONUS CASCADE
DROP TABLE SALGRADE CASCADE
DROP TABLE INSA CASCADE
*/

--3) 사용자 정의 연산자
-- CREATE OPERATOR

--4) 계층적 질의 연산자  PRIOR, CONNECT_BY_ROOT가 계층적 질의 연산자임 

5) 비교 연산자 = != <> ^= > < >= <=
    SQL 연산자
    ANY, SOME
    ALL
-- 10, 20, 30 ,40
SELECT deptno
FROM dept;

SELECT *
FROM emp
WHERE deptno > SOME (SELECT deptno FROM dept);
WHERE deptno <= ANY (SELECT deptno FROM dept);  -- 하나라도 참이면 참
WHERE deptno <= ALL (SELECT deptno FROM dept);  -- 모두 참이여야 참
WHERE deptno 비교 연산자 ALL (서브쿼리);
WHERE deptno <= 10;

6) 논리 연산자: AND OR NOT

7) SQL 연산자
    (1) [NOT] IN(list)
    (2) [NOT] BETWEEN A and B
    (3) IS [NOT] NULL
    (4) ANY, SOME, ALL : WHERE절의 서브쿼리
    (5) EXISTS: 상관 서브쿼리 
    (6) 문자 패턴 검사 시 
        ㄱ.[NOT] LIKE 연산자
        - 문자 패턴 검색할 때 사용되는 SQL 연산자
        - 와일드 카드: %, _
        - % : 정규표현식 의 * 과 같음 임의의 문자가 0개 이상옴
        - _ : 임의의 문자 1개옴
        - 와일드 카드를 일반 문자 처럼 사용하고 싶을 때 ESCAPE옵션 사용
        ㄴ.REGEXP_LIKE 함수
            REGEXP_xxx : 정규표현식 사용하는 함수
        예) emp 사원테이블에 R 문자로 시작하는 사원을 검색
            insa테이블에 사원명이 '이'씨인 사원만 검색
             insa테이블에 사원명이 '이'가 들어간 사람 사원만 검색
             insa테이블에 사원명이 마지막에'이'가 들어간 사람 사원만 검색
            ;
            SELECT *
            FROM insa
            WHERE name LIKE '%이'; -- '이'로 끝나는
            WHERE name LIKE '%이%'; -- 어디에 있든 '이' 가 있으면 TRUE
            WHERE name LIKE '이%';   --%: 정규표현식 * 
            WHERE name LIKE '패턴 와일드카드 [% _]'; --LIKE연산자 사용
            WHERE SUBSTR(name, 1, 1) = '이';
            
            예)insa 테이블에 81년생 사원 정보 조회
            SELECT *
            FROM insa
            WHERE ssn LIKE '81%';
            
            문제) insa 테이블에서 남자 사원만 조회
            SELECT *
            FROM insa
            where ssn LIKE '%-1%';
            
            문제) 이름의 두 번쨰 글자가 '순'
            SELECT *
            FROM insa
            where name LIKE '_순%';
            
            --부서 정보 테이블
            -- deptno(부서 번호), dname(부서이름), loc(지역명)
            10	ACCOUNTING	NEW YORK
            20	RESEARCH	DALLAS
            30	SALES	CHICAGO
            40	OPERATIONS	BOSTON
            
            SELECT *
            FROM dept;
            
            -- 새로운 부서 추가
            -- DML - DELETE, UPDATE, INSERT + COMMIT, ROLLBACK
            INSERT INTO 테이블명 (칼럼명,칼럼명...) VALUES (값, 값,...);
            
            INSERT INTO dept (deptno, dname, loc) VALUES (50, '한글_나라', 'SEOUL');
            --unique constraint (SCOTT.PK_DEPT) violated 유일성 제약조건 위반: PRIMARY KEY: 중복 X
            INSERT INTO dept (deptno, dname, loc) VALUES (60, '한100%나', 'SEOUL');
            COMMIT;
            
            DESC dept;

            --검색 부서명에 '_나' 검색
            SELECT * 
            FROM dept; 
            WHERE dname LIKE '%\_나%' ESCAPE '\'; --ESCAPE \
            
            문제: 부서명에 % 검색
            SELECT * 
            FROM dept 
            WHERE dname LIKE '%\%%' ESCAPE '\'; --ESCAPE \
            
            -- 수정 DML - UPDATE
            UPDATE 테이블명
            SET 컬럼명= 변경할값[, 컬럼명= 변경할값,...]
            [WHERE 조건]; (where이 없으면 그 테이블의 모든 컬럼이 변경됨)
            ;
            UPDATE dept 
            SET LOC = 'KOREA'
            WHERE loc = 'SEOUL';
            COMMIT;
            
            DELETE FROM dept
            WHERE loc = 'KOREA';
            COMMIT;
            
            

SELECT * FROM user_tables;
-- 오라클 함수