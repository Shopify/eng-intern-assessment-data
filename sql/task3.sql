-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, 
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_sales_amount
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Common Table Expression that gets the products belonging to the Toys & Games category
WITH ToysAndGamesProducts AS (
    SELECT product_id
    FROM Products
    WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
)
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE oi.product_id IN (SELECT product_id FROM ToysAndGamesProducts)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT oi.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Common Table Expression that ranks on the basis of price for each product category
WITH HighestPrice AS (
    SELECT product_id, product_name, category_id, price, RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM Products
)

SELECT product_id, product_name, category_id, price
FROM HighestPrice
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Common Table Expression that calculates the start and end dates of three consecutive orders for each user 
WITH UserOrderDates AS (
  SELECT
    user_id,
    order_date AS start_date,
    LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS end_date
  FROM Orders
)

SELECT DISTINCT
  uod.user_id,
  u.username
FROM UserOrderDates uod
JOIN Users u ON uod.user_id = u.user_id
WHERE DATEDIFF(uod.end_date, uod.start_date) >= 2;
