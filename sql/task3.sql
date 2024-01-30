-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write a SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- get the category name, cateogry id, and the sum based on quantity x unit price 
SELECT cat.category_id, cat.category_name, SUM(ord_id.quantity * ord_id.unit_price) as total_sales
from categories cat, order_items ord_id, products prod 
where prod.product_id = ord_id.product_id and
	prod.category_id = cat.category_id
group by cat.category_id
order by total_sales desc --order by total sales descending
limit 5; --select top 5

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select usrs.user_id, usrs.username
-- join everything together
from users usrs, categories cat, products prod, orders ord, order_items ord_id
where -- verify that items are all linked correctly
	usrs.user_id=ord.user_id and
	ord_id.product_id=prod.product_id and
	ord.order_id=ord_id.order_id and 
	cat.category_id=prod.category_id
	and cat.category_name like '%Toys and Games%' --verify category
group by usrs.user_id --group by the user id
-- here we will count the number of products in the category who have users who have orders for all products
having count(distinct prod.product_id) = (
	select count(distinct prod.product_id ) 
	from products prod, categories cat 
	where prod.category_id = cat.category_id
	and cat.category_name like '%Toys and Games%'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select prod.product_id, prod.product_name, cat.category_id, prod.price
from products prod, categories cat
where 
	prod.category_id = cat.category_id 
	-- iterate through to find the unique prices that match the maximum per category
	and (cat.category_id, prod.price) in (
		select prod2.category_id, MAX(prod2.price)
		from products prod2
		group by prod2.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- we will do what we did in task 2 but three times. 
select usrs.user_id, usrs.username
from users usrs, orders ord1, orders ord2, orders ord3
where ord1.user_id=usrs.user_id and usrs.user_id=ord2.user_id and usrs.user_id=ord3.user_id
and DATE_PART('day', ord1.order_date) - DATE_PART('day', ord2.order_date) = 1
and DATE_PART('day', ord2.order_date) - DATE_PART('day', ord3.order_date) = 1
-- finally, ensure that order id is not duplicated
and ord1.order_id != ord2.order_id and ord2.order_id != ord3.order_id and ord1.order_id != ord3.order_id;
