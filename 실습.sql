show user;

create table dmlemp
as
    select * from emp;
    
select * from dmlemp;

select * from user_constraints where table_name='DMLEMP';

alter table dmlemp
add constraint pk_dmlemp_empno primary key(empno);

select * from dmlemp where deptno=20;

---------------------------------------------
show user;
--kosa

create table trans_A(
    num number,
    name varchar2(20)
);

create table trans_B(
    num number constraint pk_trans_B_num primary key,
    name varchar2(20)
);

select * from trans_A;
select * from trans_B;

select * from dept;


select * from emp;


--집계 열 데이터 


/*
행을 열로 전달하기 
deptno, cnt
10      3
20       5
30       6

deptno_10 deptno_20 deptno_30
   3          5        6


*/

select deptno, count(*) as cnt from emp group by deptno order by deptno asc;

select deptno, case when deptno=10 then 1 else 0 end as dept_10,
               case when deptno=20 then 1 else 0 end as dept_20,
               case when deptno=30 then 1 else 0 end as dept_30
from emp
order by 1; -- order by deptno asc
--------------------------------------------------------------------------------

select deptno, sum(case when deptno=10 then 1 else 0 end) as dept_10,
               sum(case when deptno=20 then 1 else 0 end) as dept_20,
               sum(case when deptno=30 then 1 else 0 end) as dept_30
from emp
group by deptno; -- order by deptno asc
--deptno 컬럼은 의미가 없다
--dept 10 컬럼명 ... 10번 부서


select sum(case when deptno=10 then 1 else 0 end) as dept_10, -- 이름 의미 부여 >> 10 부서 
       sum(case when deptno=20 then 1 else 0 end) as dept_20,
       sum(case when deptno=30 then 1 else 0 end) as dept_30 
from emp;

-- 열 데이터를 행으로 바꾸는 방법 
select max(case when deptno=10 then ecount else null end) as dept_10,
       max(case when deptno=20 then ecount else null end) as dept_20,
       max(case when deptno=30 then ecount else null end) as dept_30
from (
        select deptno, count(*) as ecount
        from emp
        group by deptno
    ) x;

/*
SELECT *
    FROM (피벗 대상 쿼리문)
PIVOT ( 그룹함수(집계컬럼) FOR 

오라클 11g부터 PIVOT 기능을 제공합니다.
기존 이하버전에서는 DECODE 함수를 이용하여 로우를 컬럼으로 변경하는 작업을 하였습니다.
PIVOT 기능을 이용하면 더 좋고 
*/  

select * from emp;

select job, to_char(hiredate,'FMMM') || '월' as hire_month from emp; 

--        1월, 2월, 3월, 4월 ...... 12월 컬럼으로
-- CLEKR  0   0    1    2
-- decode 12개 >> 1월 12월

select *
from (
        select job, to_char(hiredate, 'FMMM') || '월' as hire_month from emp 
     )
pivot ( count(*) for hire_month IN('1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월')
     );
--직종별
--직종별, 부서별 급여 합계
--select job, deptno, sum(sal) from emp group by job, deptno order by job

select job, d10, d20, d30
from (
    select job, deptno, sal from emp
    )
pivot (
    sum(sal) for deptno in ('10' as d10, '20' as d20, '30' as d30)
    );
  

    
-- decode 구현한다면
SELECT job 
     , SUM(DECODE((job, 'FMMM'), '1', 1, 0)) "1¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '2', 1, 0)) "2¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '3', 1, 0)) "3¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '4', 1, 0)) "4¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '5', 1, 0)) "5¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '6', 1, 0)) "6¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '7', 1, 0)) "7¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '8', 1, 0)) "8¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '9', 1, 0)) "9¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '10', 1, 0)) "10¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '11', 1, 0)) "11¿ù" 
     , SUM(DECODE(TO_CHAR(hiredate, 'FMMM'), '12', 1, 0)) "12¿ù" 
  FROM emp 
 GROUP BY job;

select *
from (
    select job, deptno, sal from emp
    )
pivot (
    sum(sal) for job in ('PRSIDENT' as p, 'ANALYST' as a, 'MANAGER' as m, 'SALSESMAN' as s, 'CLERK' as c)
    ); 
select * from emp;

--> 동일 
select deptno, job , SUM(DECODE(job, 'PRSIDENT', sal)) as PRSIDENT
                    , SUM(DECODE(job, 'ANALYST', sal)) as ANALYST
                    , SUM(DECODE(job, 'MANAGER', sal)) as MANAGER
                    , SUM(DECODE(job, 'SALSESMAN', sal)) as SALSESMAN
                    , SUM(DECODE(job, 'CLERK', sal)) as CLERK
from emp
group by deptno
order by deptno desc;



---------------------------------------------------------------------------------
--사원테이블에서 부서별 급여합계와 전체 급옇바을 출력하세요

select deptno, sum(sal)
from emp
group by deptno
order by deptno;

select sum(sal) from emp;

select deptno, sum(sal) from emp group by deptno
union all
select null, sum(sal) from emp;
-----------------------------------------------------------------------------
--Rollup, cube 소개 (레포팅, 출력 : OLAP) -> 데이터 분석 기능에서 많이 사용이 된다.
--다차원 분석 쿼리에 사용 (소계를 만드는 방법)


select job, sum(sal)
from emp
group by rollup(job); --나는 직종별 급여의 합도 구하고 ,,, 모든 직종의 급여의 합도 구하겠다.


select job, deptno, sum(sal), count(sal)
from emp
group by job, deptno
order by job, deptno;


select job, deptno, sum(sal)
from emp
group by rollup(job, deptno); -- 우측 끝 컬럼부터 연산에서 제외하므로 컬럼의 순서가 중요

/*
TTT	    30	     9400
TTT		         9400
CLERK	10	     1300
CLERK	20	     1900
CLERK		     3200 -- 소계 
ANALYST	20	     6000
ANALYST		     6000
MANAGER	10	     2450
MANAGER	20	     2975
MANAGER		     5425
PRESIDENT	10	 5000
PRESIDENT		 5000
		         29025
*/

select job, deptno, sum(sal)
from emp
group by rollup(deptno, job);


------------------------------------
select job, deptno, sum(sal), count(sal)
from emp
group by job, deptno
order by job, deptno;

--기준 소계 : deptno 별 소계, job 별 소개, 전체 합

select deptno, job, sum(sal)
from emp
group by deptno, job
    union all
select deptno, null, sum(sal)
from emp
group by deptno
    union all
select null, job, sum(sal)
from emp
group by job
    union all
select null, null, sum(sal)
from emp;

--복잡한 쿼리(union), rollup(모든 컬럼의 집계는 안된다.) >> cube >> 모든 컬럼의 소계를 잡는다.
select deptno, job, sum(sal)
from emp
group by cube(deptno, job)
order by deptno, job;


--------------------------------------------------------------------------------
--순위 함수
--rownum (select 한 결과에 순번 처리)
--RANK
--DENSE_RANK
--순위가 동일한 결과 (같은 점수가 여러명) (100,90,80 (1,2,3 등), 100, 80, 80) 
select * from emp;

select ename, sal,
rank() over(order by sal desc) as 순위,
dense_rank() over(order by sal desc) as 순위2
from emp
order by sal desc;

/*           rank dense_rank
KING	5000	1	1
FORD	3000	2	2
SCOTT	3000	2	2
JONES	2975	4	3 -- 차이점 
BLAKE	2850	5	4
CLARK	2450	6	5
ALLEN	1600	7	6
TURNER	1500	8	7
MILLER	1300	9	8
WARD	1250	10	9
MARTIN	1250	10	9
ADAMS	1100	12	10
JAMES	950	    13	11
SMITH	800	    14	12

만약 동률을 줄일 수 있는 방법은 기준을 더 만드는 것이다.
회사) 포인트 많은 3사람에게 선물을 주겠다.
6명 동률 : 기준을 더 만들어,,, 가입순, 나이순, ... 도입 중복값을 만들지 말아라
*/

-- 동률이 나오는 경우가 꽤 있다.
select ename, sal, comm,
rank() over(order by sal desc, comm desc) as 순위 --기준을 추가 .... 더 많은 기준
from emp
order by sal desc;


--조건 (그룹안에서 순위 정하기)
--A 조 (1,2,3) B 조(1,2,3등)
select job, ename, sal, comm,
    rank() over(partition by job order by sal desc, comm desc) as 그룹순위 
from emp
order by job asc, sal desc, comm desc;


--집계 함수 (단점: select 절 집계함수 이외에 나머지 컬럼은 group by 절)
--in line view (서브쿼리) JOIN
--create view 가상테이블 JOIN

select job, sum(sal), count(sal)
from emp
where job in('MANAGER','SALESMAN')
group by job
order by job;
--이름, 사번 보고 싶어요-> (안돼요!)
select empno, job, sum(sal), count(sal) (x);

--단점 해결 ->partition 기능
select empno, ename, job, sum(sal) over (partition by job)
from emp
where job in('MANAGER','SALESMAN')
order by job;

--with절
--RARTiTION BY https://cafe.naver.com/erpzone/501
--------------------------------------------------------------------------------
--JDBC 활용 프로시져 만들기
create or replace procedure usp_EmpList
(
    p_sal IN number,
    p_cursor OUT SYS_REFCURSOR -- APP 사용하기 타입
)
is
    begin
        open p_cursor
        for select empno, ename, sal from emp where sal > p_sal;
    end;
    
var out_cursor REFCURSOR
exec usp_EmpList(2000, :out_cursor)
print out_cursor;

select null, null, sum(sal)
from emp
order by deptno, job;

create or replace procedure usp_insert_Emp
(
    vempno IN emp.empno%TYPE,
    vename IN emp.ename%TYPE,
    vjob   IN emp.job%TYPE,
    p_outmsg OUT varchar2
)
is
    begin
        insert into emp(empno,ename,job) values(vempno, vename, vjob);
        commit;
        p_outmsg := 'success'; -- 할당은 이모티콘 :=
        EXCEPTION when others then
        p_outmsg := SQLERRM;
        rollback;
    end;

alter table emp
add constraint pk_emp_empno primary key(empno);

select * from user_constraints where table_name='EMP';

select * from emp;

select * from dept;
desc dept;


--mariadb
DELIMITER $$
create procedure insert_dept3
(
    IN vempno int,
    IN vdname varchar(14),
    IN vloc varchar(13),
    OUT result varchar(1000)
)
begin
    DECLARE exit handler for SQLEXCEPTION 
    BEGIN 
    ROLLBACK;
    SET result = 'fail'; 
    END;
    start transaction;
    insert into dept(deptno,dname,loc) values(vempno,vdname,vloc);
    commit;
    set result = 'success';
END $$;

--완성된 문장 
DELIMITER $$
create procedure insert_dept5
(
    IN vempno int,
    IN vdname varchar(14),
    IN vloc varchar(13),
    OUT result varchar(1000)
)
begin
    DECLARE exit handler for SQLEXCEPTION 
    BEGIN 
    ROLLBACK;
    get diagnostics condition 1 @mt = MESSAGE_TEXT;
    set result = concat('오류: ', @mt); 
    END;
    start transaction;
    insert into dept(deptno,dname,loc) values(vempno,vdname,vloc);
    commit;
    set result = 'success';
END $$;

DROP PROCEDURE IF EXISTS SP_SYS_REF;


--JDBC 활용 프로시져 만들기
create or replace procedure usp_EmpList
(
  p_sal IN number,
  p_cursor OUT SYS_REFCURSOR -- APP 사용하기 타입
)
is
    begin
        open p_cursor 
        for select empno, ename ,sal from emp where sal > p_sal;
    end;

    var out_cursor REFCURSOR
    exec usp_EmpList(2000,:out_cursor)
    print out_cursor;

DELIMITER $$
CREATE PROCEDURE SP_SYS_REF()
BEGIN
SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID BETWEEN 100 AND 105;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE usp_EmpList_ex10
(
    IN p_sal INT
)
BEGIN
select empno, ename, sal
from emp
where sal > p_sal;
END$$
DELIMITER;

CALL SP_SYS_REF();

select * from emp;
desc emp;

delete from emp where empno=9999;

DELIMITER $$
create procedure usp_EmpList_ex9
(
    IN e_sal int
)
begin
    declare p_empno int;
    declare p_ename VARCHAR(10);
    declare p_sal int;
    declare endOfRow boolean default false;
    declare userCursor CURSOR FOR
    select empno, ename, sal
    from emp
    where sal > e_sal;
    declare continue handler
    for not found set endOfRow = TRUE;
    OPEN userCursor;
    cursor_loop : 
    LOOP
    FETCH userCursor INTO p_empno, p_ename, p_sal;
    IF endOfRow THEN
    LEAVE cursor_loop;
    END IF;
    END LOOP cursor_loop;
    select p_empno, p_ename, p_sal;
    CLOSE userCursor;
END $$
DELIMITER ;

CREATE TABLE emp (
empno INT(4) PRIMARY KEY,
ename VARCHAR(10),
job VARCHAR(9),
mgr INT,
hiredate DATE,
sal int,
comm int,
deptno int
);

desc emp;

