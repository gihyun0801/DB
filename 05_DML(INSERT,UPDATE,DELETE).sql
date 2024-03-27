-- *** DML(Date Manipulation Language) : 데이터 조작 언어

-- 테이블에 있는 값을 삽입하거나(INSERT)
-- 수정하거나 (UPDATE)
-- 삭제하거나 (DELETE) 하는 구문

-- 주의 : 혼자서 COMMIT, ROLLBACK 하지 말것! (하면 다른 결과 값이 나올수도 있음)



-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;


--------------------------------------------------------------------------------

-- 1. INSERT 

-- 테이블에 새로운 행을 추가하는 구문

-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터,.....)
-- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용
-- INSERT 하고자 하는 컬럼이 모든 컬럼인 겨우 컬럼명 생략 가능.
-- 단, 컬럼의 순서를 지켜서 VALUES에 값을 기입해야함.

INSERT INTO EMPLOYEE2 
VALUES('900','성기현','000801-3032811','gihyun0801@naver.com',01066432026,'D1'
,'J7', 'S3', 4300000, 0.2, '200', SYSDATE, NULL, 'N');


SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

ROLLBACK;

--ROLLBACK COMMIT 되지 않은 데이터를 없애버림


-- 2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명...) 
     -- VALUES(데이터, 데이터, 데이터...)
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT 할 때 사용
-- 선택 안된 컬럼은 NULL 이 들어감 (DEFAULT 존재 시 DEFAULT 값이 들어감)

INSERT INTO EMPLOYEE2(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE,
DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
VALUES('900','성기현','000801-3032811','gihyun0801@naver.com',01066432026,
'D1', 'J7','S3',4300000);

COMMIT;

--COMMIT 을 해버렷기 때문에 ROLLBACK 해도 초기화가 안됌
-- 왜 여기선 DEFALUT 값이 없냐 이유는 EMPLOYEE 를 복사하엿지만 그 조건들까진 복사를 안했기
--떄문에 디폴트값엔 아무것도 없는 상태이다. 그래서 NULL 이 뜨는 것이다

SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME , STUDENT_ADDRESS FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '건축공학과';

---------------------------------------------------------------------------

-- (참고) INSERT 시 VALUES 대신 서브쿼리 사용 가능
CREATE TABLE EMP_01(
  EMP_ID NUMBER,
  EMP_NAME VARCHAR2(30),
  DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID);

-- 서브쿼리(SELECT) 결과를 EMP_01 테이블에 INSERT
--> SELECT 조회 결과의 데이터 타입, 컬럼 개수가
-- INSERT 하려는 테이블의 컬럼과 일치해야함
INSERT INTO EMP_01(
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON(DEPT_CODE = DEPT_ID));

------------------------------------------------------------------------------------------

