/*
 * INDEX(색인)
 * 
 * -SQL 명령문 중 SELECT의 처리 속도를 향상 시키기 위해
 * 컬럼에 대해서 생성하는 객체
 * 
 * - 인덱스 내부 구조는 B* 트리 형식으로 되어있음
 * 
 *  데이터 = 첵의 내용
 *  인덱스 = 책의 목차
 * 
 *  인덱스를 포인터의 나열이라고도 부른다 
 *  
 *  포인터 = INDEX 의 객체 C1 = 의 주소값 
 * 
 * 인덱스 장점
 * -자동 정렬 및 검색 속도가 빠름 이진 트리 구조라
 * -조회 시 전체 테이블 내용을 조회하는 것이
 *  인덱스가 저장된 컬럼만을 이용해서 조회하기 때문에
 *  시스템 부하가 낮아셔 전체적인성능 향상이 된다
 * 
 * 
 * 
 * 인덱스 단점
 * - 데이터 변경 INSERT,DELELT,UPDATE 가 빈번한 경우 오히려 성능이 저하 된다.
 * - 인덱스도 하나의 객체이기 떄문에 이를 저장하기 위한 별도 공간필요
 * - 인덱스 생성 시간이 필요
 * 
 * -- 인덱스 생성 방법 --
 * 
 * [작성법]
 * 
 * CREATE INDEX 인덱스명
 * ON 테이블명 (컬럼명, 컬럼명,....)
 * 
 * 
 * --인덱스가 자동으로 생성되는 경우
 * -- PK 또는 UNIQUE 제약조건이 설정되는 경우 
 * 
 * */

-- 인덱스를 이용한 검색 방법

--> WHERE 절에 인덱스가 지정된 컬럼을 언급하면 된다.

SELECT * FROM EMPLOYEE
WHERE EMP_ID = '215'; -- 인덱스 사용  O EMP_ID 는 PK 이기때문에 자동적으로 INDEX 객체가 생성됨

--인덱스를 사용하지 않는 방법 PK나 UNIQUE 조건을 사용하지 않는 경우

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '대북혼'; -- 인덱스 사용 X 


-- 인덱스  확인용 테이블 생성
CREATE TABLE TB_IDX_TEST(   

    TEST_NO NUMBER PRIMARY KEY, -- 자동으로 인덱스 생성됨
    TEST_ID VARCHAR2(20)NOT NULL
 

);


--TB_IDX_TEST 테이블에 샘플데이터 100만개 삽입(PL/SQL 사용)


BEGIN
	
	FOR I IN 1..1000000
	LOOP
		INSERT INTO TB_IDX_TEST VALUES(I, 'TEST' || I);
	END LOOP;
	
	
END;
  -- < PL/SQL 사용이 끝낫다는 슬래쉬 구문

BEGIN
	
	FOR I IN 1..1000000
	LOOP
		INSERT INTO 
		
	END LOOP
	
	
END




--샘플데이터 100만개 확인

SELECT COUNT(*) FROM TB_IDX_TEST;


-- 'TEST500000' 찾기

SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST500000'; --INDEX 사용안한거

SELECT * FROM TB_IDX_TEST
WHERE TEST_NO =500000; -- INDEX 객체 사용한거












