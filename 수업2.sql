/*  
3일차
*/

-------------------------------------------------

--SQL JOIN 문법 (단순)
select * 
from m,s,x
where m.m1 = s.s1 and s.s1=x.x1;


--ANSI 문법(권장)
select *
from m join s on m.m1 = s.s1
        join x on s.s1 = x.x1; -- 동일한 s는 쓰지 않음
--      join y on x.x1 = y.y1;

-- HR 계정 이동
show user;
--USER이(가) "HR"입니다.

select * from employees;
select * from departments;
select * from locations;

select count(*) from employees;
--employee_id, last_name, department_id, department_name 
--사번, 이름(last_name), 부서번호, 부서이름을 출력하세요
select e.employee_id, e.last_name, e.department_id, d.department_name 
from employees e
join departments d on e.department_id=d.department_id;
-- 106명 밖에 안나옴 .. 107명 누락
select * from employees where department_id is null; -- 조금 이따가 outer join 

--사번, 이름(last_name), 부서번호, 부서이름, 지역코드, 도시명을 출력하세요
select e.employee_id, e.last_name, e.department_id, d.department_name, d.location_id, l.city
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id = l.location_id;

---KOSA 계정 이동
show user;
--USER이(가) "KOSA"입니다.
select * from emp;
select * from salgrade; -- 비등가 (범위로 딱 떨어지지 않음)

--사원의 등급 (하나의 컬럼으로 매핑 안돼요) >> 컬럼 두개 사용
-- 비등가 조인
-- 문법 등가와 동일 (의미)

select e.empno, e.ename, d.grade, e.sal
from emp e join salgrade d 
on e.sal between d.losal and d.hisal; 

-- outer join (equi 조언 선행되고 나서 >> 남아있는 데이터를 가져오는 방법)
--1. 주종 관계 (주인이 되는 쪽에 남아있는 데이터를 가져오는 방법)
--2. left outer join (왼쪽이 주인)
--2.1 right outer join (오른쪽이 주인)
--2.2 full outer join (양쪽이 주인)

select *
from m left outer join s
on m.m1= s.s1;
-- 주인이 된 쪽의 남은 데이터를 가져온다.

select *
from m right outer join s
on m.m1= s.s1;

select *
from m full outer join s
on m.m1= s.s1;


--사번, 이름(last_name), 부서번호, 부서이름을 출력하세요
select e.employee_id, e.last_name, e.department_id, d.department_name 
from employees e left join departments d on e.department_id=d.department_id;
-- 106명 밖에 안나옴 .. 107명 누락
-- 해결 : left join
-- 현업 데이터 (null 고민 JOIN >> outer join)
select * from employees where department_id is null; -- 조금 이따가 outer join 

------------------------------------------------------------------------------

--selft join(자기참조) > 문법 (x) > 의미만 존재 > 등가조인 문법
--하나의 테이블에 있는 컬럼이 자신의 테이블에 있는 특정 컬럼을 참조하는 경우

select * from emp;
--SMITH 사원의 사수 이름 
-- 같은 테이블 mgr=7902 -> empno=7902 : 자기 참조
-- 사원테이블, 관리자테이블 만드는 것이 ...
-- 테이블 가명칭 >> 2개, 3개 있는 것처럼

select e.empno, e.ename, m.empno, m.ename
from emp e left join emp m
on e.mgr = m.empno;

select count(*) from emp where mgr is null;
------------------------------------------------------------------------------
select * from emp;
select * from dept;
select * from salgrade;

-- 1. 사원들의 이름, 부서번호, 부서이름을 출력하라.
select e.ename, d.deptno, d.dname
from emp e
join dept d on e.deptno=d.deptno;

-- 2. DALLAS에서 근무하는 사원의 이름, 직위, 부서번호, 부서이름을
-- 출력하라.
select e.ename, e.job, d.deptno, d.dname, d.loc
from emp e
join dept d on e.deptno=d.deptno
where d.loc='DALLAS';


-- 3. 이름에 'A'가 들어가는 사원들의 이름과 부서이름을 출력하라.
select e.ename, e.job, d.deptno, d.dname, d.loc
from emp e
join dept d on e.deptno=d.deptno
where e.ename like '%A%';


-- 4. 사원이름과 그 사원이 속한 부서의 부서명, 그리고 월급을
--출력하는데 월급이 3000이상인 사원을 출력하라.
select e.ename, d.dname, e.sal
from emp e
join dept d on e.deptno=d.deptno
where e.sal>=3000;

-- 5. 직위(직종)가 'SALESMAN'인 사원들의 직위와 그 사원이름, 그리고
-- 그 사원이 속한 부서 이름을 출력하라.
select e.ename, e.job, d.dname
from emp e
join dept d on e.deptno=d.deptno
where e.job='SALESMAN';


-- 6. 커미션이 책정된 사원들의 사원번호, 이름, 연봉, 연봉+커미션,
-- 급여등급을 출력하되, 각각의 컬럼명을 '사원번호', '사원이름',
-- '연봉','실급여', '급여등급'으로 하여 출력하라.
--(비등가 ) 1 : 1 매핑 대는 컬럼이 없다
SELECT         E.EMPNO AS "사원번호",
               E.ENAME AS "사원이름",
               E.SAL*12 AS "연봉",
               --E.SAL*12+NVL(COMM,0) AS "실급여",
               E.SAL*12+COMM AS "실급여",
               S.GRADE AS "급여등급"
FROM EMP E  join SALGRADE S on E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE E.Comm is not null;


select * from salgrade;
-- 7. 부서번호가 10번인 사원들의 부서번호, 부서이름, 사원이름,
-- 월급, 급여등급을 출력하라.
select e.ename, d.deptno, d.dname, e.sal
from emp e join dept d on e.deptno=d.deptno
            join salgrade g on e.sal between g.losal and g.hisal
where d.deptno=10;


-- 8. 부서번호가 10번, 20번인 사원들의 부서번호, 부서이름,
-- 사원이름, 월급, 급여등급을 출력하라. 그리고 그 출력된
-- 결과물을 부서번호가 낮은 순으로, 월급이 높은 순으로
-- 정렬하라.
select e.ename, d.deptno, d.dname, e.sal, S.GRADE
from emp e
join dept d on e.deptno=d.deptno
join SALGRADE S    on E.SAL BETWEEN S.LOSAL AND S.HISAL
where d.deptno=10 OR d.deptno=20 -- e.deptno IN (10,20)
order by d.deptno, e.sal desc;
​

-- 9. 사원번호와 사원이름, 그리고 그 사원을 관리하는 관리자의
-- 사원번호와 사원이름을 출력하되 각각의 컬럼명을 '사원번호',
-- '사원이름', '관리자번호', '관리자이름'으로 하여 출력하라.
--SELF JOIN (자기 자신테이블의 컬럼을 참조 하는 경우)
select e.empno as 사원번호, e.ename as 사원이름, m.empno as 관리자번호, m.ename as 관리자이름
from emp e
left join emp m on e.mgr = m.empno;


-----------------------------------------------------------------
--JOIN END-------------------------------------------------------




--subquery(서브쿼리) 100page
--sql 꽃 ....만능 해결사

--1. 함수 > 단일 테이블 > 다중 테이블 (join, union) > 해결 안돼요 >> subquery 해결
-- 사원테이블에서 사원들의 평균 월급보다 더 많은 월급을 받는 사원의 사번, 이름, 급여를 출력!
select avg(sal) from emp;

--1. 평균급여
select avg(sal) from emp; --평균급여 2073

select empno, ename, sal
from emp
where sal > 2073;

--2개의 쿼리 통합 (하나의 쿼리)
select empno, ename, sal
from emp
where sal > (select avg(sal) from emp);

--subquery
/*
1. single row subquery : 실행 결과가 단일컬럼에 단일로우값인 경우(한개의 값)
ex) select sum(sal) from emp, select max(sal) from emp
연산자 : = , != , < , >

2. multi row subquery : 실행 결과가 단일컬럼에 여러개의 로우인 경우
ex) select deptno from emp, select sal from emp
연산자 : IN, NOT IN, ANY, ALL
ALL : sal > 1000 and sal > 40000 and ....
ANY : sal > 1000 or sal > 40000 or .....

문법)
1. 괄호안에 있어야 한다 (select max(sal) from emp)
2. 단일 컬럼 구성     (select max(sal), min(sal) from emp) 서브쿼리 안돼요 (x)
3. 서브쿼리가 단독으로 실행 가능

서브 쿼리와 메인 쿼리
1. 서브 쿼리 실행되고 그 결과를 가지고
2. 메인 쿼리가 실행된다

TIP)
select (subquery) >> scala
from (subquery)   >> in line view (가상테이블)
where (subquery)  >> 조건
https://gent.tistory.com/464 참고
*/

--사원테이블에서 jones의 급여보다 더 많은 급여를 받는 사원의 사번, 이름, 급여를 출력하세요
--jones의 급여 알고 ....
select sal from emp where ename='JONES'; -- 2975

select empno, ename, sal
from emp
where sal > (select sal from emp where ename='JONES');

--부서번호가 30번인 사원과 같은 급여를 받는 모든 사원의 정보

select sal from emp where deptno=30; -- multi row

select * 
from emp
where sal in (select sal from emp where deptno=30);
--sal=1600 or sal=1250 or ....

--부서번호가 30번인 사원과 다른 급여를 받는 모든 사원의 정보
select * 
from emp
where sal not in (select sal from emp where deptno=30);
--sal !=1600 and sal!=1250 AND ....

--부하직원이 있는 사원의 사번과 이름을 출력하기
select mgr from emp where mgr is not null;

select empno, ename from emp
where empno in (select mgr from emp);

--부하직원이 없는 사원의 사번과 이름을 출력하기
select mgr from emp where mgr is not null;

select empno, ename from emp
where empno not in (select mgr from emp where mgr is not null);
--where empno not in (select nvl(mgr,0) from emp);
-- empno != 7902 and empno!= 7698 ... and null >> null


-- king 에게 보고하는 즉 직속상관이 king인 사원의 사번, 이름, 직종, 관리자사번을 출력하세요
select empno from emp where ename='KING';

select empno, ename, job, mgr from emp
where mgr in (select empno from emp where ename='KING');

--20번 부서의 사원중에서 가장 많은 급여를 받는 사원보다 더 많은 급여를 받는 사원의
-- 사번, 이름, 급여, 부서번호 출력하기
select max(sal) from emp where deptno=20;

select empno, ename, sal, deptno from emp
where sal > (select max(sal) from emp where deptno=20);

--스칼라 서브 쿼리 
select e.empno, e.ename, e.deptno, (select d.dname from dept d where d.deptno = e.deptno) as dept_name
from emp e -- 이것을 쓸 수 있다?
where e.sal >= 3000;

--실무에서 가장 많이 쓰이는 쿼리
--만약에 부서번호와 부서의 평균 월급을 담고 있는 테이블이 존재한다면 
--in line view
--자기 부서의 평균 월급보다 더 많은 월급을 받는 사원의 사번, 이름, 부서번호, 부서별 평균 월급 출력
select e.empno, e.ename, e.deptno, e.sal, s.avgsal, e.sal 
from emp e join (select deptno, trunc(avg(sal)) as avgsal from emp group by deptno) s
on e.deptno = s.deptno
where e.sal> s.avgsal;

-----------------------------------------------------------------------------
--subquery END---------------------------------------------------------------


--1. 'SMITH'보다 월급을 많이 받는 사원들의 이름과 월급을 출력하라.
select ename, sal from emp where sal>(select sal from emp where ename='SMITH');


--2. 10번 부서의 사원들과 같은 월급을 받는 사원들의 이름, 월급,
-- 부서번호를 출력하라.
select ename, sal, deptno from emp where sal in (select sal from emp where deptno=10);

--3. 'BLAKE'와 같은 부서에 있는 사원들의 이름과 고용일을 뽑는데
-- 'BLAKE'는 빼고 출력하라.
​
select ename, hiredate from emp where deptno=(select deptno from emp where ename='BLAKE') AND ename!='BLAKE';​

​
--4. 평균급여보다 많은 급여를 받는 사원들의 사원번호, 이름, 월급을
-- 출력하되, 월급이 높은 사람 순으로 출력하라.
select empno, ename, sal from emp where sal > (select avg(sal) from emp) order by sal desc;
​​
--5. 이름에 'T'를 포함하고 있는 사원들과 같은 부서에서 근무하고
-- 있는 사원의 사원번호와 이름을 출력하라.
select empno, ename from emp where deptno IN (select deptno from emp where ename like '%T%');
​
--6. 30번 부서에 있는 사원들 중에서 가장 많은 월급을 받는 사원보다
-- 많은 월급을 받는 사원들의 이름, 부서번호, 월급을 출력하라.
--(단, ALL(and) 또는 ANY(or) 연산자를 사용할 것)
select ename, deptno, sal from emp where sal> (select Max(sal) from emp where deptno=30);
​
select ename, deptno, sal from emp where sal> ALL(select sal from emp where deptno=30);
--where sal > 1600 and sal > 1250 and sal > 2850 and sal > 1500 and sal > 950

--7. 'DALLAS'에서 근무하고 있는 사원과 같은 부서에서 일하는 사원의
-- 이름, 부서번호, 직업을 출력하라.
select * from emp;
select * from dept;

select ename, deptno, job from emp where deptno in 
(select e.deptno from emp e join dept d 
on e.deptno=d.deptno where d.loc='DALLAS');
​

----SELECT ENAME, DEPTNO, JOB
--FROM EMP
--WHERE DEPTNO IN(SELECT DEPTNO    -- = 이 맞는데  IN
  --              FROM DEPT
   --             WHERE LOC='DALLAS');

--8. SALES 부서에서 일하는 사원들의 부서번호, 이름, 직업을 출력하라.
select empno, ename, job from emp where deptno in (select e.deptno from emp e join dept d on e.deptno=d.deptno);
​

--9. 'KING'에게 보고하는 모든 사원의 이름과 급여를 출력하라
--king 이 사수인 사람 (mgr 데이터가 king 사번)
select ename, sal from emp where mgr=(select empno from emp where ename='KING');
​
--10. 자신의 급여가 평균 급여보다 많고, 이름에 'S'가 들어가는
-- 사원과 동일한 부서에서 근무하는 모든 사원의 사원번호, 이름,
-- 급여를 출력하라.
select empno, ename, sal from emp  where deptno in 
(select deptno from emp where sal>(select avg(sal) from emp where ename like '%S%'));​


select * from emp;
select * from dept;
select * from SALGRADE;
--11. 커미션을 받는 사원과 부서번호, 월급이 같은 사원의
-- 이름, 월급, 부서번호를 출력하라.
select ename, sal, deptno from emp where sal in 
(select sal from emp where comm is not null) 
AND deptno in (select deptno from emp where comm is not null);


--12. 30번 부서 사원들과 월급과 커미션이 같지 않은
-- 사원들의 이름, 월급, 커미션을 출력하라.
select ename, sal, comm from emp where sal not in (select sal from emp where deptno=30) 
AND comm not in (select nvl(comm,0) from emp where deptno=30);



