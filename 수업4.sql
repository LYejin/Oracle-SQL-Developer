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

