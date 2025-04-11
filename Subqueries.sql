/*
Assignments
*/

select * from EmployeeSalary
select * from EMP_Salary

-- 1. EID, NAME, CITY OF GURGAON EMPLOYEES
select
	EID, 
	NAME, 
	CITY
from
	employeesalary
where
	city = 'GURGAON'
	

-- 2.  EID, NAME , DOJ ,DEPT, DESI & SALARY OF ALL MANAGERS  

select
	 es.EID, 
	 es.NAME , 
	 es.DOJ ,
	 e.DEPT, 
	 e.DESI,
	 e.SALARY
from
	EmployeeSalary es
join EMP_Salary e
on e.eid=es.eid
where desi = 'Manager'

-- 3: REDUCE THE SALARY OF ALL DELHI EMPLOYEES BY 10%.

select
	 es.EID, 
	 es.NAME , 
	 es.CITY ,
	 e.SALARY,
	 e.SALARY*0.10 as 'Updated_Salary'
from
	EmployeeSalary es
join EMP_Salary e
on e.eid=es.eid
where es.city = 'delhi'

alter table emp_salary
add Updated_Salary_Delhi int

update e
set e.Updated_Salary_Delhi= SALARY*0.10 
from emp_salary e
join EmployeeSalary es
on e.eid=es.eid
where es.city = 'delhi'

select * from  emp_salary

-- 4 : DISPLAY THE EID, NAME , CITY, DOJ ,DEPT, DESI & SALARY OF THE TEAM  MEMBERS OF DAVID & RAMESH GUPTA.

select
	 es.EID, 
	 es.NAME , 
	 es.CITY ,
	 es.DOJ,
	 e.DEPT, 
	 e.DESI,
	 e.SALARY
from
	EmployeeSalary es
join EMP_Salary e
on e.eid=es.eid
where 
	e.DEPT in(
		select e.DEPT
		from EmployeeSalary es 
		join EMP_Salary e
		on e.eid=es.eid
		where es.NAME in ('DAVID' , 'RAMESH GUPTA'))

-- A-5: CREATE A TRAINING TABLE CONTAINING EID, NAME, DEPT. INSERT THE DETAILS OF OPS TEAM MEMBERS IN THE TRAINING TABLE.

SELECT  
    es.EID, 
    es.NAME, 
    e.DEPT 
INTO TRAINING_TABLE
FROM EmployeeSalary es
JOIN EMP_Salary e ON es.EID = e.EID
WHERE e.DEPT = 'OPS';

select * from TRAINING_TABLE
select * from EMP_Salary
where DEPT='ops' and DESI = 'director'

-- 6: DETAILS OF DIRECTORS SHOULD BE DELETED FROM THE TRAINING TABLE.

delete from TrainingTable
where EID in (
	select e.EID from EMP_Salary e
	join TRAINING_TABLE t on e.EID=t.EID 
	where e.DEPT='ops' and e.DESI='Director')

-- 7: DISPLAY THE SALARY DETAILS OFF ALL EMPLOYES IF ANY OF THE TEAM MEMBER  HAS SALARY MORE THAN 200000.

select * from EmployeeSalary
select * from EMP_Salary

select 
	E.EID,
	E.Name,
	ES.DEPT,
	ES.DESI,
	ES.SALARY
from EmployeeSalary E
join EMP_Salary ES
on ES.EID = E.EID
where 
	ES.DEPT in
	(Select distinct DEPT
	from EMP_Salary
	where salary > 200000)