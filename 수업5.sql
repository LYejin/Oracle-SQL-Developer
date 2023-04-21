--과제
---정규표현식 전화번호
select phone_number from employees where regexp_like (phone_number, '([[:digit:]]{3})\.([[:digit:]]{3})\.([[:digit:]]{4})');

/*
문제 풀기
*/

/*
2조
*/

select * from employees; -- 노동자들의 정보
select * from departments; -- 노동자들의 부서
select * from locations; -- 위치 지역

--employees 테이블에서 직원들 중 연봉이 가장 높은 10명의 이름, 직책, 연봉, 소속 부서 이름을 출력하세요.
--단, 소속 부서 이름은 departments 테이블에서 가져와야 합니다.
select e.first_name || e.last_name, e.job_id, e.salary*12, d.department_name 
from employees e 
join departments d on e.department_id=d.department_id 
where ROWNUM <=10 order by salary desc;


--이름(last_name)에 'A'가 속하는 사원이 근무하는 부서의 도시명을 모두 출력하세요.
select l.city
from employees e
join departments d on e.department_id=d.department_id 
join locations l on d.location_id=l.location_id
where lower(e.last_name) like '%a%';

--'Colmenares'(last_name)이 근무하는 부서의 담당 관리자 이름을 출력하세요.
select last_name
from employees
where employee_id in (select manager_id from employees where last_name='Colmenares');


/*
3조
*/

select * from employees; -- 노동자들의 정보
select * from departments; -- 노동자들의 부서
select * from locations; -- 위치 지역

/*
근무도시별 평균봉급, 평균근속년수, 사원수를 계산하여,
'도시명', '평균봉급', '평균근속년수', '사원수' column명으로 출력하되
도시별 평균봉급의 내림차순으로 정렬하시오.

근속년수를 계산할 때, 현재날짜를 2010년 1월 1일로 가정하고
근속 12개월마다 근속년수가 1씩 늘어나는 것으로 계산하시오.
예) 입사일이 2009-09-03인 사원은 근속년수가 0년이다.
단, 근무부서나 근무지역이 없는 사원은 제외하고, 평균은 반올림하여 소수점 1자리까지 출력하라 -> round
*/

select round(avg(e.salary)), 
from employees e
join departments d on e.department_id=d.department_id 
join locations l on d.location_id=l.location_id
group by l.country_id;


select max(avg(t.salary))
from (select *
      from employees e join (select department_id, avg(salary) as 부서별평균급여 from employees group by department_id) e1 on e.department_id = e1.department_id
                       join departments d on e.department_id = d.department_id
                       join locations l on d.location_id = l.location_id
      where e.salary > e1.부서별평균급여
            and (e.first_name like '%a%' or e.last_name like '%a%')) t
group by t.country_id;


select trunc(avg(e.salary)) as avgsal
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where l.country_id in (select Max(l.country_id)
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where e.salary in (select trunc(avg(salary))from employees group by department_id)) AND lower(e.first_name || e.last_name) like '%a%';







