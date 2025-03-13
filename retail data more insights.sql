use Projects;

---- Products with prices higher than the average price within their category

SELECT
	D.Product_ID,
	D.Product_name,
	D.Category,
	D.Price
FROM
	Data_Retail D
WHERE
	D.Price > (
			SELECT
				AVG(D1.Price)
			FROM
				Data_Retail D1
			WHERE
				D.Category = D1.Category);

-- above question but with better approach considering performance we can use join
-- for row wise row correlated subquery is used but if data is larger then join would be more beneficial
-- in correlated subquery for each row of price, avgerage price per category is getting compared that's why it's slow
-- in join approch, table is created and price is getting compared with table

SELECT 
	    D.Product_ID, 
	    D.Product_name, 
	    D.Category, 
	    D.Price
	FROM Data_Retail D
	JOIN (
	    SELECT Category, AVG(Price) AS AvgPrice
	    FROM Data_Retail
GROUP BY Category
) A ON D.Category = A.Category
WHERE D.Price > A.AvgPrice;

-- for more faster approach we can use indexes

CREATE INDEX idx_category_price ON Data_Retail (Category, Price);

-- modify this query to include the average price for each category in the output
SELECT 
    D.Product_ID, 
    D.Product_name, 
    D.Category, 
    D.Price, 
    A.AvgPrice
FROM Data_Retail D
JOIN (
    SELECT Category, AVG(Price) AS AvgPrice
    FROM Data_Retail
    GROUP BY Category
) A ON D.Category = A.Category
WHERE D.Price > A.AvgPrice
order by d.category

-- query for finding the most reviewed product in each warehouse uses a correlated subquery. 
-- How could you rewrite this using JOIN for better performance

--original query
ELECT
	Product_ID,
	Product_name,
	Category,
	Warehouse,
	Reviews
FROM 
	DATA_RETAIL DR1
WHERE 
	Reviews = 
    (SELECT MAX(DR2.Reviews) 
    FROM DATA_RETAIL DR2
    WHERE DR2.Warehouse = DR1.Warehouse)
GROUP BY
	Product_ID,
	Product_name,
	Category,
	Warehouse,
	Reviews
Order BY
	Warehouse Asc

-- optimized query
SELECT
	DR1.Product_ID,
	DR1.Product_name,
	DR1.Category,
	DR1.Warehouse,
	DR1.Reviews,
	DR2.Max_reviews
FROM 
	DATA_RETAIL DR1
Join(select warehouse, MAX(Reviews) as Max_reviews
    FROM DATA_RETAIL
	group by Warehouse) DR2 on dr2.Warehouse=dr1.Warehouse
WHERE 
	Reviews = DR2.Max_reviews
GROUP BY
	DR1.Product_ID,
	DR1.Product_name,
	DR1.Category,
	DR1.Warehouse,
	DR1.Reviews,
	DR2.Max_reviews
Order BY
	dr1.Warehouse Asc

-- discount analysis query to also include the standard deviation of discounts in each category
SELECT 
    Category, 
    AVG(Discount) AS Avg_Discount, 
    STDEV(Discount) AS Std_Dev_Discount,  -- Standard Deviation of Discount
    COUNT(Product_ID) AS Product_Count
FROM DATA_RETAIL
GROUP BY Category
ORDER BY Avg_Discount DESC

-- Median
SELECT 
    Category, 
    AVG(Discount) AS Avg_Discount, 
    STDEV(Discount) AS Std_Dev_Discount, 
    COUNT(Product_ID) AS Product_Count,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Discount) AS Median_Discount
FROM DATA_RETAIL
GROUP BY Category
ORDER BY Avg_Discount DESC;

-- correlation
SELECT 
    Category, 
    AVG(Discount) AS Avg_Discount, 
    STDEV(Discount) AS Std_Dev_Discount, 
    AVG(Sales_Quantity) AS Avg_Sales_Volume,
    CORR(Discount, Sales_Quantity) AS Discount_Sales_Correlation  -- Measures relationship
FROM DATA_RETAIL
GROUP BY Category
ORDER BY Discount_Sales_Correlation DESC;

-- CTE instead of a subquery in the ‘higher-than-average price’ query

-- original query

SELECT 
    D.Product_ID,
	D.Product_name,
	D.Category,
	D.Price,
    D.Discount,
    D.Supplier
FROM DATA_RETAIL D
WHERE D.Price > (
    SELECT AVG(D2.Price)
    FROM DATA_RETAIL D2
    WHERE D2.Category = D.Category)

-- optimized query

with avg_price as(
			SELECT
				Category,
				AVG(Price) as avgprice
			FROM
				Data_Retail
			group by 
				Category)
SELECT
	d.Product_ID,
	d.Product_name,
	d.Price
FROM
	Data_Retail D
join avg_price a
on a.Category=d.Category
WHERE
	d.Price > a.avgprice