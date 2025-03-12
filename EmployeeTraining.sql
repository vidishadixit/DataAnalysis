use assignments

select * from EmployeeSalary
select * from EMP_Salary

-- : EID, NAME, CITY OF GURGAON EMPLOYEES
select
	EID,
	Name,
	City
from
	EmployeeSalary
where
	city = 'Gurgaon'

-- EID, NAME , DOJ ,DEPT, DESI & SALARY OF ALL MANAGERS

select
	e.EID,
	e.Name,
	e.DOJ,
	es.DEPT,
	es.DESI,
	es.Salary
from
	EmployeeSalary E
join EMP_Salary ES
on e.eid=es.eid
where
	desi = 'Manager'

-- REDUCE THE SALARY OF ALL DELHI EMPLOYEES BY 10%.

select
	e.EID,
	e.Name,
	e.CITY,
	es.DEPT,
	es.DESI,
	es.Salary,
	salary-(salary*0.10) as Revised_Salary
from
	EmployeeSalary E
join EMP_Salary ES
on e.eid=es.eid
where
	CITY = 'Delhi'

-- DISPLAY THE EID, NAME , CITY, DOJ ,DEPT, DESI & SALARY OF THE TEAM  MEMBERS OF DAVID & RAMESH GUPTA.

Select
	e.EID,
	e.NAME,
	e.CITY,
	e.DOJ,
	es.DEPT,
	es.DESI,
	es.Salary
from
	EmployeeSalary e
join EMP_Salary ES
on e.eid = es.eid
where
	e.NAME = 'DAVID' or e.NAME = 'RAMESH GUPTA'

-- CREATE A TRAINING TABLE CONTAINING EID, NAME, DEPT. INSERT THE DETAILS OF OPS TEAM MEMBERS IN THE TRAINING TABLE.
select
	e.EID,
	es.Name,
	e.Dept
into
	TrainingTable
from
	EMP_Salary e
join EmployeeSalary es
on e.eid=es.eid
where
	e.dept ='OPS'

select * from TrainingTable
	
-- DETAILS OF DIRECTORS SHOULD BE DELETED FROM THE TRAINING TABLE.
delete from TrainingTable
where eid in(
select 
	t.EID
from
	TrainingTable t
join EMP_Salary es
on t.eid = es.eid
where
	es.desi = 'Director')

-- DISPLAY THE SALARY DETAILS OFF ALL EMPLOYES IF ANY OF THE TEAM MEMBER  HAS SALARY MORE THAN 200000.

select * from TrainingTable t
join EMP_Salary es
on es.eid=t.eid
where es.salary > 200000