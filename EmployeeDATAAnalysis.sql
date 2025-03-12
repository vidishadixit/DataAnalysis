use Assignments

select * from EmployeeSalary
select * from EMP_Salary

--A-1: DEPARTMENT WISE TEAM SIZE AND AVERAGE SALARY OF ALL EMPLOYEES

select 
	dept, 
	count(EID) as Team_Size, 
	AVG(salary) as Average_Salary 
from 
	EMP_Salary
group by 
	dept

-- A-2 : COUNT OF MANAGERS IN THE COMPANY.

select
	count(*) as Manager_Count
from
	EMP_Salary
where 
	desi = 'Manager'

-- A-3: MAXIMUM & MINIMUM SALARY OF AN ASSOCIATE.

select
	min(salary) as Min_Salary,
	max(salary) as Max_Salary
from
	EMP_Salary
where 
	desi = 'Associate'

-- A-4: DEPARTMENT WISE TEAM SIZE AND AVERAGE SALARY OF DELHI EMPLOYEES.

select 
	ES.dept,
	count(*) as Dept_Count,
	avg(ES.salary) as Delhi_Salary
from
	EMP_Salary ES
join EmployeeSalary E 
on E.EID = ES.EID
where e.CITY='Delhi'
group by DEPT

-- A-5: GENERATE OFFICIAL EMAIL OF THE EMPLOYEE TAKING 1ST CHARATCER OF FIRST  NAME , 1ST CHARATCER OF LAST NAME , 
--LAST 3 DIGITS OF EID, FOLLowED BY Learnbay.co’.  EMAIL SHOULD BE IN A UPPER CASE.

select
	EID,
	Name,
	UPPER(concat(left(name,1),
	LEFT(PARSENAME(REPLACE(Name, ' ', '.'), 1), 1),  -- First letter of last name
    RIGHT(EID, 3),  -- Last 3 digits of Employee ID
    '@learnbay.co')) AS Official_Email
From
	EmployeeSalary

--A-6: NAME,CITY , PHNO & EMAIL OF THE EMPLOYEES WHOSE AGE >=40.

select
	name,
	city,
	phone,
	email 
from
	EmployeeSalary
where
	DATEDIFF(YEAR, DOB, GETDATE()) - 
    CASE 
        WHEN MONTH(DOB) > MONTH(GETDATE()) OR 
             (MONTH(DOB) = MONTH(GETDATE()) AND DAY(DOB) > DAY(GETDATE())) 
        THEN 1 
        ELSE 0 
    END >=40
group by
	name,
	city,
	phone,
	email

--A-7 EID, NAME DOJ OF EMPLOYEES WHO HAVE COMPLETED 5 YEARS IN THE COMPANY

select
	EID,
	Name,
	DOJ
from
	EmployeeSalary
where 
	DATEDIFF(year, doj, getdate())-
	case
		when MONTH(doj)>month(getdate()) or
			 month(doj)=month(getdate()) AND DAY(DOB) > DAY(GETDATE())
		then 1
		else 0
		end >=5
group by
	EID,
	Name,
	DOJ

-- A-8: DETAILS OF THE MANAGERS HAVING BIRTHDAY IN THE CURRENT MONTH

select
	*
from 
	EMP_Salary e
join EmployeeSalary ES
on es.eid = e.eid
Where
	e.desi = 'manager'
	and 
	month(dob)=month(getdate())

-- EID, DEPT , DESI , SALARY OF THE EMPLOYEE WHO IS GETTING THE MAXIMUM  SALARY

select
	EID,
	DEPT,
	DESI,
	Salary
from
	EMP_Salary
WHERE 
	SALARY = (SELECT MAX(SALARY) FROM EMP_Salary)

-- EID, NAME OF EMPLOYEE WHO HAS LONGEST NAME
select
	e.EID,
	e.Name
from
	EmployeeSalary e
where
	len(e.name) = (select max(len(name)) from employeesalary)
