-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select p.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) as total_sales_amount
from Order_Items oi 
left join Products p on oi.product_id = p.product_id
left join Categories c on p.category_id = c.category_id
group by p.category_id, c.category_name
order by total_sales_amount desc
limit 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

with order_data as (
    select o.*, oi.*, p.*
    from Orders o 
    left join Order_Items oi on o.order_id = oi.order_id
    left join Products p on oi.product_id = p.product_id) 

select u.user_id, u.username 
from Users u 
left join order_data od on u.user_id = od.user_id
where od.category_id = (select category_id from Categories where category_name = 'Toys & Games')
group by u.user_id, u.username, od.product_id
having COUNT(od.product_id) = (select COUNT(product_id) from Products where category_id = (select category_id from Categories where category_name = 'Toys & Games'));


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

with rankings as (
    select product_id, product_name, category_id, price, ROW_NUMBER() over (partition by category_id order by price desc) as ranking
    from Products
)

select product_id, product_name, category_id, price
from rankings
where ranking = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


with PrevOrders as (
    select user_id, order_date, LAG(order_date) over (partition by user_id order by order_date) as prev_order_date
    from Orders
)

select DISTINCT o.user_id, u.username
from PrevOrders o 
left join Users u on o.user_id = u.user_id
join PrevOrders o1 on o1.user_id = o.user_id and o.order_date = DATEADD(DAY, 1, o1.prev_order_date)
join PrevOrders o2 on o2.user_id = o1.user_id and o1.order_date = DATEADD(DAY, 1, o2.prev_order_date);
