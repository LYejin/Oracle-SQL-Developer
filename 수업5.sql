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

---------------------------------------------------------------------------------
--개발자 관점

--오라클.pdf
--sequence (시퀀스)
/*
2) 공유 가능한 객체(테이블간에)
3) 주로 기본 키 값을 생성하기 위해 사용됩니다.
4) 어플리케이션 코드를 대체합니다. (로직 만들 필요 없다)
5) 메모리

*/


desc board;
drop table board;


create table board(
    boardid number constraint pk_board_boardid primary key,
    title nvarchar2(50)  
);


select * from user_constraints where table_name='BOARD';
--not null, unique, index(검색속도)

--게시판 글쓰기 작업
insert into board(boardid, title) values(1,'처음글');
insert into board(boardid, title) values(2,'두번째');

rollback;
select * from board;

--처음 글을 쓰면 글번호가 1번 ... 그 다음글 순차적인 증가값 ... 2번, 3번
--어떤 논리
select count(boardid)+1 from board;

insert into board(boardid, title)
values((select count(boardid)+1 from board), '내용');


insert into board(boardid, title)
values((select count(boardid)+1 from board), '내용2');


insert into board(boardid, title)
values((select count(boardid)+1 from board), '내용3');

select * from board;
--게시글 삭제, 수정
--게시글 삭제
commit;

delete from board where boardid=1;

select * from board;
commit;

insert into board(boardid, title)
values((select count(boardid)+1 from board), '내용3'); --중복값 (로직 x)

--데이터가 삭제되어도 문제없는 순번을 가지고 싶어요
insert into board(boardid, title)
values((select nvl(max(boardid),0)+1 from board), '새글');

select * from board;

-------------------------------------------------------------------------------


--시퀀스 생성하기 (순번 만들기) : 객체(create ...) : 순차적인 번호를 생성하는 객체
create sequence board_num;
--순번
select board_num.nextval from dual; --채번 (번호표 뽑기)

select board_num.currval from dual; -- 현재까지 채번한 번호 확인 (마지막)

--공유(객체) >> 하나의 테이블이 아니라 여러개의 테이블 사용

--A테이블,             B테이블
--(insert >> 1       (insert >> 2,      insert >> 3
--(insert >> 4


create table kboard(
    num number constraint pk_kboard_num primary key,
    title nvarchar2(20)
);

create sequence kboard_num;

insert into kboard(num,title) values (kboard_num.nextval,'처음');

insert into kboard(num,title) values (kboard_num.nextval,'두번째');

insert into kboard(num,title) values (kboard_num.nextval,'세번째');

select * from kboard;


--------------------------------------------------------------------------------
/*
--게시판
--공지사항, 자유게시판, 답변형 게시판 ....
공지사항 1,2,3 (시퀀스 객체1)

자유게시판 1,2,3 (시퀀스 객체2)

답변형 게시판 1,2,3 (시퀀스 객체3)
-----------------------------------
공지사항 1, 6

자유게시판 2, 3

답변형 게시판 4, 5

시퀀스 객체 한개 3개 테이블에서 (공유객체)

TIP)
sequence 모든 DB에 ...
오라클                       (0)
MS-SQL 2012 버전 (sequence) (0)
MY-SQL                     (x)
Maiadb (엔진 MY-SQL)        (0) : https://mariadb.com/kb/ko/sequence-overview/
PostgreSQL                 (0)

--순번을 생성(테이블 종속적으로)
MS-SQL
create table board(boardnum int identity(1,1) ... title
insert into board(title) values('제목');  >> boardnum >> 1이 자동

my-sql
create table board(boardnum int auto increment, ... title
insert into board(title) values('제목');  >> boardnum >> 1이 자동

*/

--옵션
create sequence seq_num
start with 10
increment by 2;

select seq_num.nextval from dual;

select seq_num.currval from dual;

--순번
--게시판 처음 ... 데이터 가져올 때
--쿼리문
--num > 1, 2, 3, ,,,,, 1000 ,,,,,, 10000
--가장 나중에 쓴글 (최신글)
---select * from board order by num desc







