-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Utilized inner join, the Sum Function, and the Order By and Limit Keyword to write this query.
SELECT C.category_id, C.category_name, SUM(OI.quantity * OI.unit_price) AS total_sales
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Utilized inner join, the Count Function, and the Distinct Keyword to write this query.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Toys & Games'
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT P.product_id) = (
    SELECT COUNT(*)
    FROM Products P
    JOIN Categories C ON P.category_id = C.category_id
    WHERE C.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--Utilized CTE, window function Rank, inner join to write this query.
WITH MaxPriceProducts AS (
    SELECT P.product_id, P.product_name, P.category_id, P.price,
           RANK() OVER (PARTITION BY P.category_id ORDER BY P.price DESC) AS price_rank
    FROM Products P
)
SELECT M.product_id, M.product_name, M.category_id, M.price
FROM MaxPriceProducts M
WHERE M.price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--Utilized subqueries, window function Lead, inner join, and the DATEDIFF Function to write this query.
SELECT DISTINCT U.user_id, U.username
FROM (
    SELECT O.user_id, O.order_date,
           LEAD(O.order_date, 1) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS next_order_date,
           LEAD(O.order_date, 2) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS next_next_order_date
    FROM Orders O
) AS SubQuery
JOIN Users U ON SubQuery.user_id = U.user_id
WHERE DATEDIFF(SubQuery.next_order_date, SubQuery.order_date) = 1
AND DATEDIFF(SubQuery.next_next_order_date, SubQuery.next_order_date) = 1;