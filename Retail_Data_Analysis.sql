SELECT * FROM DATA_RETAIL

-- Checking if there are any Null values

SELECT 
    CASE 
        WHEN EXISTS 
		(SELECT 1 FROM DATA_RETAIL 
					WHERE Product_ID IS NULL 
						OR Product_Name IS NULL
						OR Category IS NULL
						OR Stock_Quantity IS NULL
						OR Supplier IS NULL
						OR Discount IS NULL
						OR Rating IS NULL
						OR Reviews IS NULL
						OR SKU IS NULL
						OR Warehouse IS NULL
						OR Return_Policy IS NULL
						OR Brand IS NULL
						OR Supplier_Contact IS NULL
						OR Placeholder IS NULL
						OR Price IS NULL) 
        THEN 'NULL values exist' 
        ELSE 'No NULL values' 
    END AS NullCheck;

-- More specific columns for null data
SELECT
	Sum(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS 'Product_ID',
	Sum(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS 'Product_Name',
	Sum(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS 'Category',
	Sum(CASE WHEN Stock_Quantity IS NULL THEN 1 ELSE 0 END) AS 'Stock_Quantity',
	Sum(CASE WHEN Supplier IS NULL THEN 1 ELSE 0 END) AS 'Supplier',
	Sum(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS 'Discount',
	Sum(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS 'Rating',
	Sum(CASE WHEN Reviews IS NULL THEN 1 ELSE 0 END) AS 'Reviews',
	Sum(CASE WHEN SKU IS NULL THEN 1 ELSE 0 END) AS 'SKU',
	Sum(CASE WHEN Warehouse IS NULL THEN 1 ELSE 0 END) AS 'Warehouse',
	Sum(CASE WHEN Return_Policy IS NULL THEN 1 ELSE 0 END) AS 'Return_Policy',
	Sum(CASE WHEN Brand IS NULL THEN 1 ELSE 0 END) AS 'Brand',
	Sum(CASE WHEN Supplier_Contact IS NULL THEN 1 ELSE 0 END) AS 'Supplier_Contact',
	Sum(CASE WHEN Placeholder IS NULL THEN 1 ELSE 0 END) AS 'Placeholder',
	Sum(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS 'Price'
FROM
	DATA_RETAIL

---- Checking if there are any duplicate rows for Product_ID

SELECT *
FROM DATA_RETAIL
WHERE Product_ID IN (
    SELECT Product_ID
    FROM DATA_RETAIL
    GROUP BY Product_ID
    HAVING COUNT(*) > 1
)
ORDER BY Product_ID

-- Data is okay to be proceeded with

-- Products with prices higher than the average price within their category

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
				D.Category = D1.Category)

-- Finding Categories with Highest Average Rating Across Products
SELECT
	TOP 1
	CATEGORY,
	AVG(RATING) AS AVG_RATING
FROM
	DATA_RETAIL
GROUP BY
	CATEGORY
ORDER BY
	AVG_RATING DESC 

-- Find the most reviewed product in each warehouse
SELECT
	Product_ID,
	Product_name,
	Category,
	Warehouse,
	Reviews
FROM DATA_RETAIL
Group By 
	Product_ID,
	Product_name,
	Category,
	Warehouse,
	Reviews
Order by
	Reviews desc, Warehouse Asc

SELECT
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

--find products that have higher-than-average prices within their category, along with their discount and supplier.
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

--Query to find the top 2 products with the highest average rating in each category
SELECT
	TOP 2
	Product_ID,
	Product_Name,
	CATEGORY,
	AVG(RATING) AS AVG_RATING
FROM
	DATA_RETAIL
GROUP BY
	Product_ID,
	Product_Name,
	CATEGORY
ORDER BY
	AVG_RATING DESC 

--Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc)


SELECT 
    Return_Policy, 
    COUNT(Product_ID) AS Product_Count, 
    AVG(Stock_Quantity) AS Avg_Stock_Quantity,
    SUM(Stock_Quantity) AS Total_Stock,
    AVG(Price) AS Avg_Price,
    SUM(Price * Stock_Quantity) / SUM(Stock_Quantity) AS Weighted_Avg_Price,
    AVG(Rating) AS Avg_Rating,
    SUM(Rating * Reviews) / NULLIF(SUM(Reviews), 0) AS Weighted_Avg_Rating,
    AVG(Discount) AS Avg_Discount,
    SUM(Price * Stock_Quantity) AS Total_Estimated_Revenue,
    MAX(Reviews) AS Max_Reviews,
    SUM(Stock_Quantity) / SUM(Reviews) AS Stock_Turnover_Rate,
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price,
    COUNT(DISTINCT Brand) AS Unique_Brands,
    COUNT(DISTINCT SKU) AS Unique_SKUs,
    COUNT(DISTINCT Supplier) AS Unique_Suppliers
FROM 
    DATA_RETAIL
GROUP BY 
    Return_Policy
ORDER BY 
    Product_Count DESC
