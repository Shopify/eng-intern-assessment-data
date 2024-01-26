-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Problem 9 Solution
SELECT TOP 3 T1.category_id, T1.category_name, SUM(T1.sales) as total_sales_amount          -- Get total price for each category and select the top 3 categories
FROM 
(SELECT T.category_id, T.category_name, O.quantity * O.unit_price AS sales                  -- Get the product sales price by calculating QTY * unit price
FROM 
(SELECT C.category_id, C.category_name, P.product_id                                        -- LEFT JOIN Categories and Products relations
FROM Categories C LEFT JOIN Products P
ON C.category_id = P.category_id) AS T
LEFT JOIN Order_Items O 
ON T.product_id = O.product_id 
GROUP BY O.product_id) AS T1
GROUP BY T1.category_id
ORDER BY SUM(T1.sales) DESC;

-- Problem 10 Solution

SELECT DISTINCT T2.user_id, U.username                    -- Select users that have non-NULL entry (i.e. ordered from all products in Category 5)
FROM
(SELECT T1.product_id, T1.order_id, O.user_id             -- Perform left joins to obtain user id/username (from order_items, orders, users)
FROM 
(SELECT T.product_id, O1.order_id 
FROM 
(SELECT P.product_id                                      -- Find all products in Category 5
FROM Categories C INNER JOIN Products P
ON C.category_id = P.category_id
WHERE C.category_id = 5) AS T
LEFT JOIN Order_Items O1 
ON T.product_id = O1.product_id) AS T1
LEFT JOIN Orders O
ON T1.order_id = O.order_id) AS T2
LEFT JOIN Users U
ON T2.user_id = U.user_id
WHERE T2.user_id IS NOT NULL;

-- Problem 11 Solution
SELECT DISTINCT T.product_id, T.product_name, T.category_id, T.max_price                      -- Select the product with the maximum product price
FROM
(SELECT C.category_id, P.product_id, P.product_name, P.price, MAX(P.price) as max_price       -- Join Categories and Products relations, and get maximum product price for each category
FROM Categories C LEFT JOIN Products P
ON C.category_id = P.category_id
GROUP BY C.category_id, P.product_id) AS T 
WHERE T.price = T.max_price;

-- Problem 12 Solution
-- similar approach to Problem 8, but create 1 more column to get date and date difference of 2 rows prior when sorted by ASC order_dates
SELECT DISTINCT T1.user_id, T1.user_name
FROM
(SELECT T.user_id, T.user_name, DATEDIFF(day, lag2, lag1) AS diff2, DATEDIFF(day, lag1, T.order_date) AS diff1
FROM
(SELECT U.user_id, U.user_name, O.order_date, LAG(O.order_date, 1) OVER (ORDER BY O.order_date ASC) AS lag1, LAG(O.order_date, 2) OVER (ORDER BY O.order_date ASC) AS lag2
FROM Users U LEFT JOIN Orders O
ON U.user_id = O.user_id) AS T) AS T1
WHERE T1.diff2 = 1 AND T1.diff1 = 1;

