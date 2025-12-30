-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Solution 9
-- CTE is used to first calculate the total sales per category and then assign a rank to each category based on this total.
-- The main query selects from the CTE and limits the results to the top 3 categories with the highest total sales.

WITH CategorySalesRanking AS (
    SELECT 
        C.category_id,
        C.category_name,
        SUM(OI.unit_price * OI.quantity) AS total_sales,
        RANK() OVER (ORDER BY SUM(OI.unit_price * OI.quantity) DESC) AS sales_rank
    FROM Categories C
    JOIN Products P ON C.category_id = P.category_id
    JOIN Order_Items OI ON P.product_id = OI.product_id
    GROUP BY C.category_id
)
SELECT 
    category_id,
    category_name,
    total_sales
FROM CategorySalesRanking
WHERE sales_rank <= 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Solution 10
-- It involves multiple JOIN operations to link together the Users, Orders, Order_Items, Products, and Categories tables.
-- The WHERE clause filters the joined tables to only include products in the 'Toys & Games' category.
-- The GROUP BY clause groups the results by user_id, focusing the analysis at the level of individual users.
-- The HAVING clause filters out users based on whether the count of distinct products they have ordered in the 'Toys & Games' category matches the total number of products available in that category.

SELECT U.user_id,
       U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Toys & Games'
GROUP BY U.user_id
HAVING COUNT(DISTINCT P.product_id) =
  (SELECT COUNT(product_id)
   FROM Products p
   JOIN categories c ON p.category_id = c.category_id
   WHERE C.category_name = 'Toys & Games');

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Solution 11
-- The query within the CTE selects product_id, product_name, category_id, and price from the Products table.
-- The RANK() window function is used to assign a rank to each product based on its price within its respective category. This is done by partitioning the data by category_id.
-- The WHERE clause in the main query filters the results to include only those products with a price_rank of 1.

WITH RankedProducts AS (
	SELECT P.product_id,
          P.product_name,
          P.category_id,
          P.price,
          RANK() OVER (PARTITION BY P.category_id ORDER BY P.price DESC) AS price_rank
	FROM Products P
)
SELECT product_id,
       product_name,
       category_id,
       price
FROM RankedProducts
WHERE price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Solution 12
-- A Common Table Expression (CTE) named UserOrderDates is used for this purpose.
-- Within the CTE, the Users table is joined with the Orders table.
-- The LAG() window function is applied twice to each user's set of order dates.
-- The window function is partitioned by user_id.
-- The WHERE clause in the main query filters the results to include only those users who have placed orders on consecutive days for at least 3 days.

WITH UserOrderDates AS (
    SELECT 
        U.user_id, 
        U.username, 
        O.order_date,
        LAG(O.order_date, 1) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS prev_order_date,
        LAG(O.order_date, 2) OVER (PARTITION BY U.user_id ORDER BY O.order_date) AS prev_order_date2
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
)
SELECT DISTINCT
    user_id, 
    username
FROM UserOrderDates
WHERE
	order_date = prev_order_date + INTERVAL '1 day' 
	AND prev_order_date = prev_order_date2 + INTERVAL '1 day';