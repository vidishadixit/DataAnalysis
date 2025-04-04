/*
CREATE A FUNCTION CALC TO PERFORM THE SPECIFIED OPERATION ON THE  GIVEN TWO NUMBERS 
*/

CREATE FUNCTION dbo.CALC(
    @Num1 DECIMAL(10,2), 
    @Num2 DECIMAL(10,2), 
    @Operation CHAR(1)  -- '+' for Add, '-' for Subtract, '*' for Multiply, '/' for Divide
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Result DECIMAL(18,2)

    IF @Operation = '+'
        SET @Result = @Num1 + @Num2
    ELSE IF @Operation = '-'
        SET @Result = @Num1 - @Num2
    ELSE IF @Operation = '*'
        SET @Result = @Num1 * @Num2
    ELSE IF @Operation = '/' AND @Num2 <> 0
        SET @Result = @Num1 / @Num2
    ELSE
        SET @Result = NULL  -- Return NULL for invalid operations (like division by zero)

    RETURN @Result
END;


SELECT dbo.CALC(10, 5, '+') AS Addition;       -- Output: 15.00
SELECT dbo.CALC(10, 5, '-') AS Subtraction;    -- Output: 5.00
SELECT dbo.CALC(10, 5, '*') AS Multiplication; -- Output: 50.00
SELECT dbo.CALC(10, 5, '/') AS Division;       -- Output: 2.00
SELECT dbo.CALC(10, 0, '/') AS Division;       -- Output: NULL (division by zero)


/*
FUNCTION TO GENERATE THE EMAIL ID BY ACCEPTING NAME & EID. 
EMAIL  SHOULD CONTAIN 1ST CHARACTER OF 1ST last NAME ,  First NAME, LAST  3 DIGITS OF EMP ID FOLLOWED BY @abc.co;
*/

select * from EmployeeSalary
select * from EMP_Salary

CREATE FUNCTION dbo.GeneratEmail(
    @FullName NVARCHAR(100),
    @EID NVARCHAR(20)  -- Accepts alphanumeric EID
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @Email NVARCHAR(100), @EIDStr NVARCHAR(10)

    -- Ensure EID is at least 3 characters long (handle short EIDs)
    SET @EIDStr = RIGHT(@EID, 3)

    -- Extract first name (first word before space)
    SET @FirstName = LEFT(@FullName, CHARINDEX(' ', @FullName + ' ') - 1)

    -- Extract last name (last word after space, handles cases with only first name)
    SET @LastName = RIGHT(@FullName, CHARINDEX(' ', REVERSE(@FullName) + ' ') - 1)

    -- Construct Email ID
    SET @Email = UPPER(LEFT(@LastName, 1)) + @FirstName + @EIDStr + '@abc.co'

    RETURN @Email
END;


SELECT dbo.GeneratEmail(Name, EID) AS EmailID from EmployeeSalary;

/*
FUNCTION TO RETURN EID, NAME, DESI, DEPT ,SALARY OF THE EMPLOYEES OF A  SPECIFIED DEPARTMENT.
*/

Create function GetEmpDetails()
returns table
as
return
(
	select
		ES.EID, 
		ES.NAME, 
		E.DESI, 
		E.DEPT,
		E.SALARY
	from
		EmployeeSalary ES
	join
		EMP_Salary E
	on
		E.EID = ES.EID)

select * from GetEmpDetails()
where DEPT = 'OPS'

/*
FUNCTION TO DISPLAY THE NAME , DEPT . DESI , CITY OF THE EMPLOYEES WHO  HAVE THE BIRTHDAY IN THE CURRENT MONTH
*/

create function CurrentBdayMonthEMP()
returns table
as
return
(
	select 
		ES.NAME , 
		E.DEPT,
		E.DESI , 
		ES.CITY
	from
		EmployeeSalary ES
	join
		EMP_Salary E
	on E.EID = ES.EID
	where
		month(ES.DOB)=MONTH(getdate())
		)

select * from CurrentBdayMonthEMP()

/*
FUNCTION TO DISPLAY THE NAME, DEPT & DOJ OF EMPLOYEES WHO HAVE  COMPLETED 5 YEARS IN THE COMPANY.
*/

Create function FiveYrOldEmp()
returns table
as
return 
(
	select
		ES.NAME, 
		E.DEPT,
		ES.DOJ
	From
		EmployeeSalary ES
	join EMP_Salary E
	on E.EID = ES.EID
	where
		DATEDIFF(year, ES.DOJ,getdate()) -
			case
				when
					month(ES.DOJ)>month(getdate()) or
					month(ES.DOJ) = month(getdate()) and day(ES.DOJ)>day(getdate())
					then 1
					else 0
				end >=5
		)

Select * from FiveYrOldEmp()