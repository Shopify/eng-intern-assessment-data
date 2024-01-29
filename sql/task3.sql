-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- use AGGREGATE and GROUP BY category to get sales per category, use ORDER BY and TOP to select top 3
SELECT TOP 3
    P.category_id,
    category_name,
    SUM(quantity*unit_price) AS total_category_sales 
FROM Orders O
LEFT JOIN Order_items OI ON O.order_id = OI.order_id
LEFT JOIN Products P ON OI.product_id = P.product_id
LEFT JOIN Categories C ON P.category_id = C.category_id
GROUP BY P.category_id, category_name
ORDER BY total_category_sales DESC;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- similar logic to problem 6, first group products ordered only for category 5: Toys & Games
SELECT O.user_id, username
FROM Orders O
LEFT JOIN Order_items OI ON O.order_id = OI.order_id
LEFT JOIN Products P ON OI.product_id = P.product_id
LEFT JOIN Users U ON O.user_id = U.user_id
WHERE category_id = 5
GROUP BY O.user_id, username
-- in having clause check if the unique products orders equals number of products in that category
HAVING COUNT(DISTINCT(P.product_name)) = 
	(SELECT COUNT(product_name)
     FROM Products
     WHERE category_id = 5);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- CTE to get desired columns as well as max price per category
WITH max_price AS (
SELECT 
  	product_id,
    product_name,
    category_id,
    price,
    MAX(price) OVER(PARTITION BY category_id) AS max_per_cat
FROM 
    Products)

-- grab all products that are the most expensive in their category (includes ties) 
SELECT 
	product_id, 
    product_name,
    category_id,price
FROM max_price
WHERE max_per_cat = price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- CTE with second previous and previous order dates, and 1 and 2 days past of order
WITH order_updated AS (
SELECT 
	O.user_id,
    order_date,
	LAG(order_date,1) OVER(PARTITION BY O.user_id ORDER BY order_date) AS prev_order,
    LAG(order_date,2) OVER(PARTITION BY O.user_id ORDER BY order_date) AS second_prev_order,
    DATEADD(day,-1,order_date) as prev_date,
    DATEADD(day,-2,order_date) as second_prev_date
FROM Orders O)

-- return all users that have a order within 3 consecutive days
SELECT DISTINCT
	OU.user_id,
    username
FROM order_updated OU
LEFT JOIN Users U ON OU.user_id = U.user_id 
WHERE prev_order = prev_date AND
      second_prev_order = second_prev_date;