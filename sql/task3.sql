-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select c.category_id, c.category_name, sum(o.total_amount) as sales
from Categories c, Products p, Order_Items oi, Orders o
where c.category_id = p.category_id and p.product_id = oi.product_id and oi.order_id = o.order_id
group by c.category_id, c.category_name
order by sales desc
limit 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select u.user_id, u.username
from Users u, Orders o, Order_Items oi, Products p, Categories c
where u.user_id = o.user_id and o.order_id = oi.order_id 
and oi.product_id = p.product_id and p.category_id = c.category_id
and c.category_id = 5 -- Toys & Games is the 5th category
having count(distinct oi.product_id) = (select count(*) from Products where category_id = 5);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select distinct p.product_id, p.product_name, p.category_id, p.price
from Products p
where p.price = (
    select max(price) from (
        select p2.price
        from Products p2
        where p2.category_id = p.category_id
    )
);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select distinct u.user_id, u.username
from Users u, Orders o1, Orders o2, Orders o3
where u.user_id = o1.user_id and u.user_id = o2.user_id and u.user_id = o3.user_id
and o1.order_date = o2.order_date - interval 1 day
and o2.order_date = o3.order_date - interval 1 day; -- same logic as task 8, but with 3 orders instead of 2