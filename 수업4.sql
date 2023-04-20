/*
개발자 (SQL)
1. CRUD (create > insert, read > select, update, delete)
2. APP(JAVA) - 표준(JDBC API) - Oracle
3. insert, update, delete, select (70%)

하나의 테이블에 대해서 작업가능
JAVA 에서 EMP 테이블 접근 (CRUD)
APP(JAVA)
MVC(패턴) >> model(DTO,DAO,SERVICE-java) - view(html,jsp-front) - controller(servlet-java) (니가 잘하는 것만 해)

*****DAO!!!!
DB 작업 (DAO) >> EmpDao.java >> DB연결 (CRUD)
기본적으로 5개의 함수 생성 ....
1. 전체조회 (함수) : select * from emp 처리 함수
>> public List<Emp> getEmpList() { select * from emp return null }
--> 데이터 여러건 조회

2. 조건조회 (함수) : select * from emp where empno=?
>> pubilc Emp getEmpListByEmpno(int empno) { select * from emp where empno=? return null }
--> 데이터 한 건 처리 

3. 삽입 (함수)    : insert into emp(...) values(...)
>> public int insertEmp(Emp emp) { insert ... return row; }

4. 수정 (함수)    : update emp(...) set .... where ...
5. 삭제 (함수)    : delete emp where ...
*/
--9장 테이블 생성하기
--page 138


--DDL (create, alter, drop, rename) 테이블(객체) 생성, 수정, 삭제)
--코드 몰라도 ... TOOL 마우스 ... 코드 폼나게 살자

select * from tab;

select * from tab where tname=lower('board');

create table board(
    boardid number,
    title nvarchar2(50), --영문자 특수 공백 상관없이 50자 
    content nvarchar2(2000), --2000wk (4000byte)
    regdate date
);

desc board; --기본적인 정보
--Tip)
select * from user_tables where lower(table_name) = 'board';
select * from col where lower(tname)='board';
--제약정보 확인하기 (반드시)
select * from user_constraints where lower(table_name) ='board';
select * from user_constraints where lower(table_name) = 'emp';

--oracle 11g >> 실무 >> 가상컬럼(조합컬럼)
--학생 성적 테이블 (국어, 영어, 수학)
--합계, 평균
--학생 성적 테이블 (국어, 영어, 수학, 평균) -> 평균은 점수에 의해 바뀌어야 되니 잘못된 것
-- 각각의 점수 변화 >> 평균값도 변화 보장 >> 무결성

create table vtable(
    no1 number,
    no2 number,
    no3 number GENERATED ALWAYS as (no1 + no2) VIRTUAL
);

select * from col where lower(tname)='vtable';

insert into vtable(no1,no2) values(100,50);
select * from vtable;

--insert into vtable(no1,no2,no3) values(10,20,30); (x)

--실무에서 활용되는 코드
--제품정보 (입고) : 분기별 데이터 추출(4분기)
create table vtable2(
    no number, --순번
    p_code char(4), --제품코드 (A001, B003)
    p_date char(8), --입고일 (20230101)
    p_qty number, --수량
    p_bungi number(1) GENERATED ALWAYS as (
                                                case when substr(p_date,5,2) in ('01','02','03') then 1
                                                     when substr(p_date,5,2) in ('04','05','06') then 2
                                                     when substr(p_date,5,2) in ('07','08','09') then 3
                                                     else 4
                                                end
                                            ) VIRTUAL                                          
);

select * from col where lower(tname)='vtable2';

insert into vtable2(p_date) values('20220101');
insert into vtable2(p_date) values('20220522');
insert into vtable2(p_date) values('20220601');
insert into vtable2(p_date) values('20221111');
insert into vtable2(p_date) values('20221201');
commit;

select * from vtable2;

select * from vtable2 where p_bungi=2;

-----------------------------------------------------------------
--테이블 만들고 수정 삭제
--1. 테이블 생성하기
create table temp6(id number);

desc temp6;

--2. 테이블 생성 후에 컬럼 추가하기
alter table temp6
add ename varchar2(20);

desc temp6;

--3. 기존 테이블에 있는 컬럼 이름 잘못 표기 (ename -> username)
--기존 테이블 있는 기존 컬럼명 변경 (rename)
alter table temp6
rename column ename to username;

desc temp6;

--4. 기존 테이블에 있는 기존 칼럼의 타입 크기 수정 (기억) modify
alter table temp6
modify (username varchar2(2000));

desc temp6;


--5. 기존 테이블에 기존 컬럼 삭제
alter table temp6
drop column username;

desc temp6;

select * from tab;
--모든 작업은 TOOL 에서 가능 ....^^

--6. 테이블 전체가 필요 없어요
--6.1 delete 데이터만 삭제
--테이블 처음 만들면 처음 크기설정 >> 데이터 넣으면 >> 데이터 크기 만큼 테이블 크기 증가 
--처음 1M >> 데이터 10만건(insert) >> 100M >> delete 10만건 삭제 >> 테이블 크기 100M

--테이블 (데이터) 삭제(공간의 크기도 줄일 수 없을까)
--truncate ( 단점 : where 절 사용 못해요 )
--처음 1M >> 데이터 10만건(insert) >> 100M >> truncate >> 1M
--truncate table emp -- DBA 관리자 
--1M

--테이블 삭제
drop table temp6;

desc temp6; -- 객체가 존재하지 않습니다. 
select * from emp;

------------------------------------------------------------------------------
--테이블에 제약 설정하기
--page 144
/*
제약조건 설명
PRIMARY KEY(PK)    : 유일하게 테이블의 각행을 식별(NOT NULL 과 UNIQUE 조건을 만족)
FOREIGN KEY(FK)    : 열과 참조된 열 사이의 외래키 관계를 적용하고 설정합니다.
UNIQUE key(UK)     : 테이블의 모든 행을 유일하게 하는 값을 가진 열(NULL 을 허용)
NOT NULL(NN)       : 열은 NULL 값을 포함할 수 없습니다.
CHECK(CK)          : 참이어야 하는 조건을 지정함(대부분 업무 규칙을 설정

제약은 아니지만 default sysdate ....
*/

--PRIMARY KEY(PK) : NOT NULL과 UNIQUE 조건 >> null 데이터와 중복값 안돼요 
--보장 (유일값) 
--empno primary key >> where empno==7788 >> 데이터 1건 보장
--PK (주민번호, 회원ID, 상품ID) -> 중복되는 것을 막고 null 데이터 막는다
--성능 (PK 자동으로 index ....) >> 조회 empno >> 성능 >> index >> 자동생성

-- 테이블당 1개만 설정(1개의 의미는 (묶어서)) >> 복합키

--언제
--1. create table 생성시 제약 생성
--2. create table 생성후에 필요에 따라서 추가 (alter table emp add constraint ...)

--제약 확인
select * from user_constraints where table_name='EMP';

create table temp7(
    -- id number primary key 권장하지 않아요 (제약이름 자동설정 ... 제약 편집 ...)
    id number constraint pk_temp7_id primary key, --개발자 제약 이름 : pk_temp7_id
    name varchar2(20) not null,
    addr varchar2(50)
);

desc temp7;

select * from user_constraints where lower(table_name)='temp7';

--insert into temp7(name,addr) values('홍길동','서울시 강남구'); -- id 값이 없어서 에러

insert into temp7(id,name,addr) values(10,'홍길동','서울시 강남구'); 
select * from temp7;
commit;


insert into temp7(id,name,addr) values(10,'야무지개','서울시 강남구'); --기존 10번 있어서 안들어감

--Unique (UK) 테이블의 모든 행을 유일하게 하는 값을 가진 열(NULL을 허용)
--컬럼수 만큼 생성 가능
--null 허용
--Unique 제약을 걸고 추가적으로 not null >> 여러개
create table temp8(
    id number constraint pk_temp8_id primary key,
    name varchar2(20) not null,
    jumin nvarchar2(6) constraint uk_temp8_jumin unique, -- 중복 데이터를 갖지 않는다 
    addr varchar2(50)
);

select * from user_constraints where lower(table_name)='temp8';

insert into temp8(id,name,jumin,addr)
values(10,'홍길동','123456','경기도');

select * from temp8;

-- unique 특징
insert into temp8(id,name,jumin,addr)
values(20,'길동','123456','서울'); -- 중복으로 인해 걸림


insert into temp8(id,name,addr)
values(20,'길동','서울'); -- 들어간다..!! null은 허락한다.

select * from temp8;
--그럼 null도 중복체크 하나?? 아니요..ㅎㅎ

insert into temp8(id,name,addr)
values(30,'순신','서울');

select * from temp8;
commit;

--not null 가져가고 싶으면
--jumin nvarchar2(6) not null constraint uk_temp8_jumin unique,


--테이블 생성 후에 제약 걸기 (추천)
create table temp9(id number);
--기존 테이블에 제약 추가하기 (대부분의 툴이 이 방법)

alter table temp9
add constraint pk_temp9_id primary key(id);

select * from user_constraints where lower(table_name)='temp9';

--복합키 
--create table temp9(id number, num number);
--alter table temp9
--add constraint pk_temp9_id primary key(id, num); -- 복합키 
--유일한 한개의 row >> where id=100 and num=1

--컬럼 추가 
alter table temp9
add ename varchar2(50);


desc temp9;


--ename 컬럼에 not null 추가 
alter table temp9
modify(ename not null);

desc temp9; -- ENAME NOT NULL VARCHAR2(50)


----------------------------------------------------------------------
--check 제약 (업무 규칙 : where 조건을 쓰는 것 처럼)
--where gender in ('남','여')
create table temp10(
    id number constraint pk_temp10_id primary key,
    name varchar2(20) not null,
    jumin char(6) not null constraint uk_temp10_jumin unique
    addr varchar2(30),
    age number constraint ck_temp10_age check(age >= 19) -- where age >= 19
);

select * from user_constraints where table_name='TEMP10';


insert into temp10(id,name,jumin,addr,age)
values(100,'홍길동','123456','서울시 강남구', 20);

select * from temp10;


insert into temp10(id,name,jumin,addr,age)
values(200,'아무개','2345678','서울시 강남구', 18); -- check 제약에 위배 된다.
-- DB에도 방어막이 있어야 한다!!! java 코드에서만 막는 건 위험
commit;



--FOREIGN KEY (FK)    : 열과 참조된 열 사이의 외래키 관계를 적용하고 설정합니다.
--참조제약 (테이블과 테이블과의 관계 설정)


create table c_emp
as
    select empno, ename, deptno from emp where 1=2;
    

select * from c_emp;

create table c_dept
as
    select deptno , dname from dept where 1=2;
    
select * from c_dept;

desc c_emp;
desc c_dept;

--c_emp 테이블에 있는 deptno 컬럼의 데이터는 c_dept 테이블에 있는 deptno 컬럼에 있는 데이터만
--쓰겠다

--강제 (FK)
--c_dept 에 deptno 컬럼이 신용이 없어요 (PK, UNIQUE) ....
--alter table c_emp
--add constraint fk_c_emp_deptno foreign key(deptno) references c_dept(deptno);
-- c_dept(deptno) => 신용증이 없다..? 


alter table c_dept
add constraint pk_c_dept_deptno primary key(deptno);

--그리고 나서 참조제약 
alter table c_emp
add constraint fk_c_emp_deptno foreign key(deptno) references c_dept(deptno);

select * from user_constraints where talbe_name = 'C_DEPT';
select * from user_constraints where talbe_name = 'C_EMP';


--부서
insert into c_dept(deptno, dname) values(100,'인사팀');
insert into c_dept(deptno, dname) values(200,'관리팀');
insert into c_dept(deptno, dname) values(300,'회계팀');
commit; 


select * from c_dept;
--신입사원 입사
insert into c_emp(empno,ename,deptno)
values(1,'신입이',100);

select * from c_emp;


insert into c_emp(empno,ename,deptno)
values(2,'아무개',101);
--parent key not found

commit;
-----------------------------------------------------------------------
--제약 END--------------------------------------------------------------
--개발자 관점에서 FK 살펴보기--
--master - detail 관계
--부모 - 자식 관계

--c_emp 과 c_dept (관계 FK) >> c_emp(deptno) 컬럼이 c_dept(deptno) 컬럼을 참조
--FK 관계 : master(c_dept) - detail(c_emp) >> 화면 (부서 출력) >> 부서번호 클릭 >> 사원정보 출력
--deptno 참조 관계 부모(c_dept) - 자식(c_emp)

--관계 PK가지고 있는 쪽(master), FK(detail)

select * from c_dept;

select * from c_emp;

--1. 위 상황에서 c_emp 테이블에 있는 신입이 삭제할 수 있을까요?

delete from c_dept where deptno=100; -- 참조 당하는 쪽은 삭제가 안된다. emp에서 오류가 생기기 때문에
delete from c_dept where deptno=200; -- 이건 지워진다. 실제 참조해서 빌려쓰고 있지 않으면 지워진다. 

delete from c_dept where deptno=100;
delete from c_emp where empno=1; --참조하지 않게 ...

--자식 삭제
--부모 삭제 하시면 됩니다.

commit;


/*



ON DELETE CASCADE 부모 테이블과 생명을 같이 하겠다

alter table c_emp
add constraint fk_c_emp_deptno foregin key(deptno) references c_dept(deptno) ON DELETE CASCADE

delete from c_emp where empno=1 >> deptno >> 100번

delete from c_dept where deptno=100; 삭제 안돼요 (참조하고 있으니)
on delete CASCADE 걸면 삭제 된다. 대신 부모도 삭제, 참조하고 있는 자식도 삭제

부모삭제 >> 참조하고 있는 자식도 삭제

ORACLE
ON DELETE CASCADE

MS-SQL 
ON DELETE CASCADE
ON UPDATE  CASCADE
*/

create table studentScore (
    id number constraint pk_studentScore_id primary key,
    name varchar2(20) not null,
    korean number ,
    math number ,
    english number,
    totalScore number GENERATED ALWAYS as (korean+math+english) VIRTUAL,
    avgScore number GENERATED ALWAYS as ((korean+math+english)/3) VIRTUAL,
    deptno number, 
    constraint fk_studentScore_deptno foreign key(deptno) references schoolDepartment(deptno)
);

create table schoolDepartment (
    deptno number constraint pk_schoolDepartment_deptno primary key,
    deptname varchar2(20) not null
);

desc schoolDepartment;
select * from user_constraints where lower(table_name)='schoolDepartment';

------------------------------------------------------------------------
--요기까지 초급 과정 END-----------------------------------------------------

--제 12장 VIEW (초중급)
--가상 테이블 (subquery >> in line view >> from())
--필요한 가상테이블을 객체형태로 만들기 (영속적으로)

create view view001
as
    select * from emp;
    
--view001 이라는 객체가 생성 되었어요 (가상 테이블 >> 쿼리 문장을 가지고 있는 객체)
---사용자 편집 -> 시스템 권한 -> create anyview 체크하기
--뷰 -> view

select * from view001; -- 하나의 객체로 가상 테이블로서 사용 가능

select *  from view001 where deptno=20;

--view (가상 테이블)
--사용법 : 일반 테이블과 동일 (select, insert, update, delete)
--단 VIEW 볼 수 있는 데이터에 한해서
--view 통해서 원본 테이블에 insert, update, delete (DML) 기능 ... 기능정도만 ...

--VIEW 목적
--1. 개발자의 편리성 : join, subquery 복잡한 쿼리 미리 생성해두었다가 사용
--2. 쿼리 단순화 : view 생성해서 JOIN 편리성
--3. DBA 보안 : 원본데이터는 노출하지 않고 view 만들어서 제공 (특정 컬럼을 노출하지 않는다)

--보안적인 특징 
create or replace view v_001
as
    select empno ename from emp;
    

select * from v_001;

create or replace view v_emp
as
    select empno, ename, job, hiredate from emp;
    

--신입이 .... v_emp

select * from v_emp;

select * from v_emp where job='CLERK';


--편리성
create or replace view v_002
as
    select e.empno, e.ename, e.deptno, d.dname
    from emp e join dept d
    on e.deptno = d.deptno;

select * from = v_002;


--직종별 평균 급여를 볼 수 있는 view 작성 (객체) -- 객체를 drop 하지 않는 한 영속적 ...
create view v_003
as
    select deptno, trunc(avg(sal),0) as avgsal from emp group by deptno;
    

select *
from emp e join v_003 s
on e.deptno = s.deptno
where e.sal > s.avgsal;

/*
view 나름 테이블(가상) view를 [통해서] view가 [볼수있는] 데이터에 대해서 
DML (insert, update, delete) 가능 ....
*/
/*
create or replace view v_emp
as
    select empno, ename, job, hiredate from emp;
*/

select * from v_emp;

update v_emp
set sal=0; -- view 가 볼 수 없는 데이터

update v_emp
set job='IT';

--실제로는 원본 emp 테이블 데이터 업데이트
select * from emp;
select * from v_emp;

rollback;

--1.
--30번 부서 사원들의 직종, 이름, 월급을 담는 VIEW를 만드는데,
--각각의 컬럼명을 직종, 사원이름, 월급으로 ALIAS를 주고 월급이
--300보다 많은 사원들만 추출하도록 하라.
create view  v_30
as
    select job, ename, sal from emp where deptno=30;


--2.
--부서별 평균월급을 담는 VIEW를 만들되, 평균월급이 2000이상인
--부서만 출력하도록 하라. view102

select * from v_emp;

create view view102
as
    select deptno, avg(sal) as avgsal from emp group by deptno having svg(sal) >=2000;
    


select * from employees; -- 노동자들의 정보
select * from departments; -- 노동자들의 부서
select * from locations; -- 위치 지역


--문제
-- 자신의 급여가 부서별 평균 급여보다 많고 comm을 받는 사원들 중 가장 많은 country_ID의 급여 평균을 출력하라.

--1. 문제 
--부서의 소재지가 미국인 직원 중 본인의 부서 평균 월급보다 높은 직원을 추출하고
--이름, 월급, 부서번호, 부서이름, 도시이름을 월급이 높은 순으로 출력하세요.
--단 이름은 성과 이름이 모두 한 칼럼에 출력되어야 한다

select e.first_name || e.last_name, e.salary, e.department_id, d.department_name, l.city
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where e.salary in (select trunc(avg(salary))from employees group by department_id) and l.country_id='US'
order by e.salary desc;

--2. 자신의 급여가 부서별 평균 급여보다 많고 이름에 'A'가 들어가는 사원들 중 가장 많은 country_ID의 급여 평균을 출력하라.
-- 자신의 급여가 부서별 평균 급여보다 많고 'A'가 들어가는 사원들 

select trunc(avg(e.salary))
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where l.country_id in (select Max(l.country_id)
from employees e
join departments d on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where e.salary in (select trunc(avg(salary))from employees group by department_id)) AND lower(e.first_name || e.last_name) like '%a%';















