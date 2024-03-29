/* 
[JOIN 용어 정리]
  오라클       	  	                                SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인		                            내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인 		                        왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인   	                		    JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱		              			 교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.

-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!

/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.   
*/


-------------------------------------------------------------------------------------

-- 기존에 서로 다른 테이블의 데이터를 조회 할 경우 아래와 같이 따로 조회함.

-- 직원번호, 직원명, 부서코드, 부서명을 조회하고자 할때

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;


--부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;


SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


--------------------------------------------------------------------------------------------------------

--1. 내부 조인(INNER JOIN) (== 등가 조인(EQUAL JOIN) )
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.
--> (== 일치하는 값이 없는 행은 조인에서 제외됨.)


-- 작성 방법은 크게 ANSI 구문과 오라클 구문으로 나뉘고
-- ANSI에서 USING과 ON을 쓰는 방법으로 나뉜다.


-- 1) 연결에 사용할 두 컬럼명이 다른 경우

-- ANSI
-- 연결에 사용할 컬럼명이 다른경우 ON() 을 사용


-- 오라클
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT 테이블, LOCATION 테이블을 참조하여
-- 부서명, 지역명 조회


SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 오라클 방식

SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT , LOCATION 
WHERE LOCATION_ID = LOCAL_CODE;



--2) 연결에 사용할 두 컬럼명이 같은 경우

-- EMPLOYEE 테이블, JOB 테이블 참조하여
-- 사번, 이름, 직급코드, 직급명 조회


--ANSI
--연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 오라클 -> 별칭 사용
-- 테이블 별로 별칭을 등록할 수 있음.

SELECT EMP_ID, EMP_NAME , J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE ;


------------------------------------------------------------------------------------

-- INNER JOIN(내부조인) 문제점
-- > 연결에 사용된 컬럼의 값이 일치하지 않으면
-- 조회 결과에 포함되지않는다

-- 2. 외부 조인 (OUTER JOIN)

-- OUTER JOIN 과 비교할 INNER JOIN 쿼리문
-- > 반드시 OUTER JOIN 임을 명시해줘야 한다.

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함 시킴

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN  OUTER 생략가능
-- 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의
-- 컬럼수를 기준으로 JOIN

--> 왼편에 작성된 테이블의 모든행이 결과에 포함되어야 한다(JOIN이 안되는 행도 결과 포함)

-- ANSI 표준

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID); --23행 (하동운, 이오리 포함)


--오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID(+);
--반대쪽 테이블 컬럼에(+) 기호를 작성해야된다


--2) RIGHT [OUTER] JOIN : OUTER 생략가능
--합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의
--컬럼수를 기준으로 JOIN

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

--오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;


-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진
-- 모든 행을 결과에 포함

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);



------------------------------------------------------------------------

--3 교차 조인 (CROSS JOIN == CARTESIAN PRODUCT)

-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집함)
--> JOIN 구문을 잘못 작성하는 경우 크로스 조인결과가 조회됨

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT ;

--2349 8523 65 
--209


-------------------------------------------------------------------------

--4. 비등가 조인 

-- '=' 를 사용하지 않는 조인문
-- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 
--방식

SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE;

--사원의 급여에 따른 급여 등급 파악하기

SELECT EMP_NAME, SAL_LEVEL ,SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);



-----------------------------------------------------------------------------------

-- 5. 자체 조인 (셀프 조인)


--같은 테이블을 조인.
-- 자기 자신과 조인을 맺음
--TIP ! 같은 테이블 2개 있다고 생각하고 진행

--사번, 이름, 사수의 사번, 사수 이름 조회


--ANSI

SELECT E1.EMP_ID, E1.EMP_NAME, 
NVL(E1.MANAGER_ID, 'X'), NVL(E2.EMP_NAME, 'X')
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);



------------------------------------------------------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 테이블 간의
-- 조인을 간단히 표현하는 방법

-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요

--> 없을 경우 교차조인됨.

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
--JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;


SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;


------------------------------------------------------------------------------------------------
-- 7. 다중 조인
-- N개의 테이블을 조회할 때 사용(순서 중요)

--사원이름, 부서명, 지역명 조회
-- -> EMPLOYEE, DEPARTMENT, LOCATION

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 직급이 대리이면서 아시아 지역에서 근무하는 직원 조회
--사버느 이름, 직급며으 부서명, 근무지역명 급여를 조회해라



SELECT EMP_NAME,JOB_NAME, DEPT_TITLE, LOCAL_NAME, EMP_ID, SALARY
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';


------------------------------------------------------------------------------------------------


--1
SELECT EMP_NAME, EMP_NO,DEPT_TITLE,JOB_NAME
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SUBSTR(EMP_NO, 1, 1) LIKE '7%' AND
EMP_NAME LIKE '전%';

--2
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE EMP_NAME LIKE '%형%';

--3
SELECT EMP_NAME, DEPT_TITLE, DEPT_CODE , JOB_NAME
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE LOCATION_ID IN('L2', 'L3');

--4
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM LOCATION 
LEFT JOIN DEPARTMENT ON(LOCAL_CODE = LOCATION_ID)
LEFT JOIN EMPLOYEE ON(DEPT_ID = DEPT_CODE)
WHERE BONUS IS
NOT NULL;


--5
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM LOCATION 
JOIN DEPARTMENT ON(LOCAL_CODE = LOCATION_ID)
JOIN EMPLOYEE ON(DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IS NOT NULL;

--6

SELECT EMP_NAME, JOB_NAME, SALARY, SALARY * ( 1 + NVL(BONUS , 0 ) ) * 12
,SAL_LEVEL 
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > MIN_SAL;

--7

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM NATIONAL
JOIN LOCATION USING(NATIONAL_CODE)
JOIN DEPARTMENT ON(LOCAL_CODE = LOCATION_ID)
JOIN EMPLOYEE ON(DEPT_ID = DEPT_CODE)
WHERE NATIONAL_CODE IN('KO', 'JP');

--8

SELECT E1.EMP_NAME 사원명, E1.DEPT_CODE 부서코드, E2.EMP_NAME 동료이름
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY 사원명;



--9
SELECT EMP_NAME, JOB_NAME, SALARY, BONUS
FROM JOB
JOIN EMPLOYEE USING(JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN('J4', 'J7');






