/*
 * 
 * SEQUENCE(순서, 연속, 수열)
 * - 순차적 번호 자동 발생기 역할의 객체
 * 
 * -> SEQUENCE 객체를 이용해서 호출하게 되면
 * 지정된 범위 내에서 일정한 간격으로 증가는 숫자가
 * 순차적으로 출력됨.
 * 
 * 
 * EX) 1부터 10까지 1씩 증가하고 반복하는 시퀀스 객체
 * 1 2 3 4 5 6 7 8 9 10 // 1 2 3 4 5 6 7 8 9 10// 1 2 3 4 5 6 7 8 9 10 ... 
 * 
 * 
 * 주로 PRIMARY KEY 역할의 컬럼에 삽입되는 값을 만드는 용도로 사용
 * 
 * 저기 위에있는 값으로 반복되면서 넣진않는다 왜냐하면 PK는 반복되면 안돼므로 1부터 매우큰값을 정해서
 * 넣게된다
 * 
 * 
 * [작성법]
 * 
 * CREATE SEQUENCE 시퀀스이름
 * [START WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동1이 기본
 * [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동1이 기본
 * [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정(10의 27승 -1) 까지 기본값임
 * [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정(-10의 26승)
 * [CYCLE | NOCYCLE] -- 값 순환 여부 지정 
 * [CACHE 바이트크기 | NOCACHE] -- 캐시메모리 기본값은 20바이트, 최소값은 2바이트
 * 
 * 
 * 
 * 
 * -- 시퀀스의 캐시메모리는 할당된 크기만큼 미리 다음값들을 생성해 저장해둠
 * --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로
 * -- 매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * --미리 1부터 10000까지의 시퀀스를 메모리에 저장해놓고 필요할때 갖다 쓴다
 * 
 * 
 * ---시퀀스 사용 방법----
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.(INCREMENT BY 만큼 증가된 값)
 * 													단, 시퀀스 생성 후 첫 호출 경우 START WITH의 값을 얻어옴
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호 얻어옴.
 *  											단, 시퀀스 생성 후 NEXTVAL 호출 없이 CURRVAL를 호출하면 오류 발생.
 * 
 * 
 * 
 * */



-- 옵션 없이 시퀀스 생성
-- 범위 : 1 ~ 최댓값
-- 시작 : 1
-- 반복안함 : NOCYCLE
-- 캐시메모리 CATCE 20바이트 (기본값)

CREATE SEQUENCE SEQ_TEST;


-- * CURRVAL 주의사항 *
-- CURRVAL 는 마지막 NEXTVAL 호출 값을 다시 보여주는 기능
-- > NEXTVALFMF 먼저 호출해야 CURRVAL 호출이 가능하다.

-- 생성 하자마자 바로 현재 값 확인

SELECT SEQ_TEST.CURRVAL FROM DUAL;

--SQL Error [8002] [72000]: ORA-08002: 시퀀스 SEQ_TEST.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
--현재 아직 값이 시작되지 않아서 안나오는거다

SELECT SEQ_TEST.NEXTVAL FROM DUAL;



--실제 사용 예시

CREATE TABLE EMP_TEMP
AS
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

SELECT * FROM EMP_TEMP;

--223번 부터 10씩 증가하는 시퀀스 생성

CREATE SEQUENCE SEQ_TEMP
START WITH 223 --223번 부터 시작
INCREMENT BY 10
NOCYCLE -- 반복 X 안써도 기본값 
NOCACHE -- 캐시 X 기본값은 20바이트
;

--EMP_TEMP 테이블에 사원 정보 삽입

INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '홍길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '고길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '김길동');

SELECT * FROM EMP_TEMP;

-----------------------------------------------------------------------------

--SEQUNCE 수정

/*
 *  
 *  ALTER SEQUENCE 시퀀스이름
 *  --STARTWITH 는 못바꿈
 * [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동1이 기본
 * [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정(10의 27승 -1) 까지 기본값임
 * [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정(-10의 26승)
 * [CYCLE | NOCYCLE] -- 값 순환 여부 지정 
 * [CACHE 바이트크기 | NOCACHE] -- 캐시메모리 기본값은 20바이트, 최소값은 2바이트
 * 
 * 
 * 
 * */


--SEQ_TEMP를 1씩 증가하는 형태로 변경

ALTER SEQUENCE SEQ_TEMP
INCREMENT BY 1;

SELECT SEQ_TEMP.CURRVAL FROM DUAL;

INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '이길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '박길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL , '최길동');

--테이블, 뷰, 시퀀스 삭제

DROP TABLE EMP_TEMP;

DROP VIEW V_DCOPY2;

DROP SEQUENCE SEQ_TEMP;
