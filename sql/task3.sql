-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select c.category_id, c.category_name, sum(o.total_amount) as sales_amount
from categories c 
join products p on c.category_id = p.category_id 
join order_items oi on p.product_id = oi.product_id 
join orders o on oi.order_id = o.order_id 
group by c.category_id 
order by sales_amount desc
limit 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select u.user_id, u.username 
from users u 
join orders o on u.user_id = o.user_id 
join order_items oi on o.order_id = oi.order_id 
join products p on oi.product_id = p.product_id 
where p.category_id = 5
group by u.user_id 
having count(distinct oi.product_id) = ( -- check the count of products is equal to that in the category
	select count(p2.category_id) 
	from products p2 
	where p2.category_id = 5
); 


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
		
select p.product_id, p.product_name, p.category_id, p.price 
from products p
where p.price = ( -- find the row with the max price per category
	select max(cp.price)
	from (
		select p2.price
		from products p2
		where p.category_id = p2.category_id 
	) cp
)

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
select ua.user_id, ua.username
from (
	select u.user_id, u.username, -- get id and username paired with the difference in dates for each user order
		datediff(o.order_date, lag(o.order_date, 1) over (partition by u.user_id order by o.order_date)) as diff
	from users u, orders o 
	where u.user_id = o.user_id 
) ua
where ua.diff is not null and ua.diff = 1
group by ua.user_id
having count(*) >= 2 -- 3 consequtive dates returns 2 entries from the inner ua table

