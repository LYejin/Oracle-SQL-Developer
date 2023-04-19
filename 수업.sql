/*

1일차 수업

1. 소프트웨어 다운로드 (11g)

2. Oracle 설치 (SYS, STYSTEM 계정에 대한 암호 설정: 1004)

3. sqlplus 프로그램 제공(CMD) : 단점 GUI 환경 제공하지 않아요

4. 별도의 프로그램 접속 Tool
4.1 SqlDeveloper 무료, dbeaver 무료
4.2 토드, 오렌지, SqlGate 회사 ....

5. SqlDevelop 실행 >> Oracle 서버 접속 >> GUI
5.1 HR 계정 사용 (unlock)

-- USER SQL
ALTER USER "HR" IDENTIFIED BY "1004" 
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP"
ACCOUNT UNLOCK ;

-- QUOTAS
ALTER USER "HR" QUOTA UNLIMITED ON "USERS";

-- ROLES
ALTER USER "HR" DEFAULT ROLE "CONNECT","RESOURCE";

-- SYSTEM PRIVILEGES


5.2 kosa 계정 쿼리 

*/

show user;

--문자열 함수
select initcap('the super man') from dual; --The Super Man

select lower('AAA'), upper('aaa') from dual;

select ename, lower(ename) as "ename" from emp;

select * from emp where lower(ename) = 'king';

select length('abcd') from dual; --문자열의 개수

select length('홍길동') from dual; -- 3개

select length('   홍 길 동a') from dual; -- 9개

select concat('a', 'b') from dual; --ab

--select concat('a','b','c') from dual; -- 오류
select 'a' || 'b' || 'c' from dual;

select concat(ename, job) from emp;
select ename || '    '  ||  job from emp;

--Java : substring
--ORABLE : substr
--  ( 1 -> 시작점 , 몇개 )

select substr('ABCDE',2,3) from dual; -- BCD // 2번째부터 3개 
select substr('ABCDE',1,1) from dual; -- A
select substr('ABCDE',3,1) from dual; -- C

select substr('dfsuehfksuhdfkujs', 3) from dual; -- 3번째부터 끝까지
select substr('dfsuehfksuhdfkujs', 3, length(ename)) from dual; -- 도 가능 

/*
사원테이블에서 ename 컬럼의 데이터에 대해서 첫글자는 소문자로 나머지 글자는 대문자로
출력하되 하나의 컬럼으로 만들어서 출력하시고 컬럼의 별칭은 fullname하고 첫글자와 나머지
문자 사이에는 공백 하나를 넣으세요.
*/
select lower(substr(ename,1,1)) || ' ' || upper(substr(ename,2)) 
as fullname from emp;

select lpad('ABC',10,'*') from dual; -- left padding

select rpad('ABC',10,'*') from dual; -- right padding 총 10글자 

select rpad('ABC',10,'#') from dual;

--사용자 비번 : hong1004 or k1234
--화면 앞에 2글자만 보여주고 나머지는 특수 문자로

select rpad(substr('hong1004',1,2), length('hong1004'), '*') from dual;
select rpad(substr('k1234',1,2), length('k1234'), '*') from dual;

-- emp 테이블에서 ename 컬럼의 데이터를 출력하되 첫글자만 출력하고 나머지는 * 출력하세요

select rpad(substr(ename,1,1), length(ename), '*') as ename from emp; 
-- 새롭게 만들면 이름이 만든 걸로 지정하게 된다.

create table member2(
    id number,
    jumin varchar2(14)
);

insert into member2(id, jumin) values(100,'123456-1234567');
insert into member2(id, jumin) values(200,'234657-1234567');
commit;

select * from member2;
--출력결과 
--100 : 123456-*******
--200 : 234567-*******

select id || ' : ' || rpad(substr(jumin,1,7), length(jumin), '*') as jumin 
from member2;

--rtrim 함수
--오른쪽 문자를 지워라
select rtrim('MILLER','ER') from dual; --MILL // 문자 기준 오른쪽 


--ltrim 함수
--왼쪽 문자를 지워라
select ltrim('MILLLLLLLER','MIL') from dual; -- ER

--공백제거
select '>' || 'MILLER      ' || '<' from dual; -- >MILLER      <
select '>' || ltrim('MILLER      ',' ') || '<' from dual; -- >MILLER<

--치환함수
select ename, replace(ename,'A','와우') from emp;

-----------------------------------------------------------------------------
--숫자함수
--round (반올림함수)
--trunc (절식함수)
-- mod() 나머지 구하는 함수 

--round
-- -3 -2 -1 0 (정수) 1 2 3
select round(12.345,0) as r from dual; -- 정수부만 남겨라 12

select round(12.567,0) as r from dual; -- 반올림이 되어서 13

select round(12.345,1) as r from dual; -- 소수점 첫째짜리 12.3

select round(12.567,1) as r from dual; -- 반올림 12.6

select round(12.345,-1) as r from dual; -- 10의 자리까지 남겨라 10

select round(15.345,-1) as r from dual;  -- 반올림 20 

select round(15.345,-2) as r from dual; -- 0 없는 숫자 


--trunc
select trunc(12.345,0) as t from dual; -- 정수부만 남겨라 12

select trunc(12.567,0) as t from dual; -- 반올림이 안되고 12

select trunc(12.345,1) as t from dual; -- 소수점 첫째짜리 12.3

select trunc(12.567,1) as t from dual; -- 12.5

select trunc(12.345,-1) as t from dual; -- 10의 자리까지 남겨라 10

select trunc(15.345,-1) as t from dual;  -- 10 

select trunc(15.345,-2) as t from dual; -- 0 없는 숫자 

-- 나머지
select 12/10 from dual; --1.2

select mod(12, 10) from dual; -- 나머지를 구하는 함수 

select mod(0,0) from dual; -- 오류 나지 않고 0이 뜸

--------------------------------------------------------------------
--날짜 함수 (연산)
select sysdate from dual;
--POINT
--1. Date + Number >> Date
--2. Date - Number >> Date
--3. Date - Date   >> Number *** (일수) ^^

select sysdate + 100 from dual; -- 
select sysdate + 1000 from dual;
select sysdate - 1000 from dual;

select hiredate from emp;

--개월을 구하는 함수 months_between 
select trunc(months_between('2022-09-27','2020-09-27'), 0) from dual; -- 24개월 

select months_between(sysdate, '2020-01-01') from dual; -- 39개월

--주의사항 조심하세요^^
select '2023-01-01' + 100 from dual; -- 에러 // '2023-01-01' [날짜형식]이지만 문자열로 본다

--해결함수 : 문자를 날짜로 바꾸는 함수 to_date()
select to_date('2023-01-01') + 100 from dual;

-- 사원테이블에서 사원들의 입사일에서 현재날짜까지의 근속월수를 구하세요
-- 사원이름, 입사일, 근속월수 출력
-- 단 근속월수는 정수부만 출력 
-- 한달이 31일이라고 가정하고 그 기준에서 근속월수 
-- 함수는 사용하지 마세요 (반올림 하지 마세요)

select ename, hiredate, trunc((sysdate-hiredate)/31, 0) 
as 근속월수 from emp;

--------------------------------------------------------------------
--문자함수, 숫자함수, 날짜함수 END -------------------------------




--변환함수 Today Point
--오라클 데이터 유형 : 문자열, 숫자, 날짜

-- to_char() : 숫자 -> 형식문자 (100000 -> $100,000) 문자로 변환 >> format 출력형식정의
-- to_char() : 날짜 -> 형식문자 ('2023-01-01' -> 2023년01월01일 >> format 출력형식정의

-- to_date() : 문자(날짜형식) -> 날짜
--select to_date('2023-01-01' + 100 from dual;

--to_number() : 문자 -> 숫자 (자동 형변환)
select '100' + 100 from dual; -- 200
select to_number('100') + 100 from dual; -- 200

-- 변환시 표참조 (page 69 ~ 71 참조)
-- 형식 format 찾기

select sysdate, to_char(sysdate,'YYYY') || '년' as yyyy,
to_char(sysdate,'YEAR') as YEAR,
to_char(sysdate,'MM') as MM,
to_char(sysdate,'DD') as DD,
to_char(sysdate,'DAY') as DAY
from dual;

-----입사일이 12월인 사원의 사번, 이름, 입사일, 입사년도, 입사월을 출력
select empno, ename, hiredate, to_char(hiredate,'YYYY') , to_char(hiredate,'MM') 
from emp where to_char(hiredate,'MM')='12';

select '>' || to_char(12345,'9999999999') || '<' from dual;

select '>' || ltrim(to_char(12345,'$999,999,999,999')) || '<' from dual;

select sal, to_char(sal, '$999,999') as 급여 from emp;


----HR 계정 이동
show user;
--USER이(가) "HR"입니다.

select * from employees;

select last_name || first_name as fullname, salary, to_char(hire_date,'YYYY-MM-DD') as 입사일, 
salary*12 as 연봉, to_char((salary*12)*1.1, '$999,999,999') as 인상분  
from employees
where to_char(hire_date, 'YYYY') >= '2005'
--order by salary*12 desc;
order by 연봉 desc; -- select 한 결과를 정렬하기 때문에 select 컬럼명 

--다시 KOSA USER로
show user;

--Tip
select 'A' as a, 10 as b, null as c, empno 
from emp;

------------------------------------------------------------------
--문자, 숫자, 날짜, 변환함수(to_...)
------------------------------------------------------------------

--일반 함수 (프로그래밍 성격이 강하다)
--SQL (변수, 제어문 개념이 없다)
--PL-SQL (변수, 제어문 ....) 고급기능 (트리거, 커서, 프로시져)


--nvl() null 처리하는 함수
--decode() >> java if문      >> 통계 데이터(분석) >> pivot, cube, rollup
--case()   >> java switch문 

select comm, nvl(comm,0) from emp;

create table t_emp(
    id number(6), --정수 6자리
    job nvarchar2(20) -- n = 유니코드(unicode) -> 한글이던 영문자이던 2byte로 20자 >> 40byte
);

desc t_emp;

insert into t_emp(id,job) values(100,'IT');
insert into t_emp(id,job) values(200,'SALES');
insert into t_emp(id,job) values(300,'MANAGER');
insert into t_emp(id,job) values(400);
insert into t_emp(id,job) values(500,'MANAGER');
commit;

select * from t_emp;

select id, decode(id,100,'아이티' --조건값, 비교값 
                    ,200,'영업팀'
                    ,300,'관리팀'
                        ,'기타부서') as 부서이름
from t_emp;


select empno, ename, deptno, decode(deptno, 10, '인사부',
                                            20, '관리부',
                                            30, '회계부',
                                            40, '일반부서',
                                                'ETC') as 부서이름
from emp;


create table t_emp2(
    id number(2),
    jumin char(7) -- 고정길이 문자열 
);

desc t_emp2;

insert into t_emp2(id,jumin) values(1,'1234567');
insert into t_emp2(id,jumin) values(2,'2234567');
insert into t_emp2(id,jumin) values(3,'3234567');
insert into t_emp2(id,jumin) values(4,'4234567');
insert into t_emp2(id,jumin) values(5,'5234567');
commit;

select * from t_emp2;
/*
t_emp2 테이블에서 id, jumin 데이터를 출력하되 jumin컬럼에 앞자리가 1이면
남성, 2이면 여성, 3이면 중성 그외는 기타라고 출력하세요. (컬럼명은 성별)
*/

select id, jumin ,decode(substr(jumin,1,1), 1, '남성',
                                            2, '여성',
                                            3, '중성',
                                                '기타') as 성별 
from t_emp2;

--if 안에 if가 올 수 있다
--decode(decode())

/*
부서번호가 20번인 사원중에서 SMITH라는 이름을 가진 사원고이라면 HELLO 문자 출력하고
부서번호가 20번인 사원중에서 SMITH라는 이름을 가진 사원이 아니라면 WORLD 문자 출력하고
부서번호가 20번인 사원이 아니라면 ETC 문자 출력하고
*/

select decode(deptno, 20, decode(ename, 'SMITH', 'HELLO', 
                                                    'WORLD'), 
                    'ETC') 
from emp;

--CASE 문
/*
CASE 조건식  WHEN 결과1 THEN 출력1
           WHEN 결과2 THEN 출력2
           WHEN 결과3 THEN 출력3
           WHEN 결과4 THEN 출력4
           ELSE 출력5
END "컬럼명"
*/

create table t_zip(
    zipcode number(10)
);

desc t_zip;

insert into t_zip(zipcode) values(2);
insert into t_zip(zipcode) values(31);
insert into t_zip(zipcode) values(32);
insert into t_zip(zipcode) values(41);
commit;

select * from t_zip;

select '0' || to_char(zipcode), case zipcode when 2 then '서울'
                                             when 31 then '경기'
                                             when 41 then '제주'
                                             else '기타'
                                end 지역이름 
from t_zip;


/*
사원테이블에서 사원급여가 1000달러 이하면 4급
1001달러 2000달러 이하면 3급
2001달러 3000달러 이하면 2급
3001달러 4000달러 이하면 1급
4001달러 이상이면 '특급'이라는 데이터를 출력하세요 

1.
CASE 컬럼명 WHEN 결과1 THEN 출력1

2. case 사이에 아무것도 없고 비교대상자, 비교식
CASE WHEN 조건 비교식 THEN 결과
     WHEN 조건 비교식 THEN 결과
     WHEN 조건 비교식 THEN 결과
     ELSE
END
*/

select case when sal <= 1000 then '4급'
            when sal between 1001 and 2000 then '3급'
            when sal between 2001 and 3000 then '2급'
            when sal between 3001 and 4000 then '1급'
        else '특급'
end 사원급
from emp;

------------------------------------------------------------------
--문자, 숫자, 날짜, 변환함수(to_...), 일반 함수(nvl, decode, case) END
------------------------------------------------------------------

--집계함수(그룹)
--75page
/*
1. count(*) >> row수, count(컬럼명) >> 데이터 건수
2. sum()
3. avg()
4. max()
5. min()
기타

1. 집계함수는 group by 절과 같이 사용
2. 모든 집계함수는 null값 무시
3. select 절에 집계함수 이외에 다른 컬럼이 오면 반드시 그 컬럼은 group by 절에 명시 
*/

select count(*) from emp; -- 14개의 row

select count(empno) from emp; -- 14건

select count(comm) from emp; --6 (null 아닌 데이터만 count)

select count(nvl(comm,0) from emp; --14건

-- 급여의 합
select sum(sal) from emp; -- 29025

select trunc(avg(sal)) from emp; --2073


-- 사장님 .... 총 수당이 얼마나 지급되었나
select sum(comm) from emp; -- 4330

--수당의 평균은 얼마지? (받는 사람 기준)
select trunc(avg(comm),0) from emp; -- 721
select (300+200+30+300+3500+0)/6 from dual; -- 721 /// 14인데? 
select comm from emp;

-- 사원수 기준 
select (300+200+30+300+3500+0)/14 from dual; -- 309
select trunc(avg(nvl(comm,0))) from emp; --309

-- 둘다 맞다 (의미)
-- 721
-- 309

select max(sal) from emp;
select min(sal) from emp;

select sum(sal), max(sal), min(sal), count(*), count(sal)
from emp;

-- row 14        1  -> 그래서 안된다
select empno, count(empno)
from emp;
-- not a single-group group function


-- 부서별 평균 급여를 구하세요
select deptno, avg(sal)
from emp
group by deptno;

-- 직종별 평균 급여를 구하세요
select job, avg(sal)
from emp
group by job; -- 문법적인 오류 없어요 (판단할 수 없어요)

select job, avg(sal), sum(sal), max(sal), min(sal), count(sal)
from emp
group by job;


/*
distinct 컬럼명1, 컬럼명2

order by 컬럼명1, 컬럼명2

group by 컬럼명1, 컬럼명2
*/

-- 부서별, 직종별 급여의 합을 구하세요
select deptno, job, sum(sal)
from emp
group by deptno, job -- 부서번호 .. 그 안에서 직종별 그룹 ... 합계
order by deptno; -- 부서번호 

/*
select절     4
from 절      1
where 절     2
group by 절  3
order by 절  5
*/

-- 직종별 평균급여가 3000달러 이상인 사원의 직종과 평균
select job, trunc(avg(sal)) as avgsal
from emp
--where 3000<=sal
group by job
having avg(sal) >= 3000;
--from 절의 조건절 >> where
--group by 절의 조건절 >> having (집계함수 조건을 처리)

/*
select 절    5
from 절      1
where 절     2
group by 절  3
having 절    4
order by 절  6

단일 테이블에 처리할 수 있는 모든 구문 
*/

select * from emp;
/*
사원테이블에서 직종별 급여합을 출력하되 수당은 지급받고 급여의 합이 5000 이상인
사원들의 목록을 출력하세요 (comm 0인 놈도 받는 것으로 ...)
급여의 합이 낮은 순으로 출력하세요
*/
select job, ename, sum(sal) as sumsal
from emp
where comm is not null
group by job, ename
having sum(sal) >= 5000
order by sum(sal);

/*
사원테이블에서 부서 인원이 4명보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력하세요
*/
select deptno, count(deptno) as "부서별인원", sum(sal) as "부서별 급여의 합"
from emp
group by deptno
having count(deptno)> 4;


/*
사원테이블에서 직종별 급여의 합이 5000를 초과하는 직종과 급여의 합을 출력하세요
단 판매직종(salesman) 은 제외하고 급여합으로 내림차순 정렬하세요
*/
select job, sum(sal)
from emp
where NOT job = 'SALESMAN'
group by job
having sum(sal) > 5000
order by sum(sal) desc;

/*
HR 계정으로 이동하세요
1. EMPLOYEES 테이블을 이용하여 다음 조건에 만족하는 행을 검색하세요. 
2005년이후에 입사한 사원 중에 부서번호가 있고, 급여가 5000~10000 사이인 사원을 검색합니다. 
가) 테이블 : employees 
나) 검색 : employee_id, last_name, hire_date, job_id, salary, department_id 
다) 조건
    ① 2005년 1월 1일 이후 입사한 사원
    ② 부서번호가 NULL이 아닌 사원 
    ③ 급여가 5,000보다 크거나 같고, 10,000 보다 작거나 같은 사원 
    ④ 위의 조건을 모두 만족하는 행을 검색 
라) 정렬: department_id 오름차순, salary 내림차순

2.EMPLOYEES 테이블을 이용하여 다음 조건에 만족하는 행을 검색하세요. 
부서번호가 있고, 부서별 근무 인원수가 2명 이상인 행을 검색하여 부서별 최대 급여와 최소 급여를 계산하
고 그 차이를 검색합니다. 
가) 테이블 : employees 
나) 검색 : department_id, MAX(salary), MIN(salary), difference 
        - MAX(salary) 와 MIN(salary)의 차이를 DIFFERENCE로 검색 
다) 조건
    ① 부서번호가 NULL이 아닌 사원 
    ② 부서별 근무 인원수가 2명 이상인 집합 
라) 그룹 : 부서번호가 같은 행
마) 정렬 : department_id
*/

select * from EMPLOYEES;

select employee_id, last_name, hire_date, job_id, salary, department_id
from employees
where department_id is not null and hire_date>'2005-01-01' and salary between 5000 and 10000
order by department_id, salary desc;

select department_id, MAX(salary), MIN(salary), MAX(salary) - MIN(salary) as difference
        from employees
        where department_id is not null
        group by department_id
        having count(*) >=2
        order by department_id;
        
---------------------------------------------------------------
--단일 테이블 쿼리 END --------------------------------------------
--ETC
--create table 테이블명(컬럼명 타입, 컬럼명 타입)
create table member3(age number);

--데이터 1건
insert into member3(age) values(100);

--데이터 여러건
insert into member3(age) values(200);
insert into member3(age) values(300);
insert into member3(age) values(400);

-----------------------------------------------------------------------
/*
JAVA
class Member3 ( private int age; setter, getter)

--1건
Member3 member = new Member3();
m.setAge(100);

--다수의 데이터
List<Member3> mlist = new ArrayList<>();
mlist.add(new Member3(100));
mlist.add(new Member3(200));

데이터 타입
문자열 데이터 타입
char(10)        >> 10byte >> 한글5자, 영문자, 특수, 공백 10자 >> 고정길이 문자열 
varchar2(10)    >> 10byte >> 한글5자, 영문자, 특수, 공백 10자 >> 가변길이 문자열 

고정길이 (데이터와 상관없이 크기를 갖는것)
가변길이 (들어오는 데이터 크기만큼 확보)

char(10) >> 'abc' >> [a][b][c][][][][][][][] >> 공간크기 변화 없음
varchar2(10) >> 'abc' >> [a][b][c] >> 데이터 크기 만큼 공간 확보 

누가봐도 varchar2(10)

성능 ..... 데이터 검색 >> char() 더 빠르다 >> 고정길이 .... 가변보다는 좀 앞서 검색

char(2) : 고정길이 (남, 여 ..... 대, 중, 소 ,,,, 주민번호) 검색 성능
가변길이 문자열 (사람의 이름, 취미,주소)

한글, 영어권 >> 한문자 >> unicode >> 한글, 영문 >> 2byte

nchar(20) >> 20자 >> 영문자 특수문자 공백 상관없이 >> 40byte

nvarchar2(20) >> 20자
*/

--오라클 함수 ......
select * from SYS.NLS_DATABASE_PARAMETERS;
--NLS_CHARACTERSET  : 	AL32UTF8  한글 3byte 인식
--KO16KSC5601 2Byte (현재 변환하면 한글 다깨짐)
select * from nls_database_parameters where parameter like '%CHAR%';
------------------------------------------------------------------------------
create table test2(name varchar2(2));

insert into test2(name) values('a');
insert into test2(name) values('aa');
insert into test2(name) values('가'); --한글 1자 3byte 인지
-------------------------------------------------------------------------------
--JOIN(하나 이상의 테이블에서 데이터 가져오기)
--신입 요구하는 기술

/*
2. Join의 종류
Join 방법 설명
Cartesian Product 모든 가능한 행들의 Join
*Equijoin Join 조건이 정확히 일치하는 경우 사용(일반적으로 PK와 FK 사용)
*Non Equijoin Join 조건이 정확히 일치하는 않는 경우에 사용
*Outer Join Join
*Self Join
set Operation 여러 개의 SELECT 문장을 연결하여 작성한다

Equijoin Join -- 1:1 매핑할 것이 있는 것
Non-Equijoin Join -1:1 매핑할 것이 없는 것 
Outer Join Join 
Self Join

관계형 DB (RDBS)

관계 (테이블과 테이블과의 관계)
(클래스 (자바) 비교) >> 연관관계 존재

1 : 1
1 : N (70%) 
M : N

create table M (M1 char(6) , M2 char(10));
create table S (S1 char(6) , S2 char(10));
create table X (X1 char(6) , X2 char(10));

insert into M values('A','1');
insert into M values('B','1');
insert into M values('C','3');
insert into M values(null,'3');
commit;

insert into S values('A','X');
insert into S values('B','Y');
insert into S values(null,'Z');
commit;

insert into X values('A','DATA');
commit;

*/


--1. 등가조인(equi join)
--원테이블과 대응대는 테이블에 있는 컬럼의 데이터를 1:1 매핑
--SQL JOIN 문법 (오라클) 간단
--ANSI 문법 권장 >> 무조건 >> [inner join    on 조건절]

-- SQL 문법 
select m.m1, m.m2, s.s2
from m, s
where m.m1 = s.s1;

--ANSI (표준문법)
select *
from m join s -- m inner join s
on m.m1=s.s1;

select * from emp;

select * from dept;

--사원번호, 사원이름, 부서번호, 부서이름을 출력하세요 (ANSI)
select emp.empno, emp.ename, emp.deptno, dept.dname
from emp join dept
on emp.deptno=dept.deptno;

--현업 (테이블 가명칭 부여)
select e.empno, e.ename, e.deptno, d.dname
from emp e join dept d
on e.deptno = d.deptno;

-- ***조인은 select * 하고 나서 컬럼을 명시
select s.s1, s.s2, x.x2
from s join x
on s.s1 = x.x1;

select sysdate from dual;








​