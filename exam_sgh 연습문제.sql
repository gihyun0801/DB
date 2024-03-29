CREATE TABLE MAJOR(   

    MAJOR_NO NUMBER,
    MAJOR_NM VARCHAR2(100) NOT NULL

);

ALTER TABLE MAJOR
ADD CONSTRAINT MAJOR_NO_CHECK PRIMARY KEY(MAJOR_NO);


SELECT * FROM MAJOR;

ALTER TABLE MAJOR RENAME COLUMN MAJOR_NM TO MAJOR_NAME;

INSERT INTO MAJOR
VALUES(1, '경제학과');
INSERT INTO MAJOR
VALUES(2, '수학과');
INSERT INTO MAJOR
VALUES(3, '물리학과');
INSERT INTO MAJOR
VALUES(4, '천문학과');
INSERT INTO MAJOR
VALUES(5, '음악학과');



COMMENT ON COLUMN MAJOR.MAJOR_NO IS '학과번호';
COMMENT ON COLUMN MAJOR.MAJOR_NM IS '학과명';

CREATE TABLE STUDENT(          
   
   STUDENT_ID NUMBER PRIMARY KEY,
   STUDENT_NAME VARCHAR2(20) NOT NULL,
   GENDER VARCHAR2(3),
   BIRTH DATE,
   MAJOR_NO NUMBER,
   
   CONSTRAINT GENDER_CHECK CHECK( GENDER IN ('남', '여')  ),
   CONSTRAINT MAJOR_NO2_CHECK FOREIGN KEY(MAJOR_NO) REFERENCES MAJOR ON DELETE SET NULL
 
);

COMMENT ON COLUMN STUDENT.STUDENT_ID IS '학번';
COMMENT ON COLUMN STUDENT.STUDENT_NAME  IS '이름';
COMMENT ON COLUMN STUDENT.GENDER IS '성별';
COMMENT ON COLUMN STUDENT.BIRTH IS '생년월일';
COMMENT ON COLUMN STUDENT.MAJOR_NO IS '전공학과번호';




INSERT INTO STUDENT
VALUES(19,'이성범','남','2000-12-25',1);
INSERT INTO STUDENT
VALUES(12,'성기현','남','2000-08-01',2);
INSERT INTO STUDENT
VALUES(15,'이정재','남','2000-10-13',3);
INSERT INTO STUDENT
VALUES(16,'이강희','여','1998-11-15',4);
INSERT INTO STUDENT
VALUES(17,'서강주','여','1997-07-25',5);

SELECT * FROM STUDENT;





CREATE TABLE SE(        

  EMP_NO NUMBER,
  EMP_NAME VARCHAR2(20)


); 


ALTER TABLE SE
ADD(EMP_NATION VARCHAR2(30) DEFAULT '한국' );

ALTER TABLE SE
MODIFY(EMP_NATION VARCHAR2(30) DEFAULT 'KOREA'  );

ALTER TABLE SE
ADD CONSTRAINT EMP_NAME_CHECK UNIQUE(EMP_NAME);




SELECT * FROM SE;







