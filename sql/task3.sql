-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    C.category_id,
    C.category_name,
    SUM(OI.quantity * OI.unit_price) AS total_sales_amount
FROM
    Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY
    C.category_id,
    C.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;



-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P ON OI.product_id = P.product_id
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Toys & Games'
GROUP BY U.user_id, U.username
HAVING COUNT(DISTINCT P.product_id) = (
    SELECT COUNT(DISTINCT product_id)
    FROM Products P
    JOIN Categories C ON P.category_id = C.category_id
    WHERE C.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
DROP VIEW IF EXISTS HighestPricedProducts CASCADE;
CREATE VIEW HighestPricedProducts AS
WITH RankedProducts AS (
  SELECT
    product_id,
    product_name,
    category_id,
    price,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
  FROM Products
)
SELECT
  product_id,
  product_name,
  category_id,
  price
FROM RankedProducts
WHERE price_rank = 1;
SELECT * FROM HighestPricedProducts;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
DROP VIEW IF EXISTS UserConsecutiveOrders CASCADE;
DROP VIEW IF EXISTS UserConsecutiveStreaks CASCADE;
DROP VIEW IF EXISTS UserStreakLengths CASCADE;
DROP VIEW IF EXISTS UsersWith3DayStreaks CASCADE;
CREATE VIEW UserConsecutiveOrders AS
SELECT
  user_id,
  order_date,
  LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_order_date
FROM Orders;
CREATE VIEW UserConsecutiveStreaks AS
SELECT
  user_id,
  order_date,
  CASE
    WHEN order_date - previous_order_date = 1 THEN 0
    ELSE 1
  END AS streak_start
FROM UserConsecutiveOrders;
CREATE VIEW UserStreakLengths AS
SELECT
  user_id,
  order_date,
  SUM(streak_start) OVER (PARTITION BY user_id ORDER BY order_date) AS streak_id
FROM UserConsecutiveStreaks;
CREATE VIEW UsersWith3DayStreaks AS
SELECT
  user_id,
  COUNT(*) AS streak_length
FROM UserStreakLengths
GROUP BY user_id, streak_id
HAVING COUNT(*) >= 3;
SELECT DISTINCT U.user_id, U.username
FROM Users U
JOIN UsersWith3DayStreaks S ON U.user_id = S.user_id;
