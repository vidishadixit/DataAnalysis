use Projects

SELECT * FROM HR_DATA
where attrition =1

-- Seeing if personal factors impacting the employees

-- Age
SELECT
	CASE 
        WHEN age <= 29 THEN '18-29'
        WHEN age > 29 AND age <= 39 THEN '30-39'
        WHEN age > 39 AND age <= 49 THEN '40-49'
        WHEN age > 49 AND age <= 59 THEN '50-59'
        ELSE '60 or above'
    END AS Age_bucket,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	CASE 
        WHEN age <= 29 THEN '18-29'
        WHEN age > 29 AND age <= 39 THEN '30-39'
        WHEN age > 39 AND age <= 49 THEN '40-49'
        WHEN age > 49 AND age <= 59 THEN '50-59'
        ELSE '60 or above'
    END
ORDER BY
	AttritionCount ASC;

--Distance
SELECT
	CASE
		WHEN DISTANCEFROMHOME <=10 THEN 'Below 10'
		WHEN DISTANCEFROMHOME > 11 AND DISTANCEFROMHOME<=20 THEN '11-20'
	ELSE 'Above 21'
	END AS 'Distance',
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	CASE
		WHEN DISTANCEFROMHOME <=10 THEN 'Below 10'
		WHEN DISTANCEFROMHOME > 11 AND DISTANCEFROMHOME<=20 THEN '11-20'
	ELSE 'Above 21'
	END
ORDER BY
	AttritionCount DESC;

--Gender
SELECT
	GENDER,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	GENDER
ORDER BY
	AttritionCount DESC;

--Marital Status
SELECT
	MARITALSTATUS,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	MARITALSTATUS
ORDER BY
	AttritionCount DESC;

--Education field
SELECT
	EDUCATIONFIELD,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	EDUCATIONFIELD
ORDER BY
	AttritionCount DESC;

--Department
SELECT
	Department,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	Department
ORDER BY
	AttritionCount DESC;

/*
FINDINGS:
	
	1. Age 18-39 i.e. young talent is leaving that could mean 
	they need for better career development programs, mentorship, and engagement strategies
	2. Employees Living Within 10 KM Have 144 Attrition that could mean 
	proximity to the office does not seem to improve retention. We need to check work life balance
	3. Life Science & Medical Fields Have 152 Attrition that could mean
	possibility is job dissatisfaction, work conditions, or compensation not meeting industry standards.
	4. Gender Males Have the Highest Attrition (150 out of 237 total attrition)
	Possible reasons: better external job opportunities, work culture, or dissatisfaction with career progression
	5. Single Employees Have the Highest Attrition (120 out of 237 total attrition)
	This suggests that single employees may have fewer personal commitments tying them to the company, 
	making them more open to new opportunities.
	They might also be seeking better work-life balance, career growth, or financial stability.
*/

-- Digging further with these results and findings
-- 1. 18-39 age group had 2-4 times trainings last year and has hike below 15 have attrition rate of 135
SELECT  
    '18-39' AS Age_bucket,  
    'Below 15' AS Hike_bucket,  
    COUNT(*) AS AttritionCount  
FROM HR_DATA  
WHERE ATTRITION = 1  
    AND age <= 39  
    AND TrainingTimesLastYear BETWEEN 0 AND 4  
    AND percentsalaryhike <= 15;

/*
2. Distance below 10 km have mostly good work life balance (3 and 4). WLB with 1&2 (poor) has only 46 attritions. 
So WLB could not be considered.
if we consider Hike bucket, most people who lived below 10 km falls under below 15% hike. Hike should be main factor in this.
*/

SELECT
	'Below 10km' as DISTANCEFROMHOME,
	'Below 15%' as percentsalaryhike,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
	and DISTANCEFROMHOME <=10
	and percentsalaryhike <= 15

/*
3. For Life Science & Medical Fields job dissatisfaction, work conditions did not give any conclusive results.
*/

SELECT
	EDUCATIONFIELD,
	JobSatisfaction,
	EnvironmentSatisfaction,
	RelationshipSatisfaction,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1 and (EDUCATIONFIELD = 'Life Sciences' or EDUCATIONFIELD = 'Medical')
GROUP BY
	EDUCATIONFIELD,
	JobSatisfaction,
	EnvironmentSatisfaction,
	RelationshipSatisfaction
ORDER BY
	AttritionCount DESC;

/*
3. For Life Science & Medical Fields compensation 121 people have less than average income.
It's important factor.
*/

SELECT
	EDUCATIONFIELD,
	Monthlyincome,
	(SELECT AVG(MonthlyIncome) FROM hr_data) AS avg_income,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1 and Monthlyincome < (SELECT AVG(MonthlyIncome) FROM hr_data) 
	and (EDUCATIONFIELD = 'Life Sciences' or EDUCATIONFIELD = 'Medical')
GROUP BY
	EDUCATIONFIELD,
	Monthlyincome
ORDER BY
	AttritionCount DESC;

/*
4. Gender Males Have the Highest Attrition (150 out of 237 total attrition) 
WLB could not play imp factor as (1-2) poor WLB has 57 attritions
Poor job satisfaction has 67 attritions
Poor env satisafaction has 67 attritions
Poor relationship satisafaction has 60 attrtions.
So gender does not play any important role in attritions.
*/
SELECT
	GENDER,
	WorkLifeBalance,
	JobSatisfaction,
	EnvironmentSatisfaction,
	RelationshipSatisfaction,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1 
and gender ='Male'
and (RelationshipSatisfaction=1 or RelationshipSatisfaction=2)
GROUP BY
	GENDER,
	WorkLifeBalance,
	JobSatisfaction,
	EnvironmentSatisfaction,
	RelationshipSatisfaction
ORDER BY
	AttritionCount DESC;

/*
5. Single Employees Have the Highest Attrition (120 out of 237 total attrition)
WLB do not impact here.
1-4 times trained employees has 104 attritions.
Below 15 hike bucket has 67 attritions.
56 people has less than avg income
34 males
This factor is non-conclusive as training is altogether different factor can not be linked with marital status.
This marital status could not be considered.
*/
SELECT
    MARITALSTATUS,
	Gender,
    WorkLifeBalance,
    TrainingTimesLastYear,
    'Below 15' AS Hike_bucket,  
	Monthlyincome,
	(SELECT AVG(MonthlyIncome) FROM hr_data) AS avg_income,
    COUNT(*) AS AttritionCount
FROM HR_DATA
WHERE
    ATTRITION = 1
		AND MARITALSTATUS = 'Single'
		AND TrainingTimesLastYear <= 4
		AND percentsalaryhike <= 15  
		and Monthlyincome < (SELECT AVG(MonthlyIncome) FROM hr_data) 
		and gender = 'male'
GROUP BY
    MARITALSTATUS,
	gender,
    WorkLifeBalance,
    TrainingTimesLastYear,
	Monthlyincome

ORDER BY
    AttritionCount DESC;


-- further analysis with additional data
--6. Travel Rarely has higher rate of attrition 156, maybe employees want more business travel.
select 
	businesstravel,  
	count(*) as 'AttritionEmployees' from hr_data
where 
	attrition =1
	and businesstravel ='Travel_Rarely'
group by 
	businesstravel -- Travel Rarely has higher rate of attrition 156
order by 
	AttritionEmployees desc

--7. Dept: 83 employees with R&D dept and %salary hike <15 
SELECT 
    COUNT(*) AS TotalAttritionCount
FROM HR_DATA
WHERE
    ATTRITION = 1
    AND Department = 'Research & Development'
    AND PercentSalaryHike <= 15
	
-- 8. 115 R&D emp has less than avg income.
SELECT 
    COUNT(*) AS TotalAttritionCount
FROM HR_DATA
WHERE
    ATTRITION = 1
    AND Department = 'Research & Development'
	and Monthlyincome < (SELECT AVG(MonthlyIncome) FROM hr_data)

-- 9. Job role has inconclusive results.
SELECT
	JobRole,
	COUNT(*) AS 'AttritionCount'
FROM 
	HR_DATA
WHERE
	ATTRITION = 1
GROUP BY
	JobRole
ORDER BY
	AttritionCount DESC


/*
FINAL CONCLUSION

1. 18-39 age group had 2-4 times trainings last year and has hike below 15 have attrition rate of 101.
So focus on younger talent, train them well so that they can improve in jobs and can get better hike.
2. Employees Living Within 10 KM Have 144 Attrition out of which 95 employees received below 15% hike.
3.For Life Science & Medical Fields compensation 121 people have less than average income.
It's important factor. If we offer competitive compensation these field could have less attrition in future.
Dept: 83 employees with R&D dept and %salary hike <15 
4. Male gender has 150 attrition but WLB,job satisfaction, env satisafaction, relationship satisafaction has less attrtions.
So gender does not play any important role in attritions.
5.Single Employees Have the Highest Attrition (120 out of 237 total attrition)
But WLB, hike bucket, less than avg income, do not impact here.
1-4 times trained employees has 104 attritions.
This factor is non-conclusive as training is altogether different factor can not be linked with marital status.
This marital status could not be considered.
6. Travel Rarely has higher rate of attrition 156, maybe employees want more business travel.