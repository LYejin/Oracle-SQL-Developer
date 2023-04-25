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

---------------------------------------------------------------------------------



