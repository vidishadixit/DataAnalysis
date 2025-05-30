use Ecommerce

select * from Customers_review_table
select * from Customers_table
select * from Order_items_table
select * from Orders_table
select * from Payments_table
select * from Products_table
select * from Sellers_table

-- delivery performance
 select * from orders_table
 where order_delivered_customer_date > order_estimated_delivery_date;

select  
   order_id,
   DATEDIFF(day, order_delivered_customer_date, order_purchase_timestamp) as actual_shipping_days,
   DATEDIFF(day, order_estimated_delivery_date, order_purchase_timestamp) as estimated_shipping_days,
   case 
       when order_delivered_customer_date > order_estimated_delivery_date THEN 'Yes'
       else 'No'
	end as sla_violated
from Orders_table
where order_delivered_customer_date is not null
  and order_purchase_timestamp is not null
  and order_estimated_delivery_date is not null


 -- 7827 deliveries were late than estimated

select payment_type, count(*) from payments_table
group by payment_type
order by count(*) desc

/*
payment_type	(No column name)
credit_card		76795
boleto			19784 -- cash in spanish
voucher			5775
debit_card		1529
not_defined		3
*/

-- geographics
select * from Customers_table
select * from Order_items_table

select customer_city, customer_state, count(*)  from Customers_table
group by customer_city,customer_state order by count(*) desc

-- highest customers are from SP 41746

select customer_city, count(*) from Customers_table
where customer_state = 'sp'--41746
group by customer_city order by count(*) desc

-- customer segmentation

--1. Spending habbits total purchase value per customer
select
	C.customer_id,
	round(sum(Payment_value),2) as Total_purchase_value
from customers_table C
join Orders_table O on O.customer_id = C.customer_id
join Payments_table P on O.order_id =P.order_id
where O.order_status = 'delivered' and o.validation_issues = 'ok'
group by c.customer_id
order by Total_purchase_value desc

--2. Order frequency of customer

--3. Average order value- comparison across states, cities, product categories

select
	C.customer_id,
	c.customer_state,
	round(sum(Payment_value),2) as Total_payment_value,
	count(*) as No_of_Orders,
	round(sum(Payment_value),2)/count(*) as AOV
from customers_table C
join Orders_table O on O.customer_id = C.customer_id
join Payments_table P on O.order_id =P.order_id
where O.order_status = 'delivered' and o.validation_issues = 'ok'
group by c.customer_id, c.customer_state
order by AOV desc

--by state
select
	c.customer_state,
	round(sum(Payment_value),2) as Total_payment_value,
	count(*) as No_of_Orders,
	round(sum(Payment_value),2)/count(*) as AOV
from customers_table C
join Orders_table O on O.customer_id = C.customer_id
join Payments_table P on O.order_id =P.order_id
where O.order_status = 'delivered' and o.validation_issues = 'ok'
group by c.customer_state
order by AOV desc

-- by city
select
	c.customer_city,
	round(sum(Payment_value),2) as Total_payment_value,
	count(*) as No_of_Orders,
	round(sum(Payment_value),2)/count(*) as AOV
from customers_table C
join Orders_table O on O.customer_id = C.customer_id
join Payments_table P on O.order_id =P.order_id
where O.order_status = 'delivered' and o.validation_issues = 'ok'
group by c.customer_city, c.customer_state
order by AOV desc

-- product category
select
	Pt.Product_category_name,
	round(sum(Payment_value),2) as Total_payment_value,
	count(*) as No_of_Orders,
	round(sum(Payment_value),2)/count(*) as AOV
from Products_table PT
join Order_items_table OT on PT.product_id = OT.product_id
join Orders_table O on OT.order_id = O.order_id
join Payments_table P on O.order_id =P.order_id
where O.order_status = 'delivered' and o.validation_issues = 'ok'
group by Pt.Product_category_name
order by AOV desc

-- Review score

select
	CR.review_score,
	count(*) as total_orders
from
	Customers_review_table CR
join Orders_table O on CR.order_id = O.order_id
group by CR.review_score
order by total_orders desc

-- orders with 0 review scores
select
	CR.review_score,
	count(*) as total_orders
from
	Customers_review_table CR
right join Orders_table O on CR.order_id = O.order_id
group by CR.review_score
order by total_orders desc

-- cancelled order analysis
select
	O.order_status,
	p.Payment_type,
	round(sum(P.payment_value),2) as refund
from 
	orders_table O
join payments_table P on P.order_id = O.order_id
where order_status = 'canceled'
group by
	o.order_status, p.payment_type
order by refund desc

/*
order_status	Payment_type	refund
canceled		credit_card		96626.73
canceled		voucher			25664.92
canceled		boleto			17504.1
canceled		debit_card		2711.27
canceled		not_defined		0
*/

select
	O.order_status,
	COUNT(DISTINCT O.order_id) AS canceled_orders
from 
	orders_table O
join payments_table P on P.order_id = O.order_id
where order_status = 'canceled'
group by
	o.order_status
order by canceled_orders desc
-- 619 orders

select
	O.order_status,
	ROUND(SUM(P.payment_value) / COUNT(DISTINCT O.order_id), 2) AS avg_refund_per_order
from 
	orders_table O
join payments_table P on P.order_id = O.order_id
where order_status = 'canceled'
group by
	o.order_status
order by avg_refund_per_order desc -- 230.22


select
	O.order_status,
	count(*) as Canceled_orders,
	format(O.order_purchase_timestamp, 'yyyy-MM') AS month
from 
	orders_table O
join payments_table P on P.order_id = O.order_id
where order_status = 'canceled'
group by o.order_status, format(O.order_purchase_timestamp, 'yyyy-MM')
order by Canceled_orders desc 

/*
canceled	85	2018-08
canceled	75	2018-02
canceled	42	2018-07
canceled	37	2017-11
canceled	36	2017-07
*/