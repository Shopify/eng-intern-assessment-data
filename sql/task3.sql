-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.amount) AS total_sales_amount
FROM
    categories c
    JOIN products p ON c.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*)
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
  SELECT
    product_id,
    product_name,
    category_id,
    price,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
  FROM
    products
)
SELECT
  product_id,
  product_name,
  category_id,
  price
FROM
  RankedProducts
WHERE
  price_rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH Ordered AS (
  SELECT
    o.user_id,
    o.order_date,
    ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS rn
  FROM
    orders o
),
ConsecutiveOrders AS (
  SELECT
    user_id,
    order_date,
    order_date - INTERVAL '1 day' * (rn - 1) AS group_date
  FROM
    Ordered
),
ConsecutiveCounts AS (
  SELECT
    user_id,
    group_date,
    COUNT(*) AS consecutive_days
  FROM
    ConsecutiveOrders
  GROUP BY
    user_id, group_date
),
QualifiedUsers AS (
  SELECT
    user_id
  FROM
    ConsecutiveCounts
  WHERE
    consecutive_days >= 3
)
SELECT DISTINCT
  u.user_id,
  u.username
FROM
  QualifiedUsers qu
  JOIN users u ON qu.user_id = u.user_id;
