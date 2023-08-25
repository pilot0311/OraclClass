--키워드(예약어) 테이블
SELECT * FROM DICTIONARY where table_name like '%WORDS%';

SELECT * FROM V$RESERVED_WORDS;

-- table or view does not exist  scott.emp는 가능  sys는 모든계정에 접근권한 있음
-- 스키마.객체명 -> 별명 (시노님)
SELECT *
FROM scott.emp;
FROM emp;

SELECT *
FROM dba_tables
WHERE OWNER = 'SCOTT';

-- PUBLIC 시노님 생성 [PUBLIC 시노님]의 생성, 삭제는 DBA만 가능
--1)DBA로 접속
--2)시노님 생성 
-- 형식
--CREATE [PUBLIC] SYNONYM [schema.]synonym명
--  	FOR [schema.]object명;

CREATE PUBLIC SYNONYM arirnag
  	FOR scott.emp;
--3) 생성된 시노님에 대해 객체 소유자로 접속한다. - scott
SELECT *
FROM arirnag;

-- PUBLIC SYNONYM 삭제
DROP PUBLIC SYNONYM arirnag;


--시노님 정보 조회
SELECT *
FROM all_synonyms; -- 모든 시노님 정보
FROM user_synonyms; -- 사용자가 만든 시노님 정보
