






--11G 버전 이전의 문법을 사용 가능하도록 하는거

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- CTRL + ENTER : 선택한 SQL 수행

-- 이제 예전 문법이 사용가능함


-- 사용자 계정 생성

CREATE USER post_project IDENTIFIED BY post_project;

-- 사용자 한테 권한을 부여해보겠다
GRANT RESOURCE, CONNECT TO post_project;
--데이터 베이스를 관리하는데 필요한권한을 준다 RESOURCE : 데이터베이스의 집합체라고 보면된다


--객체가 생성될 수 있는 공간 할당량 지정
ALTER USER post_project DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;












