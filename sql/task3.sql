-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Sum calculates the total sales for each category by summing the product of quantity and unit_price
-- The result is grouped by category ID and then arranged in descending order, returning the top 3 rows using LIMIT.
SELECT C.category_id, C.category_name, SUM(OI.quantity*OI.unit_price) AS TOTAL_SALES
FROM Order_Items OI
JOIN Products P ON OI.product_id  = P.product_id
JOIN Categories C ON P.category_id  = C.category_id
GROUP BY C.category_id
ORDER BY TOTAL_SALES DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Created a common table TOY_PRODUCTS which consists of the product_ids having cateogry 'Toys and Games'
-- Joined tables to get relation between users and the products they ordered within the 'Toys and Games' category
-- Comparison of distinct products in TOY_Products and distinct products ordered by each user gives the result.
WITH TOY_PRODUCTS AS (
    SELECT P.product_id
    FROM Products P
    JOIN Categories C ON P.category_id = C.category_id
    WHERE C.category_name = 'Toys & Games'
)
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN TOY_PRODUCTS TP on OI.product_id = TP.product_id
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT TP.product_id) = (
	SELECT COUNT(DISTINCT P.product_id)
	FROM TOY_PRODUCTS P
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Common Table Expression (CTE) named 'MAX_PRICE' is created to find the maximum price for each category
-- Query selects specific columns from the 'Products' table and joins
-- with the 'MAX_PRICE' CTE using price and category_id

WITH MAX_PRICE AS(
	SELECT MAX(P.price) AS MAX_UNIT_PRICE,P.category_id FROM
	PRODUCTS P
	GROUP BY P.category_id
)
SELECT P.product_id, P.product_name, P.category_id, P.price
FROM Products P
JOIN MAX_PRICE MP ON P.price = MP.max_unit_price and P.category_id = MP.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Similar to problem 8
-- Common Table Expression (CTE) named 'Dates' is created to store user_id, order_date, and the two previous
-- order dates (previous_date_1 and previous_date_2).
-- Just like problem 8, only change in main query is the addition in the where clause to find difference between
-- order date and the previous_date_2.
WITH Dates AS (
    SELECT user_id, order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date_1,
	LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date_2
    FROM Orders
)
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN Dates OD ON U.user_id = OD.user_id
WHERE (order_date - previous_date_1) = 1
AND (order_date - previous_date_2) = 2;


