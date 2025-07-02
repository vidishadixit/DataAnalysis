/*
1. A stakeholder wants to know which product category brings the most revenue. How would you approach it using SQL?
I would find if table has revenue column, if not try to calculate by total units sold * unit price. 
Then I would group and order by product category desc and result will display it
*/

Select
	P.category,
	Sum(oi.quantity*oi.unit_price) as total_revenue
From
	Orderitems oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY
  p.category
ORDER BY
  total_revenue DESC
LIMIT 1;

/*
2. Your manager wants a report showing returning vs new customers. How will you define and write logic for that in SQL?
Count of order IDs for new customers and returning customers would help identify customers.
*/

SELECT
  customer_id,
  CASE
    WHEN COUNT(order_id) = 1 THEN 'New Customer'
    ELSE 'Returning Customer'
  END as segment
FROM
  orders
GROUP BY
  customer_id;
