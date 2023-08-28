SELECT deptno,ename, NVL(sal+comm, sal) AS pay FROM emp
where NVL(sal+comm, sal) BETWEEN 1000 AND 3000 and deptno != 30
ORDER BY ename;

WITH e AS 
(
SELECT deptno,ename, NVL(sal+comm, sal) AS pay FROM emp
)
SELECT* FROM e 
WHERE pay BETWEEN 1000 AND 3000 and deptno != 30
ORDER BY ename;

SELECT * FROM (SELECT deptno,ename, NVL(sal+comm, sal)pay FROM emp)e 
WHERE e.pay BETWEEN 1000 AND 3000 and e.deptno != 30
ORDER BY e.ename;

SELECT
    'AbCdE',
    upper('AbCdE'),
    lower('AbCdE'),
    initcap('abCdE')
FROM
    dual;
 
SELECT DISTINCT job ,(SELECT COUNT(DISTINCT job) FROM emp)job¼ö FROM emp;   
SELECT job ,COUNT(job) FROM emp GROUP BY job;
    
SELECT ssn, SUBSTR(ssn,1,2)year,
EXTRACT(MONTH FROM to_date(SUBSTR(ssn,1,6)))month, 
SUBSTR(ssn,5,2)AS "DATE", 
SUBSTR(ssn,8,1)gender
FROM insa;



SELECT ename, HIREDATE, 
TO_CHAR(HIREDATE, 'yy')YEAR, 
SUBSTR(HIREDATE,4,2)month, 
EXTRACT(DAY FROM HIREDATE)AS "DATE"
FROM emp;

SELECT *
FROM (SELECT name, SUBSTR(ssn,1,8)||'******' rrn FROM insa)e
WHERE e.rrn LIKE '7%' and e.rrn LIKE '%-1%'
ORDER BY rrn;

SELECT name, ssn AS rrn
FROM insa
WHERE ssn LIKE '7%' and ssn LIKE '__12%'
ORDER BY ssn;

SELECT EMPNO,ENAME,JOB, nvl(CAST(mgr AS VARCHAR(4)),'BOSS') AS mgr, HIREDATE,SAL,NVL(COMM,0)comm,DEPTNO
FROM emp;

SELECT num, name,nvl(tel,'¿¬¶ôÃ³ µî·Ï ¾ÈµÊ')as tel
FROM insa;

SELECT ename
        , NULLIF(ename,'SMITH')
FROM emp;
 
 SELECT sal, comm
        ,sal + NVL(comm,0)pay
        ,sal + NVL2(comm,comm,0)pay
        ,COALESCE(sal + comm, sal) 
 FROM emp;

SELECT num, name, NVL(NULLIF(substr(ssn,8,1),'2'),'X')tel
FROM insa
WHERE buseo = '°³¹ßºÎ';

SELECT  num, name, tel, nvl2(NULLIF(SUBSTR(ssn, 8, 1), '2'),'O','X' )gender
FROM insa
WHERE buseo = '°³¹ßºÎ';

--RR/YYÂ÷ÀÌ
SELECT SYSDATE
        , TO_CHAR(sysdate,'cc')
        , TO_CHAR(sysdate,'scc')
FROM dual;
 -- '05/01/10'
SELECT '05/01/10'
        , TO_CHAR(TO_DATE('05/01/10','RR/MM/DD'),'YYYY')rr
        , TO_CHAR(TO_DATE('05/01/10','YY/MM/DD'),'YYYY')yy
        , TO_CHAR(TO_DATE('97/01/10','RR/MM/DD'),'YYYY')rr
        , TO_CHAR(TO_DATE('97/01/10','YY/MM/DD'),'YYYY')yy
FROM dual;
 
SELECT ename,hiredate
        , TO_CHAR(hiredate,'YYYY')
FROM emp; 
 
SELECT *
FROM dept;

INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC', 'SEOUL');

UPDATE dept SET dname = concat(dname,'2'), loc = 'POHANG'
WHERE deptno = 50;

DELETE FROM dept where deptno = 50;
DELETE FROM dept where deptno = (SELECT deptno FROM dept where dname = 'QC2');

--REPLACE
--REPLACE (char, search_string [, replacement_string] )
--ÀÌ¸§ ¼Ó¿¡ m ¹®ÀÚ Æ÷ÇÔ½Ã *·Îº¯°æ
SELECT ename, REPLACE(UPPER(ename),UPPER('m'),'*')
FROM emp
--WHERE lower(ename) LIKE '%m%';
--WHERE ename LIKE CONCAT(CONCAT('%',UPPER('m')),'%');
WHERE ename LIKE '%' || UPPER('m') || '%';
--WHERE ename LIKE upper('%m%');

--¹®Á¦ empÅ×ÀÌºí ¿¡¼­ ename la ´ë¼Ò¹®ÀÚ ±¸ºÐ¾øÀÌ ÀÖ´Â »ç¿ø Á¶È¸
SELECT ename
        , REPLACE(ename, 'LA', '<span style="color:red">'||ename||'<span>')
FROM emp
--WHERE UPPER(ename) LIKE '%LA%';
WHERE REGEXP_LIKE(ename, 'la','i');
-- Á¤±Ô Ç¥Çö½ÄÀ» »ç¿ëÇÒ¼ö ÀÖ´Â ÇÔ¼ö
--regexp_like (search_string, pattern [,match_option])
--REGEXP_LIKE(ename, 'la','i'); 'i' == ´ë¼Ò¹®ÀÚ ±¸ºÐ¾øÀ½À» ÀÇ¹Ì
--match_option : i(´ë¼Ò¹®ÀÚ ±¸ºÐX), c(´ë¼Ò¹®ÀÚ ±¸ºÐO), m(¸ÖÆ¼¶óÀÎ), X(°ø¹é¹®ÀÚ ¹«½Ã)
--ÇÔ¼ö
--º¹¼öÇü(±×·ì)ÇÔ¼ö (group function)
SELECT COUNT(*)
FROM emp;
-- ´ÜÀÏÇà ÇÔ¼ö(single row function)
SELECT LOWER(ename)
FROM emp;

--
SELECT *
FROM test
--WHERE REGEXP_LIKE(name, '^[ÇÑ¹é]');
WHERE REGEXP_LIKE(name, '°­»ê$');

--insa Å×ÀÌºí¿¡¼­ ³²ÀÚ »ç¿ø¸¸
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn,'^7\d{5}-[13579]'); 
WHERE REGEXP_LIKE(ssn,'^7.{6}[13579]'); 

--¹®Á¦ insaÅ×ÀÌºí¿¡¼­ ¼ºÀÌ ±è¾¾, ÀÌ¾¾ ¸¸ Á¶È¸
SELECT name
FROM insa
WHERE REGEXP_LIKE(name,'^[±èÀÌ][°¡-ÆR]{2}');
WHERE name LIKE '±è__' or name LIKE 'ÀÌ__';
--¹®Á¦ insaÅ×ÀÌºí¿¡¼­ ¼ºÀÌ ±è¾¾, ÀÌ¾¾ Á¦¿Ü Á¶È¸
SELECT name
FROM insa
WHERE REGEXP_LIKE(name,'^[^±èÀÌ][°¡-ÆR]{2}');
WHERE NOT REGEXP_LIKE(name,'^[±è,ÀÌ].{2}');
WHERE NOT (name LIKE '±è__' or name LIKE 'ÀÌ__');


WITH temp AS(
SELECT deptno,empno,ename, nvl(sal+comm,sal)pay FROM emp 
)
SELECT *
FROM temp
WHERE pay >= ALL(SELECT pay FROM TEMP) OR pay <= ALL(SELECT pay FROM TEMP);

SELECT * FROM emp where sal >= ALL  (SELECT sal FROM emp) or sal <= ALL  (SELECT sal FROM emp);
--MIN() MAX()
SELECT emp.*, nvl(sal+comm,sal)PAY 
FROM emp 
where nvl(sal+comm,sal)=(SELECT MAX(nvl(sal+comm,sal)) FROM emp) 
        OR nvl(sal+comm,sal) =(SELECT MIN(nvl(sal+comm,sal)) FROM emp);

--SET OPERATOR(ÁýÇÕ ¿¬»êÀÚ)
--(1) SQL ¹®¿¡¼­ ÁýÇÕ ¿¬»êÀÚ¸¦ »ç¿ëÇÏ±â À§ÇØ¼­´Â ÁýÇÕ ¿¬»êÀÇ ´ë»óÀÌ µÇ´Â µÎ Å×ÀÌºíÀÇ ÄÃ·³ ¼ö°¡ °°°í
--(2) ´ëÀÀµÇ´Â ÄÃ·³³¢¸® µ¥ÀÌÅÍ Å¸ÀÔÀÌ µ¿ÀÏÇØ¾ß ÇÑ´Ù.
--(3) ÄÃ·³ÀÌ¸§Àº ´Þ¶óµµ »ó°ü ¾øÀ¸¸ç
--(4) ÁýÇÕ ¿¬»êÀÇ °á°ú·Î Ãâ·ÂµÇ´Â ÄÃ·³ÀÇ ÀÌ¸§Àº Ã¹ ¹øÂ° select ÀýÀÇ ÄÃ·³ ÀÌ¸§À» µû¸¥´Ù.
--(5) ORDER BY ÀýÀº Ã¹ ¹øÂ°¿Í µÎ ¹øÂ° SELECT ¹®ÀÌ ³¡³­ Á¦ÀÏ ÈÄ¹Ì¿¡ ³Ö¾î¾ß ÇÑ´Ù.
-- Á¾·ù
--  ÇÕÁýÇÕ: UNION, UNION ALL
--          UNION ALLÀº Áßº¹µÈ ºÎºÐ ¸ðµÎ Ãâ·Â
--          UNIONÀº Áßº¹µÈ ºÎºÐ ÇÑ¹ø¸¸ Ãâ·Â
--  ±³ÁýÇÕ: INTERSECT
--  Â÷ÁýÇÕ: MINUS

--emp + insa ¸ðµç »ç¿ø Á¤º¸¸¦ Á¶È¸
SELECT empno, ename, hiredate --, deptno   -- NUMBERÇü
FROM emp
UNION ALL
SELECT num,name,ibsadate --, buseo -- VARCHAR Çü
FROM insa;

--UNION, UNION ALLÀÇ Â÷ÀÌÁ¡
--(1)ÀÎ»ç Å×ÀÌºíÀÇ °³¹ßºÎ Á¶È¸
--(2)ÀÎ»ç Å×ÀÌºíÀÇ Ãâ½Å Áö¿ª: ÀÎÃµ
SELECT name,city,buseo
FROM insa
WHERE city = 'ÀÎÃµ'  --9¸í(°³¹ßºÎ 6¸í)
UNION ALL              --UNION = 17¸í    UNION ALL = 23¸í (ÀÎÃµÀÌ°Å³ª °³¹ßºÎ)
SELECT name, city, buseo
FROM insa
WHERE buseo = '°³¹ßºÎ';    --14¸í
--(3) INTERSECT
SELECT name,city,buseo
FROM insa
WHERE city = 'ÀÎÃµ'  --9¸í(°³¹ßºÎ 6¸í)
INTERSECT            -- 6¸í (ÀÎÃµÀÌ°í °³¹ßºÎ ÀÎ»ç¶÷µé)
SELECT name, city, buseo
FROM insa
WHERE buseo = '°³¹ßºÎ';    --14¸í
--(4) MINUS
SELECT name,city,buseo
FROM insa
WHERE city = 'ÀÎÃµ'  --9¸í(°³¹ßºÎ 6¸í)
MINUS            -- 3¸í (ÀÎÃµÀÌ°í °³¹ßºÎ´Â ¾Æ´Ñ »ç¶÷µé)
SELECT name, city, buseo
FROM insa
WHERE buseo = '°³¹ßºÎ';    --14¸í
--(5) ORDER BY ÀýÀº Ã¹ ¹øÂ°¿Í µÎ ¹øÂ° SELECT ¹®ÀÌ ³¡³­ Á¦ÀÏ ÈÄ¹Ì¿¡ ³Ö¾î¾ß ÇÑ´Ù.
SELECT name,city,buseo
FROM insa
WHERE city = 'ÀÎÃµ'  
MINUS
SELECT name, city, buseo
FROM insa
WHERE buseo = '°³¹ßºÎ'
ORDER by name;

SELECT name, ssn, NVL2(NULLIF(MOD(SUBSTR(ssn,8,1),2),0),'O','X')gender 
FROM insa;

--ÁýÇÕ¿¬»êÀÚ (SET OPERATOR)
--1) ³²ÀÚ
-- UNION
--2) ¿©ÀÚ
SELECT name,ssn, 'O' gender
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2)= 1
UNION
SELECT name,ssn, 'X' gender
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2)= 0;

-- IS [NOT] NAN, IS [NOT] INFINITE = ÀÌ Á¶°ÇÀº Ç¥Çö½ÄÀÌ ¹«ÇÑ´ëÀÌ°Å³ª ¶Ç´Â Á¤ÀÇµÇÁö ¾ÊÀº °æ¿ì¿¡ »ç¿ëµÇ´Â ¿¬»êÀÚÀÌ´Ù. 
-- IS [NOT] NAN = NOT A NUMBER
-- IS [NOT] INFINITE : ¹«ÇÑ´ë

-- ¿À¶óÅ¬ ÇÔ¼ö Á¤ÀÇ : ora_help function Á¤¸®
1. ¿À¶óÅ¬ ÇÔ¼ö ±â´É
2. ¿À¶óÅ¬ ÇÔ¼ö Á¾·ù 
--------------------
(1) ¼ýÀÚ ÇÔ¼ö
    -- ROUND(number,¹Ý¿Ã¸²À§Ä¡ ¾ç¼ö,À½¼ö)¹Ý¿Ã¸²ÇÔ¼ö
    -- CEIL()¿Ã¸²ÇÔ¼ö
    --FLOOR()³»¸²(Àý»è)ÇÔ¼ö
        ¤¤TRUNC(number, Àý»èÇÒ À§Ä¡ ¾ç¼ö, À½¼ö) ¼ýÀÚ°ªÀ» Æ¯Á¤ À§Ä¡¿¡¼­ ³»¸²(Àý»è) 
        ;
        SELECT ROUND(15.193)a --15 ¼Ò¼öÁ¡ Ã¹¹øÂ° ÀÚ¸®¿¡¼­ ¹Ý¿Ã¸²
                --, ROUND(15.193,0)
                , ROUND(15.193,1)b --15.2 ¼Ò¼öÁ¡ µÎ¹øÂ° ÀÚ¸®¿¡¼­ ¹Ý¿Ã¸²
                --, ROUND(15.193,n) -- ¼Ò¼öÁ¡ n+1ÀÚ¸®¿¡¼­ ¹Ý¿Ã¸²
                , ROUND(15.193,-1) --20 ¼Ò¼öÁ¡ ±âÁØ ¿ÞÂÊÇÑÄ­(1ÀÇÀÚ¸®)¿¡¼­ ¹Ý¿Ã¸²
                , ROUND(15.193,-2) --0 ¼Ò¼öÁ¡ ±âÁØ ¿ÞÂÊµÎÄ­(10ÀÇÀÚ¸®)¿¡¼­ ¹Ý¿Ã¸²
        FROM dual;
        --ÁöÁ¤µÈ ¼ýÀÚº¸´Ù °°°Å³ª Å« Á¤¼ö Áß¿¡ ÃÖ¼Ò °ª
        SELECT CEIL(15.193) -- 16 ¼Ò¼öÁ¡ Ã¹¹øÂ° ÀÚ¸®¿¡¼­ ¿Ã¸²
                ,CEIL(15.913) --16
        FROM dual;
        --ÁöÁ¤µÈ ¼ýÀÚº¸´Ù ÀÛ°Å³ª °°Àº Á¤¼ö Áß ÃÖ´ë °ª
        SELECT FLOOR(15.193) --15 
                ,FLOOR(15.913) --15
        FROM dual;
        -- FLOOR() °ú TRUNC() Â÷ÀÌ
        SELECT FLOOR(15.193) --15
                ,  FLOOR(15.193*10)/10 -- 15.1
                , TRUNC(15.193) --15 == FLOOR(15.193)
                , TRUNC(15.193,1) --15.1 TRUNC´Â Æ¯Á¤ À§Ä¡¿¡¼­ Àý»è °¡´É
                , TRUNC(15.193,-1) --10 ROUND()¹Ý¿Ã¸²ÇÔ¼ö Ã³·³ À½¼öµµ °¡´É
        FROM dual;
        -- ¼Ò¼ö 3¹øÂ° ÀÚ¸®¿¡¼­ ¹Ý¿Ã¸²ÇÏ½Ã¿À
        SELECT 10/3
                ,ROUND(10/3,2)
        FROM dual;
        
        --³ª¸ÓÁö ±¸ÇÏ´Â ÇÔ¼ö MOD(), REMAINDER()
        SELECT MOD(19,4) --3
                ,REMAINDER(19,4) -- -1
        FROM dual;
        --MOD(n2,n1) = n2-n1*FLOOR(n2/n1)
        --REMAINDER(n2,n1) = n2-n1*ROUND(n2/n1)
        
        --ABS() Àý´ë°ª
        --SIGN() ºÎÈ£¿¡ µû¶ó 1, -1 ¹ÝÈ¯ 0ÀÌ¸é 0¹ÝÈ¯
        SELECT ABS(100), ABS(-100)
                , SIGN(100), SIGN(-100), SIGN(0) -- 1,-1,0
                , POWER(2,3)  -- 8 n1^n2
                , SQRT(2) -- nÀÇ Á¦°ö±Ù(ROOT)°ª
        FROM dual;
            
(2) ¹®ÀÚ ÇÔ¼ö
    -- UPPER()
    -- LOWER()
    -- INITCAP()
    -- CONCAT()
    -- SUBSTR()
    ;
    -- LENGTH() ¹®ÀÚ¿­ ±æÀÌ
    SELECT DISTINCT job
            , LENGTH(job)
    FROM emp;
    
    -- empÅ×ÀÌºí¿¡¼­ ename¿¡ L¹®ÀÚ°¡ ÀÖ´Â »ç¿ø Á¶È¸
    -- L ¹®ÀÚ°¡ ÀÖ´Â À§Ä¡°ª Á¶È¸
    -- INSTR() Æ¯Á¤¹®ÀÚ°¡ ÀÖ´Â À§Ä¡ Á¶È¸
    -- INSTR(string, substring [, position [,occurrence])
    -- string¹®ÀÚ¿­¿¡ substring¹®ÀÚ¿­À» [positionºÎÅÍ [occurrence¹øÂ°]] À§Ä¡
    SELECT ename, INSTR(ename, 'L')
    FROM emp
    WHERE REGEXP_LIKE(ename,'l','i');
    WHERE ename LIKE '%M%';
    
    select instr('corporate floor','or') -- 2 
    , instr('corporate floor','or',4)  -- 2 4¹øÂ° À§Ä¡ ºÎÅÍ or 
    , instr('corporate floor','or',1,3) -- 14 1¹øÂ° À§Ä¡ ºÎÅÍ 3¹øÂ° or À§Ä¡
    , instr('corporate floor','or',3,2)        -- 14 3¹øÂ° À§Ä¡ºÎÅÍ 2¹øÂ° or À§Ä¡
    , instr('corporate floor','or',-1,3) --2 µÚ¿¡¼­ ºÎÅÍ 3¹øÂ° or À§Ä¡
    from dual;

    -- RPAD/LPAD == ÁöÁ¤µÈ ±æÀÌ¿¡¼­ ¹®ÀÚ°ªÀ» Ã¤¿ì°í ³²Àº °ø°£À» ¿ì(ÁÂ)ÃøºÎÅÍ Æ¯Á¤°ªÀ¸·Î Ã¤¿ö ¸®ÅÏÇÑ´Ù
    -- Çü½Ä RPAD (expr1, n [, expr2] )
    SELECT ename, sal + NVl(comm,0) pay
           -- ,LPAD(sal + NVl(comm,0),10,'*') -- ÃÑ10ÀÚ¸® Áß Ãâ·ÂÇÏ°í ³²Àº ÀÚ¸®´Â ¿ÞÂÊºÎÅÍ *·Î Ã¤¿ò
           -- ,RPAD(sal + NVl(comm,0),10,'*')
           -- 10ÀÇÀÚ¸® ¹Ý¿Ã¸² ÈÄ 100¸¶´Ù #
           , ROUND(sal + NVl(comm,0),-2)RPAY
           , ROUND(sal + NVl(comm,0),-2)/100 a
           , RPAD(' ',ROUND(sal + NVl(comm,0),-2)/100+1,'#')p
           , RPAD(ROUND(sal + NVl(comm,0),-2)/100,ROUND(sal + NVl(comm,0),-2)/100+LENGTH(ROUND(sal + NVl(comm,0),-2)/100),'#')
    FROM emp;
    -- ÀÚ¹Ù.String.trim() ¾Õ/µÚ °ø¹é Á¦°ÅÇÏ´Â ÇÔ¼ö    
    --LTRIM()/RTRIM()/TRIM() ¹®ÀÚ°ª Áß¿¡¼­ ¿Þ/¿À À¸·Î ºÎÅÍ Æ¯Á¤ ¹®ÀÚ¿Í ÀÏÄ¡ÇÏ´Â ¹®ÀÚ °ª Á¦°Å 
    -- Çü½Ä: RTRIM(char [,set] )
    SELECT '[' || '   admin   ' || ']'
            ,'[' || LTRIM('   admin   ') || ']' --¿ÞÂÊ °ø¹é Á¦°Å
            ,'[' || RTRIM('   admin   ',' ') || ']' -- ¿À¸¥ÂÊ °ø¹é Á¦°Å
            ,'[' || TRIM('   admin   ') || ']' --TRIMÀº 2¹øÂ°¸Å°³º¯¼ö »ç¿ëºÒ°¡
            ,'[' || LTRIM('xyxyadminxyxy','xy') || ']'  -- ¿ÞÂÊ xyÁ¦°ÅµÊ
            ,'[' || RTRIM('xyxyadminxyxy','xy') || ']'  -- ¿À¸¥ÂÊ xyÁ¦°ÅµÊ
    FROM dual;
    
    --ASCII() : ¹®ÀÚ¸¦ ¾Æ½ºÅ° ÄÚµå·Î ¹ÝÈ¯
    --CHR() : ¾Æ½ºÅ°ÄÚµå¸¦ ÇØ´çÇÏ´Â ¹®ÀÚ·Î ¹ÝÈ¯
    SELECT ASCII('A'),ASCII('a'),ASCII('0')
            ,CHR(65), CHR(97), CHR(48)
    FROM dual;
    
    -- GREATEST()/LEAST() : ³ª¿­ÇÑ ¼ýÀÚ³ª ¹®ÀÚÁß °¡Àå Å«°ª/ÀÛÀº°ª ¹ÝÈ¯
    SELECT GREATEST(3,5,2,4,1)
            , LEAST(3,5,2,4,1)
            , GREATEST('MBC','TVC','SBS')
    FROM dual;
    
    --REPLACE() ¹®ÀÚ¿­ Ä¡È¯
    
    -- VSIZE() ÁöÁ¤µÈ ¹®ÀÚ¿­ÀÇ Å©±â¸¦ ¼ýÀÚ·Î ¹ÝÈ¯
    SELECT VSIZE('a'), VSIZE('ÇÑ')  --¿µ¾î 1¹ÙÀÌÆ® ÇÑ±Û 3¹ÙÀÌÆ®
    FROM dual;
    
    
(3) ³¯Â¥ ÇÔ¼ö
(4) º¯È¯ ÇÔ¼ö
(5) ÀÏ¹Ý ÇÔ¼ö
    - Á¤±Ô Ç¥Çö½Ä ÇÔ¼ö
(6) Áý°è ÇÔ¼ö
--------------------

