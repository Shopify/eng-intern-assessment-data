-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Select category ID, category name, and total sales amount for every category
SELECT ca.category_id, ca.category_name, 
-- Calculate the sum or the total sales amount
sum(od.quantity * od.unit_price) AS total_sales_amount
-- Join products with categories and order_items_data
from categories ca JOIN products pr ON ca.category_id = pr.category_id
JOIN order_items_data od ON pr.product_id = od.product_id
-- Group results by category id and name
GROUP BY ca.category_id, ca.category_name
-- Order results by total sales amount in descending order and limited to the top 3 categories.
ORDER BY total_sales_amount DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Select user ID and username
SELECT us.user_id, us.username FROM user_data us
-- Join user_data with order
JOIN orders ord ON us.user_id = ord.user_id
-- Join order_items_data with orders
JOIN order_items_data oid ON ord.order_id = oid.order_id
-- Join order_items_data with products
JOIN products pr ON oid.product_id = pr.product_id
-- Join products with categories.
JOIN categories ca ON pr.category_id = ca.category_id
-- Filter by Toys & Games category
WHERE ca.category_name = 'Toys & Games' 
-- Group results by user id and username
GROUP BY us.user_id, us.username
-- Filter results to show only users who have placed orders for distinct products in Toys & Games.
HAVING COUNT(distinct pr.product_id) = (
-- Create a subquery to count total number of distinct products in Toys & Games
select COUNT(distinct product_id) FROM products WHERE category_id = (
-- Create a subquery to find category_id for Toys & Games category
SELECT category_id FROM categories WHERE category_name = 'Toys & Games'
)
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Select product id, name, category id, and price.
SELECT pr.product_id, pr.product_name, pr.category_id, pr.price FROM products pr
-- Join products with a subquery which finds the max price for every category. 
INNER JOIN ( SELECT category_id, MAX(price) AS max_price FROM products 
GROUP BY category_id )
-- Match category id
AS max_prices ON pr.category_id = max_prices.category_id 
-- Match product's price with max price.
AND pr.price = max_prices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Create a CTE that creates a dataset with user id, username, order date, previous order date and next order date.
WITH DatesOrder AS ( SELECT ord.user_id, us.username, ord.order_date,
-- Use lag to get previous order date for every user.
LAG(ord.order_date, 1) OVER (partition by ord.user_id ORDER BY ord.order_date) AS
previous_order_date,
-- Lead provides the next order date for every user.
LEAD(ord.order_date, 1) OVER (partition by ord.user_id ORDER BY ord.order_date) AS 
next_order_date
-- Join orders with user_data
FROM orders ord JOIN user_data us ON ord.user_id = us.user_id )
-- Select distinct user ids and usernames
SELECT DISTINCT user_id, username
-- Filter results to show users who have ordered on 3 consecutive days
FROM DatesOrder WHERE order_date = date_add(previous_order_date, interval 1 DAY) AND
next_order_date = date_add(order_date, interval 1 day);
