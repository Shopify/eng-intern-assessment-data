-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
with cat_purchase as
(
	select c.category_id,
	c.category_name, 
	sum(quantity*unit_price) as total_sales from  Order_Items  as o --Since Order table has total sales, at product level quantity and unit price data is used to calcluate total_sales
	left join Products as p 
	on o.product_id=p.product_id
	left join Categories as c
	on c.category_id=p.category_id
	group by c.category_id,c.category_name
)

select
category_id,
category_name,
total_sales from
(
	select
	category_id,
	category_name,
	total_sales,
	row_number() over(order by total_sales desc) as rank_cat --Replacing dense rank with row _number (given test setting)-- Using dense rank to resolve the tie and give continuous ranking
	from cat_purchase
) as cp
where rank_cat<4 and category_id is not null;




-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

with user_puchased_cat as
(
	select oi.product_id,
	o.user_id,
	username,
	category_name,
	p.category_id 
	from Order_Items as oi
	join orders as o
	on oi.order_id=o.order_id
	left join Products as p
	on oi.product_id=p.product_id
	left join Categories as c
	on c.category_id=p.category_id
	left join Users as u
	on o.user_id=u.user_id
	where (category_name) like  '%Toys & Games%'
)

--select * from user_puchased_cat
-- total number of distinct products left should be equal to total number of products with toys & games_id
  

select distinct user_id, 
username 
from user_puchased_cat as u
where product_id in (
	select distinct(product_id) 
	from Products 
	where category_id=u.category_id);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select 
product_id,
product_name,
category_id,
price
from
(
	select
	p.product_id,
	product_name,
	category_id,
	price,
		
	rank() over(partition by category_id order by price desc) as price_rank from  Products as p
		--on p.product_id=oi.product_id
) as b

where price_rank=1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with nextdayorder AS (
    select
    user_id,
    order_date,
    lead(order_date, 1) over (PARTITION BY user_id ORDER BY order_date) AS next_order,
    lead(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_2 -- lead - 2 column to track third order
    FROM Orders
)

select distinct n.user_id,username 
from nextdayorder as n
join  Users as u 
on u.user_id=n.user_id
where DATEDIFF(day,order_date,next_order) =1
and DATEDIFF(day,next_order,next_order_2)=1;