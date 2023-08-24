--sys--
select *
from v$instance;
from v$sga;

select tablespace_name, file_name from dba_data_files;
 
show parameter db_block_size; --8192

select name
from v$tablespace; --현재 오라클 서버에 존재하는 tablespace 이름을 조회하는 명령어

select owner, segment_name, extent_id, bytes, blocks
from dba_extents; --dba_extents extends의 설정 정보를 조회하는 sql

-- 1extent = 8192(block)*8  = 65536
select 8192*8
from dual;

SELECT * FROM dba_users;
-- dba_xxx = 관리자만 사용가능
--관리자(SYS)가 HR계정 잠금 해제
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENFIED BY lion;

ALTER USER HR IDENTIFIED  BY lion ACCOUNT UNLOCK;

--계정
CREATE USER --생성
DROP USER --삭제
ALTER USER --수정
-- 테이블
CREATE TABLE -- 생성
DROP TABLE  -- 삭제
ALTER TABLE -- 수정
-- 테이블 스페이스
CREATE TABLESPACE -- 생성
DROP TABLESPACE -- 삭제
ALTER TABLESPACE -- 수정