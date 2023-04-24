show user;

create table dmlemp
as
    select * from emp;
    
select * from dmlemp;

select * from user_constraints where table_name='DMLEMP';

alter table dmlemp
add constraint pk_dmlemp_empno primary key(empno);

select * from dmlemp where deptno=20;

