-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(quantity* unit_price) AS total_sales_amount
FROM Categories AS c LEFT JOIN Products AS p ON c.category_id = p.category_id
                     LEFT JOIN Order_Items AS i ON p.product_id = i.product_id
GROUP BY c.category_id, c.category_name
ORDER BY SUM(quantity* unit_price) DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

#Find the category_id for 'Toys & Games'
WITH ToyCategory AS (
SELECT category_id
FROM Categories
WHERE category_name = 'Toys & Games'), 

#Find all product_id in that category
ToyProductIDs AS (
SELECT DISTINCT product_id
FROM Products
WHERE category_id = (SELECT * FROM ToyCategory)),

#Find all orders
AllOrders AS(
SELECT u.user_id, u.username, i.product_id
FROM Users as u JOIN Orders AS o ON u.user_id = o.user_id 
     JOIN Order_Items AS i ON o.order_id = i.order_id 
     JOIN Products AS p on p.product_id = i.product_id) 

#Find all the users who have placed orders for all products in the Toys & Games
SELECT user_id, username
FROM ALLOrders
GROUP BY user_id, username 
HAVING COUNT(DISTINCT product_id) = (SELECT COUNT(*) FROM ToyProductIDs);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT product_id, product_name, category_id, price
FROM (
#Rank product price in a dese order for each category
SELECT product_id, product_name, category_id, price, 
       RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
FROM Products) AS p1 
WHERE price_rank =1 ;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

# Gather order date, keep unique order_date for each user_id
WITH uniqueOrderDate as(
SELECT user_id, order_date
FROM Orders
GROUP BY user_id, order_date),

# For consecutive dates, the value of grp will be the same because for all consecutive dates
consecutiveGroup as (
SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS row_num, 
DATE_SUB(order_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) DAY) as grp
FROM uniqueOrderDate),

# Select the user_id who have placed orders on consecutive days for at least 3 days
userIdList AS (
SELECT user_id, COUNT(*) AS consecutiveDates
FROM consecutiveGroup
GROUP BY user_id, grp
HAVING COUNT(*) >=3) 

#Get the distinct user_id and join Users table for user_name information
SELECT DISTINCT l.user_id as user_id, u.username
FROM userIdList AS l LEFT JOIN Users AS u ON l.user_id = u.user_id;

