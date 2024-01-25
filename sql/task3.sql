-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select c.category_id, c.category_name, sum(oi.quantity * oi.unit_price) as total_sales_amount 
from categories as c 
join products as p 
on c.category_id = p.category_id 
join order_items as oi 
on p.product_id = oi.product_id 
group by c.category_id, c.category_name 
order by total_sales_amount desc 
limit 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select u.user_id, u.username 
from users as u 
join orders as o 
on u.user_id = o.user_id 
join order_items as oi 
on o.order_id = oi.order_id 
join products as p 
on oi.product_id = p.product_id 
join categories as c 
on p.category_id = c.category_id 
where c.category_name = 'Toys & Games' 
group by u.user_id, u.username 
having count(distinct oi.product_id) = (
    select count(distinct p2.product_id) 
    from products as p2 
    join categories as c2 
    on p2.category_id = c2.category_id 
    where c2.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
select p.product_id, p.product_name, p.category_id, p.price 
from products as p 
where p.price = (
    select max(p2.price) 
    from products as p2 
    where p2.category_id = p.category_id
);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
select distinct u.user_id, u.username
from users as u
join orders as o1 
on u.user_id = o1.user_id
join orders as o2 
on u.user_id = o2.user_id 
and ((o2.order_date = o1.order_date + interval '1 day') or (o2.order_date = o1.order_date - interval '1 day'))
join orders as o3 
on u.user_id = o3.user_id 
and ((o3.order_date = o2.order_date + interval '1 day') or (o3.order_date = o2.order_date - interval '1 day'));