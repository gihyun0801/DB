--DDL (DATE DEFINITION LANGUAGE)
-- 객체를 만들고(CREATE), 바꾸고 (ALTER), 삭제(DROP) 하는 데이터 정의 언어


/* ALTER(바꾸고, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제)
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경(테이블명, 컬럼명...)
 * 
 * */


-- 삭제 : ALTER TABLE 테이블명
                       --DROP CONSTRAINT 제약조건명;

-- ** 제약조건 자체를 수정하는 구문은 별도 존재하지 않음

CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY 
ADD CONSTRAINT TITLE_UNIQUE UNIQUE(DEPT_TITLE);

ALTER TABLE DEPT_COPY
DROP CONSTRAINT TITLE_UNIQUE;



------------------------------------------------------------------------------------------

-- ** DEPT_COPY 의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
--SQL Error [904] [42000]: ORA-00904: : 부적합한 식별자


ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL;

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL;



---------------------------------------------------------------------------------------------------------------------------------------

-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값'])


-- 컬럼 수정
--ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입 --> 데이터 타입 변경;

-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값' --> DEFAULT 값 변경


--컬럼 삭제

--ALTER TABLE 테이블명 DROP (삭제할 컬럼명);
--ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;


SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30) );

-- LNAME 컬럼 추가 (기본값 '한국')

ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국' );

-- 데이터 타입 수정

ALTER TABLE DEPT_COPY MODIFY(DEPT_ID CHAR(3) );

INSERT INTO DEPT_COPY
VALUES('D10', '개발부','L1',DEFAULT,DEFAULT);


--컬럼 삭제

ALTER TABLE DEPT_COPY
DROP COLUMN LNAME;

--LNAME의 기본값을 'KOREA'로 수정

ALTER TABLE DEPT_COPY
MODIFY LNAME DEFAULT 'KOREA';
--기본값을 변경했다고 해서 기존 데이터가 변하지는 않음

--LNAME '한국' -> 'KOREA'로 변경

UPDATE DEPT_COPY SET
LNAME = DEFAULT
WHERE LNAME = '한국';

SELECT * FROM DEPT_COPY;
COMMIT;

-- 모든 컬럼 삭제

ALTER TABLE DEPT_COPY DROP(LNAME);
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN CNAME;


ALTER TABLE DEPT_COPY DROP(LOCATION_ID);
ALTER TABLE DEPT_COPY DROP(DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP(DEPT_ID);


--테이블은 모든 열을 삭제할수 없음

DROP TABLE DEPT_COPY;

--DEPARTMENT 테이블 복사해서 DEPT_COPY 생성

--DEPT_COPY 테이블에 PK 추가 (컬럼 : DEPT_ID, 제약조건명, D_COPY_PK)


CREATE TABLE DEPT_COPY
AS
SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;


ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);

ALTER TABLE DEPT_COPY DROP CONSTRAINT D_COPY_PK;

-- 3 . 이름 변경(컬럼, 테이블, 제약조건명);

-- 1) 컬럼명 변경 DEPT_TITLE = DEPT_NAME

-- 2) 제약조건명 변경 (D_COPY_PK -> DEPT_COPY_PK)

ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

--3) 테이블명 변경(DEPT_COPY -> DCOPY)

ALTER TABLE DEPT_COPY RENAME TO DCOPY;

SELECT * FROM DCOPY;


--------------------------------------------------------------------------------------

-- 4. 테이블 삭제
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS]


-- 1) 관계가 형성되지 않은 테이블 삭제

DROP TABLE DCOPY;

-- 2) 관계가 형성된 테이블 삭제
CREATE TABLE TB1(  

    TB1_PK NUMBER PRIMARY KEY,
    TB1_COL NUMBER 
    
 

);

CREATE TABLE TB2( 
 
   TB2_PK NUMBER PRIMARY KEY,
   TB2_COL NUMBER ,
   
   CONSTRAINT TB22_COL FOREIGN KEY(TB2_COL) REFERENCES TB1
 
 );  


--TB1에 샘플 데이터 삽입하기

INSERT INTO TB1
VALUES(1, 100);
INSERT INTO TB1
VALUES(2, 200);
INSERT INTO TB1
VALUES(3, 300);

COMMIT;

INSERT INTO TB2
VALUES(1, 1);


DROP TABLE TB1;
--SQL Error [2449] [72000]: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-- 1) 자식 , 부모테이블 순으로 삭제
-- 2) ALTER를 이용해서 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제옵션 CASCADE CONSTRAINT 사용
--> CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약 조건을 모두 삭제

DROP TABLE TB1 CASCADE CONSTRAINTS;
-- 삭제 성공

SELECT * FROM TB2;

--------------------------------------------------------------------------------

/*DDL 주의 사항*/

-- 1) DDL은 COMMIT/ROLLBACK 이 되지 않는다
--> ALTER , DROP을 신중하게 진행

-- 2) DDL과 DML 구문 섞어서 수행하면 안된다
--DDL 은 수행 시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT 시킴
--DDL이 종료된 후 DML 구문을 수행할 수 있도록 권장!

SELECT * FROM TB2;

COMMIT;

INSERT INTO TB2 VALUES(14, 4);
INSERT INTO TB2 VALUES(15, 5);

ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLCOL;

ROLLBACK;


SELECT * FROM TB2;
