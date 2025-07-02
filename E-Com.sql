/*
Tables:
•	Customers(customer_id, name, email, country)
•	Orders(order_id, customer_id, order_date, total_amount)
•	OrderItems(order_item_id, order_id, product_id, quantity, unit_price)
•	Products(product_id, product_name, category, price)

Write SQL queries for the following:
1.	Find the total number of orders placed by each customer.
2.	List the top 3 products by total sales (quantity × price).
3.	Retrieve names of customers who have never placed an order.
4.	Show the average order value (AOV) per month in 2024.
5.	Identify customers who placed more than 5 orders in the last 3 months.

*/

--Find the total number of orders placed by each customer

select
	c.customer_id,
	count(o.order_id) as num_of_Orders
from
	customers c
join orders o
on c.customer_id = o.customer_id
group by
	c.customer_id

-- List the top 3 products by total sales (quantity × price)

with sales as
(select
	product_id,
	sum(quantity * unit_price) as total_sales
from
	orderItems
order by
	total_sales)
select
	top 3
	product_id,
	total_sales
from
	sales
	
-- Retrieve names of customers who have never placed an order
select
	c.customer_id
from
	customers c
left join orders o
on c.customer_id = o.customer_id
where o.order_id is null

--Show the average order value (AOV) per month in 2024.
SELECT
  DATE_TRUNC('month', order_date) AS month,
  AVG(total_amount) AS average_order_value
FROM
  orders
WHERE
  EXTRACT(YEAR FROM order_date) = 2024
GROUP BY
  DATE_TRUNC('month', order_date)
ORDER BY
  month;


--Identify customers who placed more than 5 orders in the last 3 months

SELECT
  customer_id,
  COUNT(*) AS total_orders
FROM
  orders
WHERE
  order_date >= DATEADD(MONTH, -3, GETDATE())
GROUP BY
  customer_id
HAVING
  COUNT(*) > 5;
