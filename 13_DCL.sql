/*
 * DCL(Data Control Language) : 데이터를 다루기 위한 권한을 다루는 언어
	
	- 계정에 DB, DB 객체에 대한 접근 권한을 
	  부여(GRANT)하고 회수(REVOKE)하는 언어


	* 권한의 종류
	
	1) 시스템 권한 : DB접속, 객체 생성 권한
	
	CREATE SESSION   : 데이터베이스 접속 권한
	CREATE TABLE     : 테이블 생성 권한
	CREATE VIEW      : 뷰 생성 권한
	CREATE SEQUENCE  : 시퀀스 생성 권한
	CREATE PROCEDURE : 함수(프로시져) 생성 권한
	CREATE USER      : 사용자(계정) 생성 권한
	DROP USER        : 사용자(계정) 삭제 권한
	DROP ANY TABLE   : 임의 테이블 삭제 권한
	
	
	2) 객체 권한 : 특정 객체를 조작할 수 있는 권한

	  권한 종류                 설정 객체
	    SELECT              TABLE, VIEW, SEQUENCE
	    INSERT              TABLE, VIEW
	    UPDATE              TABLE, VIEW
	    DELETE              TABLE, VIEW
	    ALTER               TABLE, SEQUENCE
	    REFERENCES          TABLE
	    INDEX               TABLE
	    EXECUTE             PROCEDURE

*/


/* USER - 계정(사용자)

* 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
                모든 권한과 책임을 가지는 계정.
                ex) sys(최고관리자), system(sys에서 권한 몇개 제외된 관리자)


* 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
                작업을 수행할 수 있는 계정으로
                업무에 필요한 최소한의 권한만을 가지는 것을 원칙으로 한다.
                ex) kh_bdh계정(각자 이니셜 계정), workbook 등
*/

-- GRANT RESOURCE, CONNECT TO kh_sgh;
-- 롤(role)
-- 다수 사용자와 다양한 권한을 효율적으로 관리하기 위하여
-- 서로 관련된 권한을 그룹화한 개념(권한의 묶음)

--ROLE_SYS_PRIVS : 오라클 DB에서 시스템 권한을 가진 역할을 나타내는 데이터 딕셔너리 뷰

SELECT * FROM ROLE_SYS_PRIVS 
WHERE ROLE = 'RESOURCE';
--CREATE 트리거, 시퀀스, 테이블 등 8 가지 권한이 부여되어있음


--RESOURCE 에는 VIEW 만드는 권한은 없다


SELECT * FROM ROLE_SYS_PRIVS 
WHERE ROLE = 'CONNECT';

-- 1. 사용자 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--> 예전 SQL 방식 허용

CREATE USER sgh_sample IDENTIFIED BY sample1234;

--2. 새 연결 추가

-- 접속 권한이 없어서 오류 발생

-- 3. 접속 권한 부여
--[권한 부여 작성법]

GRANT CREATE SESSION TO sgh_sample;

--4. 다시 연결 추가 --> 성공

-- 5. sample 테이블 생성

CREATE TABLE TB_TEST( 
  TEST_NO NUMBER,
  TEST_NAME VARCHAR2(20)

); 

--SQL Error [1031] [42000]: ORA-01031: 권한이 불충분합니다

-- 6 .테이블 생성 권한 주기
-- + 데이터를 저장할 수 있는 공간 할당

GRANT CREATE TABLE TO sgh_sample;

-- 7 . 테이블 저장 공간 할당

ALTER USER sgh_sample DEFAULT TABLESPACE 
SYSTEM QUOTA UNLIMITED ON SYSTEM;
--sample 계정의 설정을 변경하여 해당 사용자가
--system 테이블 스페이스에서 무제한으로 공간을
-- 사용 할수 있도록 변경함.



--8.테이블 생성해보기
CREATE TABLE TB_TEST( 
  TEST_NO NUMBER,
  TEST_NAME VARCHAR2(20)

); 


-- ROLE 권한 묶음
--> 묶어둔 ㅜ건한을 특정 계정에 부여

GRANT RESOURCE, CONNECT TO sgh_sample;

----------------------------------------------------------------


-- * 객체 권한 *

-- kh_sgh / sgh_sample 사용자 계정끼리 새로 객체 접근 권한 부여


-- 1. kh_sgh 계정의 EMPLOYEE 테이블 조회 어디서? 방금 만든 sample 계정에서

SELECT * FROM kh_sgh.EMPLOYEE;


-- SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
-- 접근 권한이 없어서 조회 불가

-- 2. sample 계정에서 kh_sgh 의 테이블들을 볼수 있는 권한을 준다

-- [객체 권한 부여 방법]

--GRANT 객체권한 ON 객체명 TO 사용자명;

GRANT SELECT ON EMPLOYEE TO sgh_sample;

-- 3. sample 계정으로 돌아와서 다시 조회해보기

SELECT * FROM kh_sgh.EMPLOYEE;


--4 sample 계정에 부여한 EMPLOYEE 테이블 조회 권한 회수(REVOKE)

-- [권한 회수 작성법]
-- REVOKE 객체권한 ON 객체명 FROM 사용자명;
REVOKE SELECT ON EMPLOYEE FROM sgh_sample;

--5 권한 회수 확인

SELECT * FROM kh_sgh.EMPLOYEE;
--SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다 
