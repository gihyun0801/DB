/*
 * 
 *  - 데이터 딕셔너리란?
 *  데이터베이스에 저장된 데이터구조, 메타데이터 정보를 포함하는 
 *  데이터베이스 객체 . 
 * 
 *  일반적으로 데이터베이스 시스템은 데이터 딕셔너리를 사용하여
 *  데이터베이스의 테이블, 뷰, 인덱스, 제약조건 등 관련된 정보를 저장하고 관리함.
 * 
 * * USER_TABLES : 계정이 소유한 객체 등에 관한 정보를 조회 할 수 있는 딕셔너리 뷰
 * 
 * 
 * */


SELECT * FROM USER_TABLES;

------------------------------------------------------------------------------------------------

-- DDL (DATE DEFINITION LANGUAGE ) : 데이터 정의 언어
-- 객체(OBJECT) 를 만들고 (CREATE), 수정(ALTER) 하고, 삭제 (DROP) 등
-- 데이터의 전체 구조를 정의하는 언어로 주로 DB관리자, 설계자가 사용함.


-- 객체 : 테이블(TABLE), 뷰(VIEW),  시퀀스(SEQUENCE), 
-- 인덱스(INDEX), 사용자(USER),
-- 패키지(PACKAGE), 트리거(TRIGGER)
-- 프로시져(PROCEDURE), 함수(FUNCITION)
-- 동의어(SYSNONYM)..

------------------------------------------------------------------------------------------------

-- CREATE 

-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문 
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거 할 수 있음


-- 표현식

/*
 * 
 *  CREATE TABLE 테이블명 (
 *   컬럼명 자료형(크기),
 *   컬럼명 자료형(크기),
 *   ...
 * );
 * 
 *  
 *  NUMBER : 숫자형 (정수, 실수)
 *  
 *  CHAR(크기) : 고정길이 문자형
 *      --> CHAR(10) '컬럼에' 'ABC' 3BYTE 문자열만 저장해도 10BYTE 저장공간 모두 사용
 *      
 * 
 *  VARCHAR2(크기) : 가변길이 문자형
 *      --> VARCHAR2(10) 이렇게 만들어 준 컬럼에 'ABC' 3BYTE 문자열만 저장하면 나머지 7BYTE 반환함.
 *  
 * DATE : 날짜 타입
 * BLOB : 대용량 이진 데이터(4GB)
 * CLOB : 대용량 문자 데이터(4GB)
 * 
 * */


-- MEMBER 테이블 생성
CREATE TABLE "MEMBER" ( -- 원래 쌍따옴표 안써도 되는데 예약어가 있는거 같아서 쌍따옴표를 적어줫다
  MEMBER_ID VARCHAR2(20),
  MEMBER_PWD VARCHAR2(20),
  MEMBER_NAME VARCHAR2(30),
  MEMBER_SSN CHAR(14),
  ENROLL_DATE DATE DEFAULT SYSDATE);
 
 --이렇게 DEFAULT SYSDATE 를 쓰면 값을 DEFALULT 를 넣엇을때 SYSDATE가 나오게하는것
 -- 또는 값을 아무것도 안넣엇을때 SYSDATE 가 나오게 된다

-- SQL 작성법 : 대문자 작성 권장 , 연결된 단어 사이에는 "_" (언더바) 사용
-- 문자인코딩 UTP- 8 : 영어, 숫자 1BYTE, 한글, 특수문자 등은 3BYTE취급 

-- 2. 컬럼에 주석 달기
-- [표현식]
-- COMMTENT ON COLUMN 테이블명.컬럼명 IS '주석내용'

COMMENT ON COLUMN "MEMBER".MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN "MEMBER".MEMBER_SSN  IS '회원 주민 등록 번호';
COMMENT ON COLUMN "MEMBER".ENROLL_DATE  IS '회원 가입일';

SELECT * FROM MEMBER;

-- MEMBER 테이블에 샘플 데이터 삽입

INSERT INTO "MEMBER" VALUES('kh_sgh', 'kh1234', '성기현', '000801-3032811', DEFAULT);

-- * INSERT / UPDATE 시 컬럼 값으로 DEFALUT를 작성하면
--   테이블 생성 시 해당 컬럼에 지정된 DEFAULT 값으로 삽입이 된다 !

COMMIT;

-- 추가 샘플 데이터 삽입
-- 가입일 -> SYSDATE를 활용

INSERT INTO "MEMBER" VALUES('MEM02', 'QWER1234', '이정재', '001012-3042011', SYSDATE);

SELECT * FROM MEMBER;

-- 가입일 -> INSERT 시 미작성 하는 경우 

INSERT INTO "MEMBER"(MEMBER_ID, MEMBER_PWD, MEMBER_NAME,MEMBER_SSN) VALUES('MEM03', 'QW12334','이성범','001225-3032154');


SELECT * FROM MEMBER;

-- ** JDBC 에서 날짜를 입력 받았을 대 삽입하는 방법
-- '2022-09-13 17:33:27' 이런식의 문자열이 넘어온 경우...

INSERT INTO "MEMBER" VALUES
('MEM04','PASS04', '김길동', '123456-1234561' , 
  TO_DATE('2022-09-13 17:33:27', 'YY-MM-DD HH24:MI:SS')        );
 
 COMMIT;




-- ** NUMBER 타입의 문제점 **

-- MEMBER2 테이블 (아이디, 비밀번호, 이름, 전화번호)


CREATE TABLE "MEMBER2" ( 
  MEMBER_ID VARCHAR2(20),
  MEMBER_PWD VARCHAR2(20),
  MEMBER_NAME VARCHAR2(30),
  MEMBER_TELL NUMBER(30)
);

SELECT * FROM "MEMBER2";

INSERT INTO "MEMBER2" VALUES('KH_SGH', 'KH1234', '성기현', 01066432026);
INSERT INTO "MEMBER2" VALUES('KH_GGG', 'KH3234', '이정재', 7712341234);


--------------------------------------------------------------------------------------------

-- 제약 조건 (    CONSTRAINTS    )

/*
 * 
 * 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약.
 * 데이터 무결성 보장을 목적으로 함 
 *    -> 중복 데이터 X
 *  
 *  + 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
 *  + 데이터의 수정/삭제 가능 여부 검사등을 목적으로 함 
 *     -- > 제약 조건을 위배하는 DML 구문은 수행할 수 없다 
 * 
 *   제약조건 종류
 *   PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY
 * 
 *   
 * 
 * */

-- 제약 조건 확인
-- USER CONSTRAINSTS : 사용자가 작성한 제약조건을 확인하는 딕셔너리 뷰.

--DESC USER_CONTSTRAINTS : -- SQLPLUS 에서만 작동됨

SELECT * FROM USER_CONSTRAINTS;

-- USER_CONS_COLUMNS : 제약조건이 걸려있는 컬럼을 딕셔너리 뷰

SELECT * FROM USER_CONS_COLUMNS;


-- 1. NOT NULL
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정 시 NULL 값을 허용하지 않도록 컬럼레벨에서 제한 

-- * 컬럼 레벨 : 테이블 생성 시 컬럼을 정의하는 부분에 작성하는 것

CREATE TABLE "USER_USED_NN" (

 			USER_NO NUMBER NOT NULL, -- 사용자번호 (모든 사용자는 사용자 번호가 있어야 한다)
 			 											--> 컬럼 레벨 제약조건 설정 
 			USER_ID VARCHAR2(20),
 			USER_PWD VARCHAR2(30),
 			USER_NAME VARCHAR2(30),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50)

);

INSERT INTO USER_USED_NN VALUES( 
1,'USER01','PASS01','홍길동','남','01066432026','GIHYUN0801@NAVER.COM');


INSERT INTO USER_USED_NN VALUES( 
NULL,'USER01','PASS01','홍길동','남','01066432026','GIHYUN0801@NAVER.COM');
-- NULL 을 넣으면 안됀다고 조건을 걸어놧기 때문에
-- NULL값을 넣으면 제약조건에 위배되어 오류발생


-------------------------------------------------------------------------------------------------

-- 2. UNIQUE 제약조건
-- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건
-- 컬럼레벨에서 설정가능, 테이블 레벨에서 설정 가능 
-- 단, UNIQUE 제약조건 설정된 컬럼에 NULL 값은 중복 삽입 가능.

-- * 테이블 레벨 : 테이블 생성 시 컬럼 정의가 끝난 후 마지막에 작성

-- * 제약조건 지정 방법
-- 1) 컬럼 레벨 : [CONSTRAINT 제약조건명] 제약 조건 
-- 2) 테이블 레벨 : [CONSTRAINT 제약조건명] 제약 조건 (컬럼명)


-- UNIQUE 제약 조건 테이블 생성
CREATE TABLE USER_USED_UK (  
    	USER_NO NUMBER,
 			--USER_ID VARCHAR2(20) UNIQUE, -- 컬럼 레벨 (제약조건명 미지정)
 			--USER_PWD VARCHAR2(30) CONSTRAINT USER_PWD_U UNIQUE, -- 컬럼 레벨(제약조건명 지정)
 			USER_NAME VARCHAR2(30),
 			USER_PWD VARCHAR2(30),
 			USER_ID VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 
      /*테이블 레벨*/
 			
  -- 			UNIQUE(USER_ID) -- 테이블 레벨에서 (제약조건명 미지정)
 		CONSTRAINT USER_ID_U UNIQUE(USER_ID)	
 	         -- 제약조건명      어느곳에다 걸것인지
 	
 	
);

INSERT INTO USER_USED_UK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr');

INSERT INTO USER_USED_UK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr');
--SQL Error [1] [23000]: ORA-00001: 무결성 제약 조건(KH_SGH.USER_ID_U)에 위배됩니다

INSERT INTO USER_USED_UK
VALUES(1, 'USER01', 'PASS01', NULL, '남', '010-1234-5674', 'hong123@kh,or.kr');
-- 아이디에 NULL 값 삽입 가능 

INSERT INTO USER_USED_UK
VALUES(1, 'USER01', 'PASS01', NULL, '남', '010-1234-5674', 'hong123@kh,or.kr');
-- 아디 NULL 값 중복 삽입 가능

SELECT * FROM USER_USED_UK;

---------------------------------------------------------------------------------------------

-- UNIQUE 복합키
-- 두 개 이상의 컬럼을 묶어서 하나의 UNIQUE 제약조건을 설정함

-- 복합키 지정은 테이블 레벨에서만 가능 

CREATE TABLE USER_USED_UK2( 
      USER_NO NUMBER,
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30),
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			
 			-- 테이블 레벨 UNIQUE 복합키 지정 
 			
 			CONSTRAINT USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)
) ;

INSERT INTO USER_USED_UK2
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr');

SELECT * FROM USER_USED_UK2;

INSERT INTO USER_USED_UK2
VALUES(1, 'USER01', 'PASS01', '이정재', '남', '010-1234-5674', 'hong123@kh,or.kr');

SELECT * FROM USER_USED_UK2;

INSERT INTO USER_USED_UK2
VALUES(1, 'USER02', 'PASS01', '이정재', '남', '010-1234-5674', 'hong123@kh,or.kr');
--SQL Error [1] [23000]: ORA-00001: 무결성 제약 조건(KH_SGH.USER_ID_NAME_U)에 위배됩니다




SELECT * FROM USER_USED_UK2;

-------------------------------------------------------------------------------------------

-- 3 . PRIMARY KEY(기본키) 제약조건

-- 테이블에서 한 행의 정보를 찾기위해 사용할 컬럼을 의미함.
-- 테이블에 대한 식별자(사용자번호, 학번...) 역할을 함

-- NOT NULL + UNIQUE 제약조건의 의미 -> 중복되지 않는 값 , NULL 이 들어가면 안돼는 거 = 
-- 중복되지 않는 값이 필수로 존재해야함.
-- NULL값도 중복이 안됀다는 거다 

-- 한 테이블당 한 개만 설정할 수 있음
-- 컬럼레벨, 테이블레벨 둘다 설정 가능함
-- 한 개 컬럼에 설정할 수 있고, 여러개의 컬럼을 묶어서 설정할 수 있음.

CREATE TABLE USER_USED_PK( 

 			USER_NO NUMBER, --CONSTRAINT USER_NO_PK PRIMARY KEY, --컬럼 레벨 
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30),
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			
 			-- 테이블레벨
 			
 			CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
   );
  
  INSERT INTO USER_USED_PK
 VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr'); 

  INSERT INTO USER_USED_PK
 VALUES(1, 'USER02', 'PASS02', '이정재', '남', '010-5678-5678', 'lee123@kh,or.kr'); 
--SQL Error [1] [23000]: ORA-00001: 무결성 제약 조건(KH_SGH.USER_NO_PK)에 위배됩니다

  INSERT INTO USER_USED_PK
 VALUES(NULL, 'USER03', 'PASS03', '이성범', '여', '010-4656-4787', 'fff123@kh,or.kr'); 
--NULL 안됌

---------------------------------------------------------------------------------------

--PRIMARY 복합키 

CREATE TABLE USER_USED_PK2( 

 			USER_NO NUMBER, --CONSTRAINT USER_NO_PK PRIMARY KEY, --컬럼 레벨 
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30),
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			
 			-- 테이블레벨
 			
 			CONSTRAINT PK_USERNO_USERID PRIMARY KEY(USER_NO, USER_ID)
   );
  
  
  INSERT INTO USER_USED_PK2
   VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr'); 

     INSERT INTO USER_USED_PK2
   VALUES(2, 'USER02', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr'); 

     INSERT INTO USER_USED_PK2
   VALUES(3, 'USER02', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr'); 
     INSERT INTO USER_USED_PK2
   VALUES(3, 'USER03', 'PASS01', 'TT', 'T', '010-1234-5674', 'hong123@kh,or.kr'); 
     INSERT INTO USER_USED_PK2
   VALUES(4, 'USER03', 'PASS01', 'TT', 'T', '010-1234-5674', 'hong123@kh,or.kr'); 
     INSERT INTO USER_USED_PK2
   VALUES(4, 'USER05', 'PASS01', 'TT', 'T', '010-1234-5674', 'hong123@kh,or.kr'); 
  
  --PRIMARY KEY 는 NULL 값이 들어갈 수 없음
  
  SELECT * FROM USER_USED_PK2;
 
 
 --------------------------------------------------------------------------------------------
 
 --4. FOREING KEY(외래키/외부키) 제약조건
 
 -- 참조(REFERENCES)된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
 -- FOREIGN KEY 제약조건에 의해서 테이블간의 관계가 형성됨
 -- 제공되는 값 외에는 NULL을 사용할 수 있음.
 
 -- 컬럼레벨일 경우
 -- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]
 
 -- 테이블레벨일 경우
 -- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명)	REFERENCES 참조할 테이블명 [(참조할컬럼)] [삭제룰]
 
 -- 참조할컬럼은 PRIMARY KEY 컬럼과 , UNIQUE 가 지정된 컬럼만 외래키로 사용할 수 있음 
 -- 참조할 테이블의 참조할 컬럼명이 생략되면, PRIMARY KEY 로 설정된 컬럼이 자동 참조할 컬럼이 됨.
 
 -- 부모테이블 / 참조할 테이블(대상이되는 테이블)
 
 CREATE TABLE USER_GRADE (  
 
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
 
 );

SELECT * FROM USER_GRADE;

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');



 
-- 자식 테이블 방금 만들 USER_GRADE 를 사용할 테이블 

CREATE TABLE USER_USED_FK(  
  		USER_NO NUMBER,
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30) NOT NULL,
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			GRADE_CODE NUMBER,
  
 			CONSTRAINT USER_NO_P PRIMARY KEY(USER_NO),
 			CONSTRAINT USER_NO_PP UNIQUE(USER_ID),
 			                --컬럼명 미작성 시 USER_GRADE 테이블의 PK를 자동 참조
 			
 			-- FOREIGN KEY 는 테이블 레벨에서만 사용 
 			CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE
);

COMMIT;

  INSERT INTO USER_USED_FK
   VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK
   VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'KH123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK
   VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'UOO123@kh,or.kr', 30);
  
  INSERT INTO USER_USED_FK
   VALUES(4, 'USER04', 'PASS04', '고길동', '남', '010-2000-3131', 'UOO123@kh,or.kr', NULL);
  --NULL 사용 가능 
  
  INSERT INTO USER_USED_FK
   VALUES(5, 'USER05', 'PASS05', '이이이', '남', '010-8951-3431', 'UO123@kh,or.kr', 50);
  --SQL Error [2291] [23000]: ORA-02291: 무결성 제약조건(KH_SGH.GRADE_CODE_FK)이 위배되었습니다- 부모 키가 없습니다
  -- 50이라는 값은 USER_GRADE 에 PK 가 달려있는 컬럼에 범위에 50이라는 값이 없기때문에 쓸수가 없다.
  
  SELECT * FROM USER_USED_FK;
 
 COMMIT;

-------------------------------------------------------------------------------------------------------------------

-- * FOREIGN KEY 삭제 옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를
-- 어떤식으로 처리할지에 대한 내용을 설정할 수 있다.

-- 1) ON DELETE RESTRICTED (삭제 제한)로 기본 지정되어 있음
-- FOREIGN KEY 로 지정된 컬럼에서 사용되고 잇는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함

DELETE FROM USER_GRADE WHERE GRADE_CODE = 30; -- 30은 자식테이블에서 사용되고 있는 값 
--SQL Error [2292] [23000]: ORA-02292: 무결성 제약조건(KH_SGH.GRADE_CODE_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다

DELETE FROM USER_GRADE WHERE GRADE_CODE = 20;
-- 자식이 20이란걸 참조하고 있지 않기때문에 삭제가능함 

-- 자식이 사용하고 있으면 부모 테이블은 삭제 안됌 

ROLLBACK;

--2 ) ON DELETE SET NULL : 부모키 삭제시 자식키를 NULL로 변경하는 옵션 

    CREATE TABLE USER_GRADE2 (  
 
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
 
 );


INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE2;
     

--ON DELETE SET NULL 삭제옵션이 적영된 테이블 생성
CREATE TABLE USER_USED_FK2(  
  		USER_NO NUMBER,
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30) NOT NULL,
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			GRADE_CODE NUMBER,
  
 			CONSTRAINT USER_NO_P2 PRIMARY KEY(USER_NO),
 			CONSTRAINT USER_NO_PP2 UNIQUE(USER_ID),
 			      
 			CONSTRAINT GRADE_CODE_FK2 FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE ON DELETE SET NULL
);

INSERT INTO USER_USED_FK2
   VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK2
   VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'KH123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK2
   VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'UOO123@kh,or.kr', 30);
  
  INSERT INTO USER_USED_FK2
   VALUES(4, 'USER04', 'PASS04', '고길동', '남', '010-2000-3131', 'UOO123@kh,or.kr', NULL);
  --NULL 사용 가능 

   
  DELETE FROM USER_GRADE2 WHERE GRADE_CODE = 10;
 SELECT * FROM USER_GRADE2; 
 SELECT * FROM USER_USED_FK2;
 

-- 3) ON DELETE CASCADE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제됨 그냥 행이 삭제됨

    CREATE TABLE USER_GRADE4 (  
 
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
 
 );


INSERT INTO USER_GRADE4 VALUES(10, '일반회원');
INSERT INTO USER_GRADE4 VALUES(20, '우수회원');
INSERT INTO USER_GRADE4 VALUES(30, '특별회원');
 
CREATE TABLE USER_USED_FK4(  
  		USER_NO NUMBER,
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30) NOT NULL,
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			GRADE_CODE NUMBER,
  
 			CONSTRAINT USER_NO_P233 PRIMARY KEY(USER_NO),
 			CONSTRAINT USER_NO_PP232 UNIQUE(USER_ID),
 			      
 			CONSTRAINT GRADE_CODE_FK33 FOREIGN KEY(GRADE_CODE) 
 			REFERENCES USER_GRADE4 ON DELETE CASCADE
);

INSERT INTO USER_USED_FK4
   VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK4
   VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'KH123@kh,or.kr', 10);
  
  INSERT INTO USER_USED_FK4
   VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'UOO123@kh,or.kr', 30);
  
  INSERT INTO USER_USED_FK4
   VALUES(4, 'USER04', 'PASS04', '고길동', '남', '010-2000-3131', 'UOO123@kh,or.kr', NULL);
  
  SELECT * FROM USER_GRADE4; 
 SELECT * FROM USER_USED_FK4;

DELETE FROM USER_GRADE4 WHERE GRADE_CODE = 10;

 SELECT * FROM USER_USED_FK4;

-------------------------------------------------------------------------------------------------------

--5. CHECK 제약조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있음
-- CHECK(컬럼명 비교연산자 비교값)

CREATE TABLE USER_USED_CHECK(  
     
			USER_NO NUMBER,
	    USER_ID VARCHAR2(30),
 			USER_PWD VARCHAR2(30) NOT NULL,
 			USER_NAME VARCHAR2(20),
 			GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN('남', '여')   ),
 			PHONE VARCHAR2(30),
 			EMAIL VARCHAR(50),
 			
 			CONSTRAINT USER_NO_YA PRIMARY KEY(USER_NO),
 		  CONSTRAINT USER_ID_IA UNIQUE(USER_ID)
 		 

);

INSERT INTO USER_USED_CHECK
   VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5674', 'hong123@kh,or.kr');
  
  INSERT INTO USER_USED_CHECK
   VALUES(2, 'USER02', 'PASS02', '홍길동', '남자', '010-1234-5674', 'hong123@kh,or.kr');
  
  -- SQL Error [2290] [23000]: ORA-02290: 체크 제약조건(KH_SGH.GENDER_CHECK)이 위배되었습니다
   
  SELECT * FROM USER_USED_CHECK;
  
 
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 CREATE TABLE USER_TEST(

     USER_NO NUMBER CONSTRAINT PK_USER_TEST PRIMARY KEY,
     USER_ID VARCHAR2(20) CONSTRAINT UK_USERID UNIQUE,
     USER_PWD VARCHAR2(20) NOT NULL,
     PNO VARCHAR2(20) NOT NULL,
     GENDER VARCHAR2(3) CONSTRAINT CK_CHECK CHECK(GENDER IN( '남',' 여' ) ) ,
     PHONE VARCHAR2(20),
     ADDRESS VARCHAR2(100),
     STATUS VARCHAR2(3) DEFAULT 'N' CONSTRAINT NN_STATUS NOT NULL,
     
     CONSTRAINT CK_STATUS CHECK(STATUS IN('Y','N')  ),
     CONSTRAINT UK_PNO UNIQUE(PNO)
     
     
     
     
 
 ); 

DROP TABLE USER_TEST;

COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';

COMMENT ON COLUMN USER_TEST.USER_ID IS '회원아이디';
COMMENT ON COLUMN USER_TEST.USER_PWD IS '회원비밀번호';
COMMENT ON COLUMN USER_TEST.PNO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.GENDER IS '성별';
COMMENT ON COLUMN USER_TEST.PHONE IS '연락처';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '주소';
COMMENT ON COLUMN USER_TEST.STATUS IS '탈퇴여부';

INSERT INTO USER_TEST
VALUES(1, 'user01', 'pass01', '880122-1234567', '남','010-1111-9999','서울시 강남구 역삼동','N');

INSERT INTO USER_TEST
VALUES(2, 'user02', 'pass02', '890222-1234567', '남','010-2222-9999','서울시 도봉구 창3동','N');

INSERT INTO USER_TEST
VALUES(3, 'user03', 'pass03', '950122-1234567', '남','010-3333-9999','서울시 마포구 지레동','N');

INSERT INTO USER_TEST
VALUES(4, 'user04', 'pass04', '990122-1234567', '남','010-4444-9999','서울시 강북구 미아동','N');

INSERT INTO USER_TEST
VALUES(5, 'user05', 'pass05', '780122-1234567', '남','010-5555-9999','서울시 노원구 중계동','N');

 SELECT * FROM USER_TEST;

-- 테이블 주석확인

SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'USER_TEST';
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--8 . SUBQUERY를 이용한 테이블 생성
-- 컬럼명, 데이터 타입, 값이 복사되고, 제약조건은 NOT NULL만 복사됨

--1) 테이블 전체 복사

CREATE TABLE EMPLOYEE_COPY AS 
SELECT * FROM EMPLOYEE;
--> 서브쿼리의 조회 결과 (RESULT SET)의 모양대로 테이블이 생성됨

SELECT * FROM EMPLOYEE_COPY;

-- 2) JOIN 후 원하는 컬럼만 테이블로 복사
CREATE TABLE EMPLOYEE_COPY2
AS 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE);


SELECT * FROM EMPLOYEE_COPY2;
--> 서브쿼리로 테이블 생성 시
-- 테이블의 형태(컬럼명, 데이터 타입) + NOT NULL 제약조건만 복사!
-- 제약조건, 코멘트는 복사 되지 않기 때문에 별도 추가 작업이 필요하다.


--### 제약조건 추가

--만들어진 테이블명에 제약조건을 추가하고 싶으면
--ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명)
--ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명)
--ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼명 비교연산자 비교값)
--ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
--> 참조 테이블에 PK를 FK로 지정하는 경우 참조 컬럼명 생략 가능

--ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL

--NOT NULL 제약조건만 복사된 EMPLOYEE_COPYE 테이블에
-- EMP_ID 컬럼에 PRIMARY KEY 제약조건 추가

ALTER TABLE EMPLOYEE_COPY ADD CONSTRAINT PK_EMP_COPY PRIMARY KEY(EMP_ID);

--테이블 제약조건 확인
SELECT * FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';


ALTER TABLE EMPLOYEE ADD CONSTRAINT DEPT_ID_PK FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT ON DELETE SET NULL;

--EMPLOYEE 테이블의 JOB_CODE 외래키 제약조건 추가

ALTER TABLE EMPLOYEE ADD CONSTRAINT JOB_CODE_FO FOREIGN KEY(JOB_CODE) REFERENCES JOB ON DELETE SET NULL;

--EMPLOYE 테이블의 SAL_LEVEL 외래키 제약조건 추가

ALTER TABLE EMPLOYEE ADD CONSTRAINT SAL_LEVEL_FO FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE ON DELETE SET NULL;

--DEPARTMENT 테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조테이블은 LOCATION 참조 컬럼은 LOCATION의 기본키

ALTER TABLE DEPARTMENT ADD CONSTRAINT LOCATION_CO FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;

--LOCATION 테이블의 NATIONAL_CODE 에 외래키 제약조건추가

ALTER TABLE LOCATION ADD CONSTRAINT NATION_NO FOREIGN KEY(NATIONAL_CODE) REFERENCES NATIONAL;

INSERT INTO EMPLOYEE
VALUES('290','성기현','000801-3032811','seong_di@or.ke','01066432026','D4','J6','S4',4000000,0.3,'200',SYSDATE,NULL,'N');

DELETE FROM EMPLOYEE WHERE EMP_ID = '290';

UPDATE EMPLOYEE SET EMP_ID = '200' , EMP_NAME = '선동일'
WHERE EMP_ID = '299' AND EMP_NAME = '성기현';

SELECT * FROM EMPLOYEE;

CREATE TABLE EMPLOYEE_COCO 
AS
SELECT EMP_ID, EMP_NAME , EMP_NO
FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COCO;

