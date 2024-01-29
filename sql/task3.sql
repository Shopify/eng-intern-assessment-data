-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem description can be interpreted in different ways, so:
-- If we use unit_price in Order_Items
select Categories.category_id, Categories.category_name, sum(Order_Items.unit_price*Order_Items.quantity) as total_sales
from Categories join Products on Categories.category_id = Products.category_id join Order_Items on Order_Items.product_id = Products.product_id
group by Categories.category_id, Categories.category_name
order by total_sales DESC
limit 3;

-- If we use the price in Products.price (uncomment)
-- select Categories.category_id, Categories.category_name, sum(Products.price*Order_Items.quantity) as total_sales
-- from Categories join Products on Categories.category_id = Products.category_id join Order_Items on Order_Items.product_id = Products.product_id
-- group by Categories.category_id, Categories.category_name
-- order by total_sales DESC
-- limit 3

-- If we want just to summarise number of products sold, we just do sum(Order_Items.quantity)


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
with toys_buyers as (
select user_id
from Orders join Order_Items on Orders.order_id = Order_Items.order_id join Products on Products.product_id = Order_Items.product_id join Categories on Categories.category_id = Products.category_id
where Categories.category_name like '%Toys & Games%'
), -- people who bougth things from categories than Toys & Games
other_buyers as (
select user_id
from Orders join Order_Items on Orders.order_id = Order_Items.order_id join Products on Products.product_id = Order_Items.product_id join Categories on Categories.category_id = Products.category_id
where Categories.category_name not like '%Toys & Games%'
) -- people who bougth things from categories different than Toys & Games
select Users.user_id, Users.username
from Users
where Users.user_id in (select * from toys_buyers) and Users.user_id not in (select * from other_buyers)


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with max_per_cat as (
select Categories.category_id, max(Products.price) as maximum
from Products join Categories on Products.category_id = Categories.category_id
group by category_id
)
select Products.product_id, Products.product_name, Categories.category_id, price
from Products join Categories on Products.category_id = Categories.category_id join max_per_cat on max_per_cat.category_id = Categories.category_id
where Products.price = max_per_cat.maximum

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with cons as (
select Users.user_id, Orders.order_date,
LAG(Orders.order_date) over (partition by Users.user_id order by Orders.order_date) as prev_date, -- previous date to compare
lead(Orders.order_date) over (partition by Users.user_id order by Orders.order_date) as next_date -- next date to compare
from Users left join Orders on Users.user_id = Orders.order_id
)
select Users.user_id, Users.username
from Users join cons on Users.user_id = cons.user_id
where cons.next_date = DATE_ADD(cons.order_date, INTERVAl 1 DAY) and cons.order_date = DATE_ADD(cons.prev_date, INTERVAL 1 DAY) -- check if the orders have consecutive dates
