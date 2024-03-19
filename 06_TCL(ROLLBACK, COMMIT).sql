-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT

-- COMMIT : 트랜잭션 종료 후 저장
-- ROLLBACK : 트랜잭션 취소
-- SAVEPOINT : 임시 저장

-- DML : 데이터 조작 언어 INSERT, UPDATE, DELETE
--> 트랜잭션은 DML과 관련되어 있음

/* 트랜잭션 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 * 
 * INSERT 수행 ---------------------------------------------> DB 반영 (X)
 * 
 * INSERT 를 하면 트랜잭션이란 바구니에 담기는 거고 -- COMMIT 을 하면 이제 바구니에 담겨져 있는게
 * 실제 DB 에 반영되는거다
 * 
 * 
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 수행한 구문에 추가되어있다 -> ROLLABACK --> DB반영 X
 * 
 * 1) COMMIT : 메모리 버퍼 (트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 * 
 * 2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *  						마지막 COMMIT 상태로 돌아감(DB에 변경 내용 반영X)
 * 
 * 3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *  						 ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 * 								저장 지점까지만 일부 ROLLBACK
 * 
 * [SAVEPOINT 사용법]
 * 
 * SAVEPOINT  "포인트명1"; 
 * 
 * 
 * SAVEPOINT  "포인트명2"; 
 * 
 * 
 * 
 * 
 * ROLLBACK TO "포인트명1"; -- 포인트 1 로 돌아감
 * 
 *  SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함
 * 
 * */

-- 새로운 데이터 INSERT
SELECT * FROM DEPARTMENT2;


INSERT INTO DEPARTMENT2 VALUES('T1', '개발 1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발 2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발 3팀', 'L2');


SELECT * FROM DEPARTMENT2;

























