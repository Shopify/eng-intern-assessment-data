-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- **********Explanation**********:

-- combine relevant tables based on their relationships and use SUM(OI.quantity * OI.unit_price) to
-- calculates the total sales amount for each category.
-- GROUP BY clause groups the results by category, and ORDER_BY clause orders the categories by the
-- total sales amount in descending order. At the end we restrict to top 3 categories using LIMIT.

SELECT C.category_id, C.category_name, SUM(OI.quantity * OI.unit_price) AS total_sales_amount
FROM Categories AS C
JOIN Products AS P ON C.category_id = P.category_id
JOIN Order_Items AS OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales_amount DESC
LIMIT 3


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- **********Explanation**********:

-- ToysGamesProducts CTE selects all products in the "Toys & Games" category.
-- UserOrders CTE finds all user orders for products in the "Toys & Games" category.
-- UsersWithAllProducts CTE selects users who have ordered every product in the "Toys & Games" category. Checks
-- if there is any product in the "Toys & Games" category that the user has not ordered.
WITH ToysGamesProducts AS (
    SELECT product_id
    FROM Products
    WHERE category_id = (
		SELECT category_id 
            FROM Categories 
            WHERE category_name = 'Toys & Games'
	)
), UserOrders AS (
	SELECT O.user_id, OI.product_id
    FROM Orders AS O
    JOIN Order_Items AS OI ON O.order_id = OI.order_id
    WHERE OI.product_id IN (SELECT product_id FROM ToysGamesProducts)
    GROUP BY O.user_id, OI.product_id
), UsersWithAllProducts AS (
    SELECT U.user_id
    FROM Users U
    WHERE NOT EXISTS (
		SELECT 1
            FROM ToysGamesProducts
            WHERE product_id NOT IN (
				SELECT product_id
                    FROM UserOrders AS UO
                    WHERE UO.user_id = U.user_id
			)
	)
)

-- Final query joins the UsersWithAllProducts CTE with the Users table to get the user_id and username of users
-- who have ordered all products in the "Toys & Games" category.
SELECT U.user_id, U.username
FROM UsersWithAllProducts AS UWP
JOIN Users AS U ON UWP.user_id = U.user_id;


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- **********Explanation**********:

-- RankedProducts CTE selects all columns from the Products table and adds a row number. The ROW_NUMBER() 
-- function is partitioned by category_id and orders the products within each category by their price in 
-- descending order. Meaning the highest-priced product in each category gets rn = 1.

WITH RankedProducts AS (
    SELECT P.product_id, P.product_name, P.category_id, P.price,
    ROW_NUMBER() OVER (
		PARTITION BY P.category_id 
        ORDER BY P.price DESC
	) AS rn
    FROM Products P
)

-- Final query retrieves the product_id, product_name, category_id, and price from the RankedProducts CTE, but
-- only for those rows where rn = 1.
SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE rn = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- **********Explanation**********:

-- OrderedDates CTE generates a list of order dates for each user along with the previous two order dates
-- using the LAG function.

-- ConsecutiveOrderUsers CTE identifies users who have ordered on three consecutive days. We check if the
-- order_date is exactly one day after prev_order_date, and prev_order_date is one day after prev_order_date_2.
-- This indicates a 3-day consecutive ordering streak.

WITH OrderedDates AS (
    SELECT user_id, order_date, 
		LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date_2
    FROM Orders
), ConsecutiveOrderUsers AS (
    SELECT user_id
    FROM OrderedDates
    WHERE order_date = DATE_ADD(prev_order_date, INTERVAL 1 DAY)
    AND prev_order_date = DATE_ADD(prev_order_date_2, INTERVAL 1 DAY)
    GROUP BY user_id
    HAVING COUNT(*) >= 2
)

-- Final query joins the ConsecutiveOrderUsers CTE with the Users table to get the user_id and username for
-- users who have met the consecutive ordering criteria.
SELECT U.user_id, U.username
FROM Users AS U
JOIN ConsecutiveOrderUsers AS COU ON U.user_id = COU.user_id
