-- HR 계정이 소유하고 있는 샘플 테이블 조회
SELECT *
FROM user_tables;
-- 사원 정보를 저장하고 있는 테이블 
SELECT * FROM EMPLOYEES;
-- 사원 정보를 저장하고 있는 테이블 에서 first last name + 전체 이름 출력
SELECT first_name, last_name FROM EMPLOYEES;
SELECT first_name, last_name, concat(first_name, last_name) as name FROM EMPLOYEES;
SELECT first_name, last_name, first_name || ' ' || last_name as name FROM EMPLOYEES;
-- 오라클 =  '문자열'  '날짜형식'
--REGIONS
--COUNTRIES
--LOCATIONS
--DEPARTMENTS
--JOBS
--EMPLOYEES
--JOB_HISTORY

--table or view does not exist
-- emp테이블(객체)를 소유한 소유자도 아니고 SELECT권한도 X
SELECT *
FROM emp;
--HR의 테이블 구조 정리
SELECT * FROM tabs 