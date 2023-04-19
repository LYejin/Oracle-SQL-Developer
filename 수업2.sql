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



