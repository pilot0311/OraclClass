-- 주석처리
-- 모든 사용자 계정을 조회하는 DQL문
SELECT * 
FROM dba_users;
FROM all_users;

-- 1) 관리자 접속
show user;

-- 2) scott 계정 tiger 비밀번호 새로운 사용자 계정 생성

CREATE USER scott IDENTIFIED BY tiger;

-- CREATE SESSION 시스템 권한 부여
-- 1) SYS계정 접속
SHOW user;

-- 2) 권한 부여
GRANT CREATE SESSION TO scott;
GRANT CONNECT, RESOURCE TO scott;
-- 3) 권한 회수
REVOKE CREATE SESSION From scott;

-- 미리 정의된 롤과 운영체제에서의 롤
-- 1) 오라클 설치 후 미리 정의된 롤을 조회하는 SQL문 작성
SELECT * 
FROM dba_roles;

--scott 계정 삭제
-- 1) sys 접속
DROP USER scott;
-- ORA-01940: cannot drop a user that is currently connected 현재 접속중이라 삭제 안됨
-- User SCOTT이(가) 삭제되었습니다.
SELECT *
FROM all_users;