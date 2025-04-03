USE Assignments;

SELECT * FROM EMP_Salary
SELECT * FROM EmployeeSalary

/*
Create a View for the below queries:

From the employee salary table, 
we need to see the total salary as “TOTAL  COST” for each department arranged in the descending order of total salary .

Also just show only those departments where “TOTAL COST” is greater than
50000.
*/

CREATE VIEW 
	EMPLOYEE_SAL AS
SELECT 
	DEPT, 
	sum(SALARY) as 'TOTAL_COST'
FROM 
	EMP_Salary
GROUP BY
	DEPT
HAVING 
	sum(SALARY) >50000

Select * from EMPLOYEE_SAL 
order by TOTAL_COST desc