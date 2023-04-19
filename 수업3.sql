--데이터 조작 (DML) 입니다
--168page
--insert, update, delete (반드시 암기)
/*
DDL(데이터 정의어) : [create, alter, drop, trucate], rename, modify
DML(데이터 조작어) : 트랜잭션을 일으키는 작업 : insert, update, delete
ex) 개발자 ... 회사 갑자기 ...DB select 잘되는데 insert, update, delete 안돼요
    >> 갑자기 log write를 수행하는 작업 (어떤놈이 .언제.어떤.무슨 기록)
    >> DISK 기록 (log file full) >> log write 안되면 DML 작업도 못한다
    >> log backup >> log 삭제 .....
    
    >> commit 하지 않은 경우 ..... 실습 ... 일상다반사
    >> 
DQL (데이터 질의어) : select 
DCL (데이터 제어어) : 관리자 : grant, revoke
TCL (트랜젝션)     : commit, rollback, savepoint  
*/

-- 오라클 insert, update, delete 작업 반드시 commit, rollback 처리
-- Tip) tab, col 테이블 사용하기 
select * from tab; -- 사용자(KOSA) 계정이 가지고 있는 테이블 목록


--내가 테이블을 생성 .... 그 이름이 있는지 없는지 
select * from tab where tname='BOARD'; 
select * from tab where tname='EMP';
select * from col where tname='EMP';

-----------------------------------------------------------------------------
--insert, update, delete 무조건 암기

--1. INSERT
create table temp(
    id number primary  key, -- not null, unique 받겠다 (회원ID, 주민번호)
    name varchar2(20)
);

desc temp;

--1. 일반적인 insert
insert into temp(id, name)
values(100,'홍길동');

--commit, rollback 하기 전까지 실반영하지 않아요 
select * from temp;
-- 마음에 들면 commit 아니면 rollback

commit;
-- 디스크에 들어가서 컴퓨터를 껏다켜도 남아있다

--2. 컬럼 목록 생략 (insert) 쓰지 마세요 
insert into temp
values(200, '김유신');

select * from temp;
rollback; -- 마음에 안들어서 롤백 -> 전 것으로 돌아감

--3. 문제 ...insert
insert into temp(name)
values('아무개');
--자동 id 컬럼 >> null >> PK >> ORA-01400: cannot insert NULL into ("KOSA"."TEMP"."ID")

insert into temp(id,name)
values(100,'개똥이');
--PK >> id >> 중복데이터 (x) >> ORA-00001: unique constraint (KOSA.SYS_C006998) violated

insert into temp(id,name)
values(200,'정상인');

select * from temp;
commit;

-----------------------------------------------------------------------------
--Tip
--SQL 은 프로그램적 요소 (x)
--PL-SQL 변수, 제어문

create table temp2(id varchar2(50));

desc temp2;
--PL-SQL
--for (int i=1; i<=100; i++) {}
/*
BEGIN
    FOR i IN 1..100 LOOP
        insert into temp2(id) values('A' || to_char(i));
    END LOOP;
END;
*/


select * from temp2;


create table temp3 (
    memberid number(3) not null, --3자리 정수
    name varchar2(10), --null 허용
    regdate date default sysdate -- 테이블 기본값 설정 (insert 하지 않으면 자동 (날짜))
);

desc temp3;

select sysdate from dual;

--1. 정상
insert into temp3(memberid, name, regdate)
values(100,'홍길동','2023-04-19');

select * from temp3;
commit;

--2. 날짜 생략 
insert into temp3(memberid, name) --regdate
values(200,'김유신'); --default sysdate

select * from temp3;
commit;

--3. 컬럼 하나 
insert into temp3(memberid)
values(300);

select * from temp3;
commit;

--4. 오류
insert into temp3(name)
values('나누구'); -- id 컬럼에 null 값을 넣으려고 함 -> 그래서 터짐 
--ORA-01400: cannot insert NULL into ("KOSA"."TEMP3"."MEMBERID")

-----------------------------------------------------------------------------
--TIP)
create table temp4(id number);
create table temp5(id number);

desc temp4;
desc temp5;

insert into temp4(id) values(1);
insert into temp4(id) values(2);
insert into temp4(id) values(3);
insert into temp4(id) values(4);
insert into temp4(id) values(5);
insert into temp4(id) values(6);
insert into temp4(id) values(7);
insert into temp4(id) values(8);
insert into temp4(id) values(9);
insert into temp4(id) values(10);
commit;

select * from temp4;
--대량 데이터 삽입하기
select * from temp5;
--temp4 테이블에 모든 데이터를 temp5 넣고 싶어요
--insert into 테이블명(컬럼리스트) values ...

insert into temp5(id)
select id from temp4; --대량 데이터 삽입

select * from temp5;
commit;

--2. 대량 데이터 삽입하기
-- 데이터를 담을 테이블도 없고 >> 테이블 구조(복제):스키마 + 데이터 삽입
-- 단 제약정보는 복제 안돼요(PK, FK)
-- 순수한 데이터 구조 + 데이터

create table copyemp
as
    select * from emp;
    
select * from copyemp;

create table copyemp2
as 
    select empno, ename, sal
    from emp
    where deptno=30;
    
select * from copyemp2;

--토막 퀴즈
--틀만(스키마) 복제 데이터는 복사하고 싶지 않아요
create table copyemp3
as
    select * from emp where 1=2;

select * from copyemp3;
------------------------------------------------------------------------------
--INSERT END------------------------------------------------------------------




--UPDATE
/*
update 테이블명
set 컬럼명 = 값,컬럼명 = 값,컬럼명 = 값 .......
where 조건절

update 테이블명
set 컬럼명 = (subquery)
where 컬럼명 = (subquery)
*/

select * from copyemp;

update copyemp
set sal = 0;

select * from copyemp;
rollback;


update copyemp
set sal = 1111
where deptno=20;

select * from copyemp;
rollback;

update copyemp
set sal=(select sum(sal) from emp);

select * from copyemp;
rollback;

update copyemp
set ename='AAA', job='BBB', hiredate=sysdate, sal=(select sum(sal) from emp)
where empno=7788;

select * from copyemp where empno=7788;
commit;
------------------------------------------------------------------
--UPDATE END------------------------------------------------------



--DELETE

delete from copyemp;

select * from copyemp;
rollback;

delete from copyemp
where deptno=20;

select * from copyemp where deptno=20;
commit;
--------------------------------------------------------------------
--DELETE END--------------------------------------------------------







